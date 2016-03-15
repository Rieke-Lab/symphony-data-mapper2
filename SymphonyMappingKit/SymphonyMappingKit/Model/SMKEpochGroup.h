//
//  SMKEpochGroup.h
//  SymphonyMappingKit
//
//  Created by Mark Cafaro on 1/25/13.
//  Copyright (c) 2013 Rieke Lab. All rights reserved.
//

#import <Foundation/Foundation.h>

#include "hdf5.h"

@class SMKEpochEnumerator;
@class SMKEpochGroupEnumerator;
@class MACHdf5Reader;

@interface SMKEpochGroup : NSObject {
    NSString *_sourceIdentifier;
    NSString *_label;
    NSDate *_startTime;
    NSDate *_endTime;
    NSDictionary *_properties;
    NSSet *_keywords;
    NSMutableArray *_epochs;
    SMKEpochEnumerator *_epochEnumerator;
    SMKEpochGroupEnumerator *_epochGroupEnumerator;
}

@property (copy) NSString *sourceIdentifier;
@property (copy) NSString *label;
@property (retain) NSDate *startTime;
@property (retain) NSDate *endTime;
@property (retain) NSDictionary *properties;
@property (retain) NSSet *keywords;
@property (retain) SMKEpochEnumerator *epochEnumerator;
@property (retain) SMKEpochGroupEnumerator *epochGroupEnumerator;

@end
