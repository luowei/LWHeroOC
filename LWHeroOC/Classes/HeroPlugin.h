//
//  HeroPlugin.h
//  Hero-ObjectiveC
//
//  Created by luca.li on 2017/1/22.
//  Copyright © 2017年 luca. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HeroTypes.h"

@class HeroContext;

@interface HeroPlugin : NSObject <HeroPreprocessor, HeroAnimator>

/**
 Determines whether or not to receive `seekTo` callback on every frame.
 
 Default is false.
 
 When **requirePerFrameCallback** is **false**, the plugin needs to start its own animations inside `animate` & `resume`
 The `seekTo` method is only being called during an interactive transition.
 
 When **requirePerFrameCallback** is **true**, the plugin will receive `seekTo` callback on every animation frame. Hence it is possible for the plugin to do per-frame animations without implementing `animate` & `resume`
 */
@property (nonatomic, assign) BOOL requirePerFrameCallback;

- (instancetype)init;

/**
 Called before any animation.
 Override this method when you want to preprocess modifiers for views
 - Parameters:
 - context: object holding all parsed and changed modifiers,
 - fromViews: A flattened list of all views from source ViewController
 - toViews: A flattened list of all views from destination ViewController
 
 To check a view's modifier:
 
 [[context stateOfView:view] customItemOfKey:@"modifierName"];
 
 To set a view's modifier:
 
  [[context stateOfView:view] setCustomItemOfKey:@"modifierName" value:modifier];
 
 */
- (void)processFromViews:(NSArray *)fromviews toViews:(NSArray *)toviews;

/**
 - Returns: return true if the plugin can handle animating the view.
 - Parameters:
 - context: object holding all parsed and changed modifiers,
 - view: the view to check whether or not the plugin can handle the animation
 - appearing: true if the view is appearing(i.e. a view in destination ViewController)
 If return true, Hero won't animate and won't let any other plugins animate this view.
 The view will also be hidden automatically during the animation.
 */
- (BOOL)canAnimateView:(UIView *)view appearing:(BOOL)appear;

/**
 Perform the animation.
 
 Note: views in `fromViews` & `toViews` are hidden already. Unhide then if you need to take snapshots.
 - Parameters:
 - context: object holding all parsed and changed modifiers,
 - fromViews: A flattened list of all views from source ViewController (filtered by `canAnimate`)
 - toViews: A flattened list of all views from destination ViewController (filtered by `canAnimate`)
 - Returns: The duration needed to complete the animation
 */
- (NSTimeInterval)animateFromViews:(NSArray *)fromviews toViews:(NSArray *)toviews;

/**
 Called when all animations are completed.
 
 Should perform cleanup and release any reference
 */
- (void)clean;

/**
 For supporting interactive animation only.
 
 This method is called when an interactive animation is in place
 The plugin should pause the animation, and seek to the given progress
 - Parameters:
 - timePassed: time of the animation to seek to.
 */
- (void)seekToTime:(NSTimeInterval)timePassed;

/**
 For supporting interactive animation only.
 
 This method is called when an interactive animation is ended
 The plugin should resume the animation.
 - Parameters:
 - timePassed: will be the same value since last `seekTo`
 - reverse: a boolean value indicating whether or not the animation should reverse
 */
- (NSTimeInterval)resumeForTime:(NSTimeInterval)timePassed reverse:(BOOL)reverse;

/**
 For supporting interactive animation only.
 
 This method is called when user wants to override animation modifiers during an interactive animation
 
 - Parameters:
 - state: the target state to override
 - view: the view to override
 */
- (void)applyState:(HeroTargetState *)state toView:(UIView *)view;

@end


// methods for enable/disable the current plugin
@interface HeroPlugin (StateControl)

@property (nonatomic, strong, readonly) HeroContext *context;

+ (BOOL)isEnabled;

+ (void)setEnabled:(BOOL)enable;

+ (void)enable;

+ (void)disable;

@end
