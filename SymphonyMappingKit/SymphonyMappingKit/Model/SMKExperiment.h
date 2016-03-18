//
//  SMKExperiment.h
//  SymphonyMappingKit
//
//  Created by Mark Cafaro on 3/16/16.
//  Copyright © 2016 Rieke Lab. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SMKTimelineEntity.h"

@class SMKDeviceEnumerator;
@class SMKSourceEnumerator;
@class SMKEpochGroupEnumerator;

@interface SMKExperiment : SMKTimelineEntity {
    NSString *_purpose;
    SMKDeviceEnumerator *_deviceEnumerator;
    SMKSourceEnumerator *_sourceEnumerator;
    SMKEpochGroupEnumerator *_epochGroupEnumerator;
}

@property (copy) NSString *purpose;
@property (retain) SMKDeviceEnumerator *deviceEnumerator;
@property (retain) SMKSourceEnumerator *sourceEnumerator;
@property (retain) SMKEpochGroupEnumerator *epochGroupEnumerator;

@end
