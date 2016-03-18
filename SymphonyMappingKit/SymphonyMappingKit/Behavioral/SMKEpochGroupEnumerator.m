//
//  SMKEpochGroupEnumerator.m
//  SymphonyMappingKit
//
//  Created by Mark Cafaro on 1/25/13.
//  Copyright (c) 2013 Rieke Lab. All rights reserved.
//

#import "SMKEpochGroupEnumerator.h"
#import "SMKEpochGroup.h"
#import "SMKEpoch.h"
#import "SMKEpochEnumerator.h"
#import "MACHdf5Reader.h"
#import "MACHdf5ObjectInformation.h"
#import "MACHdf5LinkInformation.h"

#include "hdf5.h"

@implementation SMKEpochGroupEnumerator

- (id)initWithReader:(MACHdf5Reader *)reader epochGroupPaths:(NSArray *)paths
{
    self = [super init];
    if (self) {
        _reader = [reader retain];
        _paths = [paths retain];
        _index = 0;
    }
    return self;
}

- (id)nextObject
{
    if (_index >= [_paths count]) {
        return nil;
    }
    
    NSString *groupPath = [_paths objectAtIndex:_index];
    
    // Release the last returned group
    if (_lastGroup != nil) {
        [_lastGroup release];
    }
    
    SMKEpochGroup *group = [SMKEpochGroup new];
    
    _index++;
    _lastGroup = group;
    return group;
}

- (NSArray *)allObjects
{
    return nil;
}

- (id)copyWithZone:(NSZone *)zone
{
    SMKEpochGroupEnumerator *another = [[SMKEpochGroupEnumerator alloc] initWithReader:_reader epochGroupPaths:_paths];
    return another;
}

- (void)dealloc
{
    [_reader release];
    [_paths release];
    [_lastGroup release];
    
    [super dealloc];
}

@end
