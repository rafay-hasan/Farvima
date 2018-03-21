//
//  SearchProductDetailsViewController.m
//  Farvima
//
//  Created by Rafay Hasan on 10/29/17.
//  Copyright © 2017 Rafay Hasan. All rights reserved.
//

#import "SearchProductDetailsViewController.h"
#import "UIViewController+LGSideMenuController.h"
#import "RHWebServiceManager.h"
#import "SVProgressHUD.h"
#import "User Details.h"
#import "ChooseYourPharmacyViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "AppDelegate.h"
#import "OrderDetailsViewController.h"

@interface SearchProductDetailsViewController ()<RHWebServiceDelegate> {
    AppDelegate *appDelegate;
}

@property (strong,nonatomic) RHWebServiceManager *myWebService;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *scrollviewContainerHeight;
- (IBAction)backButtonAction:(id)sender;
- (IBAction)leftSliderButtonAction:(id)sender;
- (IBAction)ProductDetilaPageBottomTabMenuButtonAction:(UIButton *)sender;

@property (weak, nonatomic) IBOutlet UIButton *purchaseButton;


@property (weak, nonatomic) IBOutlet UIImageView *productImageView;
@property (weak, nonatomic) IBOutlet UILabel *productNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *productDetailsTaxtView;
@property (weak, nonatomic) IBOutlet UILabel *productPriceLabel;

- (IBAction)purchaseButtonAction:(id)sender;

@end

@implementation SearchProductDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    appDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    [self loadProductDetailsView];
    
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

- (void) loadProductDetailsView
{
    if (self.productObject.imageUel.length > 0) {
        [self.productImageView sd_setImageWithURL:[NSURL URLWithString:self.productObject.imageUel]
                                 placeholderImage:[UIImage imageNamed:@"placeholder"]];
    }
    else {
        self.productImageView.image = [UIImage imageNamed:@"placeholder"];
    }
    
    if (self.productObject.name.length > 0) {
        self.productNameLabel.text = self.productObject.name;
    }
    else {
        self.productNameLabel.text = nil;
    }
    
    if (self.productObject.details.length > 0) {
        self.productDetailsTaxtView.text = self.productObject.details;
    }
    else {
        self.productDetailsTaxtView.text = nil;
    }
    
    if (self.productObject.price.length > 0) {
        self.productPriceLabel.text = self.productObject.price;
    }
    else {
        self.productPriceLabel.text = nil;
    }
    self.scrollviewContainerHeight.constant = self.purchaseButton.frame.origin.y + self.purchaseButton.frame.size.height + 52;
}

- (IBAction)backButtonAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)leftSliderButtonAction:(id)sender {
     [[self sideMenuController] showLeftViewAnimated:sender];
}

- (IBAction)ProductDetilaPageBottomTabMenuButtonAction:(UIButton *)sender {
    [[User_Details sharedInstance]makePushOrPopForBottomTabMenuToNavigationStack:self.navigationController forTag:sender.tag];
}
- (IBAction)purchaseButtonAction:(id)sender {
    [self checkIfPharmacyIsAssociated];
}

-(void) checkIfUserIsLoggedIn
{
    [SVProgressHUD show];
    self.view.userInteractionEnabled = NO;
    NSString *urlStr = [NSString stringWithFormat:@"%@%@%@",BASE_URL_API,LoginAuthentication_URL_API,[[NSUserDefaults standardUserDefaults] valueForKey:@"appUserId"]];
    //urlStr = @"http://farmadevelopment.switchyapp.com/app_user_login_authentication/6";
    self.myWebService = [[RHWebServiceManager alloc]initWebserviceWithRequestType:HTTPRequestTypeLoginAuthentication Delegate:self];
    [self.myWebService getDataFromWebURLWithUrlString:urlStr];
    
}

-(void) checkIfPharmacyIsAssociated
{
    [SVProgressHUD show];
    self.view.userInteractionEnabled = NO;
    NSString *urlStr = [NSString stringWithFormat:@"%@%@%@",BASE_URL_API,CheckPharmacyAssociation_URL_API,[[NSUserDefaults standardUserDefaults] valueForKey:@"appUserId"]];
    self.myWebService = [[RHWebServiceManager alloc]initWebserviceWithRequestType:HTTPRequestTypeCheckPharmacyAssociation Delegate:self];
    [self.myWebService getDataFromWebURLWithUrlString:urlStr];
    
}

-(void) dataFromWebReceivedSuccessfully:(id) responseObj
{
    [SVProgressHUD dismiss];
    self.view.userInteractionEnabled = YES;
    if(self.myWebService.requestType == HTTPRequestTypeCheckPharmacyAssociation)
    {
        if ([[responseObj valueForKey:@"status"] isEqualToNumber:[NSNumber numberWithInt:1]]) {
            [self checkIfUserIsLoggedIn];
        }
        else {
            ChooseYourPharmacyViewController *notificationVc = [ChooseYourPharmacyViewController new];
            if (![self isControllerAlreadyOnNavigationControllerStack:notificationVc]) {
                //push controller
                ChooseYourPharmacyViewController *newView = [self.storyboard instantiateViewControllerWithIdentifier:@"choosePharmacy"];
                [self.navigationController pushViewController:newView animated:YES];
                
            }
        }
    }
    else if (self.myWebService.requestType == HTTPRequestTypeLoginAuthentication) {
        NSString *userId = [[responseObj valueForKey:@"profile"] valueForKey:@"app_id"];
        if ([userId isEqualToString:[User_Details sharedInstance].appUserId]) {
            if([appDelegate saveProductDetailsWithID:self.productObject.finalProductId forProductName:self.productObject.name productPrice:self.productObject.price productType:self.productObject.pharmacyCategoryType]) {
                
                OrderDetailsViewController *notificationVc = [OrderDetailsViewController new];
                if (![self isControllerAlreadyOnNavigationControllerStack:notificationVc]) {
                    //push controller
                    OrderDetailsViewController *newView = [self.storyboard instantiateViewControllerWithIdentifier:@"confirmOrder"];
                    [self.navigationController pushViewController:newView animated:YES];
                    
                }
            }
            else {
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"Error", Nil) message:@"Please try again later." preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                    [alert dismissViewControllerAnimated:YES completion:nil];
                }];
                [alert addAction:ok];
                [self presentViewController:alert animated:YES completion:nil];
            }
        }
    }
}

-(void) dataFromWebReceiptionFailed:(NSError*) error
{
    [SVProgressHUD dismiss];
    self.view.userInteractionEnabled = YES;
    if (self.myWebService.requestType == HTTPRequestTypeLoginAuthentication) {
        NSLog(@"%@",error.description);
        NSString *urlStr = [NSString stringWithFormat:@"%@%@%@",BASE_URL_API,LoginAuthentication_URL_API,[User_Details sharedInstance].appUserId];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlStr]];
    }
    else {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"Message", Nil) message:error.localizedDescription preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            [alert dismissViewControllerAnimated:YES completion:nil];
        }];
        [alert addAction:ok];
        [self presentViewController:alert animated:YES completion:nil];
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
