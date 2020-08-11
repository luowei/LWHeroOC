//
//  ImageLibrary.h
//  Hero-ObjectiveC
//
//  Created by luca.li on 2017/2/9.
//  Copyright © 2017年 luca. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ImageLibrary : NSObject

+ (NSInteger)count;

+ (UIImage *)thumbnailAtIndex:(NSInteger)index;

+ (UIImage *)imageAtIndex:(NSInteger)index;

@end
