//
//  SMKEpoch.h
//  SymphonyMappingKit
//
//  Created by Mark Cafaro on 1/31/13.
//  Copyright (c) 2013 Rieke Lab. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SMKTimelineEntity.h"

@interface SMKEpoch : SMKTimelineEntity {
    NSString *_protocolId;
    NSNumber *_duration;
    NSDictionary *_protocolParameters;
    NSArray *_stimuli;
    NSArray *_responses;
}

@property (copy) NSString *protocolId;
@property (retain) NSNumber *duration;
@property (retain) NSDictionary *protocolParameters;
@property (retain) NSArray *stimuli;
@property (retain) NSArray *responses;


@end
