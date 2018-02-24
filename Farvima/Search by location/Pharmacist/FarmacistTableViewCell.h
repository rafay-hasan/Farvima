//
//  FarmacistTableViewCell.h
//  Farvima
//
//  Created by Rafay Hasan on 2/24/18.
//  Copyright © 2018 Rafay Hasan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FarmacistTableViewCell : UITableViewCell


@property (weak, nonatomic) IBOutlet UIImageView *farmacistImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *jobtiTitleLabel;

@end
