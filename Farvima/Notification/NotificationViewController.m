//
//  NotificationViewController.m
//  Farvima
//
//  Created by Rafay Hasan on 10/28/17.
//  Copyright © 2017 Rafay Hasan. All rights reserved.
//

#import "NotificationViewController.h"
#import "NotificationTableViewCell.h"
#import "UIViewController+LGSideMenuController.h"
#import "User Details.h"
#import "RHWebServiceManager.h"
#import "SVProgressHUD.h"
#import "NotificationObject.h"

@interface NotificationViewController ()<LGSideMenuControllerDelegate,RHWebServiceDelegate>

- (IBAction)backButtonAction:(id)sender;
- (IBAction)leftSliderButtonAction:(id)sender;
- (IBAction)NoticeBottomTabMenuButtonAction:(UIButton *)sender;

@property (weak, nonatomic) IBOutlet UITableView *notificationTableview;
@property (strong,nonatomic) RHWebServiceManager *myWebService;
@property (strong,nonatomic) NSMutableArray *notificationArray;
@property (strong,nonatomic) NotificationObject *notification;

@end

@implementation NotificationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.notificationTableview.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    self.notificationArray = [NSMutableArray new];
    
}

-(void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.sideMenuController.delegate = self;
    [self CallNotificationWebservice];
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

- (IBAction)backButtonAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)leftSliderButtonAction:(id)sender {
    [[self sideMenuController] showLeftViewAnimated:sender];
}

- (IBAction)NoticeBottomTabMenuButtonAction:(UIButton *)sender {
    [[User_Details sharedInstance]makePushOrPopForBottomTabMenuToNavigationStack:self.navigationController forTag:sender.tag];
}

#pragma mark All Web service

-(void) CallNotificationWebservice
{
    [SVProgressHUD show];
    NSString *urlStr = [NSString stringWithFormat:@"%@%@%@",BASE_URL_API,Notification_URL_API,[[NSUserDefaults standardUserDefaults] valueForKey:@"appUserId"]];
    self.myWebService = [[RHWebServiceManager alloc]initWebserviceWithRequestType:HTTPRequestTypeNotification Delegate:self];
    [self.myWebService getDataFromWebURLWithUrlString:urlStr];
    
}

-(void) dataFromWebReceivedSuccessfully:(id) responseObj
{
    [SVProgressHUD dismiss];
    self.view.userInteractionEnabled = YES;
    if(self.myWebService.requestType == HTTPRequestTypeNotification)
    {
        [self.notificationArray addObjectsFromArray:(NSArray *)responseObj];
    }
    [self.notificationTableview reloadData];
}

-(void) dataFromWebReceiptionFailed:(NSError*) error
{
    [SVProgressHUD dismiss];
    self.view.userInteractionEnabled = YES;
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"Message", Nil) message:error.localizedDescription preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
        
        [alert dismissViewControllerAnimated:YES completion:nil];
    }];
    [alert addAction:ok];
    [self presentViewController:alert animated:YES completion:nil];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.notificationArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NotificationTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"notificationCell" forIndexPath:indexPath];
    self.notification = [self.notificationArray objectAtIndex:indexPath.row];
    cell.notificationTYpeImageView.image = [UIImage imageNamed:self.notification.NotificationCategory];
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
