//
//  SMKSourceEnumerator.m
//  
//
//  Created by Mark Cafaro on 3/17/16.
//
//

#import "SMKSourceEnumerator.h"
#import "SMKSource.h"

@implementation SMKSourceEnumerator

- (id)initWithReader:(MACHdf5Reader *)reader sourcePaths:(NSArray *)paths
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
    
    NSString *sourcePath = [_paths objectAtIndex:_index];
    
    // Release the last returned source
    if (_lastSource != nil) {
        [_lastSource release];
    }
    
    SMKSource *source = [SMKSource new];
    
    _index++;
    _lastSource = source;
    return source;
}

- (NSArray *)allObjects
{
    return nil;
}

- (id)copyWithZone:(NSZone *)zone
{
    SMKSourceEnumerator *another = [[SMKSourceEnumerator alloc] initWithReader:_reader sourcePaths:_paths];
    return another;
}

- (void)dealloc
{
    [_reader release];
    [_paths release];
    [_lastSource release];
    
    [super dealloc];
}

@end
