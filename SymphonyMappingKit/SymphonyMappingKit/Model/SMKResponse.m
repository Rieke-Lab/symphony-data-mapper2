//
//  SMKResponse.m
//  SymphonyMappingKit
//
//  Created by Mark Cafaro on 2/4/13.
//  Copyright (c) 2013 Rieke Lab. All rights reserved.
//

#import "SMKResponse.h"

@implementation SMKResponse

@synthesize data = _data;
@synthesize units = _units;
@synthesize sampleRate = _sampleRate;
@synthesize sampleRateUnits = _sampleRateUnits;
@synthesize inputTime = _inputTime;

- (void)dealloc
{
    [_data release];
    [_units release];
    [_sampleRate release];
    [_sampleRateUnits release];
    [_inputTime release];
    
    [super dealloc];
}

@end
