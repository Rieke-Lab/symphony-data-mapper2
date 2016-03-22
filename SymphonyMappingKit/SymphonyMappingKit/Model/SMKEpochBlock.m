//
//  SMKEpochBlock.m
//  
//
//  Created by Mark Cafaro on 3/18/16.
//
//

#import "SMKEpochBlock.h"

@implementation SMKEpochBlock

@synthesize epochGroup = _epochGroup;
@synthesize protocolId = _protocolId;
@synthesize protocolParameters = _protocolParameters;
@synthesize epochEnumerator = _epochEnumerator;

- (void)dealloc
{
    [_epochGroup release];
    [_protocolId release];
    [_protocolParameters release];
    [_epochEnumerator release];
    
    [super dealloc];
}

@end
