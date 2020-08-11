//
//  CityCell.h
//  Hero-ObjectiveC
//
//  Created by luca.li on 2017/1/22.
//  Copyright © 2017年 luca. All rights reserved.
//

#import <UIKit/UIKit.h>

@class City;

@interface CityCell : UICollectionViewCell

@property (nonatomic, strong) City *city;
@property (nonatomic, assign) BOOL useShortDescription;

@end
