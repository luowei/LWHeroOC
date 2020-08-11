//
//  ImageLibrary.m
//  Hero-ObjectiveC
//
//  Created by luca.li on 2017/2/9.
//  Copyright © 2017年 luca. All rights reserved.
//

#import "ImageLibrary.h"

@interface ImageLibrary ()

@property (nonatomic, assign) NSInteger count;

@end

@implementation ImageLibrary

+ (NSInteger)count {
    return 100;
}

+ (UIImage *)thumbnailAtIndex:(NSInteger)index {
    return [UIImage imageNamed:[NSString stringWithFormat:@"Unsplash%zi_thumb", index % 11]];
}

+ (UIImage *)imageAtIndex:(NSInteger)index {
    return [UIImage imageNamed:[NSString stringWithFormat:@"Unsplash%zi", index % 11]];
}

@end
