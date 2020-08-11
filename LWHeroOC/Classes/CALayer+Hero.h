//
//  CALayer+Hero.h
//  Hero-ObjectiveC
//
//  Created by luca.li on 2017/1/23.
//  Copyright © 2017年 luca. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

@interface CALayer (Hero)

// @[@{Key : CAAnimation}, ...]
@property (nonatomic, copy, readonly) NSArray <NSDictionary *> *animations;

@end
