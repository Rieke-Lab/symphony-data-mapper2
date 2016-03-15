//
//  SMKMetadataParserTest.m
//  SymphonyMappingKit
//
//  Created by Mark Cafaro on 1/4/13.
//  Copyright (c) 2013 Rieke Lab. All rights reserved.
//

#import "SMKBaseTestCase.h"
#import "SMKMetadataParser.h"
#import "SMKNote.h"
#import "SMKSource.h"

@interface SMKMetadataParserTest : SMKBaseTestCase {
    NSDateFormatter *_formatter;
    SMKMetadataParser *_parser;
}

@end

@implementation SMKMetadataParserTest

- (void)setUp
{
    [super setUp];
    
    _formatter = [[NSDateFormatter new] autorelease];
    [_formatter setDateFormat:@"MM/dd/yyyy hh:mm:ss a ZZZZZ"];
    
    _parser = [SMKMetadataParser parserForFilePath:[_resourcePath stringByAppendingString:@"010413AcMyCellID1_metadata.xml"]];
    [_parser parse];
}

- (void)testParsingSource
{
    SMKSource *source1 = [[SMKSource new] autorelease];
    source1.identifier = @"c97600a0-4721-48f7-b461-195cd10c73a1";
    source1.label = @"Mouse";
    
    SMKSource *source2 = [[SMKSource new] autorelease];
    source2.identifier = @"90bf9408-1c14-41fc-b908-aede1753137f";
    source2.label = @"Retina";
    
    SMKSource *source3 = [[SMKSource new] autorelease];
    source3.identifier = @"f18e1e5a-7fae-4872-9df1-6767318b46cb";
    source3.label = @"010413AcMyCellID1";
    
    source1.children = [NSArray arrayWithObject:source2];
    source2.children = [NSArray arrayWithObject:source3];
    source3.children = [NSMutableArray arrayWithCapacity:0];
    
    SMKSource *expected = source1;
    SMKSource *actual = _parser.source;
    
    STAssertTrue([actual isEqual:expected], nil);
}

- (void)testParsingNotes
{
    SMKNote *note1 = [[SMKNote new] autorelease];
    note1.timestamp = [_formatter dateFromString:@"1/4/2013 2:29:36 PM -08:00"];
    note1.comment = @"My note after the first 5 epochs.";
    
    SMKNote *note2 = [[SMKNote new] autorelease];
    note2.timestamp = [_formatter dateFromString:@"1/4/2013 2:31:45 PM -08:00"];
    note2.comment = @"My note after the first 10 epochs.";
    
    SMKNote *note3 = [[SMKNote new] autorelease];
    note3.timestamp = [_formatter dateFromString:@"1/4/2013 2:32:28 PM -08:00"];
    note3.comment = @"My note after the first 15 epochs.";
    
    NSArray *expected = [NSArray arrayWithObjects:note1, note2, note3, nil];
    NSArray *actual = _parser.notes;
    
    STAssertTrue([actual isEqualToArray:expected], nil);
}

@end