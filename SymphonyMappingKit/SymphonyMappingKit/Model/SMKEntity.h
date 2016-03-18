//
//  SMKEntity.h
//  
//
//  Created by Mark Cafaro on 3/18/16.
//
//

#import <Foundation/Foundation.h>

@interface SMKEntity : NSObject {
    NSDictionary *_properties;
    NSSet *_keywords;
    NSSet *_notes;
}

@property (retain) NSDictionary *properties;
@property (retain) NSSet *keywords;
@property (retain) NSSet *notes;

@end
