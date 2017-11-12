//
//  EventDetailsViewController.m
//  Farvima
//
//  Created by Rafay Hasan on 11/7/17.
//  Copyright © 2017 Rafay Hasan. All rights reserved.
//

#import "EventDetailsViewController.h"

@interface EventDetailsViewController ()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *containerViewHeightConstraint;
@property (weak, nonatomic) IBOutlet UITextView *eventDetailsTextView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *textViewHeight;

- (IBAction)backButtonAction:(id)sender;

@end

@implementation EventDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void) viewDidAppear:(BOOL)animated {
    self.eventDetailsTextView.scrollEnabled = NO;
    CGSize sizeThatFitsTextView = [self.eventDetailsTextView sizeThatFits:CGSizeMake(self.eventDetailsTextView.frame.size.width, MAXFLOAT)];
    self.textViewHeight.constant = sizeThatFitsTextView.height;
    self.containerViewHeightConstraint.constant = self.eventDetailsTextView.frame.origin.y + self.textViewHeight.constant + 16;
    NSLog(@"%f, %f",self.textViewHeight.constant,self.containerViewHeightConstraint.constant);
    [self.view layoutIfNeeded];
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
@end
