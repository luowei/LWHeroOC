//
//  CALayer+Hero.m
//  Hero-ObjectiveC
//
//  Created by luca.li on 2017/1/23.
//  Copyright © 2017年 luca. All rights reserved.
//

#import "CALayer+Hero.h"

@implementation CALayer (Hero)

- (NSArray <NSDictionary *> *)animations {
    
    NSArray *keys = [self animationKeys];
    NSMutableArray *array = [NSMutableArray array];
    
    if (keys && [keys count]) {
        [keys enumerateObjectsUsingBlock:^(NSString * _Nonnull key, NSUInteger idx, BOOL * _Nonnull stop) {
            NSDictionary *dic = @{key : [[self animationForKey:key] copy]};
            [array addObject:dic];
        }];
    }
    
    return array;
}

@end
