//
//  SMKSource.m
//  SymphonyMappingKit
//
//  Created by Mark Cafaro on 1/4/13.
//  Copyright (c) 2013 Rieke Lab. All rights reserved.
//

#import "SMKSource.h"

@implementation SMKSource

@synthesize identifier = _identifier;
@synthesize label = _label;
@synthesize children = _children;

- (BOOL)isEqual:(SMKSource *)object
{
    return [_identifier isEqualToString:object.identifier]
            && [_label isEqualToString:object.label]
            && [_children isEqualToArray:object.children];
}

- (NSString *)description
{
    return [[_identifier description] stringByAppendingString:_label];
}

- (void)dealloc
{
    [_identifier release];
    [_label release];
    
    [super dealloc];
}

@end
