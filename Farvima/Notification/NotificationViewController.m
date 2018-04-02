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
#import "OfferViewController.h"
#import "NewsDetailsViewController.h"
#import "EventDetailsViewController.h"
#import "MessageViewController.h"
#import "GalleryDetailsViewController.h"
#import "AppDelegate.h"

@interface NotificationViewController ()<LGSideMenuControllerDelegate,RHWebServiceDelegate> {
    AppDelegate *appDelegate;
}

- (IBAction)backButtonAction:(id)sender;
- (IBAction)leftSliderButtonAction:(id)sender;
- (IBAction)NoticeBottomTabMenuButtonAction:(UIButton *)sender;

@property (weak, nonatomic) IBOutlet UITableView *notificationTableview;
@property (strong,nonatomic) RHWebServiceManager *myWebService;
@property (strong,nonatomic) NSMutableArray *notificationArray;
@property (strong,nonatomic) NotificationObject *object;
@property (strong,nonatomic) NSDictionary *notificationStatusDic;
@end

@implementation NotificationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.notificationTableview.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    self.notificationArray = [NSMutableArray new];
    self.notificationStatusDic = [NSDictionary new];
    appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
}

-(void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.sideMenuController.delegate = self;
    self.sideMenuController.rightViewSwipeGestureEnabled = NO;
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
        [self.notificationArray removeAllObjects];
        [self.notificationArray addObjectsFromArray:(NSArray *)responseObj];
        [self makeRequiredDbChanges];
    }
    else if (self.myWebService.requestType == HTTPRequestTypeNotificationDetailsOffer) {
        [appDelegate updateNotificationStatusforNotificationId:self.object.notificationId];
        
        OfferViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"offerte"];
        vc.offerObject = responseObj;
        vc.fromNotificationPage = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if (self.myWebService.requestType == HTTPRequestTypeNotificationDetailsNews) {
        [appDelegate updateNotificationStatusforNotificationId:self.object.notificationId];
        
        NewsDetailsViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"newsDetails"];
        vc.object = responseObj;
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if (self.myWebService.requestType == HTTPRequestTypeNotificationDetailsEvent) {
        [appDelegate updateNotificationStatusforNotificationId:self.object.notificationId];
        
        EventDetailsViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"eventDetails"];
        vc.object = responseObj;
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if (self.myWebService.requestType == HTTPRequestTypeNotificationDetailsGallery) {
        [appDelegate updateNotificationStatusforNotificationId:self.object.notificationId];
        
        GalleryDetailsViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"galleryDetails"];
        vc.gallery = responseObj;
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if (self.myWebService.requestType == HTTPRequestTypeNotificationDetailsOfferProduct) {
        NSLog(@"%@",responseObj);
    }
    else if (self.myWebService.requestType == HTTPRequestTypeNotificationDetailsMessage) {
        [appDelegate updateNotificationStatusforNotificationId:self.object.notificationId];
        
        MessageViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"messaggi"];
        vc.messageObject = responseObj;
        vc.fromNotificationPage = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
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

-(void) makeRequiredDbChanges {
    NSMutableDictionary *finalDic = [NSMutableDictionary new];
    //retrieve all inserted notification
    self.notificationStatusDic = [[NSDictionary alloc]initWithDictionary:[appDelegate getAllValuesfromNotification]];
    NSArray *keyArray = [self.notificationStatusDic allKeys];
    
    for (NotificationObject *notification in self.notificationArray) {
        if ([keyArray containsObject:notification.notificationId]) {
            [finalDic setObject:[self.notificationStatusDic valueForKey:notification.notificationId] forKey:notification.notificationId];
        }
        else {
            [finalDic setObject:[NSNumber numberWithBool:NO] forKey:notification.notificationId];
        }
    }
    
    // delete all notification as there may be old notifications which are not required now
    [appDelegate removeAllNotificationData];
    
    // insert notifications
    NSUInteger totalCount = 0;
    for(NSString *key in finalDic) {
        [appDelegate savNotificationDetailsWithID:key Status:[finalDic valueForKey:key]];
        if ([[finalDic valueForKey:key] isEqual:[NSNumber numberWithBool:NO]]) {
            totalCount = totalCount + 1;
        }
    }
    
    if(totalCount > 0) {
        [UIApplication sharedApplication].applicationIconBadgeNumber = totalCount;
    }
    else {
        [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    }
    
    self.notificationStatusDic = nil;
    self.notificationStatusDic = [[NSDictionary alloc]initWithDictionary:[appDelegate getAllValuesfromNotification]];
    
    [self.notificationTableview reloadData];
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
    self.object = [self.notificationArray objectAtIndex:indexPath.row];
    cell.notificationTitleLabel.text = self.object.notificationTitle;
    cell.notificationTYpeImageView.image = [UIImage imageNamed:self.object.NotificationCategory];
    if ([[self.notificationStatusDic valueForKey:self.object.notificationId] isEqual:[NSNumber numberWithBool:YES]]) {
        cell.backgroundColor = [UIColor colorWithRed:157.0/255.0 green:157.0/255.0 blue:156.0/255.0 alpha:1];//[UIColor lightGrayColor];
    }
    else {
        cell.backgroundColor = [UIColor whiteColor];
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    self.object = [self.notificationArray objectAtIndex:indexPath.row];
    
    [SVProgressHUD show];
    NSString *urlStr = [NSString stringWithFormat:@"%@%@%@",BASE_URL_API,NotificationDetails_URL_API,self.object.notificationId];
    if ([self.object.notificationTypeId isEqualToString:@"1"]) {
        self.myWebService = [[RHWebServiceManager alloc]initWebserviceWithRequestType:HTTPRequestTypeNotificationDetailsOffer Delegate:self];
    }
    else if ([self.object.notificationTypeId isEqualToString:@"2"]) {
        self.myWebService = [[RHWebServiceManager alloc]initWebserviceWithRequestType:HTTPRequestTypeNotificationDetailsNews Delegate:self];
    }
    else if ([self.object.notificationTypeId isEqualToString:@"3"]) {
        self.myWebService = [[RHWebServiceManager alloc]initWebserviceWithRequestType:HTTPRequestTypeNotificationDetailsEvent Delegate:self];
    }
    else if ([self.object.notificationTypeId isEqualToString:@"4"]) {
        self.myWebService = [[RHWebServiceManager alloc]initWebserviceWithRequestType:HTTPRequestTypeNotificationDetailsGallery Delegate:self];
    }
    else if ([self.object.notificationTypeId isEqualToString:@"5"]) {
        self.myWebService = [[RHWebServiceManager alloc]initWebserviceWithRequestType:HTTPRequestTypeNotificationDetailsOfferProduct Delegate:self];
    }
    else if ([self.object.notificationTypeId isEqualToString:@"6"]) {
        self.myWebService = [[RHWebServiceManager alloc]initWebserviceWithRequestType:HTTPRequestTypeNotificationDetailsMessage Delegate:self];
    }
    [self.myWebService getDataFromWebURLWithUrlString:urlStr];
    
    
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
    [User_Details sharedInstance].currentlySelectedLeftSlideMenu = @"";
}

- (void)didHideLeftView:(nonnull UIView *)leftView sideMenuController:(nonnull LGSideMenuController *)sideMenuController {
    if ([User_Details sharedInstance].currentlySelectedLeftSlideMenu.length > 0) {
        [[User_Details sharedInstance] makePushOrPopViewControllertoNavigationStack:self.navigationController];
    }
}

@end
