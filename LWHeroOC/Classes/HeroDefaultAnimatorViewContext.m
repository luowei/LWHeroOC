//
//  HeroDefaultAnimatorViewContext.m
//  Hero-ObjectiveC
//
//  Created by luca.li on 2017/1/24.
//  Copyright © 2017年 luca. All rights reserved.
//

#import "HeroDefaultAnimatorViewContext.h"
#import "HeroDefaultAnimator.h"
#import "HeroTargetState.h"
#import "CAMediaTimingFunction+Hero.h"
#import "CALayer+Hero.h"

@interface HeroDefaultAnimatorViewContext ()

@end

@implementation HeroDefaultAnimatorViewContext

- (instancetype)initWithAnimator:(HeroDefaultAnimator *)animator snapshot:(UIView *)snapshot targetState:(HeroTargetState *)targetState appearing:(BOOL)appearing {
    if (self = [super init]) {
        self.animator = animator;
        self.snapshot = snapshot;
        self.targetState = targetState;
        self.state = [NSMutableArray array];
        self.defaultTiming = [NSMutableArray array];

        NSMutableArray <NSDictionary *> *disappeared = [self viewStateForTargetState:targetState];
        

        [disappeared enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSString *key = [[obj allKeys] firstObject];
            id disappearedState = [obj objectForKey:key];
            
            id appearingState = [snapshot.layer valueForKeyPath:key];
            id toValue = appearing ? appearingState : disappearedState;
            id fromValue = !appearing ? appearingState : disappearedState;
            
            __block BOOL contain = NO;
            __block NSInteger index = 0;
            [self.state enumerateObjectsUsingBlock:^(NSMutableDictionary * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if ([[[obj allKeys] firstObject] isEqualToString:key]) {
                    contain = YES;
                    index = idx;
                }
            }];
            if (contain) {
                [self.state removeObjectAtIndex:index];
                [self.state insertObject:[@{key : @[fromValue, toValue]} mutableCopy] atIndex:index];
            } else {
                [self.state addObject:[@{key : @[fromValue, toValue]} mutableCopy]];
            }
        }];
        
        [self animateAfterDelay:[targetState.delay doubleValue]];
    }
    
    return self;
}

- (CALayer *)contentLayer {
    return [self.snapshot.layer.sublayers firstObject];
}

- (NSTimeInterval)currentTime {
    return [self.snapshot.layer convertTime:CACurrentMediaTime() fromLayer:nil];
}

- (UIView *)container {
    return self.animator.context.container;
}

/*
 // return @[delay, duration, easing]
 - (NSMutableArray *)getTimingWithKey:(NSString *)key fromValue:(id)fromValue toValue:(id)toValue {
 
 // delay should be for a specific animation. this shouldn't include the baseDelay
 
 // TODO: dynamic delay and duration for different key
 // https://material.io/guidelines/motion/choreography.html#choreography-continuity
 NSMutableArray *animParam = [NSMutableArray array];
 animParam = [@[@(0.0), self.defaultTiming[0], self.defaultTiming[1]] mutableCopy];
 
 if ([key isEqualToString:@"opacity"]) {
 if ([toValue isKindOfClass:[NSNumber class]]) {
 CGFloat value = [toValue floatValue];
 if (value == 0.0) {
 animParam = [@[@(0.0), @(0.075), [CAMediaTimingFunction functionFromName:@"standard"]] mutableCopy];
 }
 
 if (value == 1.0) {
 animParam = [@[@(0.075), @([self.defaultTiming[0] floatValue] - 0.075), [CAMediaTimingFunction functionFromName:@"standard"]] mutableCopy];
 }
 }
 }
 
 return animParam;
 }
 */

