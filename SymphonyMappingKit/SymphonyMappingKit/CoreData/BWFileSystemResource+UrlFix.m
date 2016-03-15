//
//  BWFileSystemResource+UrlFix.m
//  SymphonyMappingKit
//
//  Created by Mark Cafaro on 2/7/13.
//  Copyright (c) 2013 Rieke Lab. All rights reserved.
//

#import "BWFileSystemResource+UrlFix.h"

@implementation BWFileSystemResource (UrlFix)

// HACK: Should be modified directly in BWKit.
+ (NSURL*)URLForFileSystemResource:(BWFileSystemResource*)resource relativeToRootURL:(NSURL*)relativeRoot openPanel:(NSOpenPanel*)op {
    NSURL *result = nil;
    
    // FIXME: This was causing the BWFileSystemResource url method to return two different results when called in succession.
    // The first was a filepath URL and the second was just a URL pointing to the file.
//    if([resource relativeURL] != nil) {
//        result = [NSURL URLWithString:[[[resource relativeURL] relativePath] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] relativeToURL:relativeRoot];
//    }
    
    if ([resource relativeURL] != nil) {
        result = [NSURL URLWithString:[[[resource relativeURL] relativePath] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] relativeToURL:relativeRoot];        
        result = [NSURL fileURLWithPath:result.path];
    }
    
    if(![[NSFileManager defaultManager] fileExistsAtPath:[result path]]) { //relative-path failed. ask user to find the file
        if(op == nil) {
            op = [NSOpenPanel openPanel];
        }
        
        [op setAllowsMultipleSelection:NO];
        [op setCanChooseFiles:YES];
        [op setCanChooseDirectories:YES];
        [op setResolvesAliases:YES];
        
        if([resource relativeURL] != nil) {
            [op setMessage:[NSString stringWithFormat:BWLocalizedString(@"Find %@"), [[[resource relativeURL] path] lastPathComponent]]];
        }
        
        if([op runModal] == NSOKButton) {
            result = [op URL];
            BWLogDebug(@"Setting relative path from user-selected URL: %@", result);
            [resource setRelativeURL:[NSURL fileURLWithPath:[[result path] pathRelativeToPath:[relativeRoot path]]]];
            
        }
    }
    
    return result;
}

@end
