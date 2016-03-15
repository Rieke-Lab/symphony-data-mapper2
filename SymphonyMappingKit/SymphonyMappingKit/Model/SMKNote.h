//
//  SMKNote.h
//  SymphonyMappingKit
//
//  Created by Mark Cafaro on 1/4/13.
//  Copyright (c) 2013 Rieke Lab. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SMKNote : NSObject {
    NSString *_comment;
    NSDate *_timestamp;
}

@property (copy) NSString *comment;
@property (copy) NSDate *timestamp;

@end
