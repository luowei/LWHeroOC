//
//  HeroContext.m
//  Hero-ObjectiveC
//
//  Created by luca.li on 2017/1/22.
//  Copyright © 2017年 luca. All rights reserved.
//

#import "HeroContext.h"
#import "UIKit+Hero.h"
#import "HeroTargetState.h"
#import <CoreGraphics/CoreGraphics.h>


@interface HeroContext ()

// Using multi-dimension array to represents map
@property (nonatomic, copy) NSMutableArray <NSArray *> *heroIDToSourceView;         //@[@[string, view], ...]
@property (nonatomic, copy) NSMutableArray <NSArray *> *heroIDToDestinationView;    //@[@[string, view], ...]
@property (nonatomic, copy) NSMutableArray <NSArray *> *snapshotViews;              //@[@[view, view], ...]
@property (nonatomic, copy) NSMutableArray <NSArray *> *viewAlphas;                 //@[@[string, number], ...]
@property (nonatomic, copy) NSMutableArray <NSArray *> *targetStates;               //@[@[view, HeroTargetState], ...]

@end

@implementation HeroContext

- (instancetype)initWithContainer:(UIView *)container fromView:(UIView *)fromView toView:(UIView *)toView {
    if ([self init]) {
        self.fromViews = [HeroContext processViewTreeWithView:fromView container:container idMap:self.heroIDToSourceView stateMap:self.targetStates];
        self.toViews = [HeroContext processViewTreeWithView:toView container:container idMap:self.heroIDToDestinationView stateMap:self.targetStates];
        self.container = container;
    }
    return self;
}

- (UIView *)sourceViewForHeroID:(NSString *)heroID {
    __block UIView *view = nil;
    [self.heroIDToSourceView enumerateObjectsUsingBlock:^(NSArray *pair, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([pair[0] isEqualToString:heroID]) {
            view = pair[1];
            *stop = YES;
        }
    }];
    return view;
}

- (UIView *)destinationViewForHeroID:(NSString *)heroID {
    __block UIView *view = nil;
    [self.heroIDToDestinationView enumerateObjectsUsingBlock:^(NSArray *pair, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([pair[0] isEqualToString:heroID]) {
            view = pair[1];
            *stop = YES;
        }
    }];
    return view;
}

- (UIView *)pairedViewForView:(UIView *)view {
    if (view.heroID) {
        if ([self sourceViewForHeroID:view.heroID]) {
            return [self destinationViewForHeroID:view.heroID];
        } else if ([self destinationViewForHeroID:view.heroID]) {
            return [self sourceViewForHeroID:view.heroID];
        }
    }
    return nil;
}

