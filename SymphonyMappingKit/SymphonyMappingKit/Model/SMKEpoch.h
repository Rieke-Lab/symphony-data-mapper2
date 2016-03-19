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
    NSArray *_backgrounds;
    NSDictionary *_protocolParameters;
    NSArray *_stimuli;
    NSArray *_responses;
}

@property (retain) NSArray *backgrounds;
@property (retain) NSDictionary *protocolParameters;
@property (retain) NSArray *stimuli;
@property (retain) NSArray *responses;

@end
