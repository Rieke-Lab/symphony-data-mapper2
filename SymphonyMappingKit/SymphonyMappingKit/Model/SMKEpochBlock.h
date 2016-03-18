//
//  SMKEpochBlock.h
//  
//
//  Created by Mark Cafaro on 3/18/16.
//
//

#import <Foundation/Foundation.h>
#import "SMKTimelineEntity.h"

@class SMKEpochEnumerator;

@interface SMKEpochBlock : SMKTimelineEntity {
    NSString *_protocolId;
    NSDictionary *_protocolParameters;
    SMKEpochEnumerator *_epochEnumerator;
}

@property (copy) NSString *protocolId;
@property (retain) NSDictionary *protocolParameters;
@property (retain) SMKEpochEnumerator *epochEnumerator;

@end
