//
//  PharmaciaMapInfoPopOverViewController.m
//  Farvima
//
//  Created by Rafay Hasan on 2/24/18.
//  Copyright © 2018 Rafay Hasan. All rights reserved.
//

#import "PharmaciaMapInfoPopOverViewController.h"

@interface PharmaciaMapInfoPopOverViewController ()

@end

@implementation PharmaciaMapInfoPopOverViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.phoneNumberLabel.text = self.object.phone;
    self.webAddressLabel.text = self.object.webAddress;
    self.emailAddressLabel.text = self.object.emailAddress;
    self.locationLabel.text = self.object.location;
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)menuButtonAction:(UIButton *)sender {
    [self.delegate valueSelectedFromOver:sender.tag];
}
@end
