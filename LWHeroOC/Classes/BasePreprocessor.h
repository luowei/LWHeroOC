//
//  BasePreprocessor.h
//  Hero-ObjectiveC
//
//  Created by luca.li on 2017/1/22.
//  Copyright © 2017年 luca. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HeroTypes.h"
#import "HeroContext.h"
#import "HeroTargetState.h"

@interface BasePreprocessor : NSObject <HeroPreprocessor>

@property (nonatomic, strong, readonly) HeroContext *context;

- (void)processFromViews:(NSArray *)fromviews toViews:(NSArray *)toviews;

@end
