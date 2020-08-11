//
//  CityViewController.m
//  Hero-ObjectiveC
//
//  Created by luca.li on 2017/1/25.
//  Copyright © 2017年 luca. All rights reserved.
//

#import "CityViewController.h"
#import "City.h"
#import "CityCell.h"

@interface CityViewController () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic, copy) NSArray *cities;

@end

@implementation CityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view layoutIfNeeded];
    self.cities = [[City alloc] init].cities;
    [self.collectionView reloadData];
    [self.collectionView scrollToItemAtIndexPath:self.selectedIndex atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:NO];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.cities count];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return self.view.frame.size;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CityCell *cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:@"item" forIndexPath:indexPath];
    cell.useShortDescription = NO;
    cell.city = self.cities[indexPath.item];
    return cell;
}
@end
