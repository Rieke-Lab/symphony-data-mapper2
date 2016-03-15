//
//  SMKEpoch.m
//  SymphonyMappingKit
//
//  Created by Mark Cafaro on 1/31/13.
//  Copyright (c) 2013 Rieke Lab. All rights reserved.
//

#import "SMKEpoch.h"

@implementation SMKEpoch

@synthesize protocolId = _protocolId;
@synthesize startTime = _startTime;
@synthesize duration = _duration;
@synthesize protocolParameters = _protocolParameters;
@synthesize keywords = _keywords;
@synthesize stimuli = _stimuli;
@synthesize responses = _responses;

- (void)dealloc
{
    [_protocolId release];
    [_startTime release];
    [_duration release];
    [_protocolParameters release];
    [_keywords release];
    [_stimuli release];
    [_responses release];
    
    [super dealloc];
}

@end
