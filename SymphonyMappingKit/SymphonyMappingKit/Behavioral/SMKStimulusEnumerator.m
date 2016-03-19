//
//  SMKStimulusEnumerator.m
//  
//
//  Created by Mark Cafaro on 3/18/16.
//
//

#import "SMKStimulusEnumerator.h"
#import "SMKStimulus.h"

@implementation SMKStimulusEnumerator

- (id)createNextEntity
{
    return [SMKStimulus new];
}

@end
