//
//  CascadePreprocessor.h
//  Hero-ObjectiveC
//
//  Created by luca.li on 2017/1/24.
//  Copyright © 2017年 luca. All rights reserved.
//

#import "BasePreprocessor.h"

typedef NS_ENUM(NSUInteger, CascadeDirection) {
    CascadeDirectionTopToBottom,
    CascadeDirectionBottomToTop,
    CascadeDirectionLeftToRight,
    CascadeDirectionRightToLeft,
    CascadeDirectionRadial,         //Should set center value as CGPoint
    CascadeDirectionInverseRadial   //Should set center value as CGPoint
};

@interface CascadePreprocessor : BasePreprocessor

@property (nonatomic, assign) CGPoint center;   //When using CascadeDirectionRadial/CascadeDirectionInverseRadial Direction, center value must be set
@property (nonatomic, assign, readonly) CascadeDirection direction;


- (instancetype)initWithDirectionString:(NSString *)string;

- (void)processFromViews:(NSArray *)fromviews toViews:(NSArray *)toviews;

@end
