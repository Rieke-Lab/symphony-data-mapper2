//
//  SMKStimulusEnumerator.m
//  
//
//  Created by Mark Cafaro on 3/18/16.
//
//

#import "SMKStimulusEnumerator.h"
#import "SMKStimulus.h"
#import "MACHdf5Reader.h"

@implementation SMKStimulusEnumerator

- (id)createNextEntity
{
    return [SMKStimulus new];
}

@end
