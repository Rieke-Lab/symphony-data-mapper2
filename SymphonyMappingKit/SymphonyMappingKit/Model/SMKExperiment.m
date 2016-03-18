//
//  SMKExperiment.m
//  SymphonyMappingKit
//
//  Created by Mark Cafaro on 3/16/16.
//  Copyright © 2016 Rieke Lab. All rights reserved.
//

#import "SMKExperiment.h"

@implementation SMKExperiment

@synthesize purpose = _purpose;
@synthesize startTime = _startTime;
@synthesize endTime = _endTime;
@synthesize properties = _properties;
@synthesize keywords = _keywords;
@synthesize notes = _notes;
@synthesize deviceEnumerator = _deviceEnumerator;
@synthesize sourceEnumerator = _sourceEnumerator;
@synthesize epochGroupEnumerator = _epochGroupEnumerator;

- (void)dealloc
{
    [_purpose release];
    [_startTime release];
    [_endTime release];
    [_properties release];
    [_keywords release];
    [_notes release];
    [_deviceEnumerator release];
    [_sourceEnumerator release];
    [_epochGroupEnumerator release];
    
    [super dealloc];
}

@end
