//
//  MACHdf5ReaderTest.m
//  SymphonyMappingKit
//
//  Created by Mark Cafaro on 1/30/13.
//  Copyright (c) 2013 Rieke Lab. All rights reserved.
//

#import "SMKBaseTestCase.h"
#import "MACHdf5Reader.h"
#import "MACHdf5LinkInformation.h"

#include "hdf5.h"

@interface MACHdf5ReaderTest : SMKBaseTestCase {
    MACHdf5Reader *_reader;
}

@end

@implementation MACHdf5ReaderTest

- (void)setUp
{
    [super setUp];
    
    _reader = [MACHdf5Reader readerWithFilePath:[_resourcePath stringByAppendingString:@"010413AcMyCellID1.h5"]];
}

- (void)testGroupMemberLinkInfo
{
    MACHdf5LinkInformation *link1 = [[MACHdf5LinkInformation alloc] initWithPath:@"/MyLabel1-7d785046-3cff-402c-9ffe-52579fd130c4/epochGroups" objectType:H5O_TYPE_GROUP];
    [link1 autorelease];
    
    MACHdf5LinkInformation *link2 = [[MACHdf5LinkInformation alloc] initWithPath:@"/MyLabel1-7d785046-3cff-402c-9ffe-52579fd130c4/epochs" objectType:H5O_TYPE_GROUP];
    [link2 autorelease];
    
    MACHdf5LinkInformation *link3 = [[MACHdf5LinkInformation alloc] initWithPath:@"/MyLabel1-7d785046-3cff-402c-9ffe-52579fd130c4/properties" objectType:H5O_TYPE_GROUP];
    [link3 autorelease];
    
    NSArray *expected = [NSArray arrayWithObjects:link1, link2, link3, nil];
    NSArray *actual = [_reader groupMemberLinkInfoInPath:@"/MyLabel1-7d785046-3cff-402c-9ffe-52579fd130c4"];
    
    STAssertTrue([actual isEqualToArray:expected], nil);
}

- (void)testReadIntArrayAttribute
{
    NSMutableArray *expected = [NSMutableArray arrayWithCapacity:10];
    for (int i = 1; i <= 10; i++) {
        [expected addObject:[NSNumber numberWithInt:i]];
    }
    
    NSArray *actual = [_reader readIntArrayAttribute:@"ints" onPath:@"MyLabel1-7d785046-3cff-402c-9ffe-52579fd130c4/epochs/epoch-edu.washington.rieke.Ramp-22581860-0741-4ec2-b60b-de8cdc2df1b7/protocolParameters"];
    
    STAssertTrue([actual isEqualToArray:expected], nil);
}

- (void)testAllAttributeNamesOnPath
{
    NSSet *expected = [NSSet setWithObjects:@"amp", @"ampHoldSignal", @"displayName", @"epochInterval",
                         @"identifier", @"numberOfAverages", @"preAndTailSignal", @"preTime", @"rampAmplitude",
                         @"sampleRate", @"stimTime", @"tailTime", @"version", @"ints", @"floats", @"doubles", nil];
    
    NSArray *attributes = [_reader allAttributeNamesOnPath:@"MyLabel1-7d785046-3cff-402c-9ffe-52579fd130c4/epochs/epoch-edu.washington.rieke.Ramp-22581860-0741-4ec2-b60b-de8cdc2df1b7/protocolParameters"];
    NSSet *actual = [NSSet setWithArray:attributes];
    
    STAssertTrue([actual isEqualToSet:expected], nil);
}

- (void)testReadAttributesOnPath
{
    NSDictionary *expected = [NSDictionary dictionaryWithObjectsAndKeys:
                              @"Amplifier_Ch1", @"amp",
                              d(-60.0), @"ampHoldSignal",
                              @"Ramp", @"displayName", 
                              d(0.0), @"epochInterval", 
                              @"edu.washington.rieke.Ramp", @"identifier", 
                              d(5), @"numberOfAverages",
                              d(-60.0), @"preAndTailSignal", 
                              d(50.0), @"preTime", 
                              d(120.0), @"rampAmplitude", 
                              d(10000.0), @"sampleRate", 
                              d(500.0), @"stimTime",
                              d(50.0), @"tailTime", 
                              d(1.0), @"version", 
                              [NSArray arrayWithObjects:i(1), i(2), i(3), i(4), i(5), i(6), i(7), i(8), i(9), i(10), nil], @"ints", 
                              [NSArray arrayWithObjects:f(10), f(9), f(8), f(7), f(6), f(5), f(4), f(3), f(2), f(1), nil], @"floats", 
                              [NSArray arrayWithObjects:d(1), d(2), nil], @"doubles",
                              nil];
    
    NSDictionary *actual = [_reader readAttributesOnPath:@"MyLabel1-7d785046-3cff-402c-9ffe-52579fd130c4/epochs/epoch-edu.washington.rieke.Ramp-22581860-0741-4ec2-b60b-de8cdc2df1b7/protocolParameters"];
    
    STAssertTrue([actual isEqualToDictionary:expected], nil);
}

@end
