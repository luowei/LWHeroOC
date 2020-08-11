//
//  HeroTargetState.h
//  Hero-ObjectiveC
//
//  Created by luca.li on 2017/1/22.
//  Copyright © 2017年 luca. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class HeroModifier;

@interface HeroTargetState : NSObject <NSCopying>

@property (nonatomic, strong) NSNumber *opacity;      //@(CGFloat)
@property (nonatomic, strong) NSNumber *cornerRadius;       //@(CGFloat)
@property (nonatomic, strong) NSValue *position;         //@(CGPoint)
@property (nonatomic, strong) NSValue *size;             //@(CGSize)
@property (nonatomic, strong) NSValue *transform;       //@(CATransform3D)
@property (nonatomic, copy) NSArray <NSNumber *> *spring;    //[@(CGFloat), @(CGFloat)], represents stiffness and damping
@property (nonatomic, strong) NSNumber *delay;     //@(Double)
@property (nonatomic, strong) NSNumber *duration;      //@(Double)
@property (nonatomic, strong) CAMediaTimingFunction *timingFunction;
@property (nonatomic, strong) NSNumber *arc;        //@(CGFloat)
@property (nonatomic, strong) NSNumber *zPosition;      //@(CGFloat)
@property (nonatomic, strong) NSNumber *zPositionIfMatched;     //@(CGFloat)
@property (nonatomic, copy) NSString *source;
@property (nonatomic, copy) NSArray *cascade;       //[@(NSTimeInterval), @(CascadeDirection), @(BOOL)], represents cascade timeinterval, direction and delayMatchedViews
@property (nonatomic, strong) NSNumber *useGlobalCoordinateSpace;   //Default

@property (nonatomic, strong) NSNumber *ignoreSubviewModifiers;  //@(BOOL)

@property (nonatomic, copy, readonly) NSMutableArray <NSMutableDictionary*> *custom;

- (instancetype)initWithModifiers:(NSArray *)modifiers;

- (void)appendContentsOfModifiers:(NSArray <HeroModifier *> *)modifiers;

- (id)customItemOfKey:(NSString *)key;

- (void)setCustomItemOfKey:(NSString *)key value:(id)value;

@end

@interface HeroTargetState (ExpressibleByArrayLiteral)

- (instancetype)initWithArrayLiteralElements:(NSArray <HeroModifier *> *)elements;

@end
