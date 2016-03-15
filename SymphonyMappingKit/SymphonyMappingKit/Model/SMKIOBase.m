//
//  SMKIOBase.m
//  SymphonyMappingKit
//
//  Created by Mark Cafaro on 2/13/13.
//  Copyright (c) 2013 Rieke Lab. All rights reserved.
//

#import "SMKIOBase.h"

@implementation SMKIOBase

@synthesize deviceName = _deviceName;
@synthesize deviceManufacturer = _deviceManufacturer;
@synthesize deviceMode = _deviceMode;
@synthesize deviceParameters = _deviceParameters;
@synthesize channelNumber = _channelNumber;
@synthesize streamType = _streamType;

- (void)dealloc
{
    [_deviceName release];
    [_deviceManufacturer release];
    [_deviceParameters release];
    [_channelNumber release];
    
    [super dealloc];
}

@end
