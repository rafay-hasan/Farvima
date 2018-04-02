//
//  SearchByAddressViewController.m
//  Farvima
//
//  Created by Rafay Hasan on 11/25/17.
//  Copyright © 2017 Rafay Hasan. All rights reserved.
//

#import "SearchByAddressViewController.h"
#import "RHWebServiceManager.h"
#import "SVProgressHUD.h"
#import "User Details.h"
#import "SearchPharmacyObject.h"
#import "PharmacyListViewController.h"
#import "UIViewController+LGSideMenuController.h"

@interface SearchByAddressViewController ()<RHWebServiceDelegate,LGSideMenuControllerDelegate,UITextFieldDelegate>

@property (strong,nonatomic) RHWebServiceManager *myWebService;
@property (strong,nonatomic) SearchPharmacyObject *pharmacyObject;
@property (strong,nonatomic) NSMutableArray *pharmacyArray;
@property (strong,nonatomic) User_Details *userManager;

@property (weak, nonatomic) IBOutlet UITextField *searchTextfield;
- (IBAction)backButtonAction:(id)sender;
- (IBAction)searchButtonAction:(id)sender;
- (IBAction)productSearchPageBottomTabBarButtonAction:(UIButton *)sender;
- (IBAction)leftSlideButtonAction:(id)sender;


@end

@implementation SearchByAddressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                          action:@selector(dismissKeyboard)];
    
    [self.view addGestureRecognizer:tap];
    
    self.userManager = [User_Details sharedInstance];
    self.pharmacyObject = [SearchPharmacyObject new];
    self.pharmacyArray = [NSMutableArray new];
}

-(void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.sideMenuController.delegate = self;
    self.sideMenuController.rightViewSwipeGestureEnabled = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)dismissKeyboard {
    [self.searchTextfield resignFirstResponder];
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    if ([segue.identifier isEqualToString:@"pharmacyList"]) {
        PharmacyListViewController *vc = segue.destinationViewController;
        vc.pharmacyArray = self.pharmacyArray;
        vc.forCurrentLocation = NO;
    }
}


#pragma mark All Web service

-(void) CallSearchPharmacyWebServicewithPharmacyName:(NSString *)name
{
    [SVProgressHUD show];
    NSDictionary *postData = [NSDictionary dictionaryWithObjectsAndKeys:name,@"search_string",nil];
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",BASE_URL_API,PharmacySearch_URL_API];
    self.myWebService = [[RHWebServiceManager alloc]initWebserviceWithRequestType:HTTPRequestTypePharmacySearch Delegate:self];
    [self.myWebService getPostDataFromWebURLWithUrlString:urlStr dictionaryData:postData];
}

-(void) dataFromWebReceivedSuccessfully:(id) responseObj
{
    [SVProgressHUD dismiss];
    self.view.userInteractionEnabled = YES;
    if(self.myWebService.requestType == HTTPRequestTypePharmacySearch)
    {
        [self.pharmacyArray addObjectsFromArray:(NSArray *)responseObj];
        [self performSegueWithIdentifier:@"pharmacyList" sender:self];
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


- (IBAction)backButtonAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (BOOL) textFieldShouldReturn:(UITextField *)textField {
    if (textField == self.searchTextfield) {
        [textField becomeFirstResponder];
        [self CallSearchPharmacyWebServicewithPharmacyName:self.searchTextfield.text];
    }
    return YES;
}

- (IBAction)searchButtonAction:(id)sender {
    [self CallSearchPharmacyWebServicewithPharmacyName:self.searchTextfield.text];
//    if (self.searchTextfield.text.length > 0) {
//        [self CallSearchPharmacyWebServicewithPharmacyName:self.searchTextfield.text];
//    }
//    else {
//        UIAlertController *alert = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"Message", Nil) message:@"Please enter the product name" preferredStyle:UIAlertControllerStyleAlert];
//        UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
//
//
//            [alert dismissViewControllerAnimated:YES completion:nil];
//        }];
//        [alert addAction:ok];
//        [self presentViewController:alert animated:YES completion:nil];
//    }
}

- (IBAction)productSearchPageBottomTabBarButtonAction:(UIButton *)sender {
    [[User_Details sharedInstance]makePushOrPopForBottomTabMenuToNavigationStack:self.navigationController forTag:sender.tag];
}

- (IBAction)leftSlideButtonAction:(id)sender {
    [[self sideMenuController] showLeftViewAnimated:sender];
}

- (void)willShowLeftView:(nonnull UIView *)leftView sideMenuController:(nonnull LGSideMenuController *)sideMenuController {
    [User_Details sharedInstance].currentlySelectedLeftSlideMenu = @"";
}

- (void)didHideLeftView:(nonnull UIView *)leftView sideMenuController:(nonnull LGSideMenuController *)sideMenuController {
    if ([User_Details sharedInstance].currentlySelectedLeftSlideMenu.length > 0) {
        [[User_Details sharedInstance] makePushOrPopViewControllertoNavigationStack:self.navigationController];
    }
}


@end
