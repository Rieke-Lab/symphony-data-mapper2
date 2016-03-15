//
//  SMKStimulus.h
//  SymphonyMappingKit
//
//  Created by Mark Cafaro on 2/4/13.
//  Copyright (c) 2013 Rieke Lab. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SMKIOBase.h"

@interface SMKStimulus : SMKIOBase {
    NSDictionary *_parameters;
    NSString *_pluginId;
    NSString *_units;
}

@property (retain) NSDictionary *parameters;
@property (copy) NSString *pluginId;
@property (copy) NSString *units;

@end
