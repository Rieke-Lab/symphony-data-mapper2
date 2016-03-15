//
//  SMKEpochEnumerator.h
//  SymphonyMappingKit
//
//  Created by Mark Cafaro on 1/31/13.
//  Copyright (c) 2013 Rieke Lab. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MACHdf5Reader;
@class SMKEpoch;

@interface SMKEpochEnumerator : NSEnumerator <NSCopying> {
    MACHdf5Reader *_reader;
    NSArray *_paths;
    NSUInteger _index;
    SMKEpoch *_lastEpoch;
    NSNumberFormatter *_numFormatter;
}

- (id)initWithReader:(MACHdf5Reader *)reader epochPaths:(NSArray *)paths;

@end
