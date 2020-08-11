//
//  ImageViewController.m
//  Hero-ObjectiveC
//
//  Created by luca.li on 2017/2/9.
//  Copyright © 2017年 luca. All rights reserved.
//

#import "ImageViewController.h"
#import "ScrollingImageCell.h"
#import "ImageLibrary.h"

#import "HeroModifier.h"
#import "Hero.h"
#import "UIKit+Hero.h"

@interface ImageViewController () <UIGestureRecognizerDelegate, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UIPanGestureRecognizer *panGR;

@end

@implementation ImageViewController

static NSString * const reuseIdentifier = @"item";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.preferredContentSize = CGSizeMake(CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds));
    
    [self.view layoutIfNeeded];
    [self.collectionView reloadData];
    if (self.selectedIndex) {
        [self.collectionView scrollToItemAtIndexPath:self.selectedIndex atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:NO];
    }
    
    self.panGR = [[UIPanGestureRecognizer alloc] init];
    [self.panGR addTarget:self action:@selector(pan)];
    [self.panGR setDelegate:self];
    [self.collectionView addGestureRecognizer:self.panGR];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
    for (ScrollingImageCell *cell in [self.collectionView visibleCells]) {
        cell.topInset = [self.topLayoutGuide length];
    }
}

- (void)pan {
    CGPoint translation = [self.panGR translationInView:nil];
    CGFloat progress = translation.y / 2 / CGRectGetHeight(self.collectionView.bounds);
    switch (self.panGR.state) {
        case UIGestureRecognizerStateBegan: {
            UINavigationController *nav = self.navigationController;
            if (nav && [nav.viewControllers firstObject] != self) {
                [nav popViewControllerAnimated:YES];
            } else {
                [self dismissViewControllerAnimated:YES completion:nil];
            }
        }
            break;
        case UIGestureRecognizerStateChanged: {
            [[Hero shared] updateProgress:progress];
            ScrollingImageCell *cell = [self.collectionView.visibleCells firstObject];
            CGPoint currentPos = CGPointMake(translation.x + self.view.center.x, translation.y + self.view.center.y);
            [[Hero shared] applyModifiers:@[[HeroModifier position:[NSValue valueWithCGPoint:currentPos]]] toView:cell.imageView];
        }
            break;
        default: {
            if (progress + [self.panGR velocityInView:nil].y / CGRectGetHeight(self.collectionView.bounds) > 0.15) {
                [[Hero shared] endAnimated:YES];
            } else {
                [[Hero shared] cancelAnimated:YES];
            }
        }
            break;
    }
}

#pragma mark - ColectionView Datasource & Delegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [ImageLibrary count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ScrollingImageCell *imageCell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    imageCell.image = [ImageLibrary imageAtIndex:indexPath.item];
    imageCell.imageView.heroID = [NSString stringWithFormat:@"image_%zi", indexPath.item];
    imageCell.imageView.heroModifiers = @[[HeroModifier position:[NSValue valueWithCGPoint:CGPointMake(CGRectGetWidth(self.view.bounds)/2, CGRectGetHeight(self.view.bounds) + CGRectGetWidth(self.view.bounds)/2)]],
                                     [HeroModifier scaleX:0.6 Y:0.6 Z:1],
                                     [HeroModifier fade],
                                     [HeroModifier zPositionIfMatched:@(100)]];
    imageCell.topInset = [self.topLayoutGuide length];
    return imageCell;
}

#pragma mark - CollectionView Flow Layout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return self.view.bounds.size;
}

#pragma mark - Gesture Delegate

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    ScrollingImageCell *cell = [self.collectionView.visibleCells firstObject];
    if (cell && cell.scrollView.zoomScale == 1) {
        CGPoint v = [self.panGR velocityInView:nil];
        return (v.y > fabs(v.x));
    }
    return NO;
}
@end
