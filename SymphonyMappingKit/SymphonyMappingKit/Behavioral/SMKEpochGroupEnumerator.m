//
//  SMKEpochGroupEnumerator.m
//  SymphonyMappingKit
//
//  Created by Mark Cafaro on 1/25/13.
//  Copyright (c) 2013 Rieke Lab. All rights reserved.
//

#import "SMKEpochGroupEnumerator.h"
#import "SMKEpochGroup.h"
#import "SMKEpoch.h"
#import "SMKEpochEnumerator.h"
#import "MACHdf5Reader.h"
#import "MACHdf5ObjectInformation.h"
#import "MACHdf5LinkInformation.h"

#include "hdf5.h"

@implementation SMKEpochGroupEnumerator

- (id)initWithReader:(MACHdf5Reader *)reader epochGroupPaths:(NSArray *)paths
{
    self = [super init];
    if (self) {
        _reader = [reader retain];
        _paths = [paths retain];
        _index = 0;
    }
    return self;
}

- (id)nextObject
{
    if (_index >= [_paths count]) {
        return nil;
    }
    
    NSString *groupPath = [_paths objectAtIndex:_index];
    
    // Release the last returned group
    if (_lastGroup != nil) {
        [_lastGroup release];
    }
    
    SMKEpochGroup *group = [SMKEpochGroup new];
    
    NSDate *dotNetRefDate = [NSDate dateWithString:@"0001-01-01 00:00:00 +0000"];
    
    // Start time
    int64_t startTicks = [_reader readLongAttribute:@"startTimeDotNetDateTimeOffsetUTCTicks" onPath:groupPath];
    NSTimeInterval startSecs = startTicks / 1e7;
    group.startTime = [NSDate dateWithTimeInterval:startSecs sinceDate:dotNetRefDate];
    
    // End time
    if ([_reader hasAttribute:@"endTimeDotNetDateTimeOffsetUTCTicks" onPath:groupPath]) {
        int64_t endTicks = [_reader readLongAttribute:@"endTimeDotNetDateTimeOffsetUTCTicks" onPath:groupPath];
        NSTimeInterval endSecs = endTicks / 1e7;
        group.endTime = [NSDate dateWithTimeInterval:endSecs sinceDate:dotNetRefDate];
    } else {
        group.endTime = nil;
    }
    
    group.label = [_reader readStringAttribute:@"label" onPath:groupPath];
    group.sourceIdentifier = [_reader readStringAttribute:@"source" onPath:groupPath];
    
    // Properties
    NSArray *members = [_reader allGroupMembersInPath:groupPath];
    if ([members containsObject:@"properties"]) {
        
        NSString *memberPath = [groupPath stringByAppendingString:@"/properties"];
        MACHdf5ObjectInformation *memberInfo = [_reader objectInformationForPath:memberPath];
        
        if (memberInfo.isGroup) {
            group.properties = [_reader readAttributesOnPath:memberPath];
        } else {
            // Read compound array ??
            [NSException raise:@"UnsupportedFeature" format:@"%@ must be a group", memberPath];
        }
        
    }
    
    NSString *uuid = [_reader readStringAttribute:@"symphony.uuid" onPath:groupPath];
    [group.properties setValue:uuid forKey:@"__symphony__uuid__"];
    
    // Keywords
    if ([_reader hasAttribute:@"keywords" onPath:groupPath]) {
        NSString *keywordsStr = [_reader readStringAttribute:@"keywords" onPath:groupPath];
        group.keywords = [NSSet setWithArray:[keywordsStr componentsSeparatedByString:@","]];
    }
    
    // Epochs
    NSArray *epochMembers = [_reader groupMemberLinkInfoInPath:[groupPath stringByAppendingString:@"/epochs"]];
    NSMutableArray *epochPaths = [NSMutableArray arrayWithCapacity:[epochMembers count]];
    for (MACHdf5LinkInformation *epochMember in epochMembers) {
        [epochPaths addObject:epochMember.path];
    }
    group.epochEnumerator = [[[SMKEpochEnumerator alloc] initWithReader:_reader epochPaths:epochPaths] autorelease];
        
    // Sub-EpochGroups
    NSArray *subGroupMembers = [_reader groupMemberLinkInfoInPath:[groupPath stringByAppendingString:@"/epochGroups"]];
    NSMutableArray *subGroupPaths = [NSMutableArray arrayWithCapacity:[subGroupMembers count]];
    for (MACHdf5LinkInformation *subGroupMember in subGroupMembers) {
        [subGroupPaths addObject:subGroupMember.path];
    }
    group.epochGroupEnumerator = [[[SMKEpochGroupEnumerator alloc] initWithReader:_reader epochGroupPaths:subGroupPaths] autorelease];
    
    _index++;
    _lastGroup = group;
    return group;
}

- (NSArray *)allObjects
{
    return nil;
}

- (id)copyWithZone:(NSZone *)zone
{
    SMKEpochGroupEnumerator *another = [[SMKEpochGroupEnumerator alloc] initWithReader:_reader epochGroupPaths:_paths];
    return another;
}

- (void)dealloc
{
    [_reader release];
    [_paths release];
    [_lastGroup release];
    
    [super dealloc];
}

@end
