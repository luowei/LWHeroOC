//
//  HeroDefaultAnimator.h
//  Hero-ObjectiveC
//
//  Created by luca.li on 2017/1/24.
//  Copyright © 2017年 luca. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HeroContext.h"
#import "Hero.h"

@interface HeroDefaultAnimator : NSObject <HeroAnimator>

@property (nonatomic, strong, readonly) HeroContext *context;

@end
