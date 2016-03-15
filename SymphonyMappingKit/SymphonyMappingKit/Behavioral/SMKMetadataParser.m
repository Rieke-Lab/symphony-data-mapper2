//
//  SMKMetadataParser.m
//  SymphonyMappingKit
//
//  Created by Mark Cafaro on 1/4/13.
//  Copyright (c) 2013 Rieke Lab. All rights reserved.
//

#import "SMKMetadataParser.h"
#import "SMKNote.h"
#import "SMKSource.h"

@interface SMKMetadataParser ()

- (void)parseNotes:(NSXMLNode *)notesNode;
- (void)parseSource:(SMKSource *)source sourceNode:(NSXMLNode *)sourceNode;

@end

@implementation SMKMetadataParser

@synthesize source = _source;
@synthesize notes = _notes;

+ (id)parserForFilePath:(NSString *)filePath
{
    return [[[self alloc] initWithFilePath:filePath] autorelease];
}

- (id)initWithFilePath:(NSString *)filePath
{
    self = [super init];
    if (self) {        
        _filePath = [filePath copy];
    }
    return self;
}

- (void)parse
{
    NSURL *url = [NSURL fileURLWithPath:_filePath];
    
    NSError *error;
    NSXMLDocument *xmlDoc = [[NSXMLDocument alloc] initWithContentsOfURL:url
                                                                 options:0
                                                                   error:&error];
    
    if (xmlDoc == nil) {
        [NSException raise:@"Failed to init xml" format:@"Failed to init xml: %@", [error localizedDescription]];
    }
    
    NSXMLNode *xRoot = [xmlDoc rootElement];
    
    NSArray *cNodes = [xRoot children];
    for (int i = 0; i < [cNodes count]; i++) {
        NSXMLNode *childNode = [cNodes objectAtIndex:i];
        if ([[childNode name] isEqualToString:@"notes"]) {
            [self parseNotes:childNode];
        } else if ([[childNode name] isEqualToString:@"source"]) {
            _source = [SMKSource new];
            [self parseSource:_source sourceNode:childNode];
        }
    }
}

- (void)parseNotes:(NSXMLNode *)notesNode
{
    NSArray *cNodes = [notesNode children];
    
    _notes = [NSMutableArray arrayWithCapacity:[cNodes count]];
    
    NSDateFormatter *formatter = [NSDateFormatter new];
    
    // HACK: ISO8601 time zone format was not released until 10.8 and won't work on 10.7 and 10.6. Instead we'll remove
    // the time zone colon and try to parse the date that way.
    [formatter setDateFormat:@"MM/dd/yyyy hh:mm:ss a ZZZ"];
    for (int i = 0; i < [cNodes count]; i++) {
        NSXMLNode *childNode = [cNodes objectAtIndex:i];
        if ([[childNode name] isEqualToString:@"note"]) {
            SMKNote *note = [SMKNote new];
            
            NSXMLNode *time = [((NSXMLElement *)childNode) attributeForName:@"time"];
            NSString *timeStr = [time stringValue];
            NSRange range = NSMakeRange([timeStr length] - 4, 3);
            timeStr = [timeStr stringByReplacingOccurrencesOfString:@":" withString:@"" options:0 range:range];
            note.timestamp = [formatter dateFromString:timeStr];
            
            note.comment = [childNode stringValue];
            
            [((NSMutableArray *)_notes) addObject:note];
            [note release];
        }
    }
    [formatter release];
}

- (void)parseSource:(SMKSource *)source sourceNode:(NSXMLNode *)sourceNode
{
    NSXMLNode *identifier = [((NSXMLElement *)sourceNode) attributeForName:@"identifier"];
    source.identifier = [identifier stringValue];
    
    NSXMLNode *label = [((NSXMLElement *)sourceNode) attributeForName:@"label"];
    source.label = [label stringValue];
    
    NSArray *cNodes = [sourceNode children];
    
    source.children = [NSMutableArray arrayWithCapacity:[cNodes count]];
    
    for (int i = 0; i < [cNodes count]; i++) {
        NSXMLElement *childNode = [cNodes objectAtIndex:i];
        if ([[childNode name] isEqualToString:[sourceNode name]]) {
            SMKSource *child = [SMKSource new];
            [(NSMutableArray *)source.children addObject:child];
            [self parseSource:child sourceNode:childNode];
            [child release];
        }
    }
}

- (void)dealloc
{
    [_filePath release];
    [_source release];
    
    [super dealloc];
}

@end
