//
//  HeroDefaultAnimator.m
//  Hero-ObjectiveC
//
//  Created by luca.li on 2017/1/24.
//  Copyright © 2017年 luca. All rights reserved.
//

#import "HeroDefaultAnimator.h"
#import "HeroDefaultAnimatorViewContext.h"

@interface HeroDefaultAnimator ()

@property (nonatomic, copy) NSMutableArray <NSMutableArray *> *viewContexts;    //@[ @[view, HeroDefaultAnimatorViewContext] ]

@end

@implementation HeroDefaultAnimator

- (NSMutableArray *)viewContexts {
    if (!_viewContexts) {
        _viewContexts = [NSMutableArray array];
    }
    return _viewContexts;
}

- (HeroContext *)context {
    return [Hero shared].context;
}

- (void)seekToTime:(NSTimeInterval)timePassed {
    for (NSArray *pair in self.viewContexts) {
        HeroDefaultAnimatorViewContext *viewContext = pair[1];
        [viewContext seekForTime:timePassed];
    }
}

- (NSTimeInterval)resumeForTime:(NSTimeInterval)timePassed reverse:(BOOL)reverse {
    NSTimeInterval duration = 0;
    for (NSArray *pair in self.viewContexts) {
        HeroDefaultAnimatorViewContext *viewContext = pair[1];
        [viewContext resumeForTime:timePassed reverse:reverse];
        duration = MAX(duration, viewContext.duration);
    }
    return duration;
}

- (void)applyState:(HeroTargetState *)state toView:(UIView *)view {
    HeroDefaultAnimatorViewContext *viewContext;
    for (NSArray *pair in self.viewContexts) {
        if (pair[0] == view) {
            viewContext = pair[1];
        }
    }
    NSAssert(viewContext, @"HERO: unable to temporarily set to \(view). The view must be running at least one animation before it can be interactively changed");
    [viewContext applyState:state];
}

- (BOOL)canAnimateView:(UIView *)view appearing:(BOOL)appear {
    HeroTargetState *state = [self.context stateOfView:view];
    return state.position || state.size || state.transform || state.cornerRadius || state.opacity;
}

- (NSTimeInterval)animateFromViews:(NSArray *)fromviews toViews:(NSArray *)toviews {
    __block NSTimeInterval duration = 0;
    
    // animate
    for (UIView *v in fromviews) {
        [self animateView:v appearing:NO];
    }
    
    for (UIView *v in toviews) {
        [self animateView:v appearing:YES];
    }
    
    [self.viewContexts enumerateObjectsUsingBlock:^(NSMutableArray * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        HeroDefaultAnimatorViewContext *viewContext = obj[1];
        duration = MAX(duration, viewContext.duration);
    }];

    return duration;
}

- (void)animateView:(UIView *)view appearing:(BOOL)appear {
    UIView *snapshot = [self.context snapshotViewForView:view];
    HeroTargetState *state = [self.context stateOfView:view];
    HeroDefaultAnimatorViewContext *viewContext = [[HeroDefaultAnimatorViewContext alloc] initWithAnimator:self
                                                                                                  snapshot:snapshot
                                                                                               targetState:state
                                                                                                 appearing:appear];
    
    __block BOOL contain = NO;
    __block NSInteger index = 0;
    [self.viewContexts enumerateObjectsUsingBlock:^(NSMutableArray * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj[0] == view) {
            contain = YES;
            index = idx;
            *stop = YES;
        }
    }];
    
    if (contain) {
        [self.viewContexts removeObjectAtIndex:index];
        [self.viewContexts insertObject:[@[view, viewContext] mutableCopy] atIndex:index];
    } else {
        [self.viewContexts addObject:[@[view, viewContext] mutableCopy]];
    }
}

- (void)clean {
    [self.viewContexts removeAllObjects];
}
@end
