//
//  MACHdf5CommonInformation.h
//  SymphonyMappingKit
//
//  Created by Mark Cafaro on 1/31/13.
//  Copyright (c) 2013 Rieke Lab. All rights reserved.
//

#import <Foundation/Foundation.h>

#include "hdf5.h"

@interface MACHdf5CommonInformation : NSObject {
    NSString *_path;
    H5O_type_t _type; // FIXME: this needs to be put into a class
}

@property (readonly) NSString *path;
@property (readonly) H5O_type_t type;
@property (readonly) BOOL isGroup;

- (id)initWithPath:(NSString *)path objectType:(H5O_type_t)type;

@end
