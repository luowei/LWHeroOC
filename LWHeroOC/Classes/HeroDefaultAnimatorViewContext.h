//
//  HeroDefaultAnimatorViewContext.h
//  Hero-ObjectiveC
//
//  Created by luca.li on 2017/1/24.
//  Copyright © 2017年 luca. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class HeroDefaultAnimator;
@class HeroTargetState;

@interface HeroDefaultAnimatorViewContext : NSObject

@property (nonatomic, weak) HeroDefaultAnimator *animator;
@property (nonatomic, strong) UIView *snapshot;
@property (nonatomic, copy) NSMutableArray <NSMutableDictionary *>*state;   //@[{NSString : @[obj1, obj2]}, ...]
@property (nonatomic, assign) NSTimeInterval duration;
@property (nonatomic, strong) HeroTargetState *targetState;
@property (nonatomic, copy) NSMutableArray *defaultTiming;                  //@[@(NSTimeInterval), CAMediaTimingFunction]

// computed
@property (nonatomic, strong, readonly) CALayer *contentLayer;
@property (nonatomic, assign, readonly) NSTimeInterval currentTime;
@property (nonatomic, strong, readonly) UIView *container;


- (instancetype)initWithAnimator:(HeroDefaultAnimator *)animator snapshot:(UIView *)snapshot targetState:(HeroTargetState *)targetState appearing:(BOOL)appearing;

- (CAPropertyAnimation *)getAnimationWithKey:(NSString *)key beginTime:(NSTimeInterval)beginTime fromValue:(id)fromValue toValue:(id)toValue ignoreArc:(BOOL)ignoreArc;

- (NSTimeInterval)addAnimationWithKey:(NSString *)key beginTime:(NSTimeInterval)beginTime fromValue:(id)fromValue toValue:(id)toValue;

// Returns: a CALayer @[ {Keypath : value}, ...] dictionary array for animation
- (NSMutableArray <NSDictionary *> *)viewStateForTargetState:(HeroTargetState *)targetState;

- (void)animateAfterDelay:(NSTimeInterval)delay;

- (void)applyState:(HeroTargetState *)state;

- (void)resumeForTime:(NSTimeInterval)timePassed reverse:(BOOL)reverse;

- (void)seekLayer:(CALayer *)layer forTime:(NSTimeInterval)timePassed;

- (void)seekForTime:(NSTimeInterval)timePassed;

@end
