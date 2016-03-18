//
//  SMKEntity.m
//  
//
//  Created by Mark Cafaro on 3/18/16.
//
//

#import "SMKEntity.h"

@implementation SMKEntity

@synthesize uuid = _uuid;
@synthesize properties = _properties;
@synthesize keywords = _keywords;
@synthesize notes = _notes;

- (void)dealloc
{
    [_uuid release];
    [_properties release];
    [_keywords release];
    [_notes release];
    
    [super dealloc];
}

@end
