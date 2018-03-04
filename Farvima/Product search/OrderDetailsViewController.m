//
//  OrderDetailsViewController.m
//  Farvima
//
//  Created by Rafay Hasan on 10/30/17.
//  Copyright © 2017 Rafay Hasan. All rights reserved.
//

#import "OrderDetailsViewController.h"
#import "OrderDetailsHeaderSection.h"
#import "OrderDetailsFooetrSection.h"
#import "OrderDetailsTableViewCell.h"
#import "MessageViewController.h"
#import "NotificationViewController.h"
#import "AppDelegate.h"

@interface OrderDetailsViewController ()<UITableViewDelegate,UITableViewDataSource> {
    AppDelegate *appDelegate;
}
@property (strong,nonatomic) NSArray *orderArray;
@property (weak, nonatomic) IBOutlet UITableView *orderTableview;
- (IBAction)backButtonAction:(id)sender;
- (IBAction)messageButtonAction:(id)sender;
- (IBAction)notificationButtonAction:(id)sender;


@end

@implementation OrderDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    appDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    self.orderArray = [appDelegate retrieveAllOrder];
    self.orderTableview.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    UINib *orderTableHeaderXib = [UINib nibWithNibName:@"OrderDetailsHeaderSection" bundle:nil];
    [self.orderTableview registerNib:orderTableHeaderXib forHeaderFooterViewReuseIdentifier:@"orderTableSectionHeader"];
    UINib *orderTableFooterXib = [UINib nibWithNibName:@"OrderDetailsFooterSection" bundle:nil];
    [self.orderTableview registerNib:orderTableFooterXib forHeaderFooterViewReuseIdentifier:@"orderTableSectionFooter"];
    [self.orderTableview reloadData];
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
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.orderArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    OrderDetailsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"orderDetailsCell" forIndexPath:indexPath];
    if (indexPath.row % 2 == 0) {
        cell.backgroundColor = [UIColor colorWithRed:230/255.0 green:228/255.0 blue:228/255.0 alpha:1.0];
        //cell.notificationTYpeImageView.image = [UIImage imageNamed:@"farma logo"];
    }
    else {
        cell.backgroundColor = [UIColor whiteColor];
        //cell.notificationTYpeImageView.image = [UIImage imageNamed:@"farmacia logo"];
    }
    cell.productNameLabel.text = [[self.orderArray objectAtIndex:indexPath.row] valueForKey:@"name"];
    cell.categoryTypeImageView.image = [UIImage imageNamed:[[self.orderArray objectAtIndex:indexPath.row] valueForKey:@"type"]];
    cell.priceLabel.text = [NSString stringWithFormat:@"%@€",[[self.orderArray objectAtIndex:indexPath.row] valueForKey:@"price"]];
    
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {

    OrderDetailsHeaderSection *orderHeaderView = [self.orderTableview dequeueReusableHeaderFooterViewWithIdentifier:@"orderTableSectionHeader"];
    return orderHeaderView;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    OrderDetailsFooetrSection *orderFooterView = [self.orderTableview dequeueReusableHeaderFooterViewWithIdentifier:@"orderTableSectionFooter"];
    NSInteger total = 0;
    for (id object in self.orderArray) {
        NSString *price = [object valueForKey:@"price"];
        total = total + [price integerValue];
    }
    NSLog(@"%ld",total);
    orderFooterView.totalAmountLabel.text = [NSString stringWithFormat:@"%ld€",total];
    return orderFooterView;
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
