//
//  OfferViewController.m
//  Farvima
//
//  Created by Rafay Hasan on 10/24/17.
//  Copyright © 2017 Rafay Hasan. All rights reserved.
//

#import "OfferViewController.h"
#import "MessageViewController.h"
#import "NotificationViewController.h"
#import "UIViewController+LGSideMenuController.h"
#import "GallaryViewController.h"
#import "NewsViewController.h"
#import "ProductSearchViewController.h"
#import "SearchResultViewController.h"
#import "EventViewController.h"
#import "ChiSiamoViewController.h"
#import "User Details.h"
#import "RHWebServiceManager.h"
#import "SVProgressHUD.h"
#import "AllOfferObject.h"
#import "OfferTableViewCell.h"

@interface OfferViewController ()<UITableViewDelegate,UITableViewDataSource,LGSideMenuControllerDelegate,RHWebServiceDelegate>

@property (weak, nonatomic) IBOutlet UITableView *offerTableview;
@property (strong,nonatomic) RHWebServiceManager *myWebService;
@property (strong,nonatomic) AllOfferObject *offerObject;
@property (strong,nonatomic) NSMutableArray *offerArray;

- (IBAction)backButtonAction:(id)sender;
- (IBAction)messageButtonAction:(id)sender;
- (IBAction)notificationButtonAction:(id)sender;
- (IBAction)showLeftMenuAction:(id)sender;
- (IBAction)searchProductButtonAction:(id)sender;
- (IBAction)busketButtonAction:(id)sender;
- (IBAction)tutteLeOfferteButtonAction:(id)sender;


@end

@implementation OfferViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.offerTableview.estimatedRowHeight = 90;
    self.offerTableview.rowHeight = UITableViewAutomaticDimension;
    self.offerArray = [NSMutableArray new];
    [self CallOfferWebservice];
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

#pragma mark All Web service

-(void) CallOfferWebservice
{
    [SVProgressHUD show];
    //NSString *startingLimit = [NSString stringWithFormat:@"%li",self.offerArray.count];
    NSString *urlStr = [NSString stringWithFormat:@"%@%@%@",BASE_URL_API,Offer_URL_API,[User_Details sharedInstance].appUserId];
    self.myWebService = [[RHWebServiceManager alloc]initWebserviceWithRequestType:HTTPRequestTypeOffer Delegate:self];
    [self.myWebService getDataFromWebURLWithUrlString:urlStr];
    
}

-(void) dataFromWebReceivedSuccessfully:(id) responseObj
{
    [SVProgressHUD dismiss];
    self.view.userInteractionEnabled = YES;
    if(self.myWebService.requestType == HTTPRequestTypeOffer)
    {
        [self.offerArray removeAllObjects];
        [self.offerArray addObjectsFromArray:(NSArray *)responseObj];
    }
    [self.offerTableview reloadData];
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


//- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
//
//    NSInteger currentOffset = scrollView.contentOffset.y;
//    NSInteger maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height;
//    if (maximumOffset - currentOffset <= -40) {
//
//        [self CallGalleryWebservice];
//
//    }
//}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.offerArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    OfferTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"offerCell" forIndexPath:indexPath];
    self.offerObject = [self.offerArray objectAtIndex:indexPath.row];
    cell.pdfTitleLabel.text = self.offerObject.offerTitle;
    cell.categoryTypeImageview.image = [UIImage imageNamed:self.offerObject.offerType];
    cell.dateTimeLabel.text = self.offerObject.endTime;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
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

- (IBAction)showLeftMenuAction:(id)sender {
    [[self sideMenuController] showLeftViewAnimated:sender];
}

- (IBAction)searchProductButtonAction:(id)sender {
    
    ProductSearchViewController *messageVc = [ProductSearchViewController new];
    if (![self isControllerAlreadyOnNavigationControllerStack:messageVc]) {
        //push controller
        ProductSearchViewController *newView = [self.storyboard instantiateViewControllerWithIdentifier:@"productSearch"];
        [self.navigationController pushViewController:newView animated:YES];
        
    }
}

- (IBAction)busketButtonAction:(id)sender {
}

- (IBAction)tutteLeOfferteButtonAction:(id)sender {
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


- (void)didHideLeftView:(nonnull UIView *)leftView sideMenuController:(nonnull LGSideMenuController *)sideMenuController {
    NSString *menuname = [User_Details sharedInstance].currentlySelectedLeftSlideMenu;
    if ([menuname isEqualToString:@"GALERIA"]) {
        GallaryViewController *vc = [GallaryViewController new];
        if (![self isControllerAlreadyOnNavigationControllerStack:vc]) {
            GallaryViewController *newView = [self.storyboard instantiateViewControllerWithIdentifier:@"galleria"];
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
    else if ([menuname isEqualToString:@"PRENOTA E RITIRA"]) {
        SearchResultViewController *vc = [SearchResultViewController new];
        if (![self isControllerAlreadyOnNavigationControllerStack:vc]) {
            SearchResultViewController *newView = [self.storyboard instantiateViewControllerWithIdentifier:@"AllProducts"];
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
    else if ([menuname isEqualToString:@"CHI SIAMO"]) {
        ChiSiamoViewController *vc = [ChiSiamoViewController new];
        if (![self isControllerAlreadyOnNavigationControllerStack:vc]) {
            ChiSiamoViewController *newView = [self.storyboard instantiateViewControllerWithIdentifier:@"chi Siamo"];
            [self.navigationController pushViewController:newView animated:YES];
            
        }
    }
}

@end
