//
//  SMKEpochEnumerator.m
//  SymphonyMappingKit
//
//  Created by Mark Cafaro on 1/31/13.
//  Copyright (c) 2013 Rieke Lab. All rights reserved.
//

#import "SMKEpochEnumerator.h"
#import "SMKEpoch.h"
#import "SMKStimulus.h"
#import "SMKResponse.h"
#import "MACHdf5Reader.h"
#import "MACHdf5ObjectInformation.h"
#import "MACHdf5LinkInformation.h"

// HACK: This should be defined based on the MEASUREMENT data type in the data file.
// How do we create a struct data type from that datatype?
typedef struct measurementData {
	double quantity;
	char units[40];
} measurementData;

// HACK: Same with this.
typedef struct backgroundData {
    char externalDevice[40];
    measurementData measurement;
    measurementData sampleRate;
} backgroundData;

@implementation SMKEpochEnumerator

- (id)initWithReader:(MACHdf5Reader *)reader epochPaths:(NSArray *)paths
{
    self = [super init];
    if (self) {
        _reader = [reader retain];
        _paths = [paths retain];
        _index = 0;
        _numFormatter = [NSNumberFormatter new];
    }
    return self;
}

- (id)nextObject
{
    if (_index >= [_paths count]) {
        return nil;
    }
    
    NSString *epochPath = [_paths objectAtIndex:_index];
    
    // Release the last returned epoch
    if (_lastEpoch != nil) {
        [_lastEpoch release];
    }
    
    SMKEpoch *epoch = [SMKEpoch new];
    
    NSDate *dotNetRefDate = [NSDate dateWithString:@"0001-01-01 00:00:00 +0000"];
    
    // Start time
    int64_t startTicks = [_reader readLongAttribute:@"startTimeDotNetDateTimeOffsetUTCTicks" onPath:epochPath];
    NSTimeInterval startSecs = startTicks / 1e7;
    epoch.startTime = [NSDate dateWithTimeInterval:startSecs sinceDate:dotNetRefDate];
    
    // Duration
    double durationSecs = [_reader readDoubleAttribute:@"durationSeconds" onPath:epochPath];
    epoch.duration = [NSNumber numberWithDouble:durationSecs];
    
    epoch.protocolId = [_reader readStringAttribute:@"protocolID" onPath:epochPath];
    
    // Protocol parameters
    NSString *paramsPath = [epochPath stringByAppendingString:@"/protocolParameters"];
    MACHdf5ObjectInformation *epochInfo = [_reader objectInformationForPath:paramsPath];
    NSMutableDictionary *protocolParameters = [NSMutableDictionary new];
    if (epochInfo.isGroup) {
        [protocolParameters addEntriesFromDictionary:[_reader readAttributesOnPath:paramsPath]];
    } else {
        [NSException raise:@"UnsupportedFeature" format:@"%@ must be a group", epochInfo.path];
    }
    
    // Backgrounds
    const char *backgroundPath = [[epochPath stringByAppendingString:@"/background"] cStringUsingEncoding:[NSString defaultCStringEncoding]];
    hid_t backgroundId = H5Dopen(_reader.fileId, backgroundPath, H5P_DEFAULT);
    
    hid_t spaceId = H5Dget_space(backgroundId);
    int rank = H5Sget_simple_extent_ndims(spaceId);
    hsize_t dims[rank];
    H5Sget_simple_extent_dims(spaceId, dims, NULL);
    
    int length = (int)dims[0];
    if (length != dims[0]) {
        [NSException raise:@"LengthTooLarge"
                    format:@"%s length is too large", backgroundPath];
    }
    
    hid_t datatypeId = H5Topen(_reader.fileId, "EXTDEV_MEASUREMENT", H5P_DEFAULT);
    
    backgroundData *backgrounds = malloc(length * sizeof(backgroundData));
    H5Dread(backgroundId, datatypeId, H5S_ALL, H5S_ALL, H5P_DEFAULT, backgrounds);
    
    for (int i = 0; i < length; i++) {
        NSString *deviceName = [NSString stringWithUTF8String:backgrounds[i].externalDevice];
        NSNumber *quantity = [NSNumber numberWithDouble:backgrounds[i].measurement.quantity];
        //NSString *units = [NSString stringWithUTF8String:backgrounds[i].measurement.units];
        [protocolParameters setValue:quantity forKey:[@"background:" stringByAppendingString:deviceName]];
        //[protocolParameters setValue:units forKey:[[@"background:" stringByAppendingString:deviceName] stringByAppendingString:@"_units"]];
    }
    
    epoch.protocolParameters = protocolParameters;
    [protocolParameters release];
    
    free(backgrounds);
    H5Tclose(datatypeId);
    H5Sclose(spaceId);
    H5Dclose(backgroundId);
    
    // Keywords
    if ([_reader hasAttribute:@"keywords" onPath:epochPath]) {
        NSString *keywordsStr = [_reader readStringAttribute:@"keywords" onPath:epochPath];
        epoch.keywords = [NSSet setWithArray:[keywordsStr componentsSeparatedByString:@","]];
    }
    
    // Stimuli
    NSArray *stimulusMembers = [_reader groupMemberLinkInfoInPath:[epochPath stringByAppendingString:@"/stimuli"]];
    NSMutableArray *stimuli = [NSMutableArray arrayWithCapacity:[stimulusMembers count]];
    for (MACHdf5LinkInformation *stimulusMember in stimulusMembers) {
        SMKStimulus *stimulus = [SMKStimulus new];
        
        stimulus.deviceName = [_reader readStringAttribute:@"deviceName" onPath:stimulusMember.path];
        stimulus.deviceManufacturer = [_reader readStringAttribute:@"deviceManufacturer" onPath:stimulusMember.path];
        stimulus.pluginId = [_reader readStringAttribute:@"stimulusID" onPath:stimulusMember.path];
        stimulus.units = [_reader readStringAttribute:@"stimulusUnits" onPath:stimulusMember.path];
        stimulus.parameters = [_reader readAttributesOnPath:[stimulusMember.path stringByAppendingString:@"/parameters"]];
        
        // Read device parameters
        NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
        NSArray *spanMembers = [_reader groupMemberLinkInfoInPath:[stimulusMember.path stringByAppendingString:@"/dataConfigurationSpans"]];
        for (MACHdf5LinkInformation *spanMember in spanMembers) {
            NSArray *nodeMembers = [_reader groupMemberLinkInfoInPath:spanMember.path];
            for (MACHdf5LinkInformation *nodeMember in nodeMembers) {
                if (nodeMember.isGroup) {
                    // FIXME: This should be merging the dictionaries by combining pre-existing keys not overwriting them
                    [parameters addEntriesFromDictionary:[_reader readAttributesOnPath:nodeMember.path]];
                } else {
                    [NSException raise:@"UnsupportedFeature" format:@"%@ must be a group", nodeMember.path];
                }
            }
            
            // Read channel
            NSString *channelTypeStr;
            NSNumber *channelNumber = NULL;
            for (MACHdf5LinkInformation *nodeMember in nodeMembers) {
                NSString *name = [nodeMember.path lastPathComponent];
                NSArray *comps = [name componentsSeparatedByString:@"."];
                
                channelTypeStr = [comps objectAtIndex:0];
                
                if ([channelTypeStr isEqualToString:@"ANALOG_OUT"] ||
                    [channelTypeStr isEqualToString:@"ANALOG_IN"] ||
                    [channelTypeStr isEqualToString:@"DIGITAL_OUT"] ||
                    [channelTypeStr isEqualToString:@"DIGITAL_IN"]) {
                    NSString *numStr = [comps lastObject];
                    channelNumber = [_numFormatter numberFromString:numStr];
                    break;
                }
            }
            
            if (channelNumber == NULL) {
                [NSException raise:@"CannotFindChannelSpan" format:@"Cannot find channel span"];
            }
            
            StreamType type = [self typeWithString:channelTypeStr];
            
            if (stimulus.streamType != UNCONFIGURED && stimulus.streamType != type
                && stimulus.channelNumber != nil && ![stimulus.channelNumber isEqualToNumber:channelNumber]) {
                [NSException raise:@"HeterogeneousChannel" format:@"Channel is not homogenous in %@", stimulusMember.path];
            }
            
            stimulus.streamType = type;
            stimulus.channelNumber = channelNumber;
        }
        stimulus.deviceParameters = parameters;
        
        stimulus.deviceMode = [self modeWithString:[parameters valueForKey:@"OperatingMode"]];
        
        [stimuli addObject:stimulus];
        [stimulus release];
    }
    epoch.stimuli = stimuli;
    
    // Responses
    NSArray *responseMembers = [_reader groupMemberLinkInfoInPath:[epochPath stringByAppendingString:@"/responses"]];
    NSMutableArray *responses = [NSMutableArray arrayWithCapacity:[responseMembers count]];
    for (MACHdf5LinkInformation *responseMember in responseMembers) {
        SMKResponse *response = [SMKResponse new];
        
        response.deviceName = [_reader readStringAttribute:@"deviceName" onPath:responseMember.path];
        response.deviceManufacturer = [_reader readStringAttribute:@"deviceManufacturer" onPath:responseMember.path];
        response.sampleRate = [NSNumber numberWithDouble:[_reader readDoubleAttribute:@"sampleRate" onPath:responseMember.path]];
        response.sampleRateUnits = [_reader readStringAttribute:@"sampleRateUnits" onPath:responseMember.path];
        
        const char *dsetPath = [[responseMember.path stringByAppendingString:@"/data"] cStringUsingEncoding:[NSString defaultCStringEncoding]];
        hid_t dsetId = H5Dopen(_reader.fileId, dsetPath, H5P_DEFAULT);
        
        // Get dataspace and allocate memory for read buffer
        hid_t spaceId = H5Dget_space(dsetId);
        int rank = H5Sget_simple_extent_ndims(spaceId);
        hsize_t dims[rank];
        H5Sget_simple_extent_dims(spaceId, dims, NULL);
        
        int length = (int)dims[0];
        if (length != dims[0]) {
            [NSException raise:@"LengthTooLarge"
                        format:@"%s length is too large", dsetPath];
        }
        
        // Read data
        hid_t datatypeId = H5Topen(_reader.fileId, "MEASUREMENT", H5P_DEFAULT);
        
        measurementData *buffer = malloc(length * sizeof(measurementData));
        H5Dread(dsetId, datatypeId, H5S_ALL, H5S_ALL, H5P_DEFAULT, buffer);
        
        const char *units = buffer[0].units;
        for (int i = 1; i < length; i++) {
            if (strcmp(units, buffer[i].units) != 0) {
                [NSException raise:@"HeterogeneousUnits" format:@"Units are not homogenous in response data"];
            }
        }
        response.units = [NSString stringWithCString:buffer[0].units encoding:[NSString defaultCStringEncoding]];
        
        NSMutableData *data = [NSMutableData dataWithCapacity:length * sizeof(double)];
        for (int i = 0; i < length; i++) {
            [data appendBytes:&buffer[i].quantity length:sizeof(double)];
        }
        response.data = data;
        [data release];
        
        free(buffer);
        H5Tclose(datatypeId);
        H5Sclose(spaceId);
        H5Dclose(dsetId);
        
        // Read device parameters
        NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
        double cStart = 0;
        NSArray *spanMembers = [_reader groupMemberLinkInfoInPath:[responseMember.path stringByAppendingString:@"/dataConfigurationSpans"]];
        for (MACHdf5LinkInformation *spanMember in spanMembers) {
            double startTimeSecs = [_reader readDoubleAttribute:@"startTimeSeconds" onPath:spanMember.path];
            double gapSecs = ABS(startTimeSecs - cStart);
            if (gapSecs > 1.0/[response.sampleRate doubleValue]) {
                
                // The data configuration spans may not always appear in order. Can we sort them and check this?
                //NSLog(@"Response appears to have missing device configuration span. Gap is %f seconds.", gapSecs);
            }
            
            cStart = cStart + [_reader readDoubleAttribute:@"timeSpanSeconds" onPath:spanMember.path];
            
            NSArray *nodeMembers = [_reader groupMemberLinkInfoInPath:spanMember.path];
            for (MACHdf5LinkInformation *nodeMember in nodeMembers) {
                if (nodeMember.isGroup) {
                    // FIXME: This should be merging the dictionaries by combining pre-existing keys not overwriting them
                    [parameters addEntriesFromDictionary:[_reader readAttributesOnPath:nodeMember.path]];
                } else {
                    [NSException raise:@"UnsupportedFeature" format:@"%@ must be a group", nodeMember.path];
                }
            }
            
            // Read channel
            NSString *channelTypeStr;
            NSNumber *channelNumber = NULL;
            for (MACHdf5LinkInformation *nodeMember in nodeMembers) {
                NSString *name = [nodeMember.path lastPathComponent];
                NSArray *comps = [name componentsSeparatedByString:@"."];
                
                channelTypeStr = [comps objectAtIndex:0];
                
                if ([channelTypeStr isEqualToString:@"ANALOG_OUT"] ||
                    [channelTypeStr isEqualToString:@"ANALOG_IN"] ||
                    [channelTypeStr isEqualToString:@"DIGITAL_OUT"] ||
                    [channelTypeStr isEqualToString:@"DIGITAL_IN"]) {
                    NSString *numStr = [comps lastObject];
                    channelNumber = [_numFormatter numberFromString:numStr];
                    break;
                }
            }
            
            if (channelNumber == NULL) {
                [NSException raise:@"CannotFindChannelSpan" format:@"Cannot find channel span"];
            }
            
            StreamType type = [self typeWithString:channelTypeStr];
            
            if (response.streamType != UNCONFIGURED && response.streamType != type
                && response.channelNumber != nil && ![response.channelNumber isEqualToNumber:channelNumber]) {
                [NSException raise:@"HeterogeneousChannel" format:@"Channel is not homogenous in %@", responseMember.path];
            }
            
            response.streamType = type;
            response.channelNumber = channelNumber;
        }
        response.deviceParameters = parameters;
        
        response.deviceMode = [self modeWithString:[parameters valueForKey:@"OperatingMode"]];
        
        [responses addObject:response];
        [response release];
    }
    epoch.responses = responses;
    
    _index++;
    _lastEpoch = epoch;
    return epoch;
}

