//
//  SMKBackground.h
//  
//
//  Created by Mark Cafaro on 3/18/16.
//
//

#import "SMKEntity.h"

@interface SMKBackground : SMKEntity {
    NSNumber *_value;
    NSString *_units;
    NSNumber *_sampleRate;
    NSString *_sampleRateUnits;
}

@property (retain) NSNumber *value;
@property (copy) NSString *units;
@property (retain) NSNumber *sampleRate;
@property (copy) NSString *sampleRateUnits;

@end
