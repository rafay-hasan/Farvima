//
//  MessageViewController.m
//  Farvima
//
//  Created by Rafay Hasan on 10/28/17.
//  Copyright © 2017 Rafay Hasan. All rights reserved.
//

#import "MessageViewController.h"
#import "MessageTableViewCell.h"
#import "MessageSectionHeader.h"
#import "NotificationViewController.h"
#import "RHWebServiceManager.h"
#import "SVProgressHUD.h"
#import "User Details.h"
#import "MessageObject.h"
#import "UIViewController+LGSideMenuController.h"
#import "EventViewController.h"
#import "GallaryViewController.h"
#import "NewsViewController.h"
#import "SearchResultViewController.h"
#import "OfferViewController.h"
#import "ChiSiamoViewController.h"

@interface MessageViewController ()<UITableViewDelegate,UITableViewDataSource,RHWebServiceDelegate>

@property (strong,nonatomic) RHWebServiceManager *myWebService;
@property (strong,nonatomic) MessageObject *messageObject;
@property (strong,nonatomic) NSMutableArray *messageArray;
@property (strong,nonatomic) User_Details *userManager;

@property (weak, nonatomic) IBOutlet UITableView *messageTableview;
- (IBAction)notificationButtonAction:(id)sender;
- (IBAction)leftSliderButtonAction:(id)sender;

- (IBAction)backButtonAction:(id)sender;
@end

@implementation MessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [[NSNotificationCenter defaultCenter]
     addObserver:self selector:@selector(LeftSlideMenutriggerAction:) name:@"leftSlideSelectedMenu" object:nil];
    self.messageTableview.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    UINib *messageHeaderXix = [UINib nibWithNibName:@"MessageSectionHeader" bundle:nil];
    [self.messageTableview registerNib:messageHeaderXix forHeaderFooterViewReuseIdentifier:@"messageSectionHeader"];
    
    self.userManager = [User_Details sharedInstance];
    self.messageObject = [MessageObject new];
    self.messageArray = [NSMutableArray new];
    [self CallMessageWebservice];
}
-(void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [[NSNotificationCenter defaultCenter]
     addObserver:self selector:@selector(LeftSlideMenutriggerAction:) name:@"leftSlideSelectedMenu" object:nil];
}

-(void) viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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

- (IBAction)notificationButtonAction:(id)sender {
    NotificationViewController *notificationVc = [NotificationViewController new];
    if (![self isControllerAlreadyOnNavigationControllerStack:notificationVc]) {
        //push controller
        NotificationViewController *newView = [self.storyboard instantiateViewControllerWithIdentifier:@"notification"];
        [self.navigationController pushViewController:newView animated:YES];
        
    }
}

- (IBAction)leftSliderButtonAction:(id)sender {
    [[self sideMenuController] showLeftViewAnimated:sender];
}

- (IBAction)backButtonAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.messageArray.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MessageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"messageCell" forIndexPath:indexPath];
    self.messageObject = [self.messageArray objectAtIndex:indexPath.section];
    cell.dateLabel.text = self.messageObject.creationDate;
    cell.messageLabel.text = self.messageObject.details;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    MessageSectionHeader *messageHeaderView = [self.messageTableview dequeueReusableHeaderFooterViewWithIdentifier:@"messageSectionHeader"];
    self.messageObject = [self.messageArray objectAtIndex:section];
    messageHeaderView.categotyNameLabel.text = self.messageObject.name;
    if (self.messageObject.referencePharmacyId.length > 0) {
        messageHeaderView.messageCategoryImageview.image = [UIImage imageNamed:@"farmacia logo"];
    }
    else {
        messageHeaderView.messageCategoryImageview.image = [UIImage imageNamed:@"farma logo"];
    }
    return messageHeaderView;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *footerView = [[UIView alloc] init];
    footerView.backgroundColor = [UIColor clearColor];
    return footerView;
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

#pragma mark All Web service

-(void) CallMessageWebservice
{
    [SVProgressHUD show];
    NSString *startingLimit = [NSString stringWithFormat:@"%li",self.messageArray.count];
    NSString *urlStr = [NSString stringWithFormat:@"%@%@%@/%@",BASE_URL_API,Message_URL_API,self.userManager.appUserId,startingLimit];
    self.myWebService = [[RHWebServiceManager alloc]initWebserviceWithRequestType:HTTPRequestTypeMessage Delegate:self];
    [self.myWebService getDataFromWebURLWithUrlString:urlStr];
    
}

-(void) dataFromWebReceivedSuccessfully:(id) responseObj
{
    [SVProgressHUD dismiss];
    self.view.userInteractionEnabled = YES;
    if(self.myWebService.requestType == HTTPRequestTypeMessage)
    {
        [self.messageArray addObjectsFromArray:(NSArray *)responseObj];
    }
    [self.messageTableview reloadData];
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


- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    
    NSInteger currentOffset = scrollView.contentOffset.y;
    NSInteger maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height;
    if (maximumOffset - currentOffset <= -40) {
        
        [self CallMessageWebservice];
        
    }
}

-(void) LeftSlideMenutriggerAction:(NSNotification *) notification {
    NSDictionary *dict = notification.userInfo;
    NSString *menuname = [dict valueForKey:@"currentlySelectedLeftSlideMenu"];
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
