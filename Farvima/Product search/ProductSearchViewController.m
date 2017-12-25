//
//  ProductSearchViewController.m
//  Farvima
//
//  Created by Rafay Hasan on 10/29/17.
//  Copyright © 2017 Rafay Hasan. All rights reserved.
//

#import "ProductSearchViewController.h"
#import "UIViewController+LGSideMenuController.h"

@interface ProductSearchViewController ()

- (IBAction)backButtonAction:(id)sender;
- (IBAction)searchButtonAction:(id)sender;
- (IBAction)leftSliderButtonAction:(id)sender;


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *scrollContainerViewHeight;
@property (weak, nonatomic) IBOutlet UIButton *searchButton;

@end

@implementation ProductSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

-(void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:YES];
    self.scrollContainerViewHeight.constant = self.searchButton.frame.origin.y + self.searchButton.frame.size.height + 20;
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
    [self performSegueWithIdentifier:@"searchResult" sender:self];
}

- (IBAction)leftSliderButtonAction:(id)sender {
     [[self sideMenuController] showLeftViewAnimated:sender];
}
@end
