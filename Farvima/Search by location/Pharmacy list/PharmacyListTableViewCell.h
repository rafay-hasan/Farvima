//
//  PharmacyListTableViewCell.h
//  Farvima
//
//  Created by Rafay Hasan on 11/25/17.
//  Copyright © 2017 Rafay Hasan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PharmacyListTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *pharmacyNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *pharmacyAddressLabel;
@property (weak, nonatomic) IBOutlet UILabel *pharmacyVarNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *pharmacyPhoneLabel;
@property (weak, nonatomic) IBOutlet UILabel *openingHourTimeFrameLabel;
@property (weak, nonatomic) IBOutlet UIButton *associateButton;

@end
