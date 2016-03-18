//
//  SMKEntityEnumerator.h
//  
//
//  Created by Mark Cafaro on 3/18/16.
//
//

#import <Foundation/Foundation.h>

@class MACHdf5Reader;
@class SMKEntity;

@interface SMKEntityEnumerator : NSEnumerator <NSCopying> {
    MACHdf5Reader *_reader;
    NSArray *_paths;
    NSUInteger _index;
    SMKEntity *_lastEntity;
}

- (id)initWithReader:(MACHdf5Reader *)reader entityPaths:(NSArray *)paths;

- (id)createNextEntity;
- (void)mapEntity:(SMKEntity *)entity withPath:(NSString *)path;

@end
