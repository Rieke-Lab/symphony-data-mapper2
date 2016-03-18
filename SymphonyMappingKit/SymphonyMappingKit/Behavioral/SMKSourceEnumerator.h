//
//  SMKSourceEnumerator.h
//  
//
//  Created by Mark Cafaro on 3/17/16.
//
//

#import <Foundation/Foundation.h>

@class MACHdf5Reader;
@class SMKSource;

@interface SMKSourceEnumerator : NSEnumerator <NSCopying> {
    MACHdf5Reader *_reader;
    NSArray *_paths;
    NSUInteger _index;
    SMKSource *_lastSource;
}

- (id)initWithReader:(MACHdf5Reader *)reader sourcePaths:(NSArray *)paths;

@end
