//
//  ChiSiamoViewController.m
//  Farvima
//
//  Created by Rafay Hasan on 12/11/17.
//  Copyright © 2017 Rafay Hasan. All rights reserved.
//

#import "ChiSiamoViewController.h"
#import "RHWebServiceManager.h"
#import "SVProgressHUD.h"
#import "User Details.h"
#import "UIViewController+LGSideMenuController.h"
#import "OfferViewController.h"
#import "NewsViewController.h"
#import "ProductSearchViewController.h"
#import "EventViewController.h"
#import "GallaryViewController.h"

@interface ChiSiamoViewController ()<RHWebServiceDelegate>

@property (strong,nonatomic) RHWebServiceManager *myWebService;

- (IBAction)backButtonAction:(id)sender;
- (IBAction)leftMenuButtonAction:(id)sender;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *scrollContainerHeight;
@property (weak, nonatomic) IBOutlet UITextView *aboutUsTextView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *aboutUsTextViewHeight;

@end

@implementation ChiSiamoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [[NSNotificationCenter defaultCenter]
     addObserver:self selector:@selector(LeftSlideMenutriggerAction:) name:@"leftSlideSelectedMenu" object:nil];
    [self CallChiSiamoWebservice];
}

-(void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

-(void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [[NSNotificationCenter defaultCenter]
     addObserver:self selector:@selector(LeftSlideMenutriggerAction:) name:@"leftSlideSelectedMenu" object:nil];
}

-(void) viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    //[[NSNotificationCenter defaultCenter] removeObserver:self];
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

- (IBAction)leftMenuButtonAction:(id)sender {
    [[self sideMenuController] showLeftViewAnimated:sender];
}

#pragma mark All Web service

-(void) CallChiSiamoWebservice
{
    [SVProgressHUD show];
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",BASE_URL_API,ChiSiamo_URL_API];
    self.myWebService = [[RHWebServiceManager alloc]initWebserviceWithRequestType:HTTPRequestTypeChiSiamo Delegate:self];
    [self.myWebService getDataFromWebURLWithUrlString:urlStr];
    
}

-(void) dataFromWebReceivedSuccessfully:(id) responseObj
{
    [SVProgressHUD dismiss];
    self.view.userInteractionEnabled = YES;
    if(self.myWebService.requestType == HTTPRequestTypeChiSiamo)
    {
        //NSArray *tempArray = [(NSArray *)responseObj valueForKey:@"about_us_details"];
        //NSLog(@"%@",tempArray);
        self.aboutUsTextView.text = [responseObj valueForKey:@"about_us_details"];
        [self adjustLayoutForViewController];
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

-(void) adjustLayoutForViewController {
    [self.view layoutIfNeeded];
    self.aboutUsTextView.scrollEnabled = NO;
    CGSize sizeThatFitsTextView = [self.aboutUsTextView sizeThatFits:CGSizeMake(self.aboutUsTextView.frame.size.width, MAXFLOAT)];
    self.aboutUsTextViewHeight.constant = sizeThatFitsTextView.height;
    self.scrollContainerHeight.constant = self.aboutUsTextView.frame.origin.y + self.aboutUsTextViewHeight.constant + 16;
    [self.view layoutIfNeeded];
}

-(void) LeftSlideMenutriggerAction:(NSNotification *) notification {
    NSDictionary *dict = notification.userInfo;
    NSString *menuname = [dict valueForKey:@"currentlySelectedLeftSlideMenu"];
    if ([menuname isEqualToString:@"OFFERTE"]) {
        OfferViewController *vc = [OfferViewController new];
        if (![self isControllerAlreadyOnNavigationControllerStack:vc]) {
            OfferViewController *newView = [self.storyboard instantiateViewControllerWithIdentifier:@"offerte"];
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
        ProductSearchViewController *vc = [ProductSearchViewController new];
        if (![self isControllerAlreadyOnNavigationControllerStack:vc]) {
            ProductSearchViewController *newView = [self.storyboard instantiateViewControllerWithIdentifier:@"AllProducts"];
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
    else if ([menuname isEqualToString:@"GALERIA"]) {
        GallaryViewController *vc = [GallaryViewController new];
        if (![self isControllerAlreadyOnNavigationControllerStack:vc]) {
            GallaryViewController *newView = [self.storyboard instantiateViewControllerWithIdentifier:@"galleria"];
            [self.navigationController pushViewController:newView animated:YES];
            
        }
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
