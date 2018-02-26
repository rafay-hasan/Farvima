//
//  NotificationViewController.m
//  Farvima
//
//  Created by Rafay Hasan on 10/28/17.
//  Copyright © 2017 Rafay Hasan. All rights reserved.
//

#import "NotificationViewController.h"
#import "MessageViewController.h"
#import "NotificationTableViewCell.h"
#import "UIViewController+LGSideMenuController.h"
#import "User Details.h"

@interface NotificationViewController ()<LGSideMenuControllerDelegate>

- (IBAction)messageButtonAction:(id)sender;
- (IBAction)backButtonAction:(id)sender;
- (IBAction)leftSliderButtonAction:(id)sender;

@property (weak, nonatomic) IBOutlet UITableView *notificationTableview;


@end

@implementation NotificationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.notificationTableview.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    
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

-(BOOL)isControllerAlreadyOnNavigationControllerStack:(UIViewController *)targetViewController{
    for (UIViewController *vc in self.navigationController.viewControllers) {
        if ([vc isKindOfClass:targetViewController.class]) {
            [self.navigationController popToViewController:vc animated:NO];
            return YES;
        }
    }
    return NO;
}
- (IBAction)messageButtonAction:(id)sender {
    MessageViewController *messageVc = [MessageViewController new];
    if (![self isControllerAlreadyOnNavigationControllerStack:messageVc]) {
        //push controller
        MessageViewController *newView = [self.storyboard instantiateViewControllerWithIdentifier:@"messaggi"];
        [self.navigationController pushViewController:newView animated:YES];

    }
}
- (IBAction)backButtonAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)leftSliderButtonAction:(id)sender {
    [[self sideMenuController] showLeftViewAnimated:sender];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NotificationTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"notificationCell" forIndexPath:indexPath];
    if (indexPath.row % 2 == 0) {
        cell.backgroundColor = [UIColor colorWithRed:230/255.0 green:228/255.0 blue:228/255.0 alpha:1.0];
        cell.notificationTYpeImageView.image = [UIImage imageNamed:@"farma logo"];
    }
    else {
        cell.backgroundColor = [UIColor whiteColor];
        cell.notificationTYpeImageView.image = [UIImage imageNamed:@"farmacia logo"];
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UIView *headerView = [[UIView alloc] init];
    headerView.backgroundColor = [UIColor clearColor];
    return headerView;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *footerView = [[UIView alloc] init];
    footerView.backgroundColor = [UIColor clearColor];
    return footerView;
}

- (void)willShowLeftView:(nonnull UIView *)leftView sideMenuController:(nonnull LGSideMenuController *)sideMenuController {
    [User_Details sharedInstance].appUserId = @"";
}

- (void)didHideLeftView:(nonnull UIView *)leftView sideMenuController:(nonnull LGSideMenuController *)sideMenuController {
    [[User_Details sharedInstance] makePushOrPopViewControllertoNavigationStack:self.navigationController];
}

@end