- (CAPropertyAnimation *)getAnimationWithKey:(NSString *)key beginTime:(NSTimeInterval)beginTime fromValue:(id)fromValue toValue:(id)toValue ignoreArc:(BOOL)ignoreArc {
    
    CAPropertyAnimation *anim;
    NSArray *animParam = @[@(0.0), self.defaultTiming[0], self.defaultTiming[1]];   //@[delay, duration, timingFunction]
    CGPoint fromPos;
    CGPoint toPos;
    // Only for CGPoint, set the default value
    if ([[NSString stringWithCString:[fromValue objCType] encoding:NSASCIIStringEncoding] hasPrefix:@"{CGPoint"]) {
        fromPos = [fromValue CGPointValue];
        toPos = [toValue CGPointValue];
    }
    
    if (!ignoreArc && [key isEqualToString:@"position"] && self.targetState.arc &&
        fabs(fromPos.x - toPos.x) >= 1 &&
        fabs(fromPos.y - toPos.y) >= 1) {
        
        CGFloat arcIntensity = [self.targetState.arc floatValue];
        CAKeyframeAnimation *kanim = [CAKeyframeAnimation animationWithKeyPath:key];
        
        CGMutablePathRef path = CGPathCreateMutable();
        CGPoint maxControl = fromPos.y > toPos.y ? CGPointMake(toPos.x, fromPos.y) : CGPointMake(fromPos.x, toPos.y);
        CGPoint minControl = CGPointMake((toPos.x - fromPos.x)/2 + fromPos.x, (toPos.y - fromPos.y)/2 + fromPos.y);
        
        CGPathMoveToPoint(path, nil, fromPos.x, fromPos.y);
        CGPathAddQuadCurveToPoint(path,
                                  nil,
                                  minControl.x + (maxControl.x - minControl.x) * arcIntensity,
                                  minControl.y + (maxControl.y - minControl.y) * arcIntensity,
                                  toPos.x, toPos.y);
        
        kanim.values = @[fromValue, toValue];
        kanim.path = path;
        kanim.duration = [animParam[1] doubleValue];
        kanim.timingFunctions = @[animParam[2]];
        anim = kanim;
    } else if (![key isEqualToString:@"cornerRadius"] && self.targetState.spring) {
        NSArray *sanimParam = self.targetState.spring;
        CASpringAnimation *sanim = [CASpringAnimation animationWithKeyPath:key];
        sanim.stiffness = [sanimParam[0] floatValue];
        sanim.damping = [sanimParam[1] floatValue];
        sanim.duration = sanim.settlingDuration * 0.9;
        sanim.fromValue = fromValue;
        sanim.toValue = toValue;
        anim = sanim;
    } else {
        CABasicAnimation *banim = [CABasicAnimation animationWithKeyPath:key];
        banim.duration = [animParam[1] doubleValue];
        banim.fromValue = fromValue;
        banim.toValue = toValue;
        banim.timingFunction = animParam[2];
        anim = banim;
    }
    
    anim.fillMode = kCAFillModeBoth;
    [anim setRemovedOnCompletion:NO];
    anim.beginTime = beginTime + [animParam[0] floatValue];
    
    return anim;
}

- (NSTimeInterval)addAnimationWithKey:(NSString *)key beginTime:(NSTimeInterval)beginTime fromValue:(id)fromValue toValue:(id)toValue {
    CAPropertyAnimation *anim = [self getAnimationWithKey:key beginTime:beginTime fromValue:fromValue toValue:toValue ignoreArc:NO];
    
    [self.snapshot.layer addAnimation:anim forKey:key];
    
    if ([key isEqualToString:@"cornerRadius"]) {
        [self.contentLayer addAnimation:anim forKey:key];
    } else if ([key isEqualToString:@"bounds.size"]) {
        
        if ([fromValue isKindOfClass:[NSValue class]] &&
            [toValue isKindOfClass:[NSValue class]]) {
            CGSize fromSize = [(NSValue *)fromValue CGSizeValue];
            CGSize toSize = [(NSValue *)toValue CGSizeValue];
            
            // for the snapshotView(UIReplicantView): there is a
            // subview(UIReplicantContentView) that is hosting the real snapshot image.
            // because we are using CAAnimations and not UIView animations,
            // The snapshotView will not layout during animations.
            // we have to add two more animations to manually layout the content view.
            NSValue *fromPosn = [NSValue valueWithCGPoint:CGPointMake(fromSize.width/2, fromSize.height/2)];
            NSValue *toPosn = [NSValue valueWithCGPoint:CGPointMake(toSize.width/2, toSize.height/2)];
            
            CAPropertyAnimation *positionAnim = [self getAnimationWithKey:@"position" beginTime:0 fromValue:fromPosn toValue:toPosn ignoreArc:YES];
            positionAnim.beginTime = anim.beginTime;
            positionAnim.timingFunction = anim.timingFunction;
            positionAnim.duration = anim.duration;
            
            [self.contentLayer addAnimation:positionAnim forKey:@"position"];
            [self.contentLayer addAnimation:anim forKey:key];
        }
    }
    
    return anim.duration + anim.beginTime - beginTime;
}

