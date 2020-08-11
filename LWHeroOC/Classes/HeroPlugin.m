//
//  HeroPlugin.m
//  Hero-ObjectiveC
//
//  Created by luca.li on 2017/1/22.
//  Copyright © 2017年 luca. All rights reserved.
//

#import "HeroPlugin.h"
#import "Hero.h"

@implementation HeroPlugin

- (instancetype)init {
    return [super init];
}

- (void)processFromViews:(NSArray *)fromviews toViews:(NSArray *)toviews {
    return;
}

- (BOOL)canAnimateView:(UIView *)view appearing:(BOOL)appear {
    return NO;
}

- (NSTimeInterval)animateFromViews:(NSArray *)fromviews toViews:(NSArray *)toviews {
    return 0;
}

- (void)clean {
    return;
}

- (void)seekToTime:(NSTimeInterval)timePassed {
    return;
}

- (NSTimeInterval)resumeForTime:(NSTimeInterval)timePassed reverse:(BOOL)reverse {
    return 0;
}

- (void)applyState:(HeroTargetState *)state toView:(UIView *)view{
    return;
}


@end

// methods for enable/disable the current plugin
@implementation HeroPlugin (StateControl)

- (HeroContext *)context {
    return [Hero shared].context;
}

+ (BOOL)isEnabled {
    return [Hero isEnabledPlugin:self];
}

+ (void)setEnabled:(BOOL)enable {
    if (enable) {
        [self enable];
    } else {
        [self disable];
    }
}

+ (void)enable {
    [Hero enablePlugin:self];
}

+ (void)disable {
    [Hero disablePlugin:self];
}

@end
