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
@interface SearchByAddressViewController ()<RHWebServiceDelegate>

@property (strong,nonatomic) RHWebServiceManager *myWebService;
@property (strong,nonatomic) SearchPharmacyObject *pharmacyObject;
@property (strong,nonatomic) NSMutableArray *pharmacyArray;
@property (strong,nonatomic) User_Details *userManager;

@property (weak, nonatomic) IBOutlet UITextField *searchTextfield;
- (IBAction)backButtonAction:(id)sender;
- (IBAction)searchButtonAction:(id)sender;
- (IBAction)productSearchPageBottomTabBarButtonAction:(UIButton *)sender;


@end

@implementation SearchByAddressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.userManager = [User_Details sharedInstance];
    self.pharmacyObject = [SearchPharmacyObject new];
    self.pharmacyArray = [NSMutableArray new];
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
    
    if ([segue.identifier isEqualToString:@"pharmacyList"]) {
        PharmacyListViewController *vc = segue.destinationViewController;
        vc.pharmacyArray = self.pharmacyArray;
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

- (IBAction)searchButtonAction:(id)sender {
    [self CallSearchPharmacyWebServicewithPharmacyName:self.searchTextfield.text];
}

- (IBAction)productSearchPageBottomTabBarButtonAction:(UIButton *)sender {
    [[User_Details sharedInstance]makePushOrPopForBottomTabMenuToNavigationStack:self.navigationController forTag:sender.tag];
}

@end
