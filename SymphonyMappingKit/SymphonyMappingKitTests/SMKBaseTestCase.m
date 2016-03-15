//
//  SMKBaseTestCase.m
//  SymphonyMapperKit
//
//  Created by Mark Cafaro on 1/2/13.
//  Copyright (c) 2013 Rieke Lab. All rights reserved.
//

#import "SMKBaseTestCase.h"

@implementation SMKBaseTestCase

- (void)setUp
{
    _resourcePath = [[NSBundle bundleForClass:[self class]] resourcePath];
    _resourcePath = [_resourcePath stringByAppendingString:@"/"];
}

- (void)tearDown
{
    // Tear-down code here.
    
    [super tearDown];
}

- (NSString *)pathForResource:(NSString *)filename
{
    return [_resourcePath stringByAppendingString:filename];
}

@end
