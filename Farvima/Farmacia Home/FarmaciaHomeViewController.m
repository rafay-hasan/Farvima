//
//  FarmaciaHomeViewController.m
//  Farvima
//
//  Created by Rafay Hasan on 11/25/17.
//  Copyright © 2017 Rafay Hasan. All rights reserved.
//

#import "FarmaciaHomeViewController.h"
#import "UIViewController+LGSideMenuController.h"
#import "User Details.h"
#import "RHWebServiceManager.h"
#import "SVProgressHUD.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface FarmaciaHomeViewController ()<LGSideMenuControllerDelegate,RHWebServiceDelegate>
@property (strong,nonatomic) RHWebServiceManager *myWebserviceManager;
- (IBAction)FarmaciaHomeBottomTabMenuAction:(UIButton *)sender;

@property (weak, nonatomic) IBOutlet UILabel *pharmacynameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *pharmacyImageView;
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;
@property (weak, nonatomic) IBOutlet UILabel *vatNumberlabel;
@property (weak, nonatomic) IBOutlet UILabel *telephoneLabel;
@property (weak, nonatomic) IBOutlet UILabel *openingClosingTimeLabel;

@end

@implementation FarmaciaHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.sideMenuController.leftViewSwipeGestureEnabled = NO;
    self.sideMenuController.rightViewSwipeGestureEnabled = NO;
}

-(void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.sideMenuController.delegate = self;
    self.sideMenuController.leftViewSwipeGestureEnabled = NO;
    self.sideMenuController.rightViewSwipeGestureEnabled = NO;
    
    self.pharmacyImageView.image = nil;
    self.pharmacynameLabel.text = @"";
    self.locationLabel.text = @"";
    self.vatNumberlabel.text = @"";
    self.telephoneLabel.text = @"";
    self.pharmacynameLabel.hidden = YES;
    self.pharmacyImageView.hidden = YES;
    self.openingClosingTimeLabel.hidden = YES;
    [self callPharmacyDetailsWebService];
}

- (void) viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:YES];
    self.sideMenuController.leftViewSwipeGestureEnabled = YES;
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

- (IBAction)FarmaciaHomeBottomTabMenuAction:(UIButton *)sender {
    [[User_Details sharedInstance] makePushOrPopForBottomTabMenuToNavigationStack:self.navigationController forTag:sender.tag];
}

- (void)willShowLeftView:(nonnull UIView *)leftView sideMenuController:(nonnull LGSideMenuController *)sideMenuController {
    [User_Details sharedInstance].appUserId = @"";
}

- (void)didHideLeftView:(nonnull UIView *)leftView sideMenuController:(nonnull LGSideMenuController *)sideMenuController {
    [[User_Details sharedInstance] makePushOrPopViewControllertoNavigationStack:self.navigationController];
}

-(void) callPharmacyDetailsWebService
{
    NSDictionary *postData = [NSDictionary dictionaryWithObjectsAndKeys:[[NSUserDefaults standardUserDefaults] valueForKey:@"pharmacyId"],@"pharmacy_id",[[NSUserDefaults standardUserDefaults] valueForKey:@"appUserId"],@"app_user_id",nil];
    [SVProgressHUD show];
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",BASE_URL_API,PharmacyDetails_URL_API];
    self.myWebserviceManager = [[RHWebServiceManager alloc]initWebserviceWithRequestType:HTTPRequestypePharmacyDetails Delegate:self];
    [self.myWebserviceManager getPostDataFromWebURLWithUrlString:urlStr dictionaryData:postData];
}

-(void) dataFromWebReceivedSuccessfully:(id) responseObj
{
    [SVProgressHUD dismiss];
    self.view.userInteractionEnabled = YES;
    if(self.myWebserviceManager.requestType == HTTPRequestypePharmacyDetails)
    {
        if ([[responseObj valueForKey:@"pharmacy_logo_storage_path"] isKindOfClass:[NSString class]]) {
            self.pharmacynameLabel.hidden = YES;
            self.pharmacyImageView.hidden = NO;
            [self.pharmacyImageView sd_setImageWithURL:[NSURL URLWithString:[responseObj valueForKey:@"pharmacy_logo_storage_path"]]
                                     placeholderImage:[UIImage imageNamed:@"placeholder"]];
        }
        else {
            self.pharmacynameLabel.hidden = NO;
            self.pharmacyImageView.hidden = YES;
            self.pharmacynameLabel.text = [responseObj valueForKey:@"ragione_sociale"];
        }
    }
    
    NSString *address = @"";
    if ([[responseObj valueForKey:@"indirizzo"] isKindOfClass:[NSString class]]) {
        address = [responseObj valueForKey:@"indirizzo"];
    }
    
    if ([[responseObj valueForKey:@"cap"] isKindOfClass:[NSString class]]) {
        if (address.length > 0) {
            address = [NSString stringWithFormat:@"%@, %@",address,[responseObj valueForKey:@"cap"]];
        }
        else {
            address = [responseObj valueForKey:@"cap"];
        }
    }
    
    if ([[responseObj valueForKey:@"citta"] isKindOfClass:[NSString class]]) {
        if (address.length > 0) {
            address = [NSString stringWithFormat:@"%@, %@",address,[responseObj valueForKey:@"citta"]];
        }
        else {
            address = [responseObj valueForKey:@"citta"];
        }
    }
    
    if ([[responseObj valueForKey:@"provincia"] isKindOfClass:[NSString class]]) {
        if (address.length > 0) {
            address = [NSString stringWithFormat:@"%@, %@",address,[responseObj valueForKey:@"provincia"]];
        }
        else {
            address = [responseObj valueForKey:@"provincia"];
        }
    }
    self.locationLabel.text = address;
    
    if ([[responseObj valueForKey:@"piva"] isKindOfClass:[NSString class]]) {
        self.vatNumberlabel.text = [NSString stringWithFormat:@"Partia IVA: %@",[responseObj valueForKey:@"piva"]];
    }
    
    if ([[responseObj valueForKey:@"telefono"] isKindOfClass:[NSString class]]) {
        self.telephoneLabel.text = [NSString stringWithFormat:@"Tel: %@",[responseObj valueForKey:@"telefono"]];
    }
    
    if ([[responseObj valueForKey:@"pharmacy_opening_closing_time"] isKindOfClass:[NSString class]]) {
        self.openingClosingTimeLabel.text = [responseObj valueForKey:@"pharmacy_opening_closing_time"];
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

@end
