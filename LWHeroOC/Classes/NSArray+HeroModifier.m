//
//  NSArray+HeroModifier.m
//  Hero-ObjectiveC
//
//  Created by luca.li on 2017/1/23.
//  Copyright © 2017年 luca. All rights reserved.
//

#import "NSArray+HeroModifier.h"

@implementation NSArray (HeroModifier)

- (id)getObjectAtIndex:(NSInteger)index {
    if (index < [self count]) {
        return [self objectAtIndex:index];
    }
    return nil;
}

- (CGFloat)getCGFloatAtIndex:(NSInteger)index {
    id s = [self getObjectAtIndex:index];
    return [s floatValue];
}

- (double)getDoubleAtIndex:(NSInteger)index {
    id s = [self getObjectAtIndex:index];
    return [s doubleValue];
}

- (float)getFloatAtIndex:(NSInteger)index {
    id s = [self getObjectAtIndex:index];
    return [s floatValue];
}

- (BOOL)getBoolAtIndex:(NSInteger)index {
    id s = [self getObjectAtIndex:index];
    return [s boolValue];
}

@end
