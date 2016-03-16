//
//  SMKExperimentEnumerator.h
//  SymphonyMappingKit
//
//  Created by Mark Cafaro on 3/16/16.
//  Copyright © 2016 Rieke Lab. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MACHdf5Reader;
@class SMKExperiment;

@interface SMKExperimentEnumerator : NSEnumerator <NSCopying> {
    MACHdf5Reader *_reader;
    NSArray *_paths;
    NSUInteger _index;
    SMKExperiment *_lastExperiment;
}

- (id)initWithReader:(MACHdf5Reader *)reader experimentPaths:(NSArray *)paths;

@end
