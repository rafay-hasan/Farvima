//
//  NewsViewController.m
//  Farvima
//
//  Created by Rafay Hasan on 10/27/17.
//  Copyright © 2017 Rafay Hasan. All rights reserved.
//

#import "NewsViewController.h"
#import "NewsTableViewCell.h"
#import "NewsSectionHeader.h"
#import "MessageViewController.h"
#import "NotificationViewController.h"
#import "RHWebServiceManager.h"
#import "SVProgressHUD.h"
#import "User Details.h"
#import "NewsObject.h"
#import "NewsDetailsViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>


@interface NewsViewController ()<UITableViewDataSource,UITableViewDelegate,RHWebServiceDelegate>

@property (strong,nonatomic) RHWebServiceManager *myWebService;
@property (strong,nonatomic) NewsObject *newsObject;
@property (strong,nonatomic) NSMutableArray *newsArray;
@property (strong,nonatomic) User_Details *userManager;

@property (weak, nonatomic) IBOutlet UITableView *newsTableView;

- (IBAction)backButtonAction:(id)sender;
- (IBAction)messageButtonAction:(id)sender;
- (IBAction)notificationButtonAction:(id)sender;

@end

@implementation NewsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.userManager = [User_Details sharedInstance];
    self.newsObject = [NewsObject new];
    self.newsArray = [NSMutableArray new];
    
    self.newsTableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    UINib *newsHeaderXix = [UINib nibWithNibName:@"NewsHeader" bundle:nil];
    [self.newsTableView registerNib:newsHeaderXix forHeaderFooterViewReuseIdentifier:@"newsSectionHeader"];
}

-(void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (self.newsArray.count == 0) {
        [self CallNewsWebservice];
    }
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
    if ([segue.identifier isEqualToString:@"newsDetails"]) {
        NSIndexPath *indexPath = (NSIndexPath *)sender;
        NewsDetailsViewController *vc = [segue destinationViewController];
        vc.object = [self.newsArray objectAtIndex:indexPath.section];
        
    }
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.newsArray.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NewsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"newsCell" forIndexPath:indexPath];
    self.newsObject = [self.newsArray objectAtIndex:indexPath.section];
    if (self.newsObject.imageUel.length > 0) {
        [cell.newsImageView sd_setImageWithURL:[NSURL URLWithString:self.newsObject.imageUel]
                               placeholderImage:[UIImage imageNamed:@"placeholder"]];
    }
    else {
        cell.newsImageView.image = nil;
    }
    
    if (self.newsObject.name.length > 0) {
        cell.newsDetailsLabel.text = self.newsObject.details;
    }
    else {
        cell.newsDetailsLabel.text = nil;
    }
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self performSegueWithIdentifier:@"newsDetails" sender:indexPath];
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    NewsSectionHeader *newsHeaderView = [self.newsTableView dequeueReusableHeaderFooterViewWithIdentifier:@"newsSectionHeader"];
    self.newsObject = [self.newsArray objectAtIndex:section];
    newsHeaderView.nameLabel.text = self.newsObject.name;
    newsHeaderView.timeLabel.text = self.newsObject.creationDate;
    return newsHeaderView;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *footerView = [[UIView alloc] init];
    footerView.backgroundColor = [UIColor clearColor];
    return footerView;
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

#pragma mark All Web service

-(void) CallNewsWebservice
{
    [SVProgressHUD show];
    NSString *startingLimit = [NSString stringWithFormat:@"%li",self.newsArray.count];
    NSString *urlStr = [NSString stringWithFormat:@"%@%@%@/%@",BASE_URL_API,News_URL_API,self.userManager.appUserId,startingLimit];
    self.myWebService = [[RHWebServiceManager alloc]initWebserviceWithRequestType:HTTPRequestTypeNews Delegate:self];
    [self.myWebService getDataFromWebURLWithUrlString:urlStr];
    
}

-(void) dataFromWebReceivedSuccessfully:(id) responseObj
{
    [SVProgressHUD dismiss];
    self.view.userInteractionEnabled = YES;
    if(self.myWebService.requestType == HTTPRequestTypeNews)
    {
        [self.newsArray addObjectsFromArray:(NSArray *)responseObj];
        
    }
    [self.newsTableView reloadData];
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
        
        [self CallNewsWebservice];
        
    }
}


@end
