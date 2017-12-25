//
//  ChooseYourPharmacyViewController.m
//  Farvima
//
//  Created by Rafay Hasan on 11/25/17.
//  Copyright © 2017 Rafay Hasan. All rights reserved.
//

#import "ChooseYourPharmacyViewController.h"
#import "UIViewController+LGSideMenuController.h"

@interface ChooseYourPharmacyViewController ()

- (IBAction)backButtonAction:(id)sender;
- (IBAction)leftSlideButtonAction:(id)sender;


@end

@implementation ChooseYourPharmacyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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

- (IBAction)backButtonAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)leftSlideButtonAction:(id)sender {
     [[self sideMenuController] showLeftViewAnimated:sender];
}
@end
