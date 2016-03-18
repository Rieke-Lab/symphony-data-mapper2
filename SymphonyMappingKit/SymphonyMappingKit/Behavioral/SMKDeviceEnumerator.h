//
//  SMKDeviceEnumerator.h
//  
//
//  Created by Mark Cafaro on 3/17/16.
//
//

#import <Foundation/Foundation.h>

@class MACHdf5Reader;
@class SMKDevice;

@interface SMKDeviceEnumerator : NSEnumerator <NSCopying> {
    MACHdf5Reader *_reader;
    NSArray *_paths;
    NSUInteger _index;
    SMKDevice *_lastDevice;
}

- (id)initWithReader:(MACHdf5Reader *)reader devicePaths:(NSArray *)paths;

@end
