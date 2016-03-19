//
//  SMKBackgroundEnumerator.m
//  
//
//  Created by Mark Cafaro on 3/18/16.
//
//

#import "SMKBackgroundEnumerator.h"
#import "SMKBackground.h"

@implementation SMKBackgroundEnumerator

- (id)createNextEntity
{
    return [SMKBackground new];
}

@end
