//
//  UIKit+Hero.m
//  Hero-ObjectiveC
//
//  Created by luca.li on 2017/1/22.
//  Copyright © 2017年 luca. All rights reserved.
//

#import "UIKit+Hero.h"
#import "Hero.h"
#import <objc/runtime.h>

static NSString *parameterRegex = @"(?:\\-?\\d+(\\.?\\d+)?)|\\w+";
static NSString *modifiersRegex = @"(\\w+)(?:\\(([^\\)]*)\\))?";

struct AssociatedKeys {
    __unsafe_unretained NSString *HeroID;
    __unsafe_unretained NSString *HeroModifiers;
};

static struct AssociatedKeys assoKey = {@"ht_heroID", @"ht_heroModifers"};

@implementation UIView (Hero)

@dynamic heroID;
@dynamic heroModifiers;
@dynamic heroModifierString;

- (NSString *)heroID {
    return objc_getAssociatedObject(self, &assoKey.HeroID);
}

- (void)setHeroID:(NSString *)heroID {
    objc_setAssociatedObject(self,
                             &assoKey.HeroID,
                             heroID,
                             OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSArray <HeroModifier *>*)heroModifiers {
    return objc_getAssociatedObject(self, &assoKey.HeroModifiers);
}

- (void)setHeroModifiers:(NSArray <HeroModifier *>*)heroModifiers {
    objc_setAssociatedObject(self,
                             &assoKey.HeroModifiers,
                             heroModifiers,
                             OBJC_ASSOCIATION_RETAIN_NONATOMIC
                             );
}

- (NSString *)heroModifierString {
    NSAssert(0, @"Reverse lookup is not supported");
    return nil;
}

- (void)setHeroModifierString:(NSString *)heroModifierString {
    NSString *modifierString = heroModifierString;
    NSMutableArray <HeroModifier*>*modifiers = [NSMutableArray array];
    
    for (NSTextCheckingResult *r in [self matchesForRegex:modifiersRegex text:modifierString]) {
        NSMutableArray <NSString *>*parameters = [NSMutableArray array];
        if (r.numberOfRanges > 2 && [r rangeAtIndex:2].location < modifierString.length) {
            NSString *parameterString = [modifierString substringWithRange:[r rangeAtIndex:2]];
            for (NSTextCheckingResult *r in [self matchesForRegex:parameterRegex text:parameterString]) {
                [parameters addObject:[parameterString substringWithRange:r.range]];
            }
        }
        NSString *name = [modifierString substringWithRange:[r rangeAtIndex:1]];
        HeroModifier *modifier = [HeroModifier modifierFromName:name parameters:parameters];
        if (modifier) {
            [modifiers addObject:modifier];
        }
    }
    
    self.heroModifiers = modifiers;
}

- (UIView *)slowSnapshotView {
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, self.isOpaque, 0);
    [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    imageView.frame = self.bounds;
    UIView *snapshotView = [[UIView alloc] initWithFrame:self.bounds];
    [snapshotView addSubview:imageView];
    
    return snapshotView;
}

#pragma mark - Private

- (NSArray <NSTextCheckingResult *>*)matchesForRegex:(NSString *)regex text:(NSString *)text {
    NSError *error;
    NSRegularExpression *regularExpression = [NSRegularExpression regularExpressionWithPattern:regex options:NSRegularExpressionCaseInsensitive error:&error];
    
    if (error) {
        NSLog(@"invalid regex: \(error.localizedDescription)");
        return @[];
    } else {
        return [regularExpression matchesInString:text options:NSMatchingReportCompletion range:NSMakeRange(0, text.length)];
    }
}

@end

@implementation NSObject (Archiver)

- (id)copyWithArchiver {
    return [NSKeyedUnarchiver unarchiveObjectWithData:[NSKeyedArchiver archivedDataWithRootObject:self]];
}

@end


struct PreviousDelegates {
    __unsafe_unretained NSString *navigationDelegate;
    __unsafe_unretained NSString *tabBarDelegate;
};

static struct PreviousDelegates prevDelegates = {@"heroPreviousNavigationDelegate", @"heroPreviousTabBarDelegate"};

@implementation UIViewController (Delegate)

- (id<UINavigationControllerDelegate>)previousNavigationDelegate {
    return objc_getAssociatedObject(self, &prevDelegates.navigationDelegate);
}

- (void)setPreviousNavigationDelegate:(id<UINavigationControllerDelegate>)previousNavigationDelegate {
    objc_setAssociatedObject(self,
                             &prevDelegates.navigationDelegate,
                             previousNavigationDelegate,
                             OBJC_ASSOCIATION_RETAIN_NONATOMIC
                             );
}

- (id<UITabBarControllerDelegate>)previousTabBarDelegate {
    return objc_getAssociatedObject(self, &prevDelegates.tabBarDelegate);
}

- (void)setPreviousTabBarDelegate:(id<UITabBarControllerDelegate>)previousTabBarDelegate {
    objc_setAssociatedObject(self,
                             &prevDelegates.tabBarDelegate,
                             previousTabBarDelegate,
                             OBJC_ASSOCIATION_RETAIN_NONATOMIC
                             );
}

- (BOOL)isHeroEnabled {
    return [self.transitioningDelegate isKindOfClass:[Hero class]];
}

- (void)setIsHeroEnabled:(BOOL)isHeroEnabled {
    if (isHeroEnabled) {
        self.transitioningDelegate = [Hero shared];
        UINavigationController *navi = (UINavigationController *)self;
        if (navi && [navi isKindOfClass:[UINavigationController class]]) {
            self.previousNavigationDelegate = navi.delegate;
            navi.delegate = [Hero shared];
        }
        UITabBarController *tab = (UITabBarController *)self;
        if (tab && [tab isKindOfClass:[UITabBarController class]]) {
            self.previousTabBarDelegate = tab.delegate;
            tab.delegate = [Hero shared];
        }
    } else {
        self.transitioningDelegate = nil;
        UINavigationController *navi = (UINavigationController *)self;
        if (navi && [navi.delegate isKindOfClass:[Hero class]]) {
            navi.delegate = self.previousNavigationDelegate;
        }
        UITabBarController *tab = (UITabBarController *)self;
        if (tab && [tab.delegate isKindOfClass:[Hero class]]) {
            tab.delegate = self.previousTabBarDelegate;
        }
    }
}

- (IBAction)ht_dismiss:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)heroReplaceViewControllerWithNext:(UIViewController *)next {
    UINavigationController *navigationController = self.navigationController;
    if (navigationController) {
        NSMutableArray *vcs = [NSMutableArray array];
        vcs = [navigationController.childViewControllers mutableCopy];
        if ([vcs count] > 0) {
            [vcs removeLastObject];
            [vcs addObject:next];
        }
        
        if (navigationController.isHeroEnabled) {
            [Hero shared].forceNotInteractive = @(YES);
        }
        [navigationController setViewControllers:vcs animated:YES];
    } else if (self.view.superview) {
        UIViewController *parentVC = [self presentingViewController];
        UIView *container = self.view.superview;
        id <UIViewControllerTransitioningDelegate> oldTransitionDelegate = [next transitioningDelegate];
        next.isHeroEnabled = YES;
        [[Hero shared] transitionFrom:self to:next inView:container completion:^(BOOL finished){
            if (![oldTransitionDelegate isKindOfClass:[Hero class]]) {
                next.isHeroEnabled = NO;
                next.transitioningDelegate = oldTransitionDelegate;
            }
            
            if (finished) {
                [[UIApplication sharedApplication].keyWindow addSubview:[next view]];
                if (parentVC) {
                    [self dismissViewControllerAnimated:NO completion:^{
                        [parentVC presentViewController:next animated:NO completion:nil];
                    }];
                } else {
                    [[UIApplication sharedApplication].keyWindow setRootViewController:next];
                }
            }
        }];
    }
}
@end

@implementation UIImage (ScreenShot)

- (UIImage *)imageWithView:(UIView *)view {
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, NO, 0.0);
    [view drawViewHierarchyInRect:view.bounds afterScreenUpdates:YES];
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}

@end
