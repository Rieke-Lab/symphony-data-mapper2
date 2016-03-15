//
//  SMKEpochGroupEnumeratorTest.m
//  SymphonyMappingKit
//
//  Created by Mark Cafaro on 2/4/13.
//  Copyright (c) 2013 Rieke Lab. All rights reserved.
//

#import "SMKBaseTestCase.h"
#import "SMKEpochGroupEnumerator.h"
#import "SMKEpochGroup.h"
#import "SMKEpoch.h"
#import "MACHdf5Reader.h"

@interface SMKEpochGroupEnumeratorTest : SMKBaseTestCase {
    SMKEpochGroupEnumerator *_enumerator;
}

@end

@implementation SMKEpochGroupEnumeratorTest

- (void)setUp
{
    [super setUp];
    
    MACHdf5Reader *reader = [MACHdf5Reader readerWithFilePath:[_resourcePath stringByAppendingString:@"010413AcMyCellID1.h5"]];
    
    NSString *group1 = @"/MyLabel1-7d785046-3cff-402c-9ffe-52579fd130c4";
    NSString *group2 = @"/MyLabel3-330e1dab-a400-4f32-b345-23a91cfbde4f";
    
    _enumerator = [[[SMKEpochGroupEnumerator alloc] initWithReader:reader epochGroupPaths:[NSArray arrayWithObjects:group1, group2, nil]] autorelease];
}

- (void)testNextObject
{
    int i = 0;
    while ([_enumerator nextObject]) {
        i++;
    }
    STAssertTrue(i == 2, nil);
}

- (void)testLabel
{
    SMKEpochGroup *group = [_enumerator nextObject];
    
    STAssertTrue([group.label isEqualToString:@"MyLabel1"], nil);
}

- (void)testSourceIdentifier
{
    SMKEpochGroup *group = [_enumerator nextObject];
    
    STAssertTrue([group.sourceIdentifier isEqualToString:@"f18e1e5a-7fae-4872-9df1-6767318b46cb"], nil);
}

- (void)testProperties
{
    SMKEpochGroup *group = [_enumerator nextObject];
    
    NSDictionary *expected = [NSDictionary dictionaryWithObjectsAndKeys:
                              @"MyCellID1", @"cellID",
                              @"MyMouseID1", @"mouseID",
                              @"A", @"rigName",
                              @"7d785046-3cff-402c-9ffe-52579fd130c4", @"__symphony__uuid__",
                              nil];
    
    STAssertTrue([group.properties isEqualToDictionary:expected], nil);
}

- (void)testKeywords
{
    SMKEpochGroup *group = [_enumerator nextObject];
    
    STAssertTrue([group.keywords isEqualToSet:[NSSet setWithObject:@"MyKeyword"]], nil);
}

- (void)testEpochEnumerator
{
    SMKEpochGroup *group = [_enumerator nextObject];
    
    SMKEpochEnumerator *epochEnumerator = group.epochEnumerator;
    
    SMKEpoch *epoch;
    int i = 0;
    while (epoch = [epochEnumerator nextObject]) {
        i++;
    }
    STAssertTrue(i == 5, nil);
}

- (void)testEpochGroupEnumerator
{
    SMKEpochGroup *group = [_enumerator nextObject];
    
    SMKEpochGroupEnumerator *subEnumerator = group.epochGroupEnumerator;

    int i = 0;
    while ([subEnumerator nextObject]) {
        i++;
    }
    STAssertTrue(i = 1, nil);
}

@end
