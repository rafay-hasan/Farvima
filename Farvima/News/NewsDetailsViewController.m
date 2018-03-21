//
//  NewsDetailsViewController.m
//  Farvima
//
//  Created by Rafay Hasan on 10/28/17.
//  Copyright © 2017 Rafay Hasan. All rights reserved.
//

#import "NewsDetailsViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "UIViewController+LGSideMenuController.h"
#import "User Details.h"

@interface NewsDetailsViewController ()<LGSideMenuControllerDelegate>

- (IBAction)newsDetailsBottomTabButtonAction:(UIButton *)sender;
- (IBAction)newsDetailsLeftSlideButtonAction:(id)sender;

- (IBAction)backButtonAction:(id)sender;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *newsDetailsTextviewHeight;
@property (weak, nonatomic) IBOutlet UITextView *newsDetailsTextview;
@property (weak, nonatomic) IBOutlet UIImageView *newsImageView;
@property (weak, nonatomic) IBOutlet UILabel *newsHeaderLabel;
@property (weak, nonatomic) IBOutlet UILabel *newsPublisDateLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *ScrollContainerViewHeight;


@end

@implementation NewsDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self loadNewsDetailsView];
}

-(void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.sideMenuController.delegate = self;
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
    UIColor *color = [UIColor colorWithRed:145.0/255.0 green:146.0/255.0 blue:147.0/255.0 alpha:1];
    [self.newsImageView.layer setBorderColor: color.CGColor];
    [self.newsImageView.layer setBorderWidth: 2.0];
    
    if (self.object.imageUel.length > 0) {
        [self.newsImageView sd_setImageWithURL:[NSURL URLWithString:self.object.imageUel]
                               placeholderImage:[UIImage imageNamed:@"placeholder"]];
    }
    else {
        self.newsImageView.image = nil;
    }
    
    if (self.object.name.length > 0) {
        self.newsHeaderLabel.text = self.object.name;
    }
    else {
        self.newsHeaderLabel.text = nil;
    }
    
    if (self.object.creationDate.length > 0) {
        self.newsPublisDateLabel.text = self.object.creationDate;
    }
    else {
        self.newsPublisDateLabel.text = nil;
    }
    
    if (self.object.details.length > 0) {
        self.newsDetailsTextview.text = self.object.details;
    }
    else {
        self.newsDetailsTextview.text = nil;
    }
    
   [self adjustLayoutForViewController];
}

-(void) adjustLayoutForViewController {
    self.newsDetailsTextview.scrollEnabled = NO;
    CGSize sizeThatFitsTextView = [self.newsDetailsTextview sizeThatFits:CGSizeMake(self.newsDetailsTextview.frame.size.width, MAXFLOAT)];
    self.newsDetailsTextviewHeight.constant = sizeThatFitsTextView.height;
    self.ScrollContainerViewHeight.constant = self.newsDetailsTextview.frame.origin.y + self.newsDetailsTextviewHeight.constant;
    [self.view layoutIfNeeded];
}

- (IBAction)newsDetailsBottomTabButtonAction:(UIButton *)sender {
    [[User_Details sharedInstance]makePushOrPopForBottomTabMenuToNavigationStack:self.navigationController forTag:sender.tag];
}

- (IBAction)newsDetailsLeftSlideButtonAction:(id)sender {
    [[self sideMenuController] showLeftViewAnimated:sender];
}

- (IBAction)backButtonAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}


-(BOOL)isControllerAlreadyOnNavigationControllerStack:(UIViewController *)targetViewController{
    for (UIViewController *vc in self.navigationController.viewControllers) {
        if ([vc isKindOfClass:targetViewController.class]) {
            [self.navigationController popToViewController:vc animated:NO];
            return YES;
        }
    }
    return NO;
}

- (void)willShowLeftView:(nonnull UIView *)leftView sideMenuController:(nonnull LGSideMenuController *)sideMenuController {
    [User_Details sharedInstance].appUserId = @"";
}

- (void)didHideLeftView:(nonnull UIView *)leftView sideMenuController:(nonnull LGSideMenuController *)sideMenuController {
    [[User_Details sharedInstance] makePushOrPopViewControllertoNavigationStack:self.navigationController];
}

@end
