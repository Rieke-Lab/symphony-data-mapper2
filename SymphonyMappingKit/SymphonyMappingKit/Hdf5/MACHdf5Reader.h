//
//  MACHdf5Reader.h
//  SymphonyMappingKit
//
//  Created by Mark Cafaro on 1/29/13.
//  Copyright (c) 2013 Rieke Lab. All rights reserved.
//

#import <Foundation/Foundation.h>

#include "hdf5.h"

@class MACHdf5ObjectInformation;

@interface MACHdf5Reader : NSObject {
    hid_t _fileId;
}

@property (readonly) hid_t fileId;

+ (id)readerWithFilePath:(NSString *)filePath;
- (id)initWithFilePath:(NSString *)filePath;

- (NSArray *)allGroupMembersInPath:(NSString *)groupPath;
- (NSArray *)groupMemberLinkInfoInPath:(NSString *)groupPath;

- (NSArray *)allAttributeNamesOnPath:(NSString *)objectPath;

- (MACHdf5ObjectInformation *)objectInformationForPath:(NSString *)objectPath;

- (BOOL)hasAttribute:(NSString *)attributeName
              onPath:(NSString *)objectPath;

- (NSString *)readStringAttribute:(NSString *)attributeName onPath:(NSString *)objectPath;
- (int64_t)readLongAttribute:(NSString *)attributeName onPath:(NSString *)objectPath;
- (NSArray *)readLongArrayAttribute:(NSString *)attributeName onPath:(NSString *)objectPath;
- (int32_t)readIntAttribute:(NSString *)attributeName onPath:(NSString *)objectPath;
- (NSArray *)readIntArrayAttribute:(NSString *)attributeName onPath:(NSString *)objectPath;
- (int16_t)readShortAttribute:(NSString *)attributeName onPath:(NSString *)objectPath;
- (NSArray *)readShortArrayAttribute:(NSString *)attributeName onPath:(NSString *)objectPath;
- (float)readFloatAttribute:(NSString *)attributeName onPath:(NSString *)objectPath;
- (NSArray *)readFloatArrayAttribute:(NSString *)attributeName onPath:(NSString *)objectPath;
- (double)readDoubleAttribute:(NSString *)attributeName onPath:(NSString *)objectPath;
- (NSArray *)readDoubleArrayAttribute:(NSString *)attributeName onPath:(NSString *)objectPath;
- (BOOL)readBooleanAttribute:(NSString *)attributeName onPath:(NSString *)objectPath;

- (NSDictionary *)readAttributesOnPath:(NSString *)objectPath;

@end
