//
//  ListTableViewCell.m
//  Hero-ObjectiveC
//
//  Created by luca.li on 2017/2/9.
//  Copyright © 2017年 luca. All rights reserved.
//

#import "ListTableViewCell.h"

@implementation ListTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGRect imageFrame = self.imageView.frame;
    CGRect textLabelFrame = self.textLabel.frame;
    CGRect detailTextLabelFrame = self.detailTextLabel.frame;
    
    imageFrame.origin.x = 0;
    imageFrame.size = CGSizeMake(self.bounds.size.height, self.bounds.size.height);
    textLabelFrame.origin.x = self.bounds.size.height + 10;
    detailTextLabelFrame.origin.x = self.bounds.size.height + 10;
    
    self.imageView.frame = imageFrame;
    self.textLabel.frame = textLabelFrame;
    self.detailTextLabel.frame = detailTextLabelFrame;
}

@end
