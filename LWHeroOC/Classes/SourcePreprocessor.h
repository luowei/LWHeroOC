//
//  SourcePreprocessor.h
//  Hero-ObjectiveC
//
//  Created by luca.li on 2017/1/24.
//  Copyright © 2017年 luca. All rights reserved.
//

#import "BasePreprocessor.h"

@interface SourcePreprocessor : BasePreprocessor

- (void)processFromViews:(NSArray *)fromviews toViews:(NSArray *)toviews;

@end

@interface SourcePreprocessor (Prepare)

- (void)prepareForView:(UIView *)view targetView:(UIView *)targetView;

@end
