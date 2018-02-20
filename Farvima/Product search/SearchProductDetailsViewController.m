//
//  SearchProductDetailsViewController.m
//  Farvima
//
//  Created by Rafay Hasan on 10/29/17.
//  Copyright © 2017 Rafay Hasan. All rights reserved.
//

#import "SearchProductDetailsViewController.h"
#import "UIViewController+LGSideMenuController.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface SearchProductDetailsViewController ()

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *scrollviewContainerHeight;
- (IBAction)backButtonAction:(id)sender;
- (IBAction)leftSliderButtonAction:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *purchaseButton;


@property (weak, nonatomic) IBOutlet UIImageView *productImageView;
@property (weak, nonatomic) IBOutlet UILabel *productNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *productDetailsTaxtView;
@property (weak, nonatomic) IBOutlet UILabel *productPriceLabel;


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
    if (self.productObject.imageUel.length > 0) {
        [self.productImageView sd_setImageWithURL:[NSURL URLWithString:self.productObject.imageUel]
                                 placeholderImage:[UIImage imageNamed:@"placeholder"]];
    }
    else {
        self.productImageView.image = [UIImage imageNamed:@"placeholder"];
    }
    
    if (self.productObject.name.length > 0) {
        self.productNameLabel.text = self.productObject.name;
    }
    else {
        self.productNameLabel.text = nil;
    }
    
    if (self.productObject.details.length > 0) {
        self.productDetailsTaxtView.text = self.productObject.details;
    }
    else {
        self.productDetailsTaxtView.text = nil;
    }
    
    if (self.productObject.price.length > 0) {
        self.productPriceLabel.text = self.productObject.price;
    }
    else {
        self.productPriceLabel.text = nil;
    }
    self.scrollviewContainerHeight.constant = self.purchaseButton.frame.origin.y + self.purchaseButton.frame.size.height + 52;
}

- (IBAction)backButtonAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)leftSliderButtonAction:(id)sender {
     [[self sideMenuController] showLeftViewAnimated:sender];
}
@end
