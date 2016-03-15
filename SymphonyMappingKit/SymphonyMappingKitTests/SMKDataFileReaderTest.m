//
//  SMKDataFileReaderTest.m
//  SymphonyMappingKit
//
//  Created by Mark Cafaro on 1/28/13.
//  Copyright (c) 2013 Rieke Lab. All rights reserved.
//

#import "SMKBaseTestCase.h"
#import "SMKDataFileReader.h"
#import "SMKEpochGroupEnumerator.h"
#import "SMKEpochGroup.h"

@interface SMKDataFileReaderTest : SMKBaseTestCase {
    SMKDataFileReader *_reader;
}

@end

@implementation SMKDataFileReaderTest

- (void)setUp
{
    [super setUp];
    
    _reader = [SMKDataFileReader readerForHdf5FilePath:[_resourcePath stringByAppendingString:@"010413AcMyCellID1.h5"]];
}

- (void)testEpochGroupEnumerator
{
    SMKEpochGroupEnumerator *enumerator = [_reader epochGroupEnumerator];
    
    int count = 0;
    while ([enumerator nextObject]) {
        count++;
    }
    
    STAssertTrue(count == 2, nil);
}

@end
