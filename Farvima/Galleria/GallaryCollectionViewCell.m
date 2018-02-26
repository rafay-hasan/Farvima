//
//  GallaryCollectionViewCell.m
//  Farvima
//
//  Created by Rafay Hasan on 10/23/17.
//  Copyright © 2017 Rafay Hasan. All rights reserved.
//

#import "GallaryCollectionViewCell.h"

@implementation GallaryCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    UIColor *color = [UIColor colorWithRed:11.0/255.0 green:72.0/255.0 blue:155.0/255.0 alpha:1];
    [self.galleryImageView.layer setBorderColor: color.CGColor];
    [self.galleryImageView.layer setBorderWidth: 2.0];
}

@end
