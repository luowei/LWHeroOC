//
//  HeroTypes.h
//  Hero-ObjectiveC
//
//  Created by luca.li on 2017/1/22.
//  Copyright © 2017年 luca. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "HeroTargetState.h"

@protocol HeroPreprocessor <NSObject>

- (void)processFromViews:(NSArray *)fromviews toViews:(NSArray *)toviews;

@end


@protocol HeroAnimator <NSObject>

- (BOOL)canAnimateView:(UIView *)view appearing:(BOOL)appear;
- (NSTimeInterval)animateFromViews:(NSArray *)fromviews toViews:(NSArray *)toviews;
- (void)clean;

- (void)seekToTime:(NSTimeInterval)timePassed;
- (NSTimeInterval)resumeForTime:(NSTimeInterval)timePassed reverse:(BOOL)reverse;
- (void)applyState:(HeroTargetState *)state toView:(UIView *)view;

@end


@protocol HeroProgressUpdateObserver <NSObject>

- (void)heroDidUpdateProgress:(double)progress;

@end

@protocol  HeroViewControllerDelegate<NSObject>

@optional
- (void)heroWillStartAnimatingFrom:(UIViewController *)viewController;
- (void)heroDidEndAnimatingFrom:(UIViewController *)viewController;
- (void)heroWillStartTransition;
- (void)heroDidEndTransition;
- (void)heroWillStartAnimatingTo:(UIViewController *)viewController;
- (void)heroDidEndAnimatingTo:(UIViewController *)viewController;

@end

@interface HeroTypes : NSObject

@end
