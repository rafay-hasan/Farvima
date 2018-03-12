//
//  MarkerView.h
//  Farvima
//
//  Created by Rafay Hasan on 3/12/18.
//  Copyright © 2018 Rafay Hasan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MarkerView : UIView

@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *webAddressLabel;
@property (weak, nonatomic) IBOutlet UILabel *emailAddressLabel;
@property (weak, nonatomic) IBOutlet UIButton *associateButton;


@end
