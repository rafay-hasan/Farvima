//
//  SearchByAddressViewController.m
//  Farvima
//
//  Created by Rafay Hasan on 11/25/17.
//  Copyright © 2017 Rafay Hasan. All rights reserved.
//

#import "SearchByAddressViewController.h"

@interface SearchByAddressViewController ()

- (IBAction)backButtonAction:(id)sender;
- (IBAction)searchButtonAction:(id)sender;


@end

@implementation SearchByAddressViewController

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

- (IBAction)searchButtonAction:(id)sender {
    [self.navigationController pushViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"pharmacyListPage"] animated:YES];
}
@end
