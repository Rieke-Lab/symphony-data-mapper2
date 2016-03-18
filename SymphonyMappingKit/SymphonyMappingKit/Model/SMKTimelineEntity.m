//
//  SMKTimelineEntity.m
//  
//
//  Created by Mark Cafaro on 3/18/16.
//
//

#import "SMKTimelineEntity.h"

@implementation SMKTimelineEntity

@synthesize startTime = _startTime;
@synthesize endTime = _endTime;

- (void)dealloc
{
    [_startTime release];
    [_endTime release];
    
    [super dealloc];
}

@end
