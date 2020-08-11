//
//  MatchPreprocessor.m
//  Hero-ObjectiveC
//
//  Created by luca.li on 2017/1/24.
//  Copyright © 2017年 luca. All rights reserved.
//

#import "MatchPreprocessor.h"
#import "UIKit+Hero.h"

@implementation MatchPreprocessor

- (void)processFromViews:(NSArray *)fromviews toViews:(NSArray *)toviews {
    for (UIView *tv in toviews) {
        NSString *heroID = tv.heroID;
        UIView *fv = [self.context sourceViewForHeroID:heroID];
        if (tv.heroID && fv) {
            HeroTargetState *tvState = [self.context stateOfView:tv] ? [self.context stateOfView:tv] : [[HeroTargetState alloc] init];
            NSNumber *zPosition = tvState.zPositionIfMatched;
            if (zPosition) {
                [tvState appendContentsOfModifiers:@[[HeroModifier zPosition:zPosition]]];
            }
            tvState.source = heroID;
            
            HeroTargetState *fvState = tvState;
            
            tvState.opacity = @(0);
            if (([fv isKindOfClass:[UILabel class]] && !fv.isOpaque) || tv.alpha < 1) {
                // cross fade if fromView is a label or if toView is transparent
                fvState.opacity = @(0);
            } else {
                fvState.opacity = nil;
            }
      
            [self.context setState:tvState toView:tv];
            [self.context setState:fvState toView:fv];
        }
    }
}

@end
