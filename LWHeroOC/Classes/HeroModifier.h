//
//  HeroModifier.h
//  Hero-ObjectiveC
//
//  Created by luca.li on 2017/1/22.
//  Copyright © 2017年 luca. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "HeroTargetState.h"
#import "CascadePreprocessor.h"

@class HeroTargetState;

typedef void(^HeroModifierApplyBlock)(HeroTargetState *targetState);

/**
 Fade the view during transition
 */
extern const HeroModifierApplyBlock fade;;

@interface HeroModifier : NSObject

@property (nonatomic, copy) HeroModifierApplyBlock apply;

- (instancetype)initWithApplyFunction:(HeroModifierApplyBlock)applyFunction;

@end

@interface HeroModifier (BasicModifiers)

+ (HeroModifier *)fade;

/**
 Set the position for the view to animate from/to.
 - Parameters:
 - position: position for the view to animate from/to
 */
+ (HeroModifier *)position:(NSValue *)position;

/**
 Set the size for the view to animate from/to.
 - Parameters:
 - size: size for the view to animate from/to
 */
+ (HeroModifier *)size:(NSValue *)size;

@end

@interface HeroModifier (TransformModifiers)

/**
 Set the transform for the view to animate from/to. Will override previous perspective, scale, translate, & rotate modifiers
 - Parameters:
 - t: the CATransform3D object
 */
+ (HeroModifier *)transform:(NSValue *)t;

/**
 Set the perspective on the transform. use in combination with the rotate modifier.
 - Parameters:
 - perspective: set the camera distance of the transform
 */
+ (HeroModifier *)perspective:(CGFloat)perspective;

/**
 Scale 3d
 - Parameters:
 - x: scale factor on x axis, default 1
 - y: scale factor on y axis, default 1
 - z: scale factor on z axis, default 1
 */
+ (HeroModifier *)scaleX:(CGFloat)x Y:(CGFloat)y Z:(CGFloat)z;

/**
 Scale in x & y axis
 - Parameters:
 - xy: scale factor in both x & y axis
 */
+ (HeroModifier *)scaleXY:(CGFloat)xy;

/**
 Translate 3d
 - Parameters:
 - x: translation distance on x axis in display pixel, default 0
 - y: translation distance on y axis in display pixel, default 0
 - z: translation distance on z axis in display pixel, default 0
 */
+ (HeroModifier *)translateX:(CGFloat)x Y:(CGFloat)y Z:(CGFloat)z;

/**
 Rotate 3d
 - Parameters:
 - x: rotation on x axis in radian, default 0
 - y: rotation on y axis in radian, default 0
 - z: rotation on z axis in radian, default 0
 */
+ (HeroModifier *)rotateX:(CGFloat)x Y:(CGFloat)y Z:(CGFloat)z;

/**
 Rotate 2d
 - Parameters:
 - z: rotation in radian
 */
+ (HeroModifier *)rotateZ:(CGFloat)z;

@end


@interface HeroModifier (TimingMidifiers)

/**
 Sets the duration of the animation for a given view. If not used, Hero will use determine the duration based on the distance and size changes.
 - Parameters:
 - duration: duration of the animation
 */
+ (HeroModifier *)duration:(NSNumber *)duration;

/**
 Sets the delay of the animation for a given view.
 - Parameters:
 - delay: delay of the animation
 */
+ (HeroModifier *)delay:(NSNumber *)delay;

/**
 Sets the timing function of the animation for a given view. If not used, Hero will use determine the timing function based on whether or not the view is entering or exiting the screen.
 - Parameters:
 - timingFunction: timing function of the animation
 */
+ (HeroModifier *)timingFunction:(CAMediaTimingFunction*)timingFunction;

/**
 (iOS 9+) Use spring animation with custom stiffness & damping. The duration will be automatically calculated. Will be ignored if arc, timingFunction, or duration is set.
 - Parameters:
 - stiffness: stiffness of the spring
 - damping: stiffness of the spring
 */
+ (HeroModifier *)spring:(CGFloat)stiffness damping:(CGFloat)damping NS_AVAILABLE_IOS(9_0);

@end


@interface HeroModifier (OtherModifiers)

//TODO: definition of these three modifiers may not accurate
/**
 ignore all heroModifiers attributes for a view's direct subviews.
 */
@property (nonatomic, strong, readonly) HeroModifier *ignoreSubviewModifiers;
/**
 Works in combination with position modifier to apply a natural curve when moving to the destination.
 */
@property (nonatomic, strong, readonly) HeroModifier *arc;
/**
 Cascade applys increasing delay modifiers to subviews
 */
@property (nonatomic, strong, readonly) HeroModifier *cascade;

/**
 Sets the zPosition during the animation, not animatable.
 
 During animation, Hero might incorrectly infer the order to draw your views. Use this modifier to adjust
 the view draw order.
 - Parameters:
 - zPosition: zPosition during the animation
 */
+ (HeroModifier *)zPosition:(NSNumber *)zPosition;

/**
 Same as zPosition modifier but only effective only when the view is matched. Will override zPosition modifier.
 Will also force the view to use global coordinate space when the view is matched.
 - Parameters:
 - zPosition: zPosition during the animation
 */
+ (HeroModifier *)zPositionIfMatched:(NSNumber *)zPositionIfMatched;

/**
 ignore all heroModifiers attributes for a view's subviews.
 - Parameters:
 - recursive: if false, will only ignore direct subviews' modifiers. default false.
 */
+ (HeroModifier *)ignoreSubviewModifiersWithRecursive:(NSNumber *)recursive;

/**
 transition from/to the state of the view with matching heroID
 Will also force the view to use global coordinate space.
 - Parameters:
 - heroID: the source view's heroId.
 */
+ (HeroModifier *)source:(NSString *)heroID;

/**
 Works in combination with position modifier to apply a natural curve when moving to the destination.
 - Parameters:
 - intensity: a value of 1 represent a downward natural curve ╰. a value of -1 represent a upward curve ╮.
 default is 1.
 */
+ (HeroModifier *)arc:(NSNumber *)intensity;

/**
 Cascade applys increasing delay modifiers to subviews
 With Default parameters
 */
+ (HeroModifier *)cascade;

/**
 Cascade applys increasing delay modifiers to subviews
 - Parameters:
 - delta: delay in between each animation
 - direction: cascade direction
 - delayMatchedViews: whether or not to delay matched subviews until all cascading animation have started
 */
+ (HeroModifier *)cascadeWithDelta:(NSTimeInterval)delta direction:(CascadeDirection)direction delayMatchedViews:(BOOL)delayMatchedViews;

/**
 +   Use global coordinate space.
 +
 +   When using global coordinate space. The view become a independent view that is not a subview of any view.
 +   It won't move when its parent view moves, and won't be affected by parent view's attributes.
 +
 +   When a view is matched, this is automatically enabled.
 +   The `source` modifier will also enable this.
 +
 +   Global coordinate space is default for all views prior to version 0.1.3
 +   */
+ (HeroModifier *)useGlobalCoordinateSpace;
@end


@interface HeroModifier (HeroModifierString)

+ (HeroModifier *)modifierFromName:(NSString *)name parameters:(NSArray <NSString *>*)parameters;

@end
