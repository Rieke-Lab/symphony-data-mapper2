//
//  SMKMetadataParser.h
//  SymphonyMappingKit
//
//  Created by Mark Cafaro on 1/4/13.
//  Copyright (c) 2013 Rieke Lab. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SMKSource;

@interface SMKMetadataParser : NSObject {
    NSString *_filePath;
    SMKSource *_source;
    NSArray *_notes;
}

@property (readonly) SMKSource *source;
@property (readonly) NSArray *notes;

+ (id)parserForFilePath:(NSString *)filePath;
- (id)initWithFilePath:(NSString *)filePath;
- (void)parse;

@end
