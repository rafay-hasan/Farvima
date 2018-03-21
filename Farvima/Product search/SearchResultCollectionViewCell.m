//
//  SearchResultCollectionViewCell.m
//  Farvima
//
//  Created by Rafay Hasan on 10/29/17.
//  Copyright © 2017 Rafay Hasan. All rights reserved.
//

#import "SearchResultCollectionViewCell.h"

@implementation SearchResultCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    UIColor *color = [UIColor colorWithRed:145.0/255.0 green:146.0/255.0 blue:147.0/255.0 alpha:1];
    [self.productImageView.layer setBorderColor: color.CGColor];
    [self.productImageView.layer setBorderWidth: 2.0];
}

@end
