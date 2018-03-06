//
//  ChooseYourPharmacyViewController.m
//  Farvima
//
//  Created by Rafay Hasan on 11/25/17.
//  Copyright © 2017 Rafay Hasan. All rights reserved.
//

#import "ChooseYourPharmacyViewController.h"
#import "UIViewController+LGSideMenuController.h"
#import "RHWebServiceManager.h"
#import "SVProgressHUD.h"
#import "User Details.h"
#import "PharmacyListViewController.h"
#import <CoreLocation/CoreLocation.h>

@interface ChooseYourPharmacyViewController ()<RHWebServiceDelegate,CLLocationManagerDelegate> {
    CLLocationManager *locationManager;
}

- (IBAction)backButtonAction:(id)sender;
- (IBAction)leftSlideButtonAction:(id)sender;
- (IBAction)searchPharmacyByLocationButtonAction:(id)sender;
@property (strong,nonatomic) RHWebServiceManager *myWebService;
@property (strong,nonatomic) NSString *latitude,*Longtitude;
@property (strong,nonatomic) NSMutableArray *pharmacyArray;

@end

@implementation ChooseYourPharmacyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.pharmacyArray = [NSMutableArray new];
    self.latitude = [NSString new];
    self.Longtitude = [NSString new];
    self.latitude = @"";
    self.Longtitude = @"";
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [locationManager requestAlwaysAuthorization];
    [locationManager requestWhenInUseAuthorization];
}

-(void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [locationManager startUpdatingLocation];
}

-(void) viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [locationManager stopUpdatingLocation];
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

- (IBAction)leftSlideButtonAction:(id)sender {
     [[self sideMenuController] showLeftViewAnimated:sender];
}

- (IBAction)searchPharmacyByLocationButtonAction:(id)sender {
    [self CallSearchPharmacyWebServiceForCurrentLocation];
}

#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"didFailWithError: %@", error);
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"Error", Nil) message:error.localizedDescription preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [alert dismissViewControllerAnimated:YES completion:nil];
    }];
    [alert addAction:ok];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    NSLog(@"didUpdateToLocation: %@", newLocation);
    CLLocation *currentLocation = newLocation;
    
    if (currentLocation != nil) {
        self.Longtitude = [NSString stringWithFormat:@"%.4f", currentLocation.coordinate.longitude];
        self.latitude = [NSString stringWithFormat:@"%.4f", currentLocation.coordinate.latitude];
    }
}


#pragma mark All Web service

-(void) CallSearchPharmacyWebServiceForCurrentLocation
{
    [SVProgressHUD show];
    NSDictionary *postData = [NSDictionary dictionaryWithObjectsAndKeys:self.latitude,@"lat",self.Longtitude,@"lng",nil];
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",BASE_URL_API,PharmacySearchForCurrentLocation_URL_API];
    self.myWebService = [[RHWebServiceManager alloc]initWebserviceWithRequestType:HTTPRequestTypePharmacySearchForCurrentLocation Delegate:self];
    [self.myWebService getPostDataFromWebURLWithUrlString:urlStr dictionaryData:postData];
}

-(void) dataFromWebReceivedSuccessfully:(id) responseObj
{
    [SVProgressHUD dismiss];
    self.view.userInteractionEnabled = YES;
    if(self.myWebService.requestType == HTTPRequestTypePharmacySearchForCurrentLocation)
    {
        [self.pharmacyArray addObjectsFromArray:(NSArray *)responseObj];
        PharmacyListViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"pharmacyListPage"];
        vc.pharmacyArray = self.pharmacyArray;
        [self.navigationController pushViewController:vc animated:YES];
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
