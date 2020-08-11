//
//  ImageGalleryViewController.m
//  Hero-ObjectiveC
//
//  Created by luca.li on 2017/2/10.
//  Copyright © 2017年 luca. All rights reserved.
//

#import "ImageGalleryViewController.h"
#import "ImageViewController.h"
#import "ImageLibrary.h"
#import "ImageCell.h"

#import "UIKit+Hero.h"
#import "UIKit+HeroExamples.h"

@interface ImageGalleryViewController () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, HeroViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (assign, nonatomic) NSInteger columns;
@property (assign, nonatomic) CGSize cellSize;

@end

@implementation ImageGalleryViewController

static NSString * const reuseIdentifier = @"item";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.collectionView reloadData];
    [self.collectionView setIndicatorStyle:UIScrollViewIndicatorStyleWhite];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}

- (IBAction)switchLayout:(id)sender {
    
    ImageGalleryViewController *next = (ImageGalleryViewController *)[[UIStoryboard storyboardWithName:@"ImageGallery" bundle:nil] instantiateViewControllerWithIdentifier:@"imageGallery"];
    next.columns = self.columns == 3 ? 5 : 3;
    [self heroReplaceViewControllerWithNext:next];
}

- (NSInteger)columns {
    return 3;
}

- (CGSize)cellSize {
    return CGSizeMake(CGRectGetWidth(self.view.bounds)/[[NSString stringWithFormat:@"%zi.0",self.columns] doubleValue],
                      CGRectGetWidth(self.view.bounds)/[[NSString stringWithFormat:@"%zi.0",self.columns] doubleValue]);
}

#pragma mark - ColectionView Datasource & Delegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [ImageLibrary count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ImageCell *imageCell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    imageCell.imageView.image = [ImageLibrary thumbnailAtIndex:indexPath.item];
    imageCell.imageView.heroID = [NSString stringWithFormat:@"image_%zi", indexPath.item];
    imageCell.imageView.heroModifiers = @[[HeroModifier zPosition:@(100)]];
    imageCell.heroModifiers = @[[HeroModifier fade],
                                [HeroModifier scaleXY:0.8],
                                [HeroModifier zPosition:@(50)]];;
    return imageCell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    ImageViewController *vc = (ImageViewController *)[self.view viewControllerForStoryboardName:@"ImageViewer"];
    vc.selectedIndex = indexPath;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - CollectionView Flow Layout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return self.cellSize;
}

@end


@implementation ImageGalleryViewController (HeroViewControllerDelegate)

- (void)heroWillStartAnimatingTo:(UIViewController *)viewController {
    if ([viewController isKindOfClass:[ImageGalleryViewController class]]) {
        self.collectionView.heroModifiers = @[[HeroModifier cascadeWithDelta:0.015 direction:CascadeDirectionBottomToTop delayMatchedViews:YES]];
    } else if ([viewController isKindOfClass:[ImageViewController class]]) {
        // TODO: Something wrong here
        ImageCell *cell = (ImageCell *)[self.collectionView cellForItemAtIndexPath:[self.collectionView.indexPathsForSelectedItems firstObject]];
        CascadePreprocessor *preprocessor = [[CascadePreprocessor alloc] initWithDirectionType:CascadeDirectionRadial center:[NSValue valueWithCGPoint:cell.center]];
        self.collectionView.heroModifiers = @[[HeroModifier cascadeWithDelta:0.015 direction:preprocessor.direction delayMatchedViews:NO]];
    } else {
        self.collectionView.heroModifiers = @[[HeroModifier cascadeWithDelta:0.015 direction:CascadeDirectionTopToBottom delayMatchedViews:NO]];
    }
}

- (void)heroWillStartAnimatingFrom:(UIViewController *)viewController {
    
    if ([viewController isKindOfClass:[ImageGalleryViewController class]]) {
        self.collectionView.heroModifiers = @[[HeroModifier cascadeWithDelta:0.015 direction:CascadeDirectionTopToBottom delayMatchedViews:@(NO)], [HeroModifier delay:@(0.25)]];
    } else {
        self.collectionView.heroModifiers = @[[HeroModifier cascadeWithDelta:0.015 direction:CascadeDirectionTopToBottom delayMatchedViews:@(NO)]];
    }
    
    ImageViewController *vc = (ImageViewController *)viewController;
    if ([vc isKindOfClass:[ImageViewController class]]) {
        NSIndexPath *originalCellIndex = vc.selectedIndex;
        NSIndexPath *currentCellIndex = vc.collectionView.indexPathsForVisibleItems[0];
        UICollectionViewLayoutAttributes *targetAttribute = [self.collectionView layoutAttributesForItemAtIndexPath:currentCellIndex];
        CascadePreprocessor *preprocessor = [[CascadePreprocessor alloc] initWithDirectionType:CascadeDirectionInverseRadial center:[NSValue valueWithCGPoint:targetAttribute.center]];
        self.collectionView.heroModifiers = @[[HeroModifier cascadeWithDelta:0.015 direction:preprocessor.direction delayMatchedViews:NO]];
        if (![self.collectionView.indexPathsForVisibleItems containsObject:currentCellIndex]) {
            // make the cell visible
            [self.collectionView scrollToItemAtIndexPath:currentCellIndex atScrollPosition:originalCellIndex.row < currentCellIndex.row ? UICollectionViewScrollPositionBottom : UICollectionViewScrollPositionTop animated:NO];
        }
    }
}

@end
