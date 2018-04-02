//
//  EventDetailsViewController.m
//  Farvima
//
//  Created by Rafay Hasan on 11/7/17.
//  Copyright © 2017 Rafay Hasan. All rights reserved.
//

#import "EventDetailsViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "UILabel+FormattedText.h"
#import "UIViewController+LGSideMenuController.h"
#import "User Details.h"

@interface EventDetailsViewController ()<LGSideMenuControllerDelegate>
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *containerViewHeightConstraint;
@property (weak, nonatomic) IBOutlet UITextView *eventDetailsTextView;
@property (weak, nonatomic) IBOutlet UIImageView *eventImageView;
@property (weak, nonatomic) IBOutlet UILabel *eventNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *eventdateLabel;
@property (weak, nonatomic) IBOutlet UILabel *eventTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *eventLocationLabel;


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *textViewHeight;

- (IBAction)backButtonAction:(id)sender;
- (IBAction)eventDetailsPageBottomTabButtonAction:(UIButton *)sender;

@end

@implementation EventDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self loadEventDetailsdata];
}

-(void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.sideMenuController.delegate = self;
    self.sideMenuController.rightViewSwipeGestureEnabled = NO;
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

- (void) loadEventDetailsdata {
    UIColor *color = [UIColor colorWithRed:145.0/255.0 green:146.0/255.0 blue:147.0/255.0 alpha:1];
    [self.eventImageView.layer setBorderColor: color.CGColor];
    [self.eventImageView.layer setBorderWidth: 2.0];
    if (self.object.imageUel.length > 0) {
        [self.eventImageView sd_setImageWithURL:[NSURL URLWithString:self.object.imageUel]
                               placeholderImage:[UIImage imageNamed:@"placeholder"]];
    }
    else {
        self.eventImageView.image = nil;
    }
    
    if (self.object.name.length > 0) {
        self.eventNameLabel.text = self.object.name;
    }
    else {
        self.eventNameLabel.text = nil;
    }
    
    if (self.object.locationDate.length > 0) {
        self.eventdateLabel.text = [NSString stringWithFormat:@"data %@",self.object.locationDate];
        [self.eventdateLabel setTextColor:[UIColor colorWithRed:83.0/255.0 green:83.0/255.0 blue:83.0/255.0 alpha:1] String:@"data "];
        [self.eventdateLabel setFont:[UIFont systemFontOfSize:13 weight:UIFontWeightSemibold] afterOccurenceOfString:@"data "];
        [self.eventdateLabel setTextColor:[UIColor colorWithRed:56.0/255.0 green:56.0/255.0 blue:56.0/255.0 alpha:1] String:self.object.locationDate];
        [self.eventdateLabel setFont:[UIFont preferredFontForTextStyle:UIFontTextStyleCaption1] beforeOccurenceOfString:self.object.locationDate];
        
    }
    else {
        self.eventdateLabel.text = @"data ";
    }
    
    NSString *startEndTime =  [NSString stringWithFormat:@"Dalle %@ Alle %@",self.object.startTime,self.object.endTime];
    self.eventTimeLabel.text = [NSString stringWithFormat:@"ore %@",startEndTime];
    [self.eventTimeLabel setTextColor:[UIColor colorWithRed:83.0/255.0 green:83.0/255.0 blue:83.0/255.0 alpha:1] String:@"ore "];
    [self.eventTimeLabel setFont:[UIFont systemFontOfSize:13 weight:UIFontWeightSemibold] afterOccurenceOfString:@"ore "];
    [self.eventTimeLabel setTextColor:[UIColor colorWithRed:56.0/255.0 green:56.0/255.0 blue:56.0/255.0 alpha:1] String:startEndTime];
    [self.eventTimeLabel setFont:[UIFont preferredFontForTextStyle:UIFontTextStyleCaption1] beforeOccurenceOfString:startEndTime];
    
    
    if (self.object.location.length > 0) {
        self.eventLocationLabel.text = [NSString stringWithFormat:@"presso %@",self.object.location];
        [self.eventLocationLabel setTextColor:[UIColor colorWithRed:83.0/255.0 green:83.0/255.0 blue:83.0/255.0 alpha:1] String:@"presso "];
        [self.eventLocationLabel setFont:[UIFont systemFontOfSize:13 weight:UIFontWeightSemibold] afterOccurenceOfString:@"presso "];
        [self.eventLocationLabel setTextColor:[UIColor colorWithRed:56.0/255.0 green:56.0/255.0 blue:56.0/255.0 alpha:1] String:self.object.location];
        [self.eventLocationLabel setFont:[UIFont preferredFontForTextStyle:UIFontTextStyleCaption1] beforeOccurenceOfString:self.object.location];
        
    }
    else {
        self.eventLocationLabel.text = @"presso ";
    }
    
    self.eventDetailsTextView.text = self.object.details;
    [self adjustLayoutForViewController];
}

-(void) adjustLayoutForViewController {
    [self.view layoutIfNeeded];
    self.eventDetailsTextView.scrollEnabled = NO;
    CGSize sizeThatFitsTextView = [self.eventDetailsTextView sizeThatFits:CGSizeMake(self.eventDetailsTextView.frame.size.width, MAXFLOAT)];
    self.textViewHeight.constant = sizeThatFitsTextView.height;
    self.containerViewHeightConstraint.constant = self.eventDetailsTextView.frame.origin.y + self.textViewHeight.constant + 16;
    [self.view layoutIfNeeded];
}

- (IBAction)backButtonAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)eventDetailsPageBottomTabButtonAction:(UIButton *)sender {
    [[User_Details sharedInstance]makePushOrPopForBottomTabMenuToNavigationStack:self.navigationController forTag:sender.tag];
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
- (IBAction)leftMenuButtonAction:(id)sender {
     [[self sideMenuController] showLeftViewAnimated:sender];
}

- (void)willShowLeftView:(nonnull UIView *)leftView sideMenuController:(nonnull LGSideMenuController *)sideMenuController {
    [User_Details sharedInstance].currentlySelectedLeftSlideMenu = @"";
}

- (void)didHideLeftView:(nonnull UIView *)leftView sideMenuController:(nonnull LGSideMenuController *)sideMenuController {
    if ([User_Details sharedInstance].currentlySelectedLeftSlideMenu.length > 0) {
        [[User_Details sharedInstance] makePushOrPopViewControllertoNavigationStack:self.navigationController];
    }
}

@end
