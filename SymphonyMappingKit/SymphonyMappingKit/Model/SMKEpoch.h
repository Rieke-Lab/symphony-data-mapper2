//
//  SMKEpoch.h
//  SymphonyMappingKit
//
//  Created by Mark Cafaro on 1/31/13.
//  Copyright (c) 2013 Rieke Lab. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SMKEpoch : NSObject {
    NSString *_protocolId;
    NSDate *_startTime;
    NSNumber *_duration;
    NSDictionary *_protocolParameters;
    NSSet *_keywords;
    NSArray *_stimuli;
    NSArray *_responses;
}

@property (copy) NSString *protocolId;
@property (retain) NSDate *startTime;
@property (retain) NSNumber *duration;
@property (retain) NSDictionary *protocolParameters;
@property (retain) NSSet *keywords;
@property (retain) NSArray *stimuli;
@property (retain) NSArray *responses;


@end
