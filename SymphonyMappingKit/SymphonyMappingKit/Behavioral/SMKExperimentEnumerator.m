//
//  SMKExperimentEnumerator.m
//  SymphonyMappingKit
//
//  Created by Mark Cafaro on 3/16/16.
//  Copyright © 2016 Rieke Lab. All rights reserved.
//

#import "SMKExperimentEnumerator.h"
#import "SMKExperiment.h"
#import "SMKDeviceEnumerator.h"
#import "SMKSourceEnumerator.h"
#import "SMKEpochGroupEnumerator.h"
#import "SMKNote.h"
#import "MACHdf5Reader.h"
#import "MACHdf5ObjectInformation.h"
#import "MACHdf5LinkInformation.h"

#include "hdf5.h"

// HACK: This should be defined based on the NOTE data type in the data file.
// How do we create a struct data type from that datatype?
typedef struct dtoData {
    uint64_t ticks;
    double offset;
} dtoData;

typedef struct noteData {
    dtoData time;
    char *text;
} noteData;

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
    double startOffsetHours = [_reader readDoubleAttribute:@"startTimeDotNetDateTimeOffsetOffsetHours" onPath:experimentPath];
    int64_t startTicks = [_reader readLongAttribute:@"startTimeDotNetDateTimeOffsetTicks" onPath:experimentPath];
    NSTimeInterval startSecs = startTicks / 1e7 - (startOffsetHours * 60 * 60);
    experiment.startTime = [NSDate dateWithTimeInterval:startSecs sinceDate:dotNetRefDate];
    
    // End time
    double endOffsetHours = [_reader readDoubleAttribute:@"endTimeDotNetDateTimeOffsetOffsetHours" onPath:experimentPath];
    int64_t endTicks = [_reader readLongAttribute:@"endTimeDotNetDateTimeOffsetTicks" onPath:experimentPath];
    NSTimeInterval endSecs = endTicks / 1e7 - (endOffsetHours * 60 * 60);
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
    
    NSString *uuid = [_reader readStringAttribute:@"uuid" onPath:experimentPath];
    [experiment.properties setValue:uuid forKey:@"__symphony__uuid__"];
    
    // Keywords
    if ([_reader hasAttribute:@"keywords" onPath:experimentPath]) {
        NSString *keywordsStr = [_reader readStringAttribute:@"keywords" onPath:experimentPath];
        experiment.keywords = [NSSet setWithArray:[keywordsStr componentsSeparatedByString:@","]];
    }
    
    // Notes
    if ([members containsObject:@"notes"]) {
        
        NSString *memberPath = [experimentPath stringByAppendingString:@"/notes"];
        MACHdf5ObjectInformation *memberInfo = [_reader objectInformationForPath:memberPath];
        if (!memberInfo.isDataset) {
            [NSException raise:@"UnexpectedFormat" format:@"%@ must be a dataset", memberPath];
        }
        
        hid_t notesId = H5Dopen(_reader.fileId, [memberPath cStringUsingEncoding:[NSString defaultCStringEncoding]], H5P_DEFAULT);
        
        hid_t spaceId = H5Dget_space(notesId);
        int rank = H5Sget_simple_extent_ndims(spaceId);
        hsize_t dims[rank];
        H5Sget_simple_extent_dims(spaceId, dims, NULL);
        
        int length = (int)dims[0];
        if (length != dims[0]) {
            [NSException raise:@"LengthTooLarge"
                        format:@"%@ length is too large", memberPath];
        }
        
        hid_t datatypeId = H5Topen(_reader.fileId, "NOTE", H5P_DEFAULT);
        
        noteData *data = malloc(length * sizeof(noteData));
        H5Dread(notesId, datatypeId, H5S_ALL, H5S_ALL, H5P_DEFAULT, data);
        
        NSMutableSet *notes = [NSMutableSet setWithCapacity:length];
        for (int i = 0; i < length; i++) {
            SMKNote *note = [SMKNote new];
            
            NSTimeInterval interval = data[i].time.ticks / 1e7 - (data[i].time.offset * 60 * 60);
            note.timestamp = [NSDate dateWithTimeInterval:interval sinceDate:dotNetRefDate];
            
            note.comment = [NSString stringWithUTF8String:data[i].text];
            
            [notes addObject:note];
        }
        experiment.notes = notes;
    }
    
    // Devices
    NSArray *deviceMembers = [_reader groupMemberLinkInfoInPath:[experimentPath stringByAppendingString:@"/devices"]];
    NSMutableArray *devicePaths = [NSMutableArray arrayWithCapacity:[deviceMembers count]];
    for (MACHdf5LinkInformation *deviceMember in deviceMembers) {
        [devicePaths addObject:deviceMember.path];
    }
    experiment.deviceEnumerator = [[[SMKDeviceEnumerator alloc] initWithReader:_reader devicePaths:devicePaths] autorelease];
    
    // Sources
    NSArray *sourceMembers = [_reader groupMemberLinkInfoInPath:[experimentPath stringByAppendingString:@"/sources"]];
    NSMutableArray *sourcePaths = [NSMutableArray arrayWithCapacity:[sourceMembers count]];
    for (MACHdf5LinkInformation *sourceMember in sourceMembers) {
        [sourcePaths addObject:sourceMember.path];
    }
    experiment.sourceEnumerator = [[[SMKSourceEnumerator alloc] initWithReader:_reader sourcePaths:sourcePaths] autorelease];
    
    // Epoch Groups
    NSArray *groupMembers = [_reader groupMemberLinkInfoInPath:[experimentPath stringByAppendingString:@"/epochGroups"]];
    NSMutableArray *groupPaths = [NSMutableArray arrayWithCapacity:[groupMembers count]];
    for (MACHdf5LinkInformation *groupMember in groupMembers) {
        [groupPaths addObject:groupMember.path];
    }
    experiment.epochGroupEnumerator = [[[SMKEpochGroupEnumerator alloc] initWithReader:_reader epochGroupPaths:groupPaths] autorelease];
    
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
