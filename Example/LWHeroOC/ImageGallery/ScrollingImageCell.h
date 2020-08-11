//
//  ScrollingImageCell.h
//  Hero-ObjectiveC
//
//  Created by luca.li on 2017/2/9.
//  Copyright © 2017年 luca. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ScrollingImageCell : UICollectionViewCell

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UITapGestureRecognizer *dTapGR;
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, assign) CGFloat topInset;

@end
