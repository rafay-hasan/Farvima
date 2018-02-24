//
//  FarmacistTableViewCell.m
//  Farvima
//
//  Created by Rafay Hasan on 2/24/18.
//  Copyright © 2018 Rafay Hasan. All rights reserved.
//

#import "FarmacistTableViewCell.h"
#import <QuartzCore/QuartzCore.h>

@implementation FarmacistTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    UIColor *color = [UIColor colorWithRed:11.0/255.0 green:72.0/255.0 blue:155.0/255.0 alpha:1];
    [self.farmacistImageView.layer setBorderColor: color.CGColor];
    [self.farmacistImageView.layer setBorderWidth: 2.0];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
