//
//  CityGuideViewController.m
//  Hero-ObjectiveC
//
//  Created by luca.li on 2017/1/25.
//  Copyright © 2017年 luca. All rights reserved.
//

#import "CityGuideViewController.h"
#import "CityViewController.h"

#import "City.h"
#import "CityCell.h"

@interface CityGuideViewController () <UICollectionViewDataSource, UICollectionViewDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic, copy) NSArray *cities;

@end

@implementation CityGuideViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.cities = [[City alloc] init].cities;
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([sender isKindOfClass:[CityCell class]]) {
        CityCell *currentCell = sender;
        CityViewController *vc = segue.destinationViewController;
        NSIndexPath *currentCellIndex = [self.collectionView indexPathForCell:currentCell];
        vc.selectedIndex = currentCellIndex;
    }
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.cities count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CityCell *cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:@"item" forIndexPath:indexPath];
    cell.city = self.cities[indexPath.item];
    return cell;
}

@end
