//
//  SMKExperiment.h
//  SymphonyMappingKit
//
//  Created by Mark Cafaro on 3/16/16.
//  Copyright © 2016 Rieke Lab. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SMKExperiment : NSObject {
    NSString *_purpose;
    NSDate *_startTime;
    NSDate *_endTime;
    NSDictionary *_properties;
    NSSet *_keywords;
}

@property (copy) NSString *purpose;
@property (retain) NSDate *startTime;
@property (retain) NSDate *endTime;
@property (retain) NSDictionary *properties;
@property (retain) NSSet *keywords;

@end
