//
//  ListTableViewController.m
//  Hero-ObjectiveC
//
//  Created by luca.li on 2017/2/9.
//  Copyright © 2017年 luca. All rights reserved.
//

#import "ListTableViewController.h"
#import "ImageViewController.h"
#import "GridCollectionViewController.h"

#import "ListTableViewCell.h"
#import "ImageLibrary.h"
#import "HeroModifier.h"

#import "UIKit+HeroExamples.h"
#import "UIKit+Hero.h"

@interface ListTableViewController ()

@end

@implementation ListTableViewController

static NSString * const reuseIdentifier = @"item";

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [ImageLibrary count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    
    
    cell.heroModifiers = @[[HeroModifier fade],
                           [HeroModifier translateX:-100 Y:0 Z:0]];
    cell.imageView.heroID = [NSString stringWithFormat:@"image_%zi", indexPath.item];
    cell.imageView.heroModifiers = @[[HeroModifier arc:@(1)],
                                     [HeroModifier zPosition:@(10)]];
    cell.imageView.image = [ImageLibrary thumbnailAtIndex:indexPath.row];
    cell.textLabel.text = [NSString stringWithFormat:@"Item %zi", indexPath.row];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"Description %zi", indexPath.row];
    
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 52;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    ImageViewController *vc = (ImageViewController *)[self.view viewControllerForStoryboardName:@"ImageViewer"];
    vc.selectedIndex = indexPath;
    vc.view.backgroundColor = [UIColor whiteColor];
    vc.collectionView.backgroundColor = [UIColor whiteColor];
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)toGrid:(id)sender {
    GridCollectionViewController *next = [[UIStoryboard storyboardWithName:@"ListToGrid" bundle:nil] instantiateViewControllerWithIdentifier:@"grid"];
    [next.collectionView setContentOffset:CGPointMake(next.collectionView.contentOffset.x,
                                                      self.tableView.contentOffset.y + self.tableView.contentInset.top)];
    [self heroReplaceViewControllerWithNext:next];
}

@end

@interface ListTableViewController (HeroViewControllerDelegate) <HeroViewControllerDelegate>

@end

@implementation ListTableViewController (HeroViewControllerDelegate)

- (void)heroWillStartAnimatingTo:(UIViewController *)viewController {
    if ([viewController isKindOfClass:[GridCollectionViewController class]]) {
        self.tableView.heroModifiers = @[[HeroModifier ignoreSubviewModifiersWithRecursive:@(NO)]];
    } else {
        self.tableView.heroModifiers = @[[HeroModifier cascade]];
    }
}

- (void)heroWillStartAnimatingFrom:(UIViewController *)viewController {
    if ([viewController isKindOfClass:[GridCollectionViewController class]]) {
        self.tableView.heroModifiers = @[[HeroModifier ignoreSubviewModifiersWithRecursive:@(NO)]];
    } else {
        self.tableView.heroModifiers = @[[HeroModifier cascade]];
    }
    
    ImageViewController *vc = (ImageViewController *)viewController;
    if ([vc isKindOfClass:[ImageViewController class]]) {
        NSIndexPath *originalCellIndex = vc.selectedIndex;
        NSIndexPath *currentCellIndex = vc.collectionView.indexPathsForVisibleItems[0];
        if (currentCellIndex) {
            [self.tableView scrollToRowAtIndexPath:currentCellIndex atScrollPosition:originalCellIndex.row < currentCellIndex.row ? UITableViewScrollPositionBottom : UITableViewScrollPositionTop animated:NO];
        }
    }
}

@end
