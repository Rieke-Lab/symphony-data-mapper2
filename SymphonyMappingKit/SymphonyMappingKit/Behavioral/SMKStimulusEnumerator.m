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

- (void)mapEntity:(SMKEntity *)entity withPath:(NSString *)path
{
    [super mapEntity:entity withPath:path];
    
    SMKStimulus *stimulus = (SMKStimulus *)entity;
    
    stimulus.stimulusId = [_reader readStringAttribute:@"stimulusID" onPath:path];
    stimulus.units = [_reader readStringAttribute:@"units" onPath:path];
    stimulus.sampleRate = [NSNumber numberWithDouble:[_reader readDoubleAttribute:@"sampleRate" onPath:path]];
    stimulus.sampleRateUnits = [_reader readStringAttribute:@"sampleRateUnits" onPath:path];
    
    NSString *parametersPath = [path stringByAppendingString:@"/parameters"];
    stimulus.parameters = [_reader readAttributesOnPath:parametersPath];
    
    stimulus.duration = [_reader readDoubleAttribute:@"durationSeconds" onPath:path];
}

@end
