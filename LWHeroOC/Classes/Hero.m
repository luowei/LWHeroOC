//
//  Hero.m
//  Hero-ObjectiveC
//
//  Created by luca.li on 2017/1/22.
//  Copyright © 2017年 luca. All rights reserved.
//

#import "Hero.h"
#import "HeroContext.h"
#import "HeroPlugin.h"
#import "HeroModifier.h"

#import "CascadePreprocessor.h"
#import "IgnoreSubviewModifiersPreprocessor.h"
#import "SourcePreprocessor.h"
#import "MatchPreprocessor.h"

#import "HeroDefaultAnimator.h"

#import <QuartzCore/QuartzCore.h>
#import <objc/runtime.h>

typedef void(^HeroCompletionCallback)(BOOL animate);

static NSMutableArray <Class> *_enablePlugins;

@interface Hero ()

@property (nonatomic, weak) UIViewController *toViewController;
@property (nonatomic, weak) UIViewController *fromViewController;

@property (nonatomic, strong) HeroContext *context;

@property (nonatomic, assign) BOOL presenting;  //default is true in swift, but NO in here
@property (nonatomic, assign) CGFloat progress;

@property (nonatomic, strong) UIView *container;

// this is the container supplied by UIKit
@property (nonatomic, strong) UIView *transitionContainer;

// a UIViewControllerContextTransitioning object provided by UIKit,
// might be nil when transitioning. This happens when calling heroReplaceViewController
@property (nonatomic, weak) id <UIViewControllerContextTransitioning> transitionContext;
@property (nonatomic, assign) HeroCompletionCallback completionCallback;

@property (nonatomic, strong) CADisplayLink *displayLink;
@property (nonatomic, copy) NSMutableArray <id <HeroProgressUpdateObserver>>* progressUpdateObservers;

/// max duration needed by the default animator and plugins
@property (nonatomic, assign) NSTimeInterval totalDuration;
@property (nonatomic, assign) NSTimeInterval duration;
@property (nonatomic, strong) NSNumber *beginTime;      //@(Double)

@property (nonatomic, assign) BOOL finishing;
/// true if transitioning inside a UINavigationController or UITabBarController
@property (nonatomic, assign) BOOL inContainerController;

@property (nonatomic, strong) UIView *toView;
@property (nonatomic, strong) UIView *fromView;

@property (nonatomic, copy) NSMutableArray <id <HeroPreprocessor>> *processors;
@property (nonatomic, copy) NSMutableArray <id <HeroAnimator>> *animators;
@property (nonatomic, copy) NSMutableArray <HeroPlugin *> *plugins;

@end

@implementation Hero

+ (instancetype)shared {
    static Hero *hero = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        hero = [[Hero alloc] init];
    });
    
    return hero;
}

- (instancetype)init {
    if (self = [super init]) {
        //Nothing special
        self.processors = [NSMutableArray array];
        self.animators = [NSMutableArray array];
        self.plugins = [NSMutableArray array];
        _enablePlugins = [NSMutableArray array];
        self.presenting = YES;
        self.forceNotInteractive = NO;
        self.totalDuration = 0;
        self.duration= 0;
        self.finishing = YES;
        self.inContainerController = NO;
    }
    return self;
}

- (BOOL)interactive {
    return self.displayLink = nil;
}

- (BOOL)transitioning {
    return self.transitionContainer != nil;
}

- (void)setProgress:(CGFloat)progress {
    _progress = progress;
    
    if (self.transitioning && _progress != progress) {
        [self.transitionContext updateInteractiveTransition:_progress];
        NSArray *progressUpdateObservers = self.progressUpdateObservers;
        if (progressUpdateObservers) {
            for (id<HeroProgressUpdateObserver>observer in progressUpdateObservers) {
                [observer heroDidUpdateProgress:_progress];
            }
        }
        
        NSTimeInterval timePassed = self.progress * self.totalDuration;
        if (self.interactive) {
            for (id<HeroAnimator>animator in self.animators) {
                [animator seekToTime:timePassed];
            }
        } else {
            for (HeroPlugin *plugin in self.plugins) {
                if (plugin.requirePerFrameCallback) {
                    [plugin seekToTime:timePassed];
                }
            }
        }
    }
}

