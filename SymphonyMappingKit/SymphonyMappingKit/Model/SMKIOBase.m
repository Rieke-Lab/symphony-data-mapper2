//
//  SMKIOBase.m
//  SymphonyMappingKit
//
//  Created by Mark Cafaro on 2/13/13.
//  Copyright (c) 2013 Rieke Lab. All rights reserved.
//

#import "SMKIOBase.h"

@implementation SMKIOBase

@synthesize device = _device;
@synthesize deviceMode = _deviceMode;
@synthesize deviceParameters = _deviceParameters;
@synthesize channelNumber = _channelNumber;
@synthesize streamType = _streamType;

- (void)dealloc
{
    [_device release];
    [_deviceParameters release];
    [_channelNumber release];
    
    [super dealloc];
}

@end
