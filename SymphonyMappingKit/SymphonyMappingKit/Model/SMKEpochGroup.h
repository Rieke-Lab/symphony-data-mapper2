//
//  SMKEpochGroup.h
//  SymphonyMappingKit
//
//  Created by Mark Cafaro on 1/25/13.
//  Copyright (c) 2013 Rieke Lab. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SMKTimelineEntity.h"

#include "hdf5.h"

@class SMKEpochEnumerator;
@class SMKEpochGroupEnumerator;
@class MACHdf5Reader;

@interface SMKEpochGroup : SMKTimelineEntity {
    NSString *_sourceIdentifier;
    NSString *_label;
    NSMutableArray *_epochs;
    SMKEpochEnumerator *_epochEnumerator;
    SMKEpochGroupEnumerator *_epochGroupEnumerator;
}

@property (copy) NSString *sourceIdentifier;
@property (copy) NSString *label;
@property (retain) SMKEpochEnumerator *epochEnumerator;
@property (retain) SMKEpochGroupEnumerator *epochGroupEnumerator;

@end
