//
//  UIKit+HeroExamples.m
//  Hero-ObjectiveC
//
//  Created by luca.li on 2017/1/22.
//  Copyright © 2017年 luca. All rights reserved.
//

#import "UIKit+HeroExamples.h"

@implementation UIView (HeroExamples)

- (CGFloat)cornerRadius {
    return self.layer.cornerRadius;
}

- (void)setCornerRadius:(CGFloat)cornerRadius {
    self.layer.cornerRadius = cornerRadius;
}

- (CGFloat)shadowRadius {
    return self.layer.shadowRadius;
}

- (void)setShadowRadius:(CGFloat)shadowRadius {
    self.layer.shadowRadius =  shadowRadius;
}

- (CGFloat)shadowOpacity {
    return self.layer.shadowOpacity;
}

- (void)setShadowOpacity:(CGFloat)shadowOpacity {
    self.layer.shadowOpacity = shadowOpacity;
}

- (UIColor *)shadowColor {
    return self.layer.shadowColor != nil ? [UIColor colorWithCGColor:self.layer.shadowColor] : nil;
}

- (void)setShadowColor:(UIColor *)shadowColor {
    self.layer.shadowColor = shadowColor.CGColor;
}

- (CGSize)shadowOffset {
    return self.layer.shadowOffset;
}

- (void)setShadowOffset:(CGSize)shadowOffset {
    self.layer.shadowOffset = shadowOffset;
}

- (CGFloat)zPosition {
    return self.layer.shadowRadius;
}

- (void)setZPosition:(CGFloat)zPosition {
    self.layer.zPosition = zPosition;
}

- (UIViewController *)viewControllerForStoryboardName:(NSString *)storyboardName {
    UIViewController *vc = [UIStoryboard storyboardWithName:storyboardName bundle:nil].instantiateInitialViewController;
    NSAssert(vc, @"This storyboard is NOT AVAILABLE on this moment, please wait for further translation work.");
    return vc;
}
@end
