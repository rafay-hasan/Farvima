//
//  PharmaciaMapInfoPopOverViewController.h
//  Farvima
//
//  Created by Rafay Hasan on 2/24/18.
//  Copyright © 2018 Rafay Hasan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PharmacyObject.h"
@protocol InfoPopOverDelegate <NSObject>
@required
-(void)valueSelectedFromOver:(NSUInteger )value;
@end


@interface PharmaciaMapInfoPopOverViewController : UIViewController
@property (strong,nonatomic) PharmacyObject *object;
@property (nonatomic, weak) id<InfoPopOverDelegate> delegate;
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *webAddressLabel;
@property (weak, nonatomic) IBOutlet UILabel *emailAddressLabel;
- (IBAction)menuButtonAction:(UIButton *)sender;


@end
