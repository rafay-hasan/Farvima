//
//  PharmacistViewController.m
//  Farvima
//
//  Created by Rafay Hasan on 2/24/18.
//  Copyright © 2018 Rafay Hasan. All rights reserved.
//

#import "PharmacistViewController.h"
#import "UIViewController+LGSideMenuController.h"
#import "FarmacistTableViewCell.h"
#import "RHWebServiceManager.h"
#import "SVProgressHUD.h"
#import "User Details.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "FarmacistObject.h"

@interface PharmacistViewController ()<RHWebServiceDelegate,UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *farmacistTableview;
- (IBAction)backButtonAction:(id)sender;
- (IBAction)farmacistPageBottomTabMenuButtonAction:(UIButton *)sender;

@property (strong,nonatomic) RHWebServiceManager *myWebService;
@property (strong,nonatomic) NSArray *farmacistArray;
@property (strong,nonatomic) FarmacistObject *farmacist;

@end

@implementation PharmacistViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self CallFarmacistWebservice];
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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.farmacistArray.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FarmacistTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"farmacistCell" forIndexPath:indexPath];
    self.farmacist = [self.farmacistArray objectAtIndex:indexPath.section];
    if (self.farmacist.imagePath.length > 0) {
        [cell.farmacistImageView sd_setImageWithURL:[NSURL URLWithString:self.farmacist.imagePath]
                               placeholderImage:[UIImage imageNamed:@"placeholder"]];
    }
    else {
        cell.farmacistImageView.image = nil;
    }
    cell.nameLabel.text = [NSString stringWithFormat:@"%@ %@",self.farmacist.firstName,self.farmacist.lastName];
    cell.jobtiTitleLabel.text = self.farmacist.jobPosition;
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
    if (section == self.farmacistArray.count) {
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

-(void) CallFarmacistWebservice
{
    [SVProgressHUD show];
    NSString *urlStr = [NSString stringWithFormat:@"%@%@%@",BASE_URL_API,Farmacist_URL_API,[User_Details sharedInstance].appUserId];
    self.myWebService = [[RHWebServiceManager alloc]initWebserviceWithRequestType:HTTPRequestTypeFarmacist Delegate:self];
    [self.myWebService getDataFromWebURLWithUrlString:urlStr];
}

-(void) dataFromWebReceivedSuccessfully:(id) responseObj
{
    [SVProgressHUD dismiss];
    self.view.userInteractionEnabled = YES;
    if(self.myWebService.requestType == HTTPRequestTypeFarmacist)
    {
        self.farmacistArray = [NSArray arrayWithArray:(NSArray *)responseObj];
    }
    [self.farmacistTableview reloadData];
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


- (IBAction)backButtonAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)farmacistPageBottomTabMenuButtonAction:(UIButton *)sender {
    [[User_Details sharedInstance]makePushOrPopForBottomTabMenuToNavigationStack:self.navigationController forTag:sender.tag];
}
@end
