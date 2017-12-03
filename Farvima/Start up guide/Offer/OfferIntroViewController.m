//
//  OfferIntroViewController.m
//  Farvima
//
//  Created by Rafay Hasan on 10/15/17.
//  Copyright © 2017 Rafay Hasan. All rights reserved.
//

#import "OfferIntroViewController.h"
#import "User Details.h"

@interface OfferIntroViewController ()

@property (strong,nonatomic) User_Details *userManager;
- (IBAction)saltaButtonAction:(id)sender;

@end

@implementation OfferIntroViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.userManager = [User_Details sharedInstance];
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

- (IBAction)saltaButtonAction:(id)sender {
    [self.userManager makeSaltaButtonAction];
}
@end
