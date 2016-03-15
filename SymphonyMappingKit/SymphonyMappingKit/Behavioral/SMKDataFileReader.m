//
//  SMKDataFileReader.m
//  SymphonyMappingKit
//
//  Created by Mark Cafaro on 1/25/13.
//  Copyright (c) 2013 Rieke Lab. All rights reserved.
//

#import "SMKDataFileReader.h"
#import "SMKEpochGroup.h"
#import "SMKEpochGroupEnumerator.h"
#import "MACHdf5Reader.h"
#import "MACHdf5LinkInformation.h"

#define STRING_MAX 1024

@interface SMKEpochGroupEnumerator ()

- (void)readAllEpochGroups;
- (SMKEpochGroup *)readEpochGroup:(hid_t)groupId parent:(SMKEpochGroup *)parent;

@end

@implementation SMKDataFileReader

+ (id)readerForHdf5FilePath:(NSString *)hdf5FilePath
{
    return [[[self alloc] initWithHdf5FilePath:hdf5FilePath] autorelease];
}

- (id)initWithHdf5FilePath:(NSString *)hdf5FilePath
{
    self = [super init];
    if (self) {
        _reader = [MACHdf5Reader readerWithFilePath:hdf5FilePath];
        
        _epochGroupPaths = [NSMutableArray array];
        
        NSArray *rootMembers = [_reader groupMemberLinkInfoInPath:@"/"];
        
        for (MACHdf5LinkInformation *member in rootMembers) {
            if (member.isGroup) {
                [_epochGroupPaths addObject:member.path];
            }
        }
    }
    return self;
}

- (SMKEpochGroupEnumerator *)epochGroupEnumerator
{   
    return [[[SMKEpochGroupEnumerator alloc] initWithReader:_reader epochGroupPaths:_epochGroupPaths] autorelease];
}

@end
