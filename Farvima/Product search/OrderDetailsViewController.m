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
#import "RHWebServiceManager.h"
#import "SVProgressHUD.h"
#import "User Details.h"
#import "AppDelegate.h"

@interface OrderDetailsViewController ()<UITableViewDelegate,UITableViewDataSource,RHWebServiceDelegate> {
    AppDelegate *appDelegate;
}
@property (strong,nonatomic) NSArray *orderArray;
@property (strong,nonatomic) NSMutableArray *quantityArray;
@property (strong,nonatomic) RHWebServiceManager *myWebService;
@property (weak, nonatomic) IBOutlet UITableView *orderTableview;
- (IBAction)backButtonAction:(id)sender;
- (IBAction)messageButtonAction:(id)sender;
- (IBAction)notificationButtonAction:(id)sender;

- (IBAction)orderConfirmButtonAction:(id)sender;

@end

@implementation OrderDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    appDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    self.orderArray = [appDelegate retrieveAllOrder];
    self.quantityArray = [NSMutableArray new];
    for (id ob in self.orderArray) {
        [self.quantityArray addObject:@"1"];
    }
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
    cell.quantityLabel.text = [self.quantityArray objectAtIndex:indexPath.row];
    double price = ([[[self.orderArray objectAtIndex:indexPath.row] valueForKey:@"price"] doubleValue]) * ([[self.quantityArray objectAtIndex:indexPath.row] doubleValue]);
    cell.priceLabel.text = [NSString stringWithFormat:@"%.2lf€",price];
    cell.incrementButton.tag = 1000 + indexPath.row;
    [cell.incrementButton addTarget:self action:@selector(incrementButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    cell.decrementButton.tag = 1000 + indexPath.row;
    [cell.decrementButton addTarget:self action:@selector(decrementButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
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
    double total = 0;
    for (NSInteger i=0; i < self.orderArray.count; i++) {
        total = total + ([[[self.orderArray objectAtIndex:i] valueForKey:@"price"] doubleValue] * [[self.quantityArray objectAtIndex:i] integerValue]);
    }
    orderFooterView.totalAmountLabel.text = [NSString stringWithFormat:@"%.2lf€",total];
    return orderFooterView;
}

-(void) incrementButtonAction:(UIButton *)sender {
    NSInteger value = [[self.quantityArray objectAtIndex:sender.tag - 1000] integerValue] + 1;
    [self.quantityArray replaceObjectAtIndex:sender.tag - 1000 withObject:[NSString stringWithFormat:@"%ld",(long)value]];
    //NSIndexPath *myIP = [NSIndexPath indexPathForRow:sender.tag - 1000 inSection:0];
    //[self.orderTableview reloadRowsAtIndexPaths:[NSArray arrayWithObject:myIP] withRowAnimation:UITableViewRowAnimationFade];
    [self.orderTableview reloadData];
    
}

-(void) decrementButtonAction:(UIButton *)sender {
    NSInteger value = [[self.quantityArray objectAtIndex:sender.tag - 1000] integerValue] - 1;
    if (value > 0) {
        [self.quantityArray replaceObjectAtIndex:sender.tag - 1000 withObject:[NSString stringWithFormat:@"%ld",(long)value]];
        //NSIndexPath *myIP = [NSIndexPath indexPathForRow:sender.tag - 1000 inSection:0];
        //[self.orderTableview reloadRowsAtIndexPaths:[NSArray arrayWithObject:myIP] withRowAnimation:UITableViewRowAnimationFade];
        [self.orderTableview reloadData];
    }
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

- (IBAction)orderConfirmButtonAction:(id)sender {
    NSString *productHistory = [NSString new];
    productHistory = @"";
    for (NSInteger i=0; i<self.orderArray.count; i++) {
        if (productHistory.length > 0) {
            productHistory = [NSString stringWithFormat:@"%@,%@",productHistory,[[self.orderArray objectAtIndex:i] valueForKey:@"orderId"]];
            productHistory = [NSString stringWithFormat:@"%@-%@-",productHistory,[self.quantityArray objectAtIndex:i]];
            productHistory = [NSString stringWithFormat:@"%@%@",productHistory,[[self.orderArray objectAtIndex:i] valueForKey:@"price"]];
        }
        else {
            productHistory = [[self.orderArray objectAtIndex:i] valueForKey:@"orderId"];
            productHistory = [NSString stringWithFormat:@"%@-%@-",productHistory,[self.quantityArray objectAtIndex:i]];
            productHistory = [NSString stringWithFormat:@"%@%@",productHistory,[[self.orderArray objectAtIndex:i] valueForKey:@"price"]];
        }
    }
    if (productHistory.length > 0) {
        [self confirmOrderWebServiceWithOrderHistory:productHistory];
    }
}

-(void) confirmOrderWebServiceWithOrderHistory:(NSString *)orderHistory
{
    [SVProgressHUD show];
    NSDictionary *postData = [NSDictionary dictionaryWithObjectsAndKeys:orderHistory,@"order_products_history",nil];
    NSString *urlStr = [NSString stringWithFormat:@"%@%@%@",BASE_URL_API,OrderConfirmation_URL_API,[User_Details sharedInstance].appUserId];
    self.myWebService = [[RHWebServiceManager alloc]initWebserviceWithRequestType:HTTPRequestTypeOrderConfirmation Delegate:self];
    [self.myWebService getPostDataFromWebURLWithUrlString:urlStr dictionaryData:postData];
}

-(void) dataFromWebReceivedSuccessfully:(id) responseObj
{
    [SVProgressHUD dismiss];
    self.view.userInteractionEnabled = YES;
    if(self.myWebService.requestType == HTTPRequestTypeOrderConfirmation)
    {
        NSLog(@"%@",responseObj);
        [appDelegate RemoveAllDataOfOrder];
        self.orderArray = [appDelegate retrieveAllOrder];
        [self.orderTableview reloadData];
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