// Returns: a CALayer @[ {Keypath : value}, ...] dictionary array for animation
- (NSMutableArray <NSDictionary *> *)viewStateForTargetState:(HeroTargetState *)targetState {
    NSMutableArray *rtn = [NSMutableArray array];
    
    NSDictionary *dic;
    if (targetState.size) {
        dic = @{@"bounds.size" : targetState.size};
        [rtn addObject:dic];
    }
    if (targetState.position) {
        dic = @{@"position" : targetState.position};
        [rtn addObject:dic];
    }
    if (targetState.opacity) {
        dic = @{@"opacity" :  targetState.opacity};
        [rtn addObject:dic];
    }
    if (targetState.cornerRadius) {
        dic = @{@"cornerRadius" : targetState.cornerRadius};
        [rtn addObject:dic];
    }
    if (targetState.transform) {
        dic = @{@"transform" : targetState.transform};
        [rtn addObject:dic];
    }

    return rtn;
}

- (void)animateAfterDelay:(NSTimeInterval)delay {
    // calculate timing default
    NSTimeInterval defaultDuration;
    CAMediaTimingFunction *defaultTimingFunction;
    
    // timingFunction
    __block CGPoint fromPos = self.snapshot.layer.position;     //Default value when no such key in self.state
    __block CGPoint toPos = fromPos;        //Default value when no such key in self.state
    __block CATransform3D fromTransform = CATransform3DIdentity;        //Default value when no such key in self.state
    __block CATransform3D toTransform = CATransform3DIdentity;      //Default value when no such key in self.state
    __block CGPoint realFromPos;
    __block CGPoint realToPos;
    [self.state enumerateObjectsUsingBlock:^(NSMutableDictionary * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSArray *pArray = [obj objectForKey:@"position"];
        NSArray *tArray = [obj objectForKey:@"transform"];
        if (pArray && [pArray count]) {
            fromPos = (NSValue *)pArray[0] ? [(NSValue *)pArray[0] CGPointValue] : self.snapshot.layer.position;
            toPos = (NSValue *)pArray[1] ? [(NSValue *)pArray[1] CGPointValue] : fromPos;
        }
        if (tArray && [tArray count]) {
            fromTransform = (NSValue *)pArray[0] ? [(NSValue *)pArray[0] CATransform3DValue] : CATransform3DIdentity;
            toTransform = (NSValue *)pArray[1] ? [(NSValue *)pArray[1] CATransform3DValue] : CATransform3DIdentity;
        }
    }];
    
    CGAffineTransform affineTransform = CATransform3DGetAffineTransform(fromTransform);
    realFromPos = CGPointMake(CGPointApplyAffineTransform(CGPointZero, affineTransform).x + fromPos.x,
                              CGPointApplyAffineTransform(CGPointZero, affineTransform).y + fromPos.y);
    affineTransform = CATransform3DGetAffineTransform(toTransform);
    realToPos = CGPointMake(CGPointApplyAffineTransform(CGPointZero, affineTransform).x + toPos.x,
                              CGPointApplyAffineTransform(CGPointZero, affineTransform).y + toPos.y);
    
    CAMediaTimingFunction *timingFunction = self.targetState.timingFunction;
    if (timingFunction) {
        defaultTimingFunction = timingFunction;
    } else if (self.container && !CGRectContainsPoint(self.container.bounds, realToPos)) {
        // acceleration if leaving screen
        defaultTimingFunction = [CAMediaTimingFunction functionFromName:@"acceleration"];
    } else if (self.container && !CGRectContainsPoint(self.container.bounds, realFromPos)) {
        defaultTimingFunction = [CAMediaTimingFunction functionFromName:@"deceleration"];
    } else {
        defaultTimingFunction = [CAMediaTimingFunction functionFromName:@"standard"];
    }
    
    NSNumber *duration = self.targetState.duration;
    if (duration) {
        defaultDuration = [duration doubleValue];
    } else {
        __block CGSize fromSize = self.snapshot.layer.bounds.size;      //Default value when no such key in self.state
        __block CGSize toSize = fromSize;       //Default value when no such key in self.state
        __block CGSize realFromSize;
        __block CGSize realToSize;
        [self.state enumerateObjectsUsingBlock:^(NSMutableDictionary * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSArray *sArray = [obj objectForKey:@"bounds.size"];
            if (sArray && [sArray count]) {
                fromSize = (NSValue *)sArray[0] ? [(NSValue *)sArray[0] CGSizeValue] : self.snapshot.layer.bounds.size;
                toSize = (NSValue *)sArray[1] ? [(NSValue *)sArray[1] CGSizeValue] : fromSize;
            }
        }];
        CGAffineTransform affineFromTransform = CATransform3DGetAffineTransform(fromTransform);
        CGAffineTransform affineToTransform = CATransform3DGetAffineTransform(toTransform);
        realFromSize = CGSizeApplyAffineTransform(fromSize, affineFromTransform);
        realToSize = CGSizeApplyAffineTransform(toSize, affineToTransform);
        
        CGFloat movePoints = [self distanceFrom:realFromPos to:realToPos] + [self distanceFrom:CGPointMake(realFromSize.width, realFromSize.height) to:CGPointMake(realToSize.width, realToSize.height)];
        
        // duration is 0.2 @ 0 to 0.375 @ 500
        CGFloat intervalValue = (movePoints < 0 ? movePoints : (movePoints > 500 ? 500 : movePoints));  //movePoints.clamp(0, 500)
        defaultDuration = 0.208 + intervalValue / 3000;
    }
    
    self.defaultTiming = [@[@(defaultDuration), defaultTimingFunction] mutableCopy];
    
    self.duration = 0;
    NSTimeInterval beginTime = self.currentTime + delay;
    [self.state enumerateObjectsUsingBlock:^(NSMutableDictionary * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString *key = [[obj allKeys] firstObject];
        NSArray *value = [obj objectForKey:key];
        NSTimeInterval neededTime = [self addAnimationWithKey:key beginTime:beginTime fromValue:value[0] toValue:value[1]];
        self.duration = MAX(self.duration, neededTime + delay);
    }];
    
}

