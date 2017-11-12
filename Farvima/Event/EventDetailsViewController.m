//
//  EventDetailsViewController.m
//  Farvima
//
//  Created by Rafay Hasan on 11/7/17.
//  Copyright © 2017 Rafay Hasan. All rights reserved.
//

#import "EventDetailsViewController.h"
#import "MessageViewController.h"
#import "NotificationViewController.h"

@interface EventDetailsViewController ()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *containerViewHeightConstraint;
@property (weak, nonatomic) IBOutlet UITextView *eventDetailsTextView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *textViewHeight;

- (IBAction)backButtonAction:(id)sender;
- (IBAction)messageButtonAction:(id)sender;
- (IBAction)notificationButtonAction:(id)sender;

@end

@implementation EventDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void) viewDidAppear:(BOOL)animated {
    [self adjustLayoutForViewController];
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

-(void) adjustLayoutForViewController {
    self.eventDetailsTextView.scrollEnabled = NO;
    CGSize sizeThatFitsTextView = [self.eventDetailsTextView sizeThatFits:CGSizeMake(self.eventDetailsTextView.frame.size.width, MAXFLOAT)];
    self.textViewHeight.constant = sizeThatFitsTextView.height;
    self.containerViewHeightConstraint.constant = self.eventDetailsTextView.frame.origin.y + self.textViewHeight.constant + 16;
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
@end