- (void)setBeginTime:(NSNumber *)beginTime {
    _beginTime = beginTime;
    
    if (_beginTime) {
        if (self.displayLink == nil) {
            self.displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(displayUpdate:)];
            [self.displayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
        } else {
            [self.displayLink setPaused:YES];
            [self.displayLink removeFromRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
            self.displayLink = nil;
        }
    }
}

- (UIView *)toView {
    return self.toViewController.view;
}

- (UIView *)fromView {
    return self.fromViewController.view;
}

#pragma mark - private

- (void)displayUpdate:(CADisplayLink *)link {
    if (self.transitioning && self.duration > 0) {
        NSTimeInterval beginTime = [self.beginTime doubleValue];
        NSTimeInterval timePassed = CACurrentMediaTime() - beginTime;
        
        if (timePassed > self.duration) {
            self.progress = self.finishing ? 1 : 0;
            self.beginTime = @(0);
            [self complete:self.finishing];
        } else {
            NSTimeInterval completed = timePassed / self.totalDuration;
            if (self.finishing) {
                completed = 1 - completed;
            }
            completed = MAX(0, MIN(1, completed));
            self.progress = completed;
        }
    }
}

@end

typedef void(^HeroUpdateBlock)();
@implementation Hero (InteractiveTransition)

- (void)updateProgress:(CGFloat)progress {
    
    if (!self.transitioning) {
        return;
    }
    
    progress = MAX(0, MIN(1, progress));
    self.beginTime = nil;
    self.progress = progress;
}

- (void)endAnimated:(BOOL)animate {
    
    if (!self.transitioning || !self.interactive) {
        return;
    }
    
    if (!animate) {
        [self complete:YES];
        return;
    }
    
    NSTimeInterval maxTime = 0;
    for (id<HeroAnimator>animator in self.animators) {
        maxTime = MAX(maxTime, [animator resumeForTime:self.progress * self.totalDuration reverse:NO]);
    }
    [self completeAfter:maxTime finishing:YES];
}

- (void)cancelAnimated:(BOOL)animate {
    
    if (!self.transitioning || !self.interactive) {
        return;
    }
    
    if (!animate) {
        [self complete:NO];
        return;
    }
    
    NSTimeInterval maxTime = 0;
    for (id<HeroAnimator>animator in self.animators) {
        maxTime = MAX(maxTime, [animator resumeForTime:self.progress * self.totalDuration reverse:YES]);
    }
    [self completeAfter:maxTime finishing:NO];
}

- (void)applyModifiers:(NSArray *)modifiers toView:(UIView *)view {
    
    if (!self.transitioning || !self.interactive) {
        return;
    }
    
    HeroTargetState *targetState = [[HeroTargetState alloc] initWithModifiers:modifiers];
    UIView *otherView = [self.context pairedViewForView:view];
    if (otherView) {
        for (id<HeroAnimator>animator in self.animators) {
            [animator applyState:targetState toView:otherView];
        }
    }
    
    for (id<HeroAnimator>animator in self.animators) {
        [animator applyState:targetState toView:view];
    }
}

@end


@implementation Hero (Observe)

- (void)observeForProgressUpdateWithObserver:(id<HeroProgressUpdateObserver>)observer {
    
    if (self.progressUpdateObservers == nil) {
        self.progressUpdateObservers = [NSMutableArray array];
    }
    
    if (observer) {
        [self.progressUpdateObservers addObject:observer];
    }
}

@end


@implementation Hero (Transition)
- (void)start {
    UIViewController *fvc = self.fromViewController;
    UIViewController *tvc = self.toViewController;
    if (fvc && tvc) {
        [self closureProcessForHeroDelegate:fvc closure:^(id<HeroViewControllerDelegate> delegate) {
            if ([delegate respondsToSelector:@selector(heroWillStartTransition)]) {
                [delegate heroWillStartTransition];
            }
            if ([delegate respondsToSelector:@selector(heroWillStartAnimatingTo:)]) {
                [delegate heroWillStartAnimatingTo:tvc];
            }
        }];
        [self closureProcessForHeroDelegate:tvc closure:^(id<HeroViewControllerDelegate> delegate) {
            if ([delegate respondsToSelector:@selector(heroWillStartTransition)]) {
                [delegate heroWillStartTransition];
            }
            if ([delegate respondsToSelector:@selector(heroWillStartAnimatingFrom:)]) {
                [delegate heroWillStartAnimatingFrom:fvc];
            }
        }];
    }
    
    NSMutableArray *plugins = [NSMutableArray array];
    [_enablePlugins enumerateObjectsUsingBlock:^(Class _Nonnull pluginClass, NSUInteger idx, BOOL * _Nonnull stop) {
        [plugins addObject:[[pluginClass alloc] init]];
    }];
    self.plugins = plugins;
    
    NSMutableArray <id<HeroPreprocessor>> *processorsArray = [[NSMutableArray alloc] initWithObjects:[[IgnoreSubviewModifiersPreprocessor alloc] init],
                                                              [[MatchPreprocessor alloc] init],
                                                              [[SourcePreprocessor alloc] init],
                                                              [[CascadePreprocessor alloc] init], nil];
    self.processors = processorsArray;
    
    NSMutableArray <id<HeroAnimator>> *animatorArray = [[NSMutableArray alloc] initWithObjects:[[HeroDefaultAnimator alloc] init], nil];
    self.animators = animatorArray;
    
    [self.plugins enumerateObjectsUsingBlock:^(HeroPlugin * _Nonnull plugin, NSUInteger idx, BOOL * _Nonnull stop) {
        [self.processors addObject:plugin];
        [self.animators addObject:plugin];
    }];
    
    [self.transitionContainer setUserInteractionEnabled:NO];
    
    // a view to hold all the animating views
    self.container = [[UIView alloc] initWithFrame:self.transitionContainer.bounds];
    [self.transitionContainer addSubview:self.container];
    
    // take a snapshot to hide all the flashing that might happen
    UIView *completeSnapshot = [self.fromView snapshotViewAfterScreenUpdates:YES];
    [self.transitionContainer addSubview:completeSnapshot];
    
    // need to add fromView first, then insert toView under it. This eliminates the flash
    [self.container addSubview:self.fromView];
    [self.container insertSubview:self.toView belowSubview:self.fromView];
    [self.container setBackgroundColor:self.toView.backgroundColor];
    
    self.toView.frame = self.fromView.frame;
    [self.toView updateConstraints];
    [self.toView setNeedsLayout];
    [self.toView layoutIfNeeded];
    
    self.context = [[HeroContext alloc] initWithContainer:self.container fromView:self.fromView toView:self.toView];
    
    // ask each preprocessor to process
    [self.processors enumerateObjectsUsingBlock:^(id<HeroPreprocessor>  _Nonnull processor, NSUInteger idx, BOOL * _Nonnull stop) {
        [processor processFromViews:self.context.fromViews toViews:self.context.toViews];
    }];
    
    __block BOOL skipDefaultAnimation = NO;
    NSMutableArray *animatingViews = [NSMutableArray array];    //@[ @[fromviews, toviews], ... ]
    NSMutableArray *currentFromViews = [NSMutableArray array];
    NSMutableArray *currentToViews = [NSMutableArray array];
    [self.animators enumerateObjectsUsingBlock:^(id<HeroAnimator>  _Nonnull animator, NSUInteger idx, BOOL * _Nonnull stop) {
        [self.context.fromViews enumerateObjectsUsingBlock:^(UIView *  _Nonnull view, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([animator canAnimateView:view appearing:NO]) {
                [currentFromViews addObject:view];
            }
        }];
        [self.context.toViews enumerateObjectsUsingBlock:^(UIView *  _Nonnull view, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([animator canAnimateView:view appearing:YES]) {
                [currentToViews addObject:view];
            }
        }];
        
        if ([currentFromViews firstObject] == self.fromView || [currentToViews firstObject] == self.toView) {
            skipDefaultAnimation = YES;
        }
        [animatingViews addObject:@[currentFromViews, currentToViews]];
    }];
    
    if (!skipDefaultAnimation) {
        // if no animator can animate toView & fromView, set the effect to fade // i.e. default effect
        HeroModifier *fadeModifier = [HeroModifier fade];
        [self.context setState:[[HeroTargetState alloc] initWithModifiers:@[fadeModifier]] toView:self.toView];
        [((NSMutableArray *)[animatingViews firstObject][1]) insertObject:self.toView atIndex:0];
    }
    
    // wait for a frame if using navigation controller.
    // a bug with navigation controller. the snapshot is not captured if animating immediately
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(((self.inContainerController && self.presenting) ? 0.02 : 0) * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [animatingViews enumerateObjectsUsingBlock:^(NSArray * _Nonnull pair, NSUInteger idx, BOOL * _Nonnull stop) {
            NSArray *curentFromViews = pair[0];
            NSArray *currentToViews = pair[1];
            // auto hide all animated views
            for (UIView *view in curentFromViews) {
                [self.context hideView:view];
            }
            
            for (UIView *view in currentToViews) {
                [self.context hideView:view];
            }
        }];
        
        __block NSTimeInterval totalDuration = 0;
        __block BOOL animatorWantsInteractive = NO;
        [self.animators enumerateObjectsUsingBlock:^(id<HeroAnimator>  _Nonnull animator, NSUInteger idx, BOOL * _Nonnull stop) {
            NSTimeInterval duration = [animator animateFromViews:animatingViews[idx][0] toViews:animatingViews[idx][1]];
            if (duration == INFINITY) {
                animatorWantsInteractive = YES;
            } else {
                totalDuration = MAX(totalDuration, duration);
            }
        }];
        
        // we are done with setting up, so remove the covering snapshot
        [completeSnapshot removeFromSuperview];
        self.totalDuration = totalDuration;
        if (animatorWantsInteractive) {
            [self updateProgress:0.001];
        } else {
            [self completeAfter:totalDuration finishing:YES];
        }
    });
}

