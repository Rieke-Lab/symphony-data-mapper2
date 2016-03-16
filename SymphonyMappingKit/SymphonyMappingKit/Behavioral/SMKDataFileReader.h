//
//  SMKDataFileReader.h
//  SymphonyMappingKit
//
//  Created by Mark Cafaro on 1/25/13.
//  Copyright (c) 2013 Rieke Lab. All rights reserved.
//

#import <Foundation/Foundation.h>

#include "hdf5.h"

@class SMKExperimentEnumerator;
@class MACHdf5Reader;

@interface SMKDataFileReader : NSObject {
    MACHdf5Reader *_reader;
    NSMutableArray *_experimentPaths;
}

+ (id)readerForHdf5FilePath:(NSString *)hdf5FilePath;
- (id)initWithHdf5FilePath:(NSString *)hdf5FilePath;
- (SMKExperimentEnumerator *)experimentEnumerator;

@end
