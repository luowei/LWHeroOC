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

@property (nonatomic, assign, readonly) CGPoint center;
@property (nonatomic, assign, readonly) CascadeDirection direction;

// When using CascadeDirectionRadial/CascadeDirectionInverseRadial Direction, center value must be set
// Else, set center as nil
- (instancetype)initWithDirectionType:(CascadeDirection)type center:(NSValue *)center;

// When using CascadeDirectionRadial/CascadeDirectionInverseRadial Direction, center value must be set
// Else, set center as nil
// string: bottomToTop, leftToRight, rightToLeft, topToBottom, radial or inverseRadial
- (instancetype)initWithDirectionString:(NSString *)string center:(NSValue *)center;


- (void)processFromViews:(NSArray *)fromviews toViews:(NSArray *)toviews;

@end
