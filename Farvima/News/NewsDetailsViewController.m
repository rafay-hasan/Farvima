//
//  NewsDetailsViewController.m
//  Farvima
//
//  Created by Rafay Hasan on 10/28/17.
//  Copyright © 2017 Rafay Hasan. All rights reserved.
//

#import "NewsDetailsViewController.h"
#import "MessageViewController.h"
#import "NotificationViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "UIViewController+LGSideMenuController.h"
#import "EventViewController.h"
#import "GallaryViewController.h"
#import "NewsViewController.h"
#import "SearchResultViewController.h"
#import "OfferViewController.h"
#import "ChiSiamoViewController.h"
#import "User Details.h"

@interface NewsDetailsViewController ()<LGSideMenuControllerDelegate>

- (IBAction)backButtonAction:(id)sender;
- (IBAction)messageButtonAction:(id)sender;
- (IBAction)notificationButtonAction:(id)sender;
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

- (IBAction)backButtonAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)messageButtonAction:(id)sender {
    MessageViewController *messageVc = [MessageViewController new];
    if (![self isControllerAlreadyOnNavigationControllerStack:messageVc]) {
        //push controller
        MessageViewController *newView = [self.storyboard instantiateViewControllerWithIdentifier:@"messaggi"];
        [self.navigationController pushViewController:newView animated:YES];
        
    }
}

- (IBAction)notificationButtonAction:(id)sender {
    NotificationViewController *notificationVc = [NotificationViewController new];
    if (![self isControllerAlreadyOnNavigationControllerStack:notificationVc]) {
        //push controller
        NotificationViewController *newView = [self.storyboard instantiateViewControllerWithIdentifier:@"notification"];
        [self.navigationController pushViewController:newView animated:YES];
        
    }
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

- (void)didHideLeftView:(nonnull UIView *)leftView sideMenuController:(nonnull LGSideMenuController *)sideMenuController {
    NSString *menuname = [User_Details sharedInstance].currentlySelectedLeftSlideMenu;
    if ([menuname isEqualToString:@"GALERIA"]) {
        GallaryViewController *vc = [GallaryViewController new];
        if (![self isControllerAlreadyOnNavigationControllerStack:vc]) {
            GallaryViewController *newView = [self.storyboard instantiateViewControllerWithIdentifier:@"galleria"];
            [self.navigationController pushViewController:newView animated:YES];
            
        }
    }
    else if ([menuname isEqualToString:@"OFFERTE"]) {
        OfferViewController *vc = [OfferViewController new];
        if (![self isControllerAlreadyOnNavigationControllerStack:vc]) {
            OfferViewController *newView = [self.storyboard instantiateViewControllerWithIdentifier:@"offerte"];
            [self.navigationController pushViewController:newView animated:YES];
            
        }
    }
    else if ([menuname isEqualToString:@"EVENTI"]) {
        EventViewController *vc = [EventViewController new];
        if (![self isControllerAlreadyOnNavigationControllerStack:vc]) {
            EventViewController *newView = [self.storyboard instantiateViewControllerWithIdentifier:@"event"];
            [self.navigationController pushViewController:newView animated:YES];
            
        }
    }
    else if ([menuname isEqualToString:@"NEWS"]) {
        NewsViewController *vc = [NewsViewController new];
        if (![self isControllerAlreadyOnNavigationControllerStack:vc]) {
            NewsViewController *newView = [self.storyboard instantiateViewControllerWithIdentifier:@"news"];
            [self.navigationController pushViewController:newView animated:YES];
            
        }
    }
    else if ([menuname isEqualToString:@"CHI SIAMO"]) {
        ChiSiamoViewController *vc = [ChiSiamoViewController new];
        if (![self isControllerAlreadyOnNavigationControllerStack:vc]) {
            ChiSiamoViewController *newView = [self.storyboard instantiateViewControllerWithIdentifier:@"chi Siamo"];
            [self.navigationController pushViewController:newView animated:YES];
            
        }
    }
    else if ([menuname isEqualToString:@"PRENOTA E RITIRA"]) {
        SearchResultViewController *vc = [SearchResultViewController new];
        if (![self isControllerAlreadyOnNavigationControllerStack:vc]) {
            SearchResultViewController *newView = [self.storyboard instantiateViewControllerWithIdentifier:@"AllProducts"];
            [self.navigationController pushViewController:newView animated:YES];
            
        }
    }
}

@end
