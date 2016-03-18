//
//  SMKSource.h
//  SymphonyMappingKit
//
//  Created by Mark Cafaro on 1/4/13.
//  Copyright (c) 2013 Rieke Lab. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SMKEntity.h"

@interface SMKSource : SMKEntity {
    NSString *_identifier;
    NSString *_label;
    NSArray *_children;
}

@property (copy) NSString *identifier;
@property (copy) NSString *label;
@property (assign) NSArray *children;

@end