- (UIView *)snapshotViewForView:(UIView *)view {
    __block UIView *snapshot = nil;
    [self.snapshotViews enumerateObjectsUsingBlock:^(NSArray * _Nonnull pair, NSUInteger idx, BOOL * _Nonnull stop) {
        if(pair[0] == view) {
            snapshot = pair[1];
        }
    }];
    
    if (snapshot) {
        return snapshot;
    }
    
    UIView *containerView = self.container;
    if ([self stateOfView:view].useGlobalCoordinateSpace && [[self stateOfView:view].useGlobalCoordinateSpace boolValue] != YES) {
        containerView = view;
        __block BOOL contain = NO;
        __block NSInteger index = 0;
        [self.snapshotViews enumerateObjectsUsingBlock:^(NSArray * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (obj[0] == containerView) {
                contain = YES;
                index = idx;
                *stop = YES;
            }
        }];
        while (containerView != self.container &&
               !contain && containerView.superview) {
            containerView = containerView.superview;
        }
        if (contain) {
            containerView = [self.snapshotViews objectAtIndex:index][1];
        }
    }
    
    [self unhideView:view];
    
    // capture a snapshot without alpha & cornerRadius
    CGFloat oldCornerRadius = view.layer.cornerRadius;
    CGFloat oldAlpha = view.alpha;
    view.layer.cornerRadius = 0;
    view.alpha = 1;
    snapshot = nil;
    
    if ([view isKindOfClass:[UIStackView class]]) {
        UIStackView *stackView = (UIStackView *)view;
        snapshot = [stackView slowSnapshotView];
    } else if ([view isKindOfClass:[UIImageView class]] && [view.subviews count] == 0) {
        UIImageView *imageView = (UIImageView *)view;
        UIImageView *contentView = [[UIImageView alloc] initWithImage:imageView.image];
        contentView.frame = imageView.bounds;
        contentView.contentMode = imageView.contentMode;
        contentView.tintColor = imageView.tintColor;
        contentView.backgroundColor = imageView.backgroundColor;
        UIView *snapshotView = [[UIView alloc] init];
        [snapshotView addSubview:contentView];
        snapshot = snapshotView;
    } else if ([view isKindOfClass:[UINavigationBar class]] && ((UINavigationBar *)view).isTranslucent) {
        UINavigationBar *barView = (UINavigationBar *)view;
        UINavigationBar *newBarView = [[UINavigationBar alloc] initWithFrame:view.frame];
        
        newBarView.barStyle = barView.barStyle;
        newBarView.tintColor = barView.tintColor;
        newBarView.barTintColor = barView.barTintColor;
        newBarView.clipsToBounds = NO;
        
        // take a snapshot without the background
        barView.layer.sublayers[0].opacity = 0;
        UIView *realSnapshot = [barView snapshotViewAfterScreenUpdates:YES];
        barView.layer.sublayers[0].opacity = 1;
        
        [newBarView addSubview:realSnapshot];
        snapshot = newBarView;
    } else {
        snapshot = [view snapshotViewAfterScreenUpdates:YES];
    }
    view.layer.cornerRadius = oldCornerRadius;
    view.alpha = oldAlpha;
    
    if (![view isKindOfClass:[UINavigationBar class]]) {
        // the Snapshot's contentView must have hold the cornerRadius value,
        // since the snapshot might not have maskToBounds set
        UIView *contentView = snapshot.subviews.count > 0 ? snapshot.subviews[0] : nil;
        contentView.layer.cornerRadius = view.layer.cornerRadius;
        contentView.layer.masksToBounds = YES;
    }
    
    snapshot.layer.cornerRadius = view.layer.cornerRadius;
    __block BOOL contain = NO;
    [self.targetStates enumerateObjectsUsingBlock:^(NSArray * _Nonnull pair, NSUInteger idx, BOOL * _Nonnull stop) {
        if (pair[0] == view && ((HeroTargetState *)pair[1]).zPosition) {
            snapshot.layer.zPosition = [((HeroTargetState *)pair[1]).zPosition floatValue];
            contain = YES;
            *stop = YES;
        }
    }];
    if (!contain) {
        snapshot.layer.zPosition = view.layer.zPosition;
    }
    
    snapshot.layer.opacity = view.layer.opacity;
    snapshot.layer.opaque = view.layer.isOpaque;
    snapshot.layer.anchorPoint = view.layer.anchorPoint;
    snapshot.layer.masksToBounds = view.layer.masksToBounds;
    snapshot.layer.borderColor = view.layer.borderColor;
    snapshot.layer.borderWidth = view.layer.borderWidth;
    snapshot.layer.transform = view.layer.transform;
    snapshot.layer.shadowRadius = view.layer.shadowRadius;
    snapshot.layer.shadowOpacity = view.layer.shadowOpacity;
    snapshot.layer.shadowColor = view.layer.shadowColor;
    snapshot.layer.shadowOffset = view.layer.shadowOffset;
    
    snapshot.frame = [containerView convertRect:view.bounds fromView:view];
    snapshot.heroID = view.heroID;
    
    [self hideView:view];
    
    [containerView addSubview:snapshot];
    contain = NO;
    __block NSInteger index = 0;
    [self.snapshotViews enumerateObjectsUsingBlock:^(NSArray * _Nonnull pair, NSUInteger idx, BOOL * _Nonnull stop) {
        if (pair[0] == view) {
            contain = YES;
            index = idx;
            *stop = YES;
        }
    }];
    if (!contain) {
        [self.snapshotViews addObject:@[view, snapshot]];
    } else {
        [self.snapshotViews removeObjectAtIndex:index];
        [self.snapshotViews insertObject:@[view, snapshot] atIndex:index];
    }
    
    return snapshot;
}

#pragma mark - Internal

- (void)hideView:(UIView *)view {
    __block BOOL contain = NO;
    [self.viewAlphas enumerateObjectsUsingBlock:^(NSArray * _Nonnull pair, NSUInteger idx, BOOL * _Nonnull stop) {
        if (pair[0] == view) {
            contain = YES;
            *stop = YES;
        }
    }];
    
    if (!contain) {
        [self.viewAlphas addObject:@[view, @(view.alpha)]];
        view.alpha = 0;
    }
}

- (void)unhideView:(UIView *)view {
    __block NSNumber *oldAlpha = nil;
    __block BOOL contain = NO;
    __block NSInteger index = 0;
    [self.viewAlphas enumerateObjectsUsingBlock:^(NSArray * _Nonnull pair, NSUInteger idx, BOOL * _Nonnull stop) {
        if (pair[0] == view) {
            oldAlpha = pair[1];
            contain = YES;
            index = idx;
            *stop = YES;
        }
    }];
    
    if (contain && oldAlpha) {
        view.alpha = [oldAlpha floatValue];
        [self.viewAlphas removeObjectAtIndex:index];
    }
}

