//
//  SMKSource.m
//  SymphonyMappingKit
//
//  Created by Mark Cafaro on 1/4/13.
//  Copyright (c) 2013 Rieke Lab. All rights reserved.
//

#import "SMKSource.h"

@implementation SMKSource

@synthesize label = _label;
@synthesize sourceEnumerator = _sourceEnumerator;

- (void)dealloc
{
    [_label release];
    [_sourceEnumerator release];
    
    [super dealloc];
}

@end
