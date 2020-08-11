//
//  HeroModifier.m
//  Hero-ObjectiveC
//
//  Created by luca.li on 2017/1/22.
//  Copyright © 2017年 luca. All rights reserved.
//

#import "HeroModifier.h"
#import "NSArray+HeroModifier.h"

const HeroModifierApplyBlock fade = ^(HeroTargetState *targetState) {
    targetState.opacity = @(0);
};

@interface HeroModifier ()

@end

@implementation HeroModifier

- (instancetype)initWithApplyFunction:(HeroModifierApplyBlock)applyFunction {
    if (self = [super init]) {
        self.apply = applyFunction;
    }
    
    return self;
}

@end

@implementation HeroModifier (BasicModifiers)

+ (HeroModifier *)position:(NSValue *)position {
    return [[HeroModifier alloc] initWithApplyFunction:^(HeroTargetState *targetState) {
        targetState.position = position;
    }];
}

+ (HeroModifier *)size:(NSValue *)size {
    return [[HeroModifier alloc] initWithApplyFunction:^(HeroTargetState *targetState) {
        targetState.size = size;
    }];
}

@end

@implementation HeroModifier (TransformModifiers)

+ (HeroModifier *)transform:(NSValue *)t {
    return [[HeroModifier alloc] initWithApplyFunction:^(HeroTargetState *targetState) {
        targetState.transform = t;
    }];
}

+ (HeroModifier *)perspective:(CGFloat)perspective {
    return [[HeroModifier alloc] initWithApplyFunction:^(HeroTargetState *targetState) {
        CATransform3D transform = [targetState.transform CATransform3DValue];
        transform.m34 = 1.0 / -perspective;
        targetState.transform = [NSValue valueWithCATransform3D:transform];
    }];
}

+ (HeroModifier *)scaleX:(CGFloat)x Y:(CGFloat)y Z:(CGFloat)z {
    return [[HeroModifier alloc] initWithApplyFunction:^(HeroTargetState *targetState) {
        targetState.transform = [NSValue valueWithCATransform3D:CATransform3DScale([targetState.transform CATransform3DValue], x, y, z)];
        
    }];
}

+ (HeroModifier *)scaleXY:(CGFloat)xy {
    return [self scaleX:xy Y:xy Z:1.0];
}

+ (HeroModifier *)translateX:(CGFloat)x Y:(CGFloat)y Z:(CGFloat)z {
    return [[HeroModifier alloc] initWithApplyFunction:^(HeroTargetState *targetState) {
        targetState.transform = [NSValue valueWithCATransform3D:CATransform3DTranslate([targetState.transform CATransform3DValue], x, y, z)];
    }];
}

+ (HeroModifier *)rotateX:(CGFloat)x Y:(CGFloat)y Z:(CGFloat)z {
    return [[HeroModifier alloc] initWithApplyFunction:^(HeroTargetState *targetState) {
        targetState.transform = [NSValue valueWithCATransform3D:CATransform3DRotate([targetState.transform CATransform3DValue], x, 1, 0, 0)];
        targetState.transform = [NSValue valueWithCATransform3D:CATransform3DRotate([targetState.transform CATransform3DValue], y, 0, 1, 0)];
        targetState.transform = [NSValue valueWithCATransform3D:CATransform3DRotate([targetState.transform CATransform3DValue], z, 0, 0, 1)];
    }];
}

+ (HeroModifier *)rotateZ:(CGFloat)z {
    return [self rotateX:0 Y:0 Z:z];
}

@end


@implementation HeroModifier (TimingMidifiers)

+ (HeroModifier *)duration:(NSNumber *)duration {
    return [[HeroModifier alloc] initWithApplyFunction:^(HeroTargetState *targetState) {
        targetState.duration = duration;
    }];
}

+ (HeroModifier *)delay:(NSNumber *)delay {
    return [[HeroModifier alloc] initWithApplyFunction:^(HeroTargetState *targetState) {
        targetState.delay = delay;
    }];
}

+ (HeroModifier *)timingFunction:(CAMediaTimingFunction*)timingFunction {
    return [[HeroModifier alloc] initWithApplyFunction:^(HeroTargetState *targetState) {
        targetState.timingFunction = timingFunction;
    }];
}

