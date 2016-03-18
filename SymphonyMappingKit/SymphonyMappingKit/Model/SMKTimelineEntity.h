//
//  SMKTimelineEntity.h
//  
//
//  Created by Mark Cafaro on 3/18/16.
//
//

#import <Foundation/Foundation.h>
#import "SMKEntity.h"

@interface SMKTimelineEntity : SMKEntity {
    NSDate *_startTime;
    NSDate *_endTime;
}

@property (retain) NSDate *startTime;
@property (retain) NSDate *endTime;

@end
