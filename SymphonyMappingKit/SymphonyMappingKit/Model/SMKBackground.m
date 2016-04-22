//
//  SMKBackground.m
//  
//
//  Created by Mark Cafaro on 3/18/16.
//
//

#import "SMKBackground.h"

@implementation SMKBackground

@synthesize value = _value;
@synthesize units = _units;
@synthesize sampleRate = _sampleRate;
@synthesize sampleRateUnits = _sampleRateUnits;

- (void)dealloc
{
    [_value release];
    [_units release];
    [_sampleRate release];
    [_sampleRateUnits release];
    
    [super dealloc];
}

@end
