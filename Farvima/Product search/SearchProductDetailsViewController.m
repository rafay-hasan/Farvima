//
//  SearchProductDetailsViewController.m
//  Farvima
//
//  Created by Rafay Hasan on 10/29/17.
//  Copyright © 2017 Rafay Hasan. All rights reserved.
//

#import "SearchProductDetailsViewController.h"

@interface SearchProductDetailsViewController ()

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *scrollviewContainerHeight;
- (IBAction)backButtonAction:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *purchaseButton;

@end

@implementation SearchProductDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self loadNewsDetailsView];
    
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

- (void) loadNewsDetailsView
{
    self.scrollviewContainerHeight.constant = self.purchaseButton.frame.origin.y + self.purchaseButton.frame.size.height + 52;
}

- (IBAction)backButtonAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
@end
