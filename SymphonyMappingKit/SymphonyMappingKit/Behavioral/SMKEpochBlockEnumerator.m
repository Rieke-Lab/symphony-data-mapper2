//
//  SMKEpochBlockEnumerator.m
//  
//
//  Created by Mark Cafaro on 3/18/16.
//
//

#import "SMKEpochBlockEnumerator.h"
#import "SMKEpochBlock.h"
#import "SMKEpochEnumerator.h"
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
    
    NSString *parametersPath = [path stringByAppendingString:@"/protocolParameters"];    
    block.protocolParameters = [_reader readAttributesOnPath:parametersPath];
    
    // Epochs
    NSArray *epochMembers = [_reader groupMemberLinkInfoInPath:[path stringByAppendingString:@"/epochs"]];
    NSMutableArray *epochPaths = [NSMutableArray arrayWithCapacity:[epochMembers count]];
    for (MACHdf5LinkInformation *epochMember in epochMembers) {
        [epochPaths addObject:epochMember.path];
    }
    block.epochEnumerator = [[[SMKEpochEnumerator alloc] initWithReader:_reader entityPaths:epochPaths] autorelease];
}

@end
