//
//  SMKDeviceEnumerator.m
//  
//
//  Created by Mark Cafaro on 3/17/16.
//
//

#import "SMKDeviceEnumerator.h"
#import "SMKDevice.h"
#import "MACHdf5Reader.h"

@implementation SMKDeviceEnumerator

- (id)createNextEntity
{
    return [SMKDevice new];
}

- (void)mapEntity:(SMKEntity *)entity withPath:(NSString *)path
{
    [super mapEntity:entity withPath:path];
    
    SMKDevice *device = (SMKDevice *)entity;
    
    device.name = [_reader readStringAttribute:@"name" onPath:path];
    device.manufacturer = [_reader readStringAttribute:@"manufacturer" onPath:path];
}

@end