- (void)transitionFrom:(UIViewController *)from to:(UIViewController *)to inView:(UIView *)view completion:(void(^)(BOOL animate))completion {
    
    if (self.transitioning) {
        return;
    }
    
    self.forceNotInteractive = YES;
    self.inContainerController = NO;
    self.presenting = YES;
    self.transitionContainer = view;
    self.fromViewController = from;
    self.toViewController = to;
    self.completionCallback = completion;
    [self start];
}

- (void)completeAfter:(NSTimeInterval)after finishing:(BOOL)finishing {
    
    if (after <= 0.001) {
        [self complete:finishing];
        return;
    }
    
    NSTimeInterval timePassed = (finishing ? self.progress : 1 - self.progress) * self.totalDuration;
    self.finishing = finishing;
    self.duration = after + timePassed;
    self.beginTime = @(CACurrentMediaTime() - timePassed);
}

- (void)complete:(BOOL)finished {
    
    if (!self.transitioning) {
        return;
    }
    
    for (id <HeroAnimator> animator in self.animators) {
        [animator clean];
    }
    [self.context unhideAll];
    
    // move fromView & toView back from animatingViewContainer
    [self.transitionContainer addSubview:finished ? self.toView : self.fromView];
    
    if (self.presenting != finished && !self.inContainerController) {
        // bug: http://openradar.appspot.com/radar?id=5320103646199808
        [[UIApplication sharedApplication].keyWindow addSubview:self.toView];
    }
    
    [self.container removeFromSuperview];
    [self.transitionContainer setUserInteractionEnabled:YES];
    
    // use temp variables to remember these values
    // because we have to reset everything before calling
    // any delegate or completion block
    id <UIViewControllerContextTransitioning> tContext = self.transitionContext;
    HeroCompletionCallback completion = self.completionCallback;
    UIViewController *fvc = self.fromViewController;
    UIViewController *tvc = self.toViewController;
    
    self.progressUpdateObservers = nil;
    self.transitionContainer = nil;
    self.transitionContext = nil;
    self.fromViewController = nil;
    self.toViewController = nil;
    self.completionCallback = nil;
    self.container = nil;
    self.plugins = nil;
    self.animators = nil;
    self.context = nil;
    self.beginTime = nil;
    self.inContainerController = NO;
    self.forceNotInteractive = NO;
    self.progress = 0;
    self.totalDuration = 0;
    
    
    if (fvc && tvc) {
        [self closureProcessForHeroDelegate:fvc closure:^(id<HeroViewControllerDelegate> delegate) {
            if ([delegate respondsToSelector:@selector(heroDidEndAnimatingTo:)]) {
                [delegate heroDidEndAnimatingTo:tvc];
            }
            if ([delegate respondsToSelector:@selector(heroDidEndTransition)]) {
                [delegate heroDidEndTransition];
            }
        }];
        
        [self closureProcessForHeroDelegate:tvc closure:^(id<HeroViewControllerDelegate> delegate) {
            if ([delegate respondsToSelector:@selector(heroDidEndAnimatingFrom:)]) {
                [delegate heroDidEndAnimatingFrom:fvc];
            }
            if ([delegate respondsToSelector:@selector(heroDidEndTransition)]) {
                [delegate heroDidEndTransition];
            }
        }];
    }
    
    if (finished) {
        [tContext finishInteractiveTransition];
    } else {
        [tContext cancelInteractiveTransition];
    }
    [tContext completeTransition:finished];
    if (completion) {
        completion(finished);
    }
}

