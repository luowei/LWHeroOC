//
//  CityCell.m
//  Hero-ObjectiveC
//
//  Created by luca.li on 2017/1/22.
//  Copyright © 2017年 luca. All rights reserved.
//

#import "CityCell.h"
#import "City.h"
#import "UIKit+Hero.h"

@interface CityCell ()

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;

@end

@implementation CityCell

- (void)prepareForReuse {
    self.useShortDescription = YES; //Default Value
}

- (void)setCity:(City *)city {
    
    _city = city;
    
    if (!city) {
        return;
    }
    
    NSString *name = city.name;
    
    self.heroID = name;
    self.heroModifiers = @[[HeroModifier modifierFromName:@"zPositionIfMatched" parameters:@[@(3)]]];
    
    self.nameLabel.text = name;
    self.imageView.image = city.image;
    self.descriptionLabel.text = self.useShortDescription ? city.shortDescription : city.description;
}

@end
