//
//  ProfileEditViewController.m
//  Farvima
//
//  Created by Rafay Hasan on 12/3/18.
//  Copyright © 2018 Rafay Hasan. All rights reserved.
//

#import "ProfileEditViewController.h"
#import "User Details.h"

@interface ProfileEditViewController ()
- (IBAction)backButtonAction:(id)sender;
- (IBAction)profileEditBottomTabMenuButtonAction:(UIButton *)sender;

@end

@implementation ProfileEditViewController

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

- (IBAction)profileEditBottomTabMenuButtonAction:(UIButton *)sender {
    [[User_Details sharedInstance]makePushOrPopForBottomTabMenuToNavigationStack:self.navigationController forTag:sender.tag];
}
@end
