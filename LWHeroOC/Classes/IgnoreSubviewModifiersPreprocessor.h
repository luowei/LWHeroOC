//
//  IgnoreSubviewModifiersPreprocessor.h
//  Hero-ObjectiveC
//
//  Created by luca.li on 2017/1/24.
//  Copyright © 2017年 luca. All rights reserved.
//

#import "BasePreprocessor.h"

@interface IgnoreSubviewModifiersPreprocessor : BasePreprocessor

- (void)processFromViews:(NSArray *)fromviews toViews:(NSArray *)toviews;

@end
