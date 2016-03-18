//
//  SMKDeviceEnumerator.m
//  
//
//  Created by Mark Cafaro on 3/17/16.
//
//

#import "SMKDeviceEnumerator.h"
#import "SMKDevice.h"

@implementation SMKDeviceEnumerator

- (id)initWithReader:(MACHdf5Reader *)reader devicePaths:(NSArray *)paths
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
    
    NSString *devicePath = [_paths objectAtIndex:_index];
    
    // Release the last returned device
    if (_lastDevice != nil) {
        [_lastDevice release];
    }
    
    SMKDevice *device = [SMKDevice new];
    
    _index++;
    _lastDevice = device;
    return device;
}

- (NSArray *)allObjects
{
    return nil;
}

- (id)copyWithZone:(NSZone *)zone
{
    SMKDeviceEnumerator *another = [[SMKDeviceEnumerator alloc] initWithReader:_reader devicePaths:_paths];
    return another;
}

- (void)dealloc
{
    [_reader release];
    [_paths release];
    [_lastDevice release];
    
    [super dealloc];
}

@end