+ (HeroModifier *)spring:(CGFloat)stiffness damping:(CGFloat)damping NS_AVAILABLE_IOS(9_0) {
    return [[HeroModifier alloc] initWithApplyFunction:^(HeroTargetState *targetState) {
        //Use two dimension array as tuple
        targetState.spring = @[@(stiffness), @(damping)];
    }];
}

@end


@implementation HeroModifier (OtherModifiers)

+ (HeroModifier *)ignoreSubviewModifiers {
    return [self ignoreSubviewModifiers:@(NO)];
}

+ (HeroModifier *)arc {
    return [self arc:@(1)];
}

+ (HeroModifier *)cascade {
    return [self cascadeWithDelta:0.02 direction:CascadeDirectionTopToBottom delayMatchedViews:NO];
}

+ (HeroModifier *)zPosition:(NSNumber *)zPosition {
    return [[HeroModifier alloc] initWithApplyFunction:^(HeroTargetState *targetState) {
        targetState.zPosition = zPosition;
    }];
}

+ (HeroModifier *)zPositionIfMatched:(NSNumber *)zPositionIfMatched {
    return [[HeroModifier alloc] initWithApplyFunction:^(HeroTargetState *targetState) {
        targetState.zPositionIfMatched = zPositionIfMatched;
    }];
}

+ (HeroModifier *)ignoreSubviewModifiers:(NSNumber *)recursive {
    return [[HeroModifier alloc] initWithApplyFunction:^(HeroTargetState *targetState) {
        targetState.ignoreSubviewModifiers = recursive;
    }];
}

+ (HeroModifier *)source:(NSString *)heroID {
    return [[HeroModifier alloc] initWithApplyFunction:^(HeroTargetState *targetState) {
        targetState.source = heroID;
    }];
}

+ (HeroModifier *)arc:(NSNumber *)intensity {
    return [[HeroModifier alloc] initWithApplyFunction:^(HeroTargetState *targetState) {
        targetState.arc = intensity;
    }];
}

+ (HeroModifier *)cascadeWithDelta:(NSTimeInterval)delta direction:(CascadeDirection)direction delayMatchedViews:(BOOL)delayMatchedViews {
    return [[HeroModifier alloc] initWithApplyFunction:^(HeroTargetState *targetState) {
        //Use three dimension array as tuple
        targetState.cascade = @[@(delta), @(direction), @(delayMatchedViews)];
    }];
}

+ (HeroModifier *)useGlobalCoordinateSpace {
    return [[HeroModifier alloc] initWithApplyFunction:^(HeroTargetState *targetState) {
        targetState.useGlobalCoordinateSpace = @(YES);
    }];
}

@end


@implementation HeroModifier (HeroModifierString)

