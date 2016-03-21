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

// HACK: This should be defined based on the NOTE data type in the data file.
// How do we create a struct data type from that datatype?
#pragma pack(1)

typedef struct dtoData {
    uint64_t ticks;
    double offset;
} dtoData;

typedef struct noteData {
    dtoData time;
    char *text;
} noteData;

typedef struct measurementData {
    double quantity;
    char units[10];
} measurementData;

#pragma options align=reset

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
