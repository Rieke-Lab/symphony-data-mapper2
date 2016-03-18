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

@synthesize label = _label;
@synthesize source = _source;
@synthesize epochGroupEnumerator = _epochGroupEnumerator;
@synthesize epochBlockEnumerator = _epochBlockEnumerator;

- (void)dealloc
{
    [_label release];
    [_source release];
    [_epochGroupEnumerator release];
    [_epochBlockEnumerator release];
    
    [super dealloc];
}

@end
