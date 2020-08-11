//
//  City.h
//  Hero-ObjectiveC
//
//  Created by luca.li on 2017/1/22.
//  Copyright © 2017年 luca. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface City : NSObject

@property (copy, nonatomic) NSString *name;
@property (strong, nonatomic) UIImage *image;
@property (copy, nonatomic) NSString *shortDescription;
@property (copy, nonatomic) NSString *description;

@property (strong, nonatomic, readonly) NSArray *cities;

@end
