//
//  SMKExperimentMapperTest.m
//  SymphonyMapperKit
//
//  Created by Mark Cafaro on 1/2/13.
//  Copyright (c) 2013 Rieke Lab. All rights reserved.
//

#import "SMKBaseTestCase.h"
#import "SMKExperimentMapper.h"

#import <AUIModel/AUIModel.h>

@interface SMKExperimentMapperTest : SMKBaseTestCase {
    SMKExperimentMapper *_mapper;
    NSManagedObjectContext *_context;
}

@end

@implementation SMKExperimentMapperTest

- (void)setUp
{
    [super setUp];
    
    NSBundle *modelBundle = [NSBundle bundleForClass:[Experiment class]];
    NSManagedObjectModel *objectModel = [NSManagedObjectModel mergedModelFromBundles:[NSArray arrayWithObject:modelBundle]];
    NSPersistentStoreCoordinator *coordinator = [[NSPersistentStoreCoordinator alloc] autorelease];
    [coordinator initWithManagedObjectModel:objectModel];
    [coordinator addPersistentStoreWithType:NSInMemoryStoreType
                              configuration:nil
                                        URL:nil
                                    options:nil
                                      error:nil];
    
    _context = [[NSManagedObjectContext new] autorelease];
    [_context setPersistentStoreCoordinator:coordinator];
    
    NSSet *dataFiles = [NSSet setWithObjects:
                        [self pathForResource:@"010413AcMyCellID1.h5"],
                        [self pathForResource:@"010413AcMyCellID2.h5"],
                        [self pathForResource:@"021313AcMyCellID1.h5"],
                        nil];
    
    NSSet *metadataFiles = [NSSet setWithObjects:
                            [self pathForResource:@"010413AcMyCellID1_metadata.xml"],
                            [self pathForResource:@"010413AcMyCellID2_metadata.xml"],
                            [self pathForResource:@"021313AcMyCellID1_metadata.xml"],
                            nil];
    
    // Need a temp file just so the mapper won't complain
    NSURL *auisqlUrl = [NSURL fileURLWithPath:@"010413.auisql"];
    [[NSFileManager defaultManager] createFileAtPath:auisqlUrl.path contents:nil attributes:nil];
    
    // Remove any pre-existing data file from last run
    NSURL *dataFileUrl = [NSURL fileURLWithPath:@"010413.h5"];
    if ([[NSFileManager defaultManager] fileExistsAtPath:dataFileUrl.path]) {
        [[NSFileManager defaultManager] removeItemAtURL:dataFileUrl error:nil];
    }
    
    _mapper = [SMKExperimentMapper mapperForDataFilePaths:dataFiles
                                        metadataFilePaths:metadataFiles
                                                  context:_context
                                                auisqlUrl:auisqlUrl];
}

//- (void)testEpochMapping
//{
//    [_mapper map];
//    
//    NSEntityDescription *description = [NSEntityDescription entityForName:@"Epoch"
//                                                   inManagedObjectContext:_context];
//    
//    NSFetchRequest *request = [[NSFetchRequest new] autorelease];
//    request.entity = description;
//    
//    NSArray *result = [_context executeFetchRequest:request error:nil];
//    
//    NSDate *dotNetRefDate = [NSDate dateWithString:@"0001-01-01 00:00:00 +0000"];
//    NSDate *startDate = [NSDate dateWithTimeInterval:(634929066890547086 / 1e7) sinceDate:dotNetRefDate];
//    
//    for (Epoch *epoch in result) {
//        NSLog(@"%@", epoch.startDate);
//        if ([epoch.startDate isEqualToDate:startDate]) {
//            NSLog(@"HERE!");
//        }
//    }
//    
//}

- (void)testResponseMapping
{
    [_mapper map];
    
    NSEntityDescription *description = [NSEntityDescription entityForName:@"Epoch"
                                                   inManagedObjectContext:_context];
    
    NSFetchRequest *request = [[NSFetchRequest new] autorelease];
    request.entity = description;
    
    NSDate *dotNetRefDate = [NSDate dateWithString:@"0001-01-01 00:00:00 +0000"];
    NSDate *startDate = [NSDate dateWithTimeInterval:(634929066890547086 / 1e7) sinceDate:dotNetRefDate];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"startDate = %@", startDate];
    request.predicate = predicate;
    
    NSArray *result = [_context executeFetchRequest:request error:nil];
    
    Epoch *epoch = [result objectAtIndex:0];
        
    Response *response = [epoch responseWithChannelID:0 ofType:ANALOG_IN];
    
    NSData *data = response.data;
    
    double test = 50.0;
    [data getBytes:&test length:sizeof(double)];
    
    STAssertTrue(test == 0.0, nil);
    STAssertTrue(data.length == 48000, nil);
}


@end
