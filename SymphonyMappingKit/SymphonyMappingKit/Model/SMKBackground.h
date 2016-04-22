//
//  SMKBackground.h
//  
//
//  Created by Mark Cafaro on 3/18/16.
//
//

#import "SMKIOBase.h"

@class SMKDevice;

@interface SMKBackground : SMKIOBase {
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
