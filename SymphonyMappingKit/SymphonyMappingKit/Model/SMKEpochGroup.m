//
//  SMKEpochGroup.m
//  SymphonyMappingKit
//
//  Created by Mark Cafaro on 1/25/13.
//  Copyright (c) 2013 Rieke Lab. All rights reserved.
//

#import "SMKEpochGroup.h"
#import "SMKEpochGroupEnumerator.h"
#import "SMKEpochEnumerator.h"

@implementation SMKEpochGroup

@synthesize sourceIdentifier = _sourceIdentifier;
@synthesize label = _label;
@synthesize startTime = _startTime;
@synthesize endTime = _endTime;
@synthesize properties = _properties;
@synthesize keywords = _keywords;
@synthesize epochEnumerator = _epochEnumerator;
@synthesize epochGroupEnumerator = _epochGroupEnumerator;

- (void)setEpochEnumerator:(SMKEpochEnumerator *)epochEnumerator
{
    _epochEnumerator = [epochEnumerator retain];
}

- (SMKEpochEnumerator *)epochEnumerator
{
    return [[_epochEnumerator copy] autorelease];
}

- (void)setEpochGroupEnumerator:(SMKEpochGroupEnumerator *)epochGroupEnumerator
{
    _epochGroupEnumerator = [epochGroupEnumerator retain];
}

- (SMKEpochGroupEnumerator *)epochGroupEnumerator
{
    return [[_epochGroupEnumerator copy] autorelease];
}

- (void)dealloc
{
    [_sourceIdentifier release];
    [_label release];
    [_startTime release];
    [_endTime release];
    [_properties release];
    [_keywords release];
    [_epochEnumerator release];
    [_epochGroupEnumerator release];
    
    [super dealloc];
}

@end
