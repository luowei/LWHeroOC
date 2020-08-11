//
//  BasePreprocessor.m
//  Hero-ObjectiveC
//
//  Created by luca.li on 2017/1/22.
//  Copyright © 2017年 luca. All rights reserved.
//

#import "BasePreprocessor.h"
#import "Hero.h"

@implementation BasePreprocessor

- (HeroContext *)context {
    return [Hero shared].context;
}

- (void)processFromViews:(NSArray *)fromviews toViews:(NSArray *)toviews {
    return;
}
@end