- (StreamType)typeWithString:(NSString *)typeStr
{
    if ([typeStr isEqualToString:@"ANALOG_OUT"]) {
        return ANALOG_OUT;
    } else if ([typeStr isEqualToString:@"ANALOG_IN"]) {
        return ANALOG_IN;
    } else if ([typeStr isEqualToString:@"DIGITAL_OUT"]) {
        return DIGITAL_OUT;
    } else if ([typeStr isEqualToString:@"DIGITAL_IN"]) {
        return DIGITAL_IN;
    } else {
        [NSException raise:@"UnknownStreamType" format:@"Encountered unknown stream type"];
    }
    return UNCONFIGURED;
}

- (AxoPatchAmpMode)modeWithString:(NSString *)modeStr
{
    if ([modeStr isEqualToString:@"VClamp"]) {
        return VCLAMP_MODE;
    } else if ([modeStr isEqualToString:@"IO"]) {
        return I0_MODE;
    } else if ([modeStr isEqualToString:@"IClamp"]) {
        return ICLAMP_NORMAL_MODE;
    } else {
        return UNKNOWN_MODE;
    }
}

- (NSArray *)allObjects
{
    return nil;
}

- (id)copyWithZone:(NSZone *)zone
{
    SMKEpochEnumerator *another = [[SMKEpochEnumerator alloc] initWithReader:_reader epochPaths:_paths];
    return another;
}

- (void)dealloc
{
    [_reader release];
    [_paths release];
    [_lastEpoch release];
    [_numFormatter release];
    
    [super dealloc];
}

@end
