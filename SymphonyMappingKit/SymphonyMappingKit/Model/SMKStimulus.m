//
//  SMKStimulus.m
//  SymphonyMappingKit
//
//  Created by Mark Cafaro on 2/4/13.
//  Copyright (c) 2013 Rieke Lab. All rights reserved.
//

#import "SMKStimulus.h"

@implementation SMKStimulus

@synthesize parameters = _parameters;
@synthesize pluginId = _pluginId;
@synthesize units = _units;

- (void)dealloc
{
    [_parameters release];
    [_pluginId release];
    [_units release];
    
    [super dealloc];
}

@end
