//
//  SMKEpochBlockEnumerator.m
//  
//
//  Created by Mark Cafaro on 3/18/16.
//
//

#import "SMKEpochBlockEnumerator.h"
#import "SMKEpochBlock.h"
#import "MACHdf5Reader.h"
#import "MACHdf5ObjectInformation.h"
#import "MACHdf5LinkInformation.h"

@implementation SMKEpochBlockEnumerator

- (id)createNextEntity
{
    return [SMKEpochBlock new];
}

- (void)mapEntity:(SMKEntity *)entity withPath:(NSString *)path
{
    [super mapEntity:entity withPath:path];
    
    SMKEpochBlock *block = (SMKEpochBlock *)entity;
    
    block.protocolId = [_reader readStringAttribute:@"protocolID" onPath:path];
}

@end
