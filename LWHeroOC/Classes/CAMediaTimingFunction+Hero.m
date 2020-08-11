//
//  CAMediaTimingFunction+Hero.m
//  Hero-ObjectiveC
//
//  Created by luca.li on 2017/1/23.
//  Copyright © 2017年 luca. All rights reserved.
//

#import "CAMediaTimingFunction+Hero.h"

@implementation CAMediaTimingFunction (Hero)

- (CAMediaTimingFunction *)linear {
    return [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
}

- (CAMediaTimingFunction *)easeIn {
    return [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
}

- (CAMediaTimingFunction *)easeOut {
    return [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
}

- (CAMediaTimingFunction *)easeInOut {
    return [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
}

- (CAMediaTimingFunction *)standard {
    return [CAMediaTimingFunction functionWithControlPoints:0.4 :0.0 :0.2 :1.0];
}

- (CAMediaTimingFunction *)deceleration {
    return [CAMediaTimingFunction functionWithControlPoints:0.0 :0.0 :0.2 :1.0];
}

- (CAMediaTimingFunction *)acceleration {
    return [CAMediaTimingFunction functionWithControlPoints:0.4 :0.0 :1.0 :1.0];
}

- (CAMediaTimingFunction *)sharp {
    return [CAMediaTimingFunction functionWithControlPoints:0.4 :0.0 :0.6 :1.0];}

- (CAMediaTimingFunction *)easeOutBack {
    return [CAMediaTimingFunction functionWithControlPoints:0.175 :0.885 :0.32 :1.275];
}

+ (instancetype)functionFromName:(NSString *)name {
    if ([name isEqualToString:@"linear"]) {
        return [[self alloc] linear];
    }
    
    if ([name isEqualToString:@"easeIn"]) {
        return [[self alloc] easeIn];
    }
    
    if ([name isEqualToString:@"easeOut"]) {
        return [[self alloc] easeOut];
    }
    
    if ([name isEqualToString:@"easeInOut"]) {
        return [[self alloc] easeInOut];
    }
    
    if ([name isEqualToString:@"standard"]) {
        return [[self alloc] standard];
    }
    
    if ([name isEqualToString:@"deceleration"]) {
        return [[self alloc] deceleration];
    }
    
    if ([name isEqualToString:@"acceleration"]) {
        return [[self alloc] acceleration];
    }
    
    if ([name isEqualToString:@"sharp"]) {
        return [[self alloc] sharp];
    } 
    return nil;
}
@end
