//
//  SMKDevice.m
//  
//
//  Created by Mark Cafaro on 3/17/16.
//
//

#import "SMKDevice.h"

@implementation SMKDevice

@synthesize name = _name;
@synthesize manufacturer = _manufacturer;

- (void)dealloc
{
    [_name release];
    [_manufacturer release];
    
    [super dealloc];
}

@end
