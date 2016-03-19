//
//  SMKResponseEnumerator.m
//  
//
//  Created by Mark Cafaro on 3/18/16.
//
//

#import "SMKResponseEnumerator.h"
#import "SMKResponse.h"

@implementation SMKResponseEnumerator

- (id)createNextEntity
{
    return [SMKResponse new];
}

@end