+ (HeroModifier *)modifierFromName:(NSString *)name parameters:(NSArray <NSString *>*)parameters {
    HeroModifier *modifier;
    if ([name isEqualToString:@"fade"]) {
        modifier = [[HeroModifier alloc] initWithApplyFunction:fade];
    }
    
    if ([name isEqualToString:@"position"]) {
        modifier = [self position:[NSValue valueWithCGPoint:CGPointMake([parameters getFloatAtIndex:0] ? [parameters getFloatAtIndex:0] : 0, [parameters getFloatAtIndex:1] ? [parameters getFloatAtIndex:1] : 0)]];
    }
    
    if ([name isEqualToString:@"size"]) {
        modifier = [self size:[NSValue valueWithCGSize:CGSizeMake([parameters getFloatAtIndex:0] ? [parameters getFloatAtIndex:0] : 0, [parameters getFloatAtIndex:1] ? [parameters getFloatAtIndex:1] : 0)]];
    }
    
    if ([name isEqualToString:@"scale"]) {
        if ([parameters count] == 1) {
            modifier = [self scaleXY:[parameters getFloatAtIndex:0] ? [parameters getFloatAtIndex:0] : 1];
        } else {
            modifier = [self scaleX:[parameters getFloatAtIndex:0] ? [parameters getFloatAtIndex:0] : 1
                                  Y:[parameters getFloatAtIndex:1] ? [parameters getFloatAtIndex:1] : 1
                                  Z:[parameters getFloatAtIndex:2] ? [parameters getFloatAtIndex:2] : 1];
        }
    }
    
    if ([name isEqualToString:@"rotate"]) {
        if ([parameters count] == 1) {
            modifier = [self rotateZ:[parameters getFloatAtIndex:0] ? [parameters getFloatAtIndex:0] : 0];
        } else {
            modifier = [self rotateX:[parameters getFloatAtIndex:0] ? [parameters getFloatAtIndex:0] : 0
                                  Y:[parameters getFloatAtIndex:1] ? [parameters getFloatAtIndex:1] : 0
                                  Z:[parameters getFloatAtIndex:2] ? [parameters getFloatAtIndex:2] : 0];
        }
    }
    
    if ([name isEqualToString:@"translate"]) {
        modifier = [self translateX:[parameters getFloatAtIndex:0] ? [parameters getFloatAtIndex:0] : 0
                              Y:[parameters getFloatAtIndex:1] ? [parameters getFloatAtIndex:1] : 0
                              Z:[parameters getFloatAtIndex:2] ? [parameters getFloatAtIndex:2] : 0];
    }
    
    if ([name isEqualToString:@"duration"]) {
        NSTimeInterval duration = [parameters getDoubleAtIndex:0];
        if (duration) {
            modifier = [self duration:@(duration)];
        }
    }
    
    if ([name isEqualToString:@"delay"]) {
        NSTimeInterval delay = [parameters getDoubleAtIndex:0];
        if (delay) {
            modifier = [self delay:@(delay)];
        }
    }
    
    if ([name isEqualToString:@"spring"]) {
        modifier = [self spring:[parameters getFloatAtIndex:0] ? [parameters getFloatAtIndex:0] : 250 damping:[parameters getFloatAtIndex:1] ? [parameters getFloatAtIndex:1] : 30];
    }
    
    if ([name isEqualToString:@"timingFunction"]) {
        CGFloat c1 = [parameters getFloatAtIndex:0];
        CGFloat c2 = [parameters getFloatAtIndex:1];
        CGFloat c3 = [parameters getFloatAtIndex:2];
        CGFloat c4 = [parameters getFloatAtIndex:3];
        if (c1 && c2 && c3 && c4) {
            modifier = [self timingFunction:[CAMediaTimingFunction functionWithControlPoints:c1 :c2 :c3 :c4]];
        } else if ([parameters[0] isKindOfClass:[NSString class]]) {
            NSString *functionName = parameters[0];
            if (functionName &&  [CAMediaTimingFunction functionWithName:functionName]) {
                modifier = [self timingFunction:[CAMediaTimingFunction functionWithName:functionName]];
            }
        }
    }
    
    if ([name isEqualToString:@"arc"]) {
        modifier = [self arc:@([parameters getFloatAtIndex:0] ? [parameters getFloatAtIndex:0] : 1)];
    }
    
    if ([name isEqualToString:@"cascade"]) {
        CascadeDirection cascadeDirection = CascadeDirectionTopToBottom;
        if ([parameters[1] isKindOfClass:[NSString class]]) {
            CascadePreprocessor * cascadePreprocessor = [[CascadePreprocessor alloc] initWithDirectionString:parameters[1]];
            cascadeDirection = cascadePreprocessor.direction;
        }
        modifier = [self cascadeWithDelta:[parameters getFloatAtIndex:0] ? [parameters getFloatAtIndex:0] : 0.02 direction:cascadeDirection delayMatchedViews:[parameters[2] boolValue] ? [parameters[2] boolValue] : NO];
    }
    
    if ([name isEqualToString:@"source"]) {
        NSString *heroID = parameters[0];
        if (heroID) {
            modifier = [self source:heroID];
        }
    }
    
    if ([name isEqualToString:@"useGlobalCoordinateSpace"]) {
        modifier = [self useGlobalCoordinateSpace];
    }
    
    if ([name isEqualToString:@"ignoreSubviewModifiers"]) {
        modifier = [self ignoreSubviewModifiers:@([parameters getBoolAtIndex:0]) ? @([parameters getBoolAtIndex:0]) : @(NO)];
    }
    
    if ([name isEqualToString:@"zPosition"]) {
        modifier = [self zPosition:@([parameters getFloatAtIndex:0])];
    }
    
    if ([name isEqualToString:@"zPositionIfMatched"]) {
        modifier = [self zPositionIfMatched:@([parameters getFloatAtIndex:0])];
    }
    
    return modifier;
}

@end
