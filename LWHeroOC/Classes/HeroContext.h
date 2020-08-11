//
//  HeroContext.h
//  Hero-ObjectiveC
//
//  Created by luca.li on 2017/1/22.
//  Copyright © 2017年 luca. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class HeroTargetState;

@interface HeroContext : NSObject

/**
 A flattened list of all views from source ViewController
 */
@property (nonatomic, copy) NSMutableArray *fromViews;
/**
 A flattened list of all views from destination ViewController
 */
@property (nonatomic, copy) NSMutableArray *toViews;

/**
 The container holding all of the animating views
 */
@property (nonatomic, strong) UIView *container;

- (instancetype)initWithContainer:(UIView *)container fromView:(UIView *)fromView toView:(UIView *)toView;

/**
 - Returns: a source view matching the heroID, nil if not found
 */
- (UIView *)sourceViewForHeroID:(NSString *)heroID;

/**
 - Returns: a destination view matching the heroID, nil if not found
 */
- (UIView *)destinationViewForHeroID:(NSString *)heroID;

/**
 - Returns: a view with the same heroID, but on different view controller, nil if not found
 */
- (UIView *)pairedViewForView:(UIView *)view;

/**
 - Returns: a snapshot view for animation
 */
- (UIView *)snapshotViewForView:(UIView *)view;

- (void)hideView:(UIView *)view;

- (void)unhideView:(UIView *)view;

- (void)unhideAll;

+ (NSMutableArray <UIView *>*)processViewTreeWithView:(UIView *)view
                                            container:(UIView *)container
                                                idMap:(NSMutableArray *)idMap
                                             stateMap:(NSMutableArray *)stateMap;

@end

@interface HeroContext (TargetState)

- (HeroTargetState *)stateOfView:(UIView *)view;

- (void)setState:(HeroTargetState *)state toView:(UIView *)view;

@end
