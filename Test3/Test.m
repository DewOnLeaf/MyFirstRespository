//
//  Test.m
//  Test3
//
//  Created by Victor on 15/11/16.
//  Copyright © 2015年 Victor. All rights reserved.
//

#import "Test.h"

@implementation Test

- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"{name: %@,age :%i}",self.name,self.age];
}
@end
