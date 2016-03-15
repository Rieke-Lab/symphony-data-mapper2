//
//  SMKEpochGroupEnumerator.h
//  SymphonyMappingKit
//
//  Created by Mark Cafaro on 1/25/13.
//  Copyright (c) 2013 Rieke Lab. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MACHdf5Reader;
@class SMKEpochGroup;

@interface SMKEpochGroupEnumerator : NSEnumerator <NSCopying> {
    MACHdf5Reader *_reader;
    NSArray *_paths;
    NSUInteger _index;
    SMKEpochGroup *_lastGroup;
}

- (id)initWithReader:(MACHdf5Reader *)reader epochGroupPaths:(NSArray *)paths;

@end
