//
//  SMKExperiment.h
//  SymphonyMappingKit
//
//  Created by Mark Cafaro on 3/16/16.
//  Copyright © 2016 Rieke Lab. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SMKDeviceEnumerator;
@class SMKSourceEnumerator;
@class SMKEpochGroupEnumerator;

@interface SMKExperiment : NSObject {
    NSString *_purpose;
    NSDate *_startTime;
    NSDate *_endTime;
    NSDictionary *_properties;
    NSSet *_keywords;
    NSSet *_notes;
    SMKDeviceEnumerator *_deviceEnumerator;
    SMKSourceEnumerator *_sourceEnumerator;
    SMKEpochGroupEnumerator *_epochGroupEnumerator;
}

@property (copy) NSString *purpose;
@property (retain) NSDate *startTime;
@property (retain) NSDate *endTime;
@property (retain) NSDictionary *properties;
@property (retain) NSSet *keywords;
@property (retain) NSSet *notes;
@property (retain) SMKDeviceEnumerator *deviceEnumerator;
@property (retain) SMKSourceEnumerator *sourceEnumerator;
@property (retain) SMKEpochGroupEnumerator *epochGroupEnumerator;

@end
