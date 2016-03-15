//
//  BWFileSystemResource+UrlFix.h
//  SymphonyMappingKit
//
//  Created by Mark Cafaro on 2/7/13.
//  Copyright (c) 2013 Rieke Lab. All rights reserved.
//

#import <BWKit/BWKit.h>

@interface BWFileSystemResource (UrlFix)

+ (NSURL*)URLForFileSystemResource:(BWFileSystemResource*)resource relativeToRootURL:(NSURL*)relativeRoot openPanel:(NSOpenPanel*)op;

@end
