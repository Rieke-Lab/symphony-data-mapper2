//
//  SMKTimelineEntityEnumerator.m
//  
//
//  Created by Mark Cafaro on 3/18/16.
//
//

#import "SMKTimelineEntityEnumerator.h"
#import "SMKTimelineEntity.h"
#import "MACHdf5Reader.h"

@implementation SMKTimelineEntityEnumerator

- (void)mapEntity:(SMKEntity *)entity withPath:(NSString *)path
{
    [super mapEntity:entity withPath:path];
    
    SMKTimelineEntity *timelineEntity = (SMKTimelineEntity *)entity;
    
    NSDate *dotNetRefDate = [NSDate dateWithString:@"0001-01-01 00:00:00 +0000"];
    
    // Start time
    double startOffsetHours = [_reader readDoubleAttribute:@"startTimeDotNetDateTimeOffsetOffsetHours" onPath:path];
    int64_t startTicks = [_reader readLongAttribute:@"startTimeDotNetDateTimeOffsetTicks" onPath:path];
    NSTimeInterval startSecs = startTicks / 1e7 - (startOffsetHours * 60 * 60);
    timelineEntity.startTime = [NSDate dateWithTimeInterval:startSecs sinceDate:dotNetRefDate];
    
    // End time
    double endOffsetHours = [_reader readDoubleAttribute:@"endTimeDotNetDateTimeOffsetOffsetHours" onPath:path];
    int64_t endTicks = [_reader readLongAttribute:@"endTimeDotNetDateTimeOffsetTicks" onPath:path];
    NSTimeInterval endSecs = endTicks / 1e7 - (endOffsetHours * 60 * 60);
    timelineEntity.endTime = [NSDate dateWithTimeInterval:endSecs sinceDate:dotNetRefDate];
}

@end
