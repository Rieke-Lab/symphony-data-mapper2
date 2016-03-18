//
//  SMKEpochGroup.h
//  SymphonyMappingKit
//
//  Created by Mark Cafaro on 1/25/13.
//  Copyright (c) 2013 Rieke Lab. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SMKTimelineEntity.h"

@class SMKSource;
@class SMKEpochGroupEnumerator;
@class SMKEpochBlockEnumerator;

@interface SMKEpochGroup : SMKTimelineEntity {
    NSString *_label;
    SMKSource *_source;
    SMKEpochGroupEnumerator *_epochGroupEnumerator;
    SMKEpochBlockEnumerator *_epochBlockEnumerator;
}

@property (copy) NSString *label;
@property (retain) SMKSource *source;
@property (retain) SMKEpochGroupEnumerator *epochGroupEnumerator;
@property (retain) SMKEpochBlockEnumerator *epochBlockEnumerator;

@end
