//
//  ScrollingImageCell.m
//  Hero-ObjectiveC
//
//  Created by luca.li on 2017/2/9.
//  Copyright © 2017年 luca. All rights reserved.
//

#import "ScrollingImageCell.h"

@interface ScrollingImageCell () <UIScrollViewDelegate>

@end

@implementation ScrollingImageCell

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        self.scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
        self.imageView = [[UIImageView alloc] initWithFrame:self.bounds];
        self.imageView.contentMode = UIViewContentModeScaleAspectFill;
        [self.scrollView addSubview:self.imageView];
        [self.scrollView setMaximumZoomScale:3.0];
        [self.scrollView setDelegate:self];
        [self.scrollView setContentMode:UIViewContentModeCenter];
        [self.scrollView setShowsVerticalScrollIndicator:NO];
        [self.scrollView setShowsHorizontalScrollIndicator:NO];
        [self addSubview:self.scrollView];
        
        self.dTapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTap:)];
        self.dTapGR.numberOfTapsRequired = 2;
        [self addGestureRecognizer:self.dTapGR];
    };
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.scrollView.frame = self.bounds;
    CGSize size;
    UIImage *image = self.imageView.image;
    if (image) {
        size = CGSizeMake(CGRectGetWidth(self.bounds), CGRectGetWidth(self.bounds) * image.size.height / image.size.width);
    } else {
        size = self.bounds.size;
    }
    
    self.imageView.frame = CGRectMake(0, 0, size.width, size.height);
    self.scrollView.contentSize = size;
    [self centerIfNeeded];
}

- (void)prepareForReuse {
    [super prepareForReuse];
    [self.scrollView setZoomScale:1 animated:NO];
}

- (UIImage *)image {
    return _imageView.image;
}

- (void)setImage:(UIImage *)image {
    _imageView.image = image;
    [self setNeedsLayout];
}

- (void)setTopInset:(CGFloat)topInset {
    _topInset = topInset;
    [self centerIfNeeded];
}

- (CGRect)zoomRectForScale:(CGFloat)scale center:(CGPoint)center {
    
    CGRect zoomRect = CGRectZero;
    zoomRect.size.height = CGRectGetHeight(self.imageView.frame) / scale;
    zoomRect.size.width = CGRectGetWidth(self.imageView.frame) / scale;
    CGPoint newCenter = [self.imageView convertPoint:center fromView:self.scrollView];
    zoomRect.origin.x = newCenter.x - (CGRectGetWidth(zoomRect) / 2.0);
    zoomRect.origin.y = newCenter.y - (CGRectGetHeight(zoomRect) / 2.0);
    return zoomRect;
}

- (void)doubleTap:(UIGestureRecognizer *)gr {
    if (self.scrollView.zoomScale == 1) {
        [self.scrollView zoomToRect:[self zoomRectForScale:self.scrollView.maximumZoomScale center:[gr locationInView:gr.view]] animated:YES];
    } else {
        [self.scrollView setZoomScale:1 animated:YES];
    }
}

- (void)centerIfNeeded {
    UIEdgeInsets inset = UIEdgeInsetsMake(self.topInset, 0, 0, 0);
    if (self.scrollView.contentSize.height < self.scrollView.bounds.size.height - self.topInset) {
        CGFloat insetV = self.scrollView.bounds.size.height - self.topInset - self.scrollView.contentSize.height;
        inset.top += insetV;
        inset.bottom = insetV;
    }
    if (self.scrollView.contentSize.width < self.scrollView.bounds.size.width) {
        CGFloat insetV = (self.scrollView.bounds.size.width - self.scrollView.contentSize.width)/2;
        inset.left = insetV;
        inset.right = insetV;
    }
    self.scrollView.contentInset = inset;
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return self.imageView;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    [self centerIfNeeded];
}
@end