@end


// delegate helper
@implementation Hero (DelegateHelper)

- (void)closureProcessForHeroDelegate:(UIViewController *)vc closure:(void(^)(id<HeroViewControllerDelegate> delegate))closure {
    
    id <HeroViewControllerDelegate>delegate = (id <HeroViewControllerDelegate>)vc;
    if ([delegate conformsToProtocol:@protocol(HeroViewControllerDelegate)]) {
        closure(delegate);
    }
    
    UINavigationController *navigationController = (UINavigationController *)vc;
    if ([vc isKindOfClass:[UINavigationController class]]) {
        delegate = (id <HeroViewControllerDelegate>)navigationController.topViewController;
        if (navigationController && [delegate conformsToProtocol:@protocol(HeroViewControllerDelegate)]) {
            closure(delegate);
        }
    }
    
    UITabBarController *tabBarController = (UITabBarController *)vc;
    if ([vc isKindOfClass:[UITabBarController class]]) {
        delegate = (id <HeroViewControllerDelegate>)tabBarController.viewControllers[tabBarController.selectedIndex];
        if ([delegate conformsToProtocol:@protocol(HeroViewControllerDelegate)]) {
            closure(delegate);
        }
    }
}

@end

// plugin support
@implementation Hero (PluginSupport)

+ (BOOL)isEnabledPlugin:(Class)plugin {
    for (Class plugin in _enablePlugins) {
        if ([NSStringFromClass(plugin) isEqualToString:NSStringFromClass([plugin class])]) {
            return YES;
        }
    }
    return nil;
}

