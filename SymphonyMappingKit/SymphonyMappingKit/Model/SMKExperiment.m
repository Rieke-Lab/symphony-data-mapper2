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
@synthesize deviceEnumerator = _deviceEnumerator;
@synthesize sourceEnumerator = _sourceEnumerator;
@synthesize epochGroupEnumerator = _epochGroupEnumerator;

- (void)dealloc
{
    [_purpose release];
    [_deviceEnumerator release];
    [_sourceEnumerator release];
    [_epochGroupEnumerator release];
    
    [super dealloc];
}

@end
