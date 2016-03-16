//
//  SMKExperimentEnumerator.m
//  SymphonyMappingKit
//
//  Created by Mark Cafaro on 3/16/16.
//  Copyright © 2016 Rieke Lab. All rights reserved.
//

#import "SMKExperimentEnumerator.h"
#import "SMKExperiment.h"
#import "MACHdf5Reader.h"
#import "MACHdf5ObjectInformation.h"
#import "MACHdf5LinkInformation.h"

#include "hdf5.h"

@implementation SMKExperimentEnumerator

- (id)initWithReader:(MACHdf5Reader *)reader experimentPaths:(NSArray *)paths
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
    
    NSString *experimentPath = [_paths objectAtIndex:_index];
    
    // Release the last returned experiment
    if (_lastExperiment != nil) {
        [_lastExperiment release];
    }
    
    SMKExperiment *experiment = [SMKExperiment new];
    
    NSDate *dotNetRefDate = [NSDate dateWithString:@"0001-01-01 00:00:00 +0000"];
    
    // Start time
    int64_t startTicks = [_reader readLongAttribute:@"startTimeDotNetDateTimeOffsetUTCTicks" onPath:experimentPath];
    NSTimeInterval startSecs = startTicks / 1e7;
    experiment.startTime = [NSDate dateWithTimeInterval:startSecs sinceDate:dotNetRefDate];
    
    // End time
    int64_t endTicks = [_reader readLongAttribute:@"endTimeDotNetDateTimeOffsetUTCTicks" onPath:experimentPath];
    NSTimeInterval endSecs = endTicks / 1e7;
    experiment.endTime = [NSDate dateWithTimeInterval:endSecs sinceDate:dotNetRefDate];
    
    experiment.purpose = [_reader readStringAttribute:@"purpose" onPath:experimentPath];
    
    NSArray *members = [_reader allGroupMembersInPath:experimentPath];
    
    // Properties
    if ([members containsObject:@"properties"]) {
        
        NSString *memberPath = [experimentPath stringByAppendingString:@"/properties"];
        MACHdf5ObjectInformation *memberInfo = [_reader objectInformationForPath:memberPath];
        
        if (!memberInfo.isGroup) {
            [NSException raise:@"UnexpectedFormat" format:@"%@ must be a group", memberPath];
        }
        
        experiment.properties = [_reader readAttributesOnPath:memberPath];
    }
    
    NSString *uuid = [_reader readStringAttribute:@"symphony.uuid" onPath:experimentPath];
    [experiment.properties setValue:uuid forKey:@"__symphony__uuid__"];
    
    // Keywords
    if ([_reader hasAttribute:@"keywords" onPath:experimentPath]) {
        NSString *keywordsStr = [_reader readStringAttribute:@"keywords" onPath:experimentPath];
        experiment.keywords = [NSSet setWithArray:[keywordsStr componentsSeparatedByString:@","]];
    }
    
    _index++;
    _lastExperiment = experiment;
    return experiment;
}

- (NSArray *)allObjects
{
    return nil;
}

- (id)copyWithZone:(NSZone *)zone
{
    SMKExperimentEnumerator *another = [[SMKExperimentEnumerator alloc] initWithReader:_reader experimentPaths:_paths];
    return another;
}

- (void)dealloc
{
    [_reader release];
    [_paths release];
    [_lastExperiment release];
    
    [super dealloc];
}

@end
