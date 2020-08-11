//
//  LWViewController.m
//  LWHeroOC
//
//  Created by luowei on 08/11/2020.
//  Copyright (c) 2020 luowei. All rights reserved.
//

#import "LWViewController.h"
#import "UIKit+HeroExamples.h"

@interface LWViewController ()

@property (strong, nonatomic) NSArray *storyboards;

@end

@implementation LWViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _storyboards = @[
                     @[],
                     @[@"Basic", @"MusicPlayer", @"Menu"],
                     @[@"CityGuide", @"ImageViewer", @"ListToGrid", @"ImageGallery"],
                     @[@"LiveInjection", @"Debug", @"LabelMorph"]
                     ];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.item < [_storyboards[indexPath.section] count]) {
        NSString *storyboardName = _storyboards[indexPath.section][indexPath.row];
        UIViewController *viewController = [self.view viewControllerForStoryboardName:storyboardName];
        [self presentViewController:viewController animated:YES completion:nil];
    }
}

@end
