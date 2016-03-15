//
//  main.m
//  SymphonyDataMapper
//
//  Created by Mark Cafaro on 1/3/13.
//  Copyright (c) 2013 Rieke Lab. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import <SymphonyMappingKit/SMKExperimentMapper.h>
#import "AUIModel/Experiment.h"

int usage()
{
    printf("usage: sdm -a auisqlFile dataFile1 [metaDataFile1] .. [dataFileN [metaDataFileN]]\n");
    return 1;
}

int main(int argc, char *argv[])
{
    NSAutoreleasePool *pool = [NSAutoreleasePool new];
    NSError *error;
    
    NSString *auisqlFilePath = nil;
    BOOL overwriteExisting = NO;
    
    int ch;
    while ((ch = getopt(argc, argv, "a:y")) != -1) {
        switch (ch) {
            case 'a':
                auisqlFilePath = [NSString stringWithCString:optarg encoding:NSASCIIStringEncoding];
                break;
            case 'y':
                overwriteExisting = YES;
                break;
            default:
                return usage();
                break;
        }
    }
    
    if (auisqlFilePath == nil || optind == argc) {
        return usage();
    }
    
    NSMutableSet *dataFilePaths = [NSMutableSet setWithCapacity:argc - optind];
    NSMutableSet *metaDataFilePaths = [NSMutableSet setWithCapacity:argc - optind];
    
    NSFileManager* manager = [NSFileManager defaultManager];
    
    for (int i = optind; i < argc; i++) {
        NSString *filePath = [NSString stringWithCString:argv[i] encoding:NSASCIIStringEncoding];
        
        if (![manager isReadableFileAtPath:filePath]) {
            printf("File is not readable or does not exist: %s\n", [filePath cStringUsingEncoding:NSASCIIStringEncoding]);
            return 1;
        }
        
        if ([filePath hasSuffix:@".xml"]) {
            [metaDataFilePaths addObject:filePath];
        } else {
            [dataFilePaths addObject:filePath];
        }
    }
    
    NSArray *components = [auisqlFilePath componentsSeparatedByString:@".auisql"];
    NSString *hdf5File = [[components objectAtIndex:0] stringByAppendingString:@".h5"];
    
    if ([manager fileExistsAtPath:auisqlFilePath]) {
        char response;
        
        if (overwriteExisting) {
            response = 'Y';
        } else {
            printf("Database file %s already exists.\n", [auisqlFilePath cStringUsingEncoding:NSASCIIStringEncoding]);
        }
        
        while (response != 'Y' && response != 'N') {
            printf("Overwriting will devalidate previous OvationExports! Overwrite? [Y/N] ");
            response = getchar();
            while (getchar() != '\n');
        }
        
        switch (response) {
            case 'Y':
                if ([manager removeItemAtPath:auisqlFilePath error:&error] == NO) {
                    NSLog(@"Couldn't remove existing AUISQL file: %@", error);
                    return 1;
                }
                
                if ([manager fileExistsAtPath:hdf5File]) {
                    if ([manager removeItemAtPath:hdf5File error:&error] == NO) {
                        NSLog(@"Couldn't remove existing HDF5 file: %@", error);
                        return 1;
                    }
                }                
                break;
                
            case 'N':
                return 0;
        }
    }
    
    NSBundle *modelBundle = [NSBundle bundleForClass:[Experiment class]];
    NSManagedObjectModel *objectModel = [NSManagedObjectModel mergedModelFromBundles:[NSArray arrayWithObject:modelBundle]];
    NSPersistentStoreCoordinator *coordinator = [[NSPersistentStoreCoordinator alloc] autorelease];
    [coordinator initWithManagedObjectModel:objectModel];
    
    NSURL *auisqlUrl = [NSURL fileURLWithPath:auisqlFilePath];
    id result = [coordinator addPersistentStoreWithType:NSSQLiteStoreType
                                          configuration:nil
                                                    URL:auisqlUrl
                                                options:nil
                                                  error:&error];
    if (result == nil) {
        NSLog(@"Failed to initialize auisql store: %@", error);
        return 2;
    }
    
    NSManagedObjectContext *context = [[NSManagedObjectContext new] autorelease];
    [context setPersistentStoreCoordinator:coordinator];
    [context setUndoManager:nil];
    
    SMKExperimentMapper *mapper = [SMKExperimentMapper mapperForDataFilePaths:dataFilePaths
                                                            metadataFilePaths:metaDataFilePaths
                                                                      context:context
                                                                    auisqlUrl:auisqlUrl];
    
    @try {
        [mapper map];
    }
    @catch (NSException *exception) {
        NSLog(@"Error: %@", exception);
    }
    
    [pool drain];
    return 0;
}
