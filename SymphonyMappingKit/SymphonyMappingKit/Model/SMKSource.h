//
//  SMKSource.h
//  SymphonyMappingKit
//
//  Created by Mark Cafaro on 1/4/13.
//  Copyright (c) 2013 Rieke Lab. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SMKEntity.h"

@class SMKSourceEnumerator;

@interface SMKSource : SMKEntity {
    SMKSource *_parent;
    NSString *_label;
    SMKSourceEnumerator *_sourceEnumerator;
}

@property (retain) SMKSource *parent;
@property (copy) NSString *label;
@property (retain) SMKSourceEnumerator *sourceEnumerator;

@end
