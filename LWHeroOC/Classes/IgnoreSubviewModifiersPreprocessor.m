//
//  IgnoreSubviewModifiersPreprocessor.m
//  Hero-ObjectiveC
//
//  Created by luca.li on 2017/1/24.
//  Copyright © 2017年 luca. All rights reserved.
//

#import "IgnoreSubviewModifiersPreprocessor.h"

@implementation IgnoreSubviewModifiersPreprocessor

- (void)processFromViews:(NSArray *)fromviews toViews:(NSArray *)toviews {
    [self processViews:fromviews];
    [self processViews:toviews];
}

- (void)processViews:(NSArray <UIView *> *)views {
    [views enumerateObjectsUsingBlock:^(UIView * _Nonnull view, NSUInteger viewIndex, BOOL * _Nonnull stop) {
        NSNumber *recursive = [self.context stateOfView:view].ignoreSubviewModifiers;
        if (recursive) {
            UIView *parentView = view;
            if ([view isKindOfClass:[UITableView class]]) {
                UIView *wrapperView = [view.subviews firstObject];
                if (wrapperView) {
                    parentView = wrapperView;
                }
            }
            
            if ([recursive boolValue]) {
                for (NSInteger i = viewIndex + 1; i < views.count; i ++) {
                    UIView *childView = views[i];
                    if (childView.superview == view.superview) {
                        break;
                    }
                    [self.context setState:nil toView:childView];
                }
            } else {
                for (UIView *subview in parentView.subviews) {
                    [self.context setState:nil toView:subview];
                }
            }
        }
    }];
}

@end
