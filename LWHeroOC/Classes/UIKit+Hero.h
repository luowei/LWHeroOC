//
//  UIKit+Hero.h
//  Hero-ObjectiveC
//
//  Created by luca.li on 2017/1/22.
//  Copyright © 2017年 luca. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "HeroModifier.h"

@interface UIView (Hero)

@property (nonatomic, copy) IBInspectable NSString *heroID;
@property (nonatomic, strong) IBInspectable NSArray <HeroModifier *>*heroModifiers;
@property (nonatomic, copy) IBInspectable NSString *heroModifierString;

- (UIView *)slowSnapshotView;

@end

@interface UIViewController (Delegate)

@property (nonatomic, weak) id <UINavigationControllerDelegate> previousNavigationDelegate;
@property (nonatomic, weak) id <UITabBarControllerDelegate> previousTabBarDelegate;
@property (nonatomic, assign) IBInspectable BOOL isHeroEnabled;

- (IBAction)ht_dismiss:(id)sender;
- (void)heroReplaceViewControllerWithNext:(UIViewController *)next;

@end
