//
//  SMKStimulus.m
//  SymphonyMappingKit
//
//  Created by Mark Cafaro on 2/4/13.
//  Copyright (c) 2013 Rieke Lab. All rights reserved.
//

#import "SMKStimulus.h"

@implementation SMKStimulus

@synthesize stimulusId = _stimulusId;
@synthesize units = _units;
@synthesize sampleRate = _sampleRate;
@synthesize sampleRateUnits = _sampleRateUnits;
@synthesize parameters = _parameters;
@synthesize duration = _duration;

- (void)dealloc
{
    [_stimulusId release];
    [_units release];
    [_sampleRate release];
    [_sampleRateUnits release];
    [_parameters release];
    
    [super dealloc];
}

@end
