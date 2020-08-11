//
//  CAMediaTimingFunction+Hero.h
//  Hero-ObjectiveC
//
//  Created by luca.li on 2017/1/23.
//  Copyright © 2017年 luca. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import <UIKit/UIKit.h>

@interface CAMediaTimingFunction (Hero)

// Default
@property (nonatomic, strong, readonly) CAMediaTimingFunction *linear;
@property (nonatomic, strong, readonly) CAMediaTimingFunction *easeIn;
@property (nonatomic, strong, readonly) CAMediaTimingFunction *easeOut;
@property (nonatomic, strong, readonly) CAMediaTimingFunction *easeInOut;

// Material
@property (nonatomic, strong, readonly) CAMediaTimingFunction *standard;
@property (nonatomic, strong, readonly) CAMediaTimingFunction *deceleration;
@property (nonatomic, strong, readonly) CAMediaTimingFunction *acceleration;
@property (nonatomic, strong, readonly) CAMediaTimingFunction *sharp;

// Easing.net
@property (nonatomic, strong, readonly) CAMediaTimingFunction *easeOutBack;

+ (instancetype)functionFromName:(NSString *)name;

@end
