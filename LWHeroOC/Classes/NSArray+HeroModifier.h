//
//  NSArray+HeroModifier.h
//  Hero-ObjectiveC
//
//  Created by luca.li on 2017/1/23.
//  Copyright © 2017年 luca. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSArray (HeroModifier)

- (id)getObjectAtIndex:(NSInteger)index;

- (CGFloat)getCGFloatAtIndex:(NSInteger)index;

- (double)getDoubleAtIndex:(NSInteger)index;

- (float)getFloatAtIndex:(NSInteger)index;

- (BOOL)getBoolAtIndex:(NSInteger)index;
@end
