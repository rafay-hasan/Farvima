//
//  ProductSearchViewController.m
//  Farvima
//
//  Created by Rafay Hasan on 10/29/17.
//  Copyright © 2017 Rafay Hasan. All rights reserved.
//

#import "ProductSearchViewController.h"
#import "UIViewController+LGSideMenuController.h"
#import "EventDetailsViewController.h"
#import "GallaryViewController.h"
#import "NewsViewController.h"
#import "EventViewController.h"
#import "OfferViewController.h"
#import "ChiSiamoViewController.h"
#import "RHWebServiceManager.h"
#import "SVProgressHUD.h"
#import "SearchResultViewController.h"
#import "User Details.h"

@interface ProductSearchViewController ()<RHWebServiceDelegate,LGSideMenuControllerDelegate>

- (IBAction)backButtonAction:(id)sender;
- (IBAction)searchButtonAction:(id)sender;
- (IBAction)leftSliderButtonAction:(id)sender;


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *scrollContainerViewHeight;
@property (weak, nonatomic) IBOutlet UIButton *searchButton;

@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *codeTextField;
@property (weak, nonatomic) IBOutlet UITextField *categoryTextField;
@property (strong,nonatomic) RHWebServiceManager *myWebService;

@end

@implementation ProductSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

-(void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:YES];
    self.scrollContainerViewHeight.constant = self.searchButton.frame.origin.y + self.searchButton.frame.size.height + 20;
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

- (IBAction)backButtonAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)searchButtonAction:(id)sender {
    if (self.nameTextField.text.length >0 || self.codeTextField.text.length > 0 || self.categoryTextField.text.length > 0) {
       // [self.delegate resultOfSearchedData:@"data received"];
       // [self.navigationController popViewControllerAnimated:YES];
        [self CallProductSearchWebserviceWithName:self.nameTextField.text OrWithCode:self.codeTextField.text OrWithCategory:self.categoryTextField.text];
    }
    else {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"Message", Nil) message:@"Please enter data" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            
            
            [alert dismissViewControllerAnimated:YES completion:nil];
        }];
        [alert addAction:ok];
        [self presentViewController:alert animated:YES completion:nil];
    }
}

-(void) CallProductSearchWebserviceWithName:(NSString *)name OrWithCode:(NSString *)code OrWithCategory:(NSString *)category
{
    NSDictionary *postData = [NSDictionary dictionaryWithObjectsAndKeys:name,@"product_name",code,@"codice_ministeriale",category,@"categoria_merciologica",nil];
    [SVProgressHUD show];
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",BASE_URL_API,CategoryProductSearch_URL_API];
    self.myWebService = [[RHWebServiceManager alloc]initWebserviceWithRequestType:HTTPRequestTypeProductSearch Delegate:self];
    [self.myWebService getPostDataFromWebURLWithUrlString:urlStr dictionaryData:postData];
}

-(void) dataFromWebReceivedSuccessfully:(id) responseObj
{
    [SVProgressHUD dismiss];
    self.view.userInteractionEnabled = YES;
    if(self.myWebService.requestType == HTTPRequestTypeProductSearch)
    {
        [self.delegate resultOfSearchedData:responseObj];
        [self.navigationController popViewControllerAnimated:YES];
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

- (IBAction)leftSliderButtonAction:(id)sender {
     [[self sideMenuController] showLeftViewAnimated:sender];
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