- (void)unhideAll {
    [self.viewAlphas enumerateObjectsUsingBlock:^(NSArray * _Nonnull pair, NSUInteger idx, BOOL * _Nonnull stop) {
        UIView *view = pair[0];
        CGFloat oldAlpha = [pair[1] floatValue];
        view.alpha = oldAlpha;
    }];
    [self.viewAlphas removeAllObjects];
}

+ (NSMutableArray <UIView *>*)processViewTreeWithView:(UIView *)view
                                            container:(UIView *)container
                                                idMap:(NSMutableArray *)idMap
                                             stateMap:(NSMutableArray *)stateMap {
    NSMutableArray <UIView *> *rtn = [NSMutableArray array];
    if (!CGRectEqualToRect(CGRectIntersection([container convertRect:view.bounds fromView:view], container.bounds), CGRectNull)) {
        rtn = [@[view] mutableCopy];
        if (view.heroID) {
            __block BOOL contain = NO;
            __block NSInteger index = 0;
            [idMap enumerateObjectsUsingBlock:^(NSArray *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if ([[obj firstObject] isEqualToString:view.heroID]) {
                    contain = YES;
                    index = idx;
                    *stop = YES;
                }
            }];
            if (contain) {
                [idMap removeObjectAtIndex:index];
            }
            [idMap insertObject:@[view.heroID, view] atIndex:index];
        }
        if (view.heroModifiers && [view.heroModifiers count]) {
            __block BOOL contain = NO;
            __block NSInteger index = 0;
            [stateMap enumerateObjectsUsingBlock:^(NSArray *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if ([obj firstObject] == view) {
                    contain = YES;
                    index = idx;
                    *stop = YES;
                }
            }];
            if (contain) {
                [stateMap removeObjectAtIndex:index];
            }
            [stateMap insertObject:@[view, [[HeroTargetState alloc] initWithModifiers:view.heroModifiers]] atIndex:index];
        }
    } else {
        rtn = [@[] mutableCopy];
    }
    
    for (UIView *sv in view.subviews) {
        [rtn addObjectsFromArray:[self processViewTreeWithView:sv container:container idMap:idMap stateMap:stateMap]];
    }
    
    return rtn;
}

#pragma mark - Getters
- (NSMutableArray<NSArray *> *)targetStates {
    if (!_targetStates) {
        _targetStates = [NSMutableArray array];
    }
    return _targetStates;
}

- (NSMutableArray<NSArray *> *)heroIDToSourceView {
    if (!_heroIDToSourceView) {
        _heroIDToSourceView = [NSMutableArray array];
    }
    return _heroIDToSourceView;
}

- (NSMutableArray<NSArray *> *)heroIDToDestinationView {
    if (!_heroIDToDestinationView) {
        _heroIDToDestinationView = [NSMutableArray array];
    }
    return _heroIDToDestinationView;
}

- (NSMutableArray<NSArray *> *)snapshotViews {
    if (!_snapshotViews) {
        _snapshotViews = [NSMutableArray array];
    }
    return _snapshotViews;
}

- (NSMutableArray<NSArray *> *)viewAlphas {
    if (!_viewAlphas) {
        _viewAlphas = [NSMutableArray array];
    }
    return _viewAlphas;
}

@end


@implementation HeroContext (TargetState)

- (HeroTargetState *)stateOfView:(UIView *)view {
    __block BOOL contain = NO;
    __block NSInteger index = 0;
    [self.targetStates enumerateObjectsUsingBlock:^(NSArray * _Nonnull pair, NSUInteger idx, BOOL * _Nonnull stop) {
        if (pair[0] == view) {
            index = idx;
            contain = YES;
            *stop = YES;
        }
    }];
    
    if (contain) {
        return [[self.targetStates objectAtIndex:index][1] copy];
    }
    return nil;
}

- (void)setState:(HeroTargetState *)state toView:(UIView *)view {
    
    BOOL contain = NO;
    NSInteger index = 0;

    for (NSArray *pair in self.targetStates) {
        if (pair[0] == view) {
            contain = YES;
            break;
        }
        index ++;
    }
    
    if (contain && [self.targetStates count]) {
        [self.targetStates removeObjectAtIndex:index];
    }
    
    if (state) {
        [self.targetStates addObject:@[view, state]];
    }
}

@end
