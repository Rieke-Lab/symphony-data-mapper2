//
//  SMKExperimentMapper.h
//  SymphonyDataMapper
//
//  Created by Mark Cafaro on 12/28/12.
//  Copyright (c) 2012 Rieke Lab. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class DAQConfigContainer;

@interface SMKExperimentMapper : NSObject {
    NSSet *_dataFilePaths;
    NSSet *_metadataFilePaths;
    NSManagedObjectContext *_context;
    DAQConfigContainer *_daqConfigContainer;
    NSMutableSet *_streams;
    NSURL *_auisqlUrl;
    NSURL *_hdf5FileUrl;
}

+ (id)mapperForDataFilePaths:(NSSet *)dataFilePaths
           metadataFilePaths:(NSSet *)metadataFilePaths
                     context:(NSManagedObjectContext *)context
                   auisqlUrl:(NSURL *)auisqlUrl;

- (id)initWithDataFilePaths:(NSSet *)dataFilePaths
          metadataFilePaths:(NSSet *)metadataFilePaths
                    context:(NSManagedObjectContext *)context
                  auisqlUrl:(NSURL *)auisqlUrl;

- (void)map;

@end
