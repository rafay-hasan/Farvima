//
//  FarmaciaHomeViewController.m
//  Farvima
//
//  Created by Rafay Hasan on 11/25/17.
//  Copyright © 2017 Rafay Hasan. All rights reserved.
//

#import "FarmaciaHomeViewController.h"
#import "UIViewController+LGSideMenuController.h"
#import "User Details.h"

@interface FarmaciaHomeViewController ()

- (IBAction)FarmaciaHomeBottomTabMenuAction:(UIButton *)sender;


@end

@implementation FarmaciaHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.sideMenuController.leftViewSwipeGestureEnabled = NO;
    self.sideMenuController.rightViewSwipeGestureEnabled = NO;
}

-(void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.sideMenuController.leftViewSwipeGestureEnabled = NO;
    self.sideMenuController.rightViewSwipeGestureEnabled = NO;
}

- (void) viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:YES];
    self.sideMenuController.leftViewSwipeGestureEnabled = YES;
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

- (IBAction)FarmaciaHomeBottomTabMenuAction:(UIButton *)sender {
    [[User_Details sharedInstance] makePushOrPopForBottomTabMenuToNavigationStack:self.navigationController forTag:sender.tag];
}
@end
