//
//  SMKSourceEnumerator.m
//  
//
//  Created by Mark Cafaro on 3/17/16.
//
//

#import "SMKSourceEnumerator.h"
#import "SMKSource.h"
#import "MACHdf5Reader.h"

@implementation SMKSourceEnumerator

- (id)createNextEntity
{
    return [SMKSource new];
}

- (void)mapEntity:(SMKEntity *)entity withPath:(NSString *)path
{
    [super mapEntity:entity withPath:path];
    
    SMKSource *source = (SMKSource *)entity;
    
    source.label = [_reader readStringAttribute:@"label" onPath:path];
}

@end
