//
//  SMKStimulus.h
//  SymphonyMappingKit
//
//  Created by Mark Cafaro on 2/4/13.
//  Copyright (c) 2013 Rieke Lab. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SMKIOBase.h"

@interface SMKStimulus : SMKIOBase {
    NSString *_stimulusId;
    NSString *_units;
    NSNumber *_sampleRate;
    NSString *_sampleRateUnits;
    NSDictionary *_parameters;
    NSTimeInterval _duration;
}

@property (copy) NSString *stimulusId;
@property (copy) NSString *units;
@property (retain) NSNumber *sampleRate;
@property (copy) NSString *sampleRateUnits;
@property (retain) NSDictionary *parameters;
@property NSTimeInterval duration;

@end
