//
//  EventViewController.m
//  Farvima
//
//  Created by Rafay Hasan on 10/28/17.
//  Copyright © 2017 Rafay Hasan. All rights reserved.
//

#import "EventViewController.h"
#import "EventTableViewCell.h"
#import "UIViewController+LGSideMenuController.h"
#import "RHWebServiceManager.h"
#import "SVProgressHUD.h"
#import "User Details.h"
#import "EventObject.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "UILabel+FormattedText.h"
#import "EventDetailsViewController.h"

@interface EventViewController ()<UITableViewDataSource,UITableViewDelegate,RHWebServiceDelegate,LGSideMenuControllerDelegate>

@property (strong,nonatomic) RHWebServiceManager *myWebService;
@property (strong,nonatomic) EventObject *eventObject;
@property (strong,nonatomic) NSMutableArray *eventsArray;
@property (strong,nonatomic) User_Details *userManager;

@property (weak, nonatomic) IBOutlet UITableView *eventtableView;

- (IBAction)backButtonAction:(id)sender;
- (IBAction)leftMenuButtonAction:(id)sender;
- (IBAction)EventBottomTabButtonAction:(UIButton *)sender;


@end

@implementation EventViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.userManager = [User_Details sharedInstance];
    self.eventObject = [EventObject new];
    self.eventsArray = [NSMutableArray new];
    [self CallEventWebservice];
}

-(void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.sideMenuController.delegate = self;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"EventDetails"]) {
        NSIndexPath *indexPath = (NSIndexPath *)sender;
        EventDetailsViewController *vc = [segue destinationViewController];
        vc.object = [self.eventsArray objectAtIndex:indexPath.section];
        
    }
}


- (IBAction)backButtonAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}


- (IBAction)leftMenuButtonAction:(id)sender {
    [[self sideMenuController] showLeftViewAnimated:sender];
}

- (IBAction)EventBottomTabButtonAction:(UIButton *)sender {
    [[User_Details sharedInstance]makePushOrPopForBottomTabMenuToNavigationStack:self.navigationController forTag:sender.tag];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.eventsArray.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    EventTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"eventCell" forIndexPath:indexPath];
    self.eventObject = [self.eventsArray objectAtIndex:indexPath.section];
    
    if (self.eventObject.imageUel.length > 0) {
        [cell.eventImageView sd_setImageWithURL:[NSURL URLWithString:self.eventObject.imageUel]
                                 placeholderImage:[UIImage imageNamed:@"placeholder"]];
    }
    else {
        cell.eventImageView.image = nil;
    }
    
    if (self.eventObject.name.length > 0) {
        cell.eventname.text = self.eventObject.name;
    }
    else {
        cell.eventname.text = nil;
    }
    
    if (self.eventObject.referencePharmacyId.length > 0) {
        cell.pharmacyTYpeImageview.image = [UIImage imageNamed:@"farmacia logo"];
    }
    else {
        cell.pharmacyTYpeImageview.image = [UIImage imageNamed:@"farma logo"];
    }
    
    if (self.eventObject.location.length > 0) {
        cell.eventLocation.text = [NSString stringWithFormat:@"presso %@",self.eventObject.location];
        [cell.eventLocation setTextColor:[UIColor colorWithRed:40.0/255.0 green:67.0/255.0 blue:135.0/255.0 alpha:1] String:@"presso "];
        [cell.eventLocation setFont:[UIFont systemFontOfSize:15 weight:UIFontWeightSemibold] afterOccurenceOfString:@"presso "];
        [cell.eventLocation setTextColor:[UIColor colorWithRed:0.0/255.0 green:41.0/255.0 blue:128.0/255.0 alpha:1] String:self.eventObject.location];
        [cell.eventLocation setFont:[UIFont preferredFontForTextStyle:UIFontTextStyleCaption1] beforeOccurenceOfString:self.eventObject.location];
        
    }
    else {
        cell.eventLocation.text = @"presso ";
    }
    
    if (self.eventObject.locationDate.length > 0) {
        cell.eventDate.text = [NSString stringWithFormat:@"data %@",self.eventObject.locationDate];
        [cell.eventDate setTextColor:[UIColor colorWithRed:40.0/255.0 green:67.0/255.0 blue:135.0/255.0 alpha:1] String:@"data "];
        [cell.eventDate setFont:[UIFont systemFontOfSize:15 weight:UIFontWeightSemibold] afterOccurenceOfString:@"data "];
        [cell.eventDate setTextColor:[UIColor colorWithRed:0.0/255.0 green:41.0/255.0 blue:128.0/255.0 alpha:1] String:self.eventObject.locationDate];
        [cell.eventDate setFont:[UIFont preferredFontForTextStyle:UIFontTextStyleCaption1] beforeOccurenceOfString:self.eventObject.locationDate];
        
    }
    else {
        cell.eventDate.text = @"data ";
    }
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self performSegueWithIdentifier:@"EventDetails" sender:indexPath];
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UIView *headerView = [[UIView alloc] init];
    headerView.backgroundColor = [UIColor clearColor];
    return headerView;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *footerView = [[UIView alloc] init];
    if (section == self.eventsArray.count) {
        footerView.backgroundColor = [UIColor clearColor];
    }
    else {
        footerView.backgroundColor = [UIColor colorWithRed:11.0/255.0 green:72.0/255.0 blue:155.0/255.0 alpha:1];
    }
    return footerView;
}

-(BOOL)isControllerAlreadyOnNavigationControllerStack:(UIViewController *)targetViewController{
    for (UIViewController *vc in self.navigationController.viewControllers) {
        NSLog(@"%@",vc);
        if ([vc isKindOfClass:targetViewController.class]) {
            [self.navigationController popToViewController:vc animated:NO];
            return YES;
        }
    }
    return NO;
}

#pragma mark All Web service

-(void) CallEventWebservice
{
    [SVProgressHUD show];
    NSString *startingLimit = [NSString stringWithFormat:@"%li",self.eventsArray.count];
    NSString *urlStr = [NSString stringWithFormat:@"%@%@%@/%@",BASE_URL_API,Event_URL_API,self.userManager.appUserId,startingLimit];
    self.myWebService = [[RHWebServiceManager alloc]initWebserviceWithRequestType:HTTPRequestTypeEvents Delegate:self];
    [self.myWebService getDataFromWebURLWithUrlString:urlStr];
}

-(void) dataFromWebReceivedSuccessfully:(id) responseObj
{
    [SVProgressHUD dismiss];
    self.view.userInteractionEnabled = YES;
    if(self.myWebService.requestType == HTTPRequestTypeEvents)
    {
        [self.eventsArray addObjectsFromArray:(NSArray *)responseObj];
    }
    [self.eventtableView reloadData];
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
        
        [self CallEventWebservice];
        
    }
}

- (void)willShowLeftView:(nonnull UIView *)leftView sideMenuController:(nonnull LGSideMenuController *)sideMenuController {
    [User_Details sharedInstance].appUserId = @"";
}

- (void)didHideLeftView:(nonnull UIView *)leftView sideMenuController:(nonnull LGSideMenuController *)sideMenuController {
    [[User_Details sharedInstance] makePushOrPopViewControllertoNavigationStack:self.navigationController];
}



@end