- (void)applyState:(HeroTargetState *)state {
    NSArray <NSDictionary *> *targetState = [self viewStateForTargetState:state];
    [targetState enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        __block BOOL contain = NO;
        NSString *key = [[obj allKeys] firstObject];
        id targetValue = [obj objectForKey:key];
        [self.state enumerateObjectsUsingBlock:^(NSMutableDictionary * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj objectForKey:key]) {
                contain = YES;
                *stop = YES;
            }
        }];
        
        if (!contain) {
            id currentValue = [self.snapshot.layer valueForKeyPath:key];
            NSDictionary *dic = @{key : @[currentValue, currentValue]};
            [self.state addObject:[dic mutableCopy]];
        }
        
        [self addAnimationWithKey:key beginTime:0 fromValue:targetValue toValue:targetValue];
    }];
}

- (void)resumeForTime:(NSTimeInterval)timePassed reverse:(BOOL)reverse {
    
    [self.state enumerateObjectsUsingBlock:^(NSMutableDictionary * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString *key = [[obj allKeys] firstObject];
        NSArray *value = [obj objectForKey:key];    //@[fromValue, toValue]
        id fromValue = value[0];
        id toValue = value[1];
        
        id realToValue = !reverse ? toValue : fromValue;
        id realFromValue = [(self.snapshot.layer.presentationLayer ? self.snapshot.layer.presentationLayer : self.snapshot.layer) valueForKeyPath:key];
        
        // Replacement
        [self.state replaceObjectAtIndex:idx withObject:[@{key : @[realFromValue, realToValue]} mutableCopy]];
    }];
    
    NSTimeInterval realDelay = MAX(0, [self.targetState.delay doubleValue] - timePassed);
    [self animateAfterDelay:realDelay];
}

- (void)seekLayer:(CALayer *)layer forTime:(NSTimeInterval)timePassed {
    NSTimeInterval timeOffset = timePassed - [self.targetState.delay doubleValue];
    [layer.animations enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString *key = [[obj allKeys] firstObject];
        CAAnimation *anim = [obj objectForKey:key];
        anim.speed = 0;
        anim.timeOffset = MAX(0, MIN(anim.duration - 0.01, timeOffset));
        [layer removeAnimationForKey:key];
        [layer addAnimation:anim forKey:key];
    }];
}

- (void)seekForTime:(NSTimeInterval)timePassed {
    [self seekLayer:self.snapshot.layer forTime:timePassed];
    if (self.contentLayer) {
        [self seekLayer:self.contentLayer forTime:timePassed];
    }
}

#pragma mark - Getter

- (void)setState:(NSMutableArray<NSMutableDictionary *> *)state {
    if (!_state) {
        _state = [NSMutableArray array];
    }
}

#pragma mark - Private
- (CGFloat)distanceFrom:(CGPoint)a to:(CGPoint)b {
    return sqrt(pow(a.x - b.x, 2) + pow(a.y - b.y, 2));
}
@end
