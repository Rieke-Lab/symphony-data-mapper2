//
//  SMKEpochGroupEnumerator.h
//  SymphonyMappingKit
//
//  Created by Mark Cafaro on 1/25/13.
//  Copyright (c) 2013 Rieke Lab. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SMKTimelineEntityEnumerator.h"
#import "SMKEpochGroup.h"

@interface SMKEpochGroupEnumerator : SMKTimelineEntityEnumerator {
    SMKEpochGroup *_parent;
}

- (id)initWithReader:(MACHdf5Reader *)reader entityPaths:(NSArray *)paths parent:(SMKEpochGroup *)parent;

@end
