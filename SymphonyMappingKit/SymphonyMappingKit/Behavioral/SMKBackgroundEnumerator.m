//
//  SMKBackgroundEnumerator.m
//  
//
//  Created by Mark Cafaro on 3/18/16.
//
//

#import "SMKBackgroundEnumerator.h"
#import "SMKBackground.h"
#import "MACHdf5Reader.h"

@implementation SMKBackgroundEnumerator

- (id)createNextEntity
{
    return [SMKBackground new];
}

- (void)mapEntity:(SMKEntity *)entity withPath:(NSString *)path
{
    [super mapEntity:entity withPath:path];
    
    SMKBackground *background = (SMKBackground *)entity;
    
    background.value = [NSNumber numberWithDouble:[_reader readDoubleAttribute:@"value" onPath:path]];
    background.units = [_reader readStringAttribute:@"valueUnits" onPath:path];
    background.sampleRate = [NSNumber numberWithDouble:[_reader readDoubleAttribute:@"sampleRate" onPath:path]];
    background.sampleRateUnits = [_reader readStringAttribute:@"sampleRateUnits" onPath:path];
}

@end
