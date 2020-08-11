//
//  UIKit+HeroExamples.h
//  Hero-ObjectiveC
//
//  Created by luca.li on 2017/1/22.
//  Copyright © 2017年 luca. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (HeroExamples)

@property (nonatomic, assign) IBInspectable CGFloat cornerRadius;
@property (nonatomic, assign) IBInspectable CGFloat shadowRadius;
@property (nonatomic, assign) IBInspectable CGFloat shadowOpacity;
@property (nonatomic, strong) IBInspectable UIColor *shadowColor;
@property (nonatomic, assign) IBInspectable CGSize shadowOffset;
@property (nonatomic, assign) IBInspectable CGFloat zPosition;

- (UIViewController *)viewControllerForStoryboardName:(NSString *)storyboardName;

@end