+ (void)enablePlugin:(Class)plugin {
    [self disablePlugin:plugin];
    [_enablePlugins addObject:plugin];
}

+ (void)disablePlugin:(Class)plugin {
    for (Class plugin in _enablePlugins) {
        if ([NSStringFromClass(plugin) isEqualToString:NSStringFromClass([plugin class])]) {
            [_enablePlugins removeObject:plugin];
            break;
        }
    }
}

@end






/*****************************
 * UIKit protocol extensions *
 *****************************/

@implementation Hero (AnimatedTransitioning)

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    
    if (self.transitioning) {
        return;
    }
    
    self.transitionContext = transitionContext;
    self.fromViewController = self.fromViewController ? self.fromViewController : [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    self.toViewController = self.toViewController ? self.toViewController : [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    self.transitionContainer = [transitionContext containerView];
    [self start];
}

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    return 0.375;   // doesn't matter, real duration will be calculated later
}

@end


@implementation Hero (TransitioningDelegate)

- (id<UIViewControllerInteractiveTransitioning>)interactiveTransitioning {
    return self.forceNotInteractive ? nil : (id<UIViewControllerInteractiveTransitioning>)self;
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source {
    self.presenting = YES;
    self.fromViewController = self.fromViewController ? self.fromViewController : presenting;
    self.toViewController = self.toViewController ? self.toViewController : presented;
    return self;
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
    self.presenting = NO;
    self.fromViewController = self.fromViewController ? self.fromViewController : dismissed;
    return self;
}

- (id<UIViewControllerInteractiveTransitioning>)interactionControllerForDismissal:(id<UIViewControllerAnimatedTransitioning>)animator {
    return self.interactiveTransitioning;
}

- (id<UIViewControllerInteractiveTransitioning>)interactionControllerForPresentation:(id<UIViewControllerAnimatedTransitioning>)animator {
    return self.interactiveTransitioning;
}
@end


@implementation Hero (InteractiveTransitioning)

- (BOOL)wantsInteractiveStart {
    return YES;
}

- (void)startInteractiveTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    [self animateTransition:transitionContext];
}

@end


@implementation Hero (NavigationControllerDelegate)

- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController animationControllerForOperation:(UINavigationControllerOperation)operation fromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC {
    self.presenting = (operation == UINavigationControllerOperationPush);
    self.fromViewController = self.fromViewController ? self.fromViewController : fromVC;
    self.toViewController = self.toViewController ? self.toViewController : toVC;
    self.inContainerController = YES;
    return self;
}

- (id<UIViewControllerInteractiveTransitioning>)navigationController:(UINavigationController *)navigationController interactionControllerForAnimationController:(id<UIViewControllerAnimatedTransitioning>)animationController {
    return self.interactiveTransitioning;
}

@end


@implementation Hero (TabBarControllerDelegate)

- (id<UIViewControllerInteractiveTransitioning>)tabBarController:(UITabBarController *)tabBarController interactionControllerForAnimationController:(id<UIViewControllerAnimatedTransitioning>)animationController {
    return self.interactiveTransitioning;
}

- (id<UIViewControllerAnimatedTransitioning>)tabBarController:(UITabBarController *)tabBarController animationControllerForTransitionFromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC {
    self.presenting = YES;
    self.fromViewController = self.fromViewController ? self.fromViewController : fromVC;
    self.toViewController = self.toViewController ? self.toViewController : toVC;
    self.inContainerController = YES;
    return self;
}
@end
