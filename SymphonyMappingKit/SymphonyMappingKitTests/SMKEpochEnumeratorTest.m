//
//  SMKEpochEnumeratorTest.m
//  SymphonyMappingKit
//
//  Created by Mark Cafaro on 2/4/13.
//  Copyright (c) 2013 Rieke Lab. All rights reserved.
//

#import "SMKBaseTestCase.h"
#import "SMKEpochEnumerator.h"
#import "SMKEpoch.h"
#import "SMKStimulus.h"
#import "SMKResponse.h"
#import "MACHdf5Reader.h"

@interface SMKEpochEnumeratorTest : SMKBaseTestCase {
    SMKEpochEnumerator *_enumerator;
    SMKEpochEnumerator *_enumerator2;
}

@end

@implementation SMKEpochEnumeratorTest

- (void)setUp
{
    [super setUp];
    
    // Fixture 1
    MACHdf5Reader *reader = [MACHdf5Reader readerWithFilePath:[_resourcePath stringByAppendingString:@"010413AcMyCellID1.h5"]];
    
    NSString *epoch1 = @"/MyLabel1-7d785046-3cff-402c-9ffe-52579fd130c4/epochs/epoch-edu.washington.rieke.Ramp-22581860-0741-4ec2-b60b-de8cdc2df1b7";
    NSString *epoch2 = @"/MyLabel1-7d785046-3cff-402c-9ffe-52579fd130c4/epochs/epoch-edu.washington.rieke.Ramp-405e5445-8e7a-413d-818f-a2ee5eef5fbb";
    
    _enumerator = [[[SMKEpochEnumerator alloc] initWithReader:reader epochPaths:[NSArray arrayWithObjects:epoch1, epoch2, nil]] autorelease];
    
    // Fixture 2
    MACHdf5Reader *reader2 = [MACHdf5Reader readerWithFilePath:[_resourcePath stringByAppendingString:@"021313AcMyCellID1.h5"]];
    
    NSString *epoch3 = @"/MyLabel3-3875aae7-3c39-475b-9929-d59d8a7dfd72/epochs/epoch-edu.washington.rieke.Pulse-6ddce172-8fc1-4bd0-b748-3c82570db84e";
    
    _enumerator2 = [[[SMKEpochEnumerator alloc] initWithReader:reader2 epochPaths:[NSArray arrayWithObject:epoch3]] autorelease];
}

- (void)testNextObject
{
    int i = 0;
    while ([_enumerator nextObject]) {
        i++;
    }
    STAssertTrue(i == 2, nil);
}

- (void)testProtocolId
{
    SMKEpoch *epoch = [_enumerator nextObject];
    
    STAssertTrue([epoch.protocolId isEqualToString:@"edu.washington.rieke.Ramp"], nil);
}

- (void)testProtocolParameters
{
    SMKEpoch *epoch = [_enumerator nextObject];
    
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
                              d(-0.06), @"background:Amplifier_Ch1",
                              @"V", @"background:Amplifier_Ch1_units",
                              d(0.0), @"background:Red_LED+Green_LED",
                              @"V", @"background:Red_LED+Green_LED_units",
                              d(0.0), @"background:Heka Digital Out",
                              @"_unitless_", @"background:Heka Digital Out_units",
                              nil];
    
    STAssertTrue([epoch.protocolParameters isEqualToDictionary:expected], nil);
}

- (void)testKeywords
{
    SMKEpoch *epoch = [_enumerator2 nextObject];
    
    NSSet *expected = [NSSet setWithObjects:@"you", @"know", @"it", @"key", nil];
    NSSet *actual = epoch.keywords;
    
    STAssertTrue([actual isEqualToSet:expected], nil);
}

- (void)testStimuliCount
{
    SMKEpoch *epoch = [_enumerator nextObject];
    
    STAssertTrue([epoch.stimuli count] == 2, nil);
}

- (void)testStimuliPluginId
{
    SMKEpoch *epoch = [_enumerator nextObject];
    
    SMKStimulus *stim1 = [epoch.stimuli objectAtIndex:0];
    SMKStimulus *stim2 = [epoch.stimuli objectAtIndex:1];
    
    STAssertTrue([stim1.pluginId isEqualToString:@"Amplifier_Ch1_Stimulus"], nil);
    STAssertTrue([stim2.pluginId isEqualToString:@"Trigger_Stimulus"], nil);
}

- (void)testStimulusChannelNumber
{
    SMKEpoch *epoch = [_enumerator nextObject];
    SMKStimulus *stim = [epoch.stimuli objectAtIndex:0];
    
    STAssertTrue([stim.channelNumber isEqualToNumber:[NSNumber numberWithInt:0]], nil);
}

- (void)testStimulusStreamType
{
    SMKEpoch *epoch = [_enumerator nextObject];
    SMKStimulus *stim = [epoch.stimuli objectAtIndex:0];
    
    STAssertTrue(stim.streamType == ANALOG_OUT, nil);
}

- (void)testStimulusDeviceMode
{
    SMKEpoch *epoch = [_enumerator nextObject];
    SMKStimulus *stim = [epoch.stimuli objectAtIndex:0];
    
    STAssertTrue(stim.deviceMode == VCLAMP_MODE, nil);
}

- (void)testStimulus
{
    SMKEpoch *epoch = [_enumerator nextObject];
    SMKStimulus *stim = [epoch.stimuli objectAtIndex:0];
    
    // TODO: additional stim testing
    STAssertTrue([stim.deviceName isEqualToString:@"Amplifier_Ch1"], nil);
    STAssertTrue([stim.units isEqualToString:@"V"], nil);
}

- (void)testResponsesCount
{
    SMKEpoch *epoch = [_enumerator nextObject];
    
    STAssertTrue([epoch.responses count] == 1, nil);
}

- (void)testResponseChannelNumber
{
    SMKEpoch *epoch = [_enumerator nextObject];
    SMKResponse *resp = [epoch.responses objectAtIndex:0];
    
    STAssertTrue([resp.channelNumber isEqualToNumber:[NSNumber numberWithInt:0]], nil);
}

- (void)testResponseStreamType
{
    SMKEpoch *epoch = [_enumerator nextObject];
    SMKResponse *resp = [epoch.responses objectAtIndex:0];
    
    STAssertTrue(resp.streamType == ANALOG_IN, nil);
}

- (void)testResponseDeviceMode
{
    SMKEpoch *epoch = [_enumerator nextObject];
    SMKResponse *resp = [epoch.responses objectAtIndex:0];
    
    STAssertTrue(resp.deviceMode == VCLAMP_MODE, nil);
}

- (void)testResponseData
{
    SMKEpoch *epoch = [_enumerator nextObject];
    SMKResponse *resp = [epoch.responses objectAtIndex:0];
    
    // TODO: this should be compared to a fixture
    STAssertTrue(resp.data.length == 48000, nil);
    //STAssertTrue([[resp.data objectAtIndex:5971] isEqualToNumber:[NSNumber numberWithFloat:-0.625]], nil);
    //STAssertTrue([[resp.data objectAtIndex:5999] isEqualToNumber:[NSNumber numberWithFloat:0.0]], nil);
}

- (void)testResponse
{
    SMKEpoch *epoch = [_enumerator nextObject];
    SMKResponse *resp = [epoch.responses objectAtIndex:0];
    
    // TODO: additional resp testing
    STAssertTrue([resp.deviceName isEqualToString:@"Amplifier_Ch1"], nil);
    STAssertTrue([resp.units isEqualToString:@"pA"], nil);
    STAssertTrue([resp.sampleRateUnits isEqualToString:@"Hz"], nil);
}

@end
