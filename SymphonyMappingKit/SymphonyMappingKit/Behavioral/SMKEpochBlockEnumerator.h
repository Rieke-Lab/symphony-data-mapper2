//
//  SMKEpochBlockEnumerator.h
//  
//
//  Created by Mark Cafaro on 3/18/16.
//
//

#import "SMKTimelineEntityEnumerator.h"

@class SMKEpochGroup;

@interface SMKEpochBlockEnumerator : SMKTimelineEntityEnumerator {
    SMKEpochGroup *_epochGroup;
}

- (id)initWithReader:(MACHdf5Reader *)reader entityPaths:(NSArray *)paths epochGroup:(SMKEpochGroup *)group;

@end
