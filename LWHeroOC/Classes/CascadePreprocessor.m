//
//  CascadePreprocessor.m
//  Hero-ObjectiveC
//
//  Created by luca.li on 2017/1/24.
//  Copyright © 2017年 luca. All rights reserved.
//

#import "CascadePreprocessor.h"

@interface CascadePreprocessor ()

@property (nonatomic, assign) CGPoint center;
@property (nonatomic, assign) CascadeDirection direction;
@property (nonatomic, assign) NSComparator comparator;

@end

@implementation CascadePreprocessor

- (instancetype)initWithDirectionString:(NSString *)string center:(NSValue *)center {
    
    if (self = [super init]) {
        
        if ([string isEqualToString:@"bottomToTop"]) {
            self.direction = CascadeDirectionBottomToTop;
            return self;
        }
        if ([string isEqualToString:@"leftToRight"]) {
            self.direction = CascadeDirectionLeftToRight;
            return self;
        }
        if ([string isEqualToString:@"rightToLeft"]) {
            self.direction = CascadeDirectionRightToLeft;
            return self;
        }
        if ([string isEqualToString:@"topToBottom"]) {
            self.direction = CascadeDirectionTopToBottom;
            return self;
        }
        if ([string isEqualToString:@"radial"]) {
            self.direction = CascadeDirectionRadial;
            self.center = [center CGPointValue];
            return self;
        }
        if ([string isEqualToString:@"inverseRadial"]) {
            self.direction = CascadeDirectionInverseRadial;
            self.center = [center CGPointValue];
            return self;
        }
        return nil;
    }
    
    return self;
}

- (instancetype)initWithDirectionType:(CascadeDirection)type center:(NSValue *)center {
    
    if (self = [super init]) {
        
        switch (type) {
            case CascadeDirectionBottomToTop: {
                self.direction = CascadeDirectionBottomToTop;
                return self;
            }
                break;
            case CascadeDirectionLeftToRight: {
                self.direction = CascadeDirectionLeftToRight;
                return self;
            }
                break;
            case CascadeDirectionRightToLeft: {
                self.direction = CascadeDirectionRightToLeft;
                return self;
            }
                break;
            case CascadeDirectionTopToBottom: {
                self.direction = CascadeDirectionTopToBottom;
                return self;
            }
                break;
            case CascadeDirectionRadial: {
                self.direction = CascadeDirectionRadial;
                self.center = [center CGPointValue];
                return self;
            }
                break;
            case CascadeDirectionInverseRadial: {
                self.direction = CascadeDirectionInverseRadial;
                self.center = [center CGPointValue];
                return self;
            }
                break;
                
            default:
                break;
        }
    }
    
    return self;
}

- (void)processFromViews:(NSArray *)fromviews toViews:(NSArray *)toviews {
    [self processViews:fromviews];
    [self processViews:toviews];
}

- (void)processViews:(NSArray <UIView *> *)views {
    [views enumerateObjectsUsingBlock:^(UIView * _Nonnull fv, NSUInteger viewIndex, BOOL * _Nonnull stop) {
        if ([self.context stateOfView:fv].cascade) {
            
            NSArray *cascadeParam = [self.context stateOfView:fv].cascade;
            NSTimeInterval deltaTime = [cascadeParam[0] doubleValue];
            BOOL delayMatchedViews = [cascadeParam[2] boolValue];
            
            UIView *parentView = fv;
            if ([fv isKindOfClass:[UITableView class]]) {
                UIView *wrapperView = [fv.subviews firstObject];
                if (wrapperView) {
                    parentView = wrapperView;
                }
            }
            
            NSArray *sortedSubviews = parentView.subviews;
            NSMutableArray *unpairedViews = [NSMutableArray array];
            [sortedSubviews enumerateObjectsUsingBlock:^(UIView * _Nonnull view, NSUInteger idx, BOOL * _Nonnull stop) {
                if (![self.context pairedViewForView:view]) {
                    [unpairedViews addObject:view];
                }
            }];
            [sortedSubviews sortedArrayUsingComparator:self.comparator];
            
            NSTimeInterval initialDelay = [[self.context stateOfView:fv].delay doubleValue];
            [sortedSubviews enumerateObjectsUsingBlock:^(UIView * _Nonnull v, NSUInteger i, BOOL * _Nonnull stop) {
                NSTimeInterval delay = (NSTimeInterval)i * deltaTime + initialDelay;
                [self.context stateOfView:v].delay = @(delay);
            }];
            
            if (delayMatchedViews) {
                for (NSInteger i = viewIndex + 1; i < views.count; i ++) {
                    UIView *otherView = views[i];
                    if (otherView.superview == fv.superview) {
                        break;
                    }
                    UIView *pairedView = [self.context pairedViewForView:otherView];
                    if (parentView) {
                        NSTimeInterval delay = (NSTimeInterval)sortedSubviews.count * deltaTime + initialDelay;
                        [self.context stateOfView:otherView].delay = @(delay);
                        [self.context stateOfView:pairedView].delay = @(delay);
                    }
                }
            }
        }
    }];
}

#pragma mark - Getter
- (NSComparator)comparator {
    
    if (!_comparator) {
        __weak typeof(self) weakSelf = self;
        _comparator = ^NSComparisonResult(UIView *view1, UIView *view2) {
            switch (weakSelf.direction) {
                case CascadeDirectionTopToBottom:
                    return CGRectGetMinY(view1.frame) < CGRectGetMinY(view2.frame);
                    break;
                case CascadeDirectionBottomToTop:
                    return (CGRectGetMaxY(view1.frame) == CGRectGetMaxY(view2.frame) ?
                            CGRectGetMaxX(view1.frame) > CGRectGetMaxX(view2.frame) :
                            CGRectGetMaxY(view1.frame) > CGRectGetMaxY(view2.frame));
                    break;
                case CascadeDirectionLeftToRight:
                    return CGRectGetMinX(view1.frame) < CGRectGetMinX(view2.frame);
                    break;
                case CascadeDirectionRightToLeft:
                    return CGRectGetMaxX(view1.frame) < CGRectGetMaxX(view2.frame);
                    break;
                case CascadeDirectionRadial:
                    return ([weakSelf distanceFrom:view1.center to:weakSelf.center] <
                            [weakSelf distanceFrom:view2.center to:weakSelf.center]);
                    break;
                case CascadeDirectionInverseRadial:
                    return ([weakSelf distanceFrom:view2.center to:weakSelf.center] <
                            [weakSelf distanceFrom:view1.center to:weakSelf.center]);
                    break;
                default:
                    break;
            }
        };
    }
    return _comparator;
}

#pragma mark - Private
- (CGFloat)distanceFrom:(CGPoint)a to:(CGPoint)b {
    return sqrt(pow(a.x - b.x, 2) + pow(a.y - b.y, 2));
}
@end
