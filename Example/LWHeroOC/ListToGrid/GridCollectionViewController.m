//
//  GridCollectionViewController.m
//  Hero-ObjectiveC
//
//  Created by luca.li on 2017/2/9.
//  Copyright © 2017年 luca. All rights reserved.
//

#import "GridCollectionViewController.h"
#import "ImageLibrary.h"
#import "ListTableViewController.h"
#import "ImageViewController.h"
#import "GridImageCell.h"

#import "UIKit+Hero.h"
#import "UIKit+HeroExamples.h"
#import "UIImage+AverageColor.h"

@interface GridCollectionViewController () <UICollectionViewDelegateFlowLayout>

@end

@implementation GridCollectionViewController

static NSString * const reuseIdentifier = @"item";

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (IBAction)toList:(id)sender {
    ListTableViewController *next = [[UIStoryboard storyboardWithName:@"ListToGrid" bundle:nil] instantiateViewControllerWithIdentifier:@"list"];
    [next.tableView setContentOffset:CGPointMake(next.tableView.contentOffset.x,
                                                      self.collectionView.contentOffset.y + self.collectionView.contentInset.top)];
    [self heroReplaceViewControllerWithNext:next];
}

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [ImageLibrary count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    GridImageCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    cell.heroModifiers = @[[HeroModifier fade],
                           [HeroModifier translateX:0 Y:20 Z:0]];
    cell.imageView.heroID = [NSString stringWithFormat:@"image_%zi", indexPath.item];
    cell.imageView.heroModifiers = @[[HeroModifier arc:@(1)],
                                     [HeroModifier zPosition:@(10)]];
    UIImage *image = [ImageLibrary thumbnailAtIndex:indexPath.item];
    cell.imageView.image = image;
    cell.textLabel.text = [NSString stringWithFormat:@"Item %zi", indexPath.item];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"Description %zi", indexPath.item];
    cell.backgroundColor = [image averageColor];
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(CGRectGetWidth(self.view.frame) / 3, 52 * 3);
}

#pragma mark <UICollectionViewDelegate>

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    ImageViewController *vc = (ImageViewController *)[self.view viewControllerForStoryboardName:@"ImageViewer"];
    vc.selectedIndex = indexPath;
    vc.view.backgroundColor = [UIColor whiteColor];
    vc.collectionView.backgroundColor = [UIColor whiteColor];
    [self.navigationController pushViewController:vc animated:YES];
}

@end

@interface GridCollectionViewController (HeroViewControllerDelegate) <HeroViewControllerDelegate>

@end

@implementation GridCollectionViewController (HeroViewControllerDelegate)

- (void)heroWillStartAnimatingFrom:(UIViewController *)viewController {
    
    ImageViewController *vc = (ImageViewController *)viewController;
    if ([vc isKindOfClass:[ImageViewController class]]) {
        NSIndexPath *originalCellIndex = vc.selectedIndex;
        NSIndexPath *currentCellIndex = vc.collectionView.indexPathsForVisibleItems[0];
        self.collectionView.heroModifiers = @[[HeroModifier cascade]];
        if (![self.collectionView.indexPathsForVisibleItems containsObject:currentCellIndex]) {
            // make the cell visible
            [self.collectionView scrollToItemAtIndexPath:currentCellIndex atScrollPosition:originalCellIndex.item < currentCellIndex.item ? UICollectionViewScrollPositionBottom : UICollectionViewScrollPositionTop animated:NO];
        }
    } else {
        self.collectionView.heroModifiers = @[[HeroModifier cascade],
                                              [HeroModifier delay:@(0.2)]];
    }
}

- (void)heroWillStartAnimatingTo:(UIViewController *)viewController {
    
    if ([viewController isKindOfClass:[ImageViewController class]]) {
        NSIndexPath *index = self.collectionView.indexPathsForSelectedItems[0];
        GridImageCell *cell = (GridImageCell *)[self.collectionView cellForItemAtIndexPath:index];
        CGPoint cellPos = [self.view convertPoint:cell.imageView.center fromView:cell];
        self.collectionView.heroModifiers = @[[HeroModifier scaleXY:3],
                                              [HeroModifier translateX:self.view.center.x - cellPos.x Y:self.view.center.y + self.collectionView.contentInset.top/2/3 - cellPos.y Z:0],
                                              [HeroModifier ignoreSubviewModifiersWithRecursive:@(NO)],
                                              [HeroModifier fade]];
    } else {
        self.collectionView.heroModifiers = @[[HeroModifier cascade]];
    }
}

@end
