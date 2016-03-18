//
//  SMKDevice.h
//  
//
//  Created by Mark Cafaro on 3/17/16.
//
//

#import <Foundation/Foundation.h>
#import "SMKEntity.h"

@interface SMKDevice : SMKEntity {
    NSString *_name;
    NSString *_manufacturer;
}

@property (copy) NSString *name;
@property (copy) NSString *manufacturer;

@end
