//
//  SMKResponse.h
//  SymphonyMappingKit
//
//  Created by Mark Cafaro on 2/4/13.
//  Copyright (c) 2013 Rieke Lab. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SMKIOBase.h"

@interface SMKResponse : SMKIOBase {
    NSData *_data;
    NSString *_units;
    NSNumber *_sampleRate;
    NSString *_sampleRateUnits;
}

@property (retain) NSData *data;
@property (copy) NSString *units;
@property (retain) NSNumber *sampleRate;
@property (copy) NSString *sampleRateUnits;

@end
