//
//  PharmacyListViewController.m
//  Farvima
//
//  Created by Rafay Hasan on 11/25/17.
//  Copyright © 2017 Rafay Hasan. All rights reserved.
//

#import "PharmacyListViewController.h"
#import "PharmacyListTableViewCell.h"
#import "FarmVimaSlideMenuSingletone.h"
#import "UIViewController+LGSideMenuController.h"
#import "MainViewController.h"
#import "FarmaciaHomeViewController.h"
#import "SearchPharmacyObject.h"
#import <GoogleMaps/GoogleMaps.h>
#import "User Details.h"
#import "RHWebServiceManager.h"
#import "SVProgressHUD.h"
#import "NavigationController.h"
#import "MarkerView.h"

@interface PharmacyListViewController () <UITableViewDelegate,UITableViewDataSource,LGSideMenuControllerDelegate,RHWebServiceDelegate,GMSMapViewDelegate>

@property (strong,nonatomic) FarmVimaSlideMenuSingletone *slideMenuSharedManager;
@property (strong, nonatomic) SearchPharmacyObject *object;
- (IBAction)leftMenuButtonAction:(id)sender;

@property (weak, nonatomic) IBOutlet UILabel *orientationHeaderLabel;
- (IBAction)backButtonAction:(id)sender;
- (IBAction)rightSlideMenuAction:(id)sender;
- (IBAction)PharmacyListBottomTabButtonAction:(UIButton *)sender;

@property (weak, nonatomic) IBOutlet UITableView *pharmacyListTableview;
@property (weak, nonatomic) IBOutlet GMSMapView *mapView;

@property (strong,nonatomic) RHWebServiceManager *myWebService;
@property (strong,nonatomic) User_Details *userManager;

@end

@implementation PharmacyListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.userManager = [User_Details sharedInstance];
    
    self.object = [SearchPharmacyObject new];
    self.mapView.hidden = YES;
    self.pharmacyListTableview.hidden = NO;
    [self resetSlideRightmenu];
    [self setMapLocation];
    
}

-(void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    NSLog(@"View did appear called");
}

-(void) viewDidDisappear:(BOOL)animated {
    self.sideMenuController.leftViewSwipeGestureEnabled = NO;
    self.sideMenuController.rightViewSwipeGestureEnabled = NO;
    [self.slideMenuSharedManager createLeftGeneralSlideMenu];
    self.sideMenuController.leftViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"leftMenu"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) resetSlideRightmenu {
    self.slideMenuSharedManager = [FarmVimaSlideMenuSingletone sharedManager];
    [self.slideMenuSharedManager.rightSideMenuArray removeAllObjects];
    [self.slideMenuSharedManager.rightSideMenuArray addObject:@"VISTA ELENCO"];
    [self.slideMenuSharedManager.rightSideMenuArray addObject:@"VISTA MAPPA"];
    self.slideMenuSharedManager.isListSelected = YES;
    self.sideMenuController.delegate = self;
}

- (void) setMapLocation {
    
    SearchPharmacyObject *object = [self.pharmacyArray objectAtIndex:0];
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:[object.latitude doubleValue]
                                                            longitude:[object.longlitude doubleValue]
                                                                 zoom:8];
    for(SearchPharmacyObject *object in self.pharmacyArray) {
        GMSMarker *marker = [[GMSMarker alloc] init];
        marker.position = CLLocationCoordinate2DMake([object.latitude doubleValue], [object.longlitude doubleValue]);
        //marker.infoWindowAnchor = CGPointMake(0.44f, 0.45f);
        marker.infoWindowAnchor = CGPointMake(0.44f, 0.45f);
        marker.icon = [UIImage imageNamed:@"pin"];
        marker.userData = object.pharmacyId;
        marker.map = self.mapView;
    }
    self.mapView.camera = camera;
    //self.mapView.delegate = self;
}
- (UIView *)mapView:(GMSMapView *)mapView markerInfoWindow:(GMSMarker *)marker {
    MarkerView *view =  [[[NSBundle mainBundle] loadNibNamed:@"CustomMarkerView" owner:self options:nil] objectAtIndex:0];
   NSUInteger index = 0;
   for(SearchPharmacyObject *object in self.pharmacyArray) {
       if ([[object valueForKey:@"pharmacyId"] isEqualToString:marker.userData]) {
           view.addressLabel.text = object.addres;
           view.phoneNumberLabel.text = object.phone;
           view.webAddressLabel.text = object.pharmacyId;
           view.emailAddressLabel.text = object.email;
           view.associateButton.tag = 1000 + index;
           [view.associateButton addTarget:self action:@selector(AssociateFromMapButtonAction:) forControlEvents:UIControlEventTouchUpInside];
           break;
       }
       index++;
   }
    return view;
}

- (void) mapView:(GMSMapView *)mapView didTapInfoWindowOfMarker:(GMSMarker *)marker {
    NSLog(@"id is %@",marker.userData);
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
    return self.pharmacyArray.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PharmacyListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PharmacyListCell" forIndexPath:indexPath];
    self.object = [self.pharmacyArray objectAtIndex:indexPath.section];
    cell.pharmacyNameLabel.text = self.object.name;
    cell.pharmacyAddressLabel.text = self.object.addres;
    cell.pharmacyVarNumberLabel.text = [NSString stringWithFormat:@"Partia Iva: %@",self.object.vatNumber];
    cell.pharmacyPhoneLabel.text = [NSString stringWithFormat:@"Tel: %@",self.object.phone];
    cell.associateButton.tag = 1000 + indexPath.section;
    [cell.associateButton addTarget:self action:@selector(makePharmacyAssociate:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UIView *headerView = [[UIView alloc] init];
    headerView.backgroundColor = [UIColor clearColor];
    return headerView;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *footerView = [[UIView alloc] init];
    footerView.backgroundColor = [UIColor colorWithRed:6.0/255.0 green:39.0/255.0 blue:156.0/255.0 alpha:1];
    return footerView;
}

-(void) makePharmacyAssociate:(UIButton *)sender {
    
    self.object = [self.pharmacyArray objectAtIndex:sender.tag - 1000];
    [self CallPharmacyAssociateWebserviceWith:self.object.pharmacyId forAppUser:self.userManager.appUserId];
}

-(void) CallPharmacyAssociateWebserviceWith:(NSString *)pharmacyId forAppUser:(NSString *)appUserId
{
    NSDictionary *postData = [NSDictionary dictionaryWithObjectsAndKeys:pharmacyId,@"pharmacy_id",appUserId,@"app_user_id",nil];
    [SVProgressHUD show];
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",BASE_URL_API,AssociatePharmacy_URL_API];
    self.myWebService = [[RHWebServiceManager alloc]initWebserviceWithRequestType:HTTPRequestTypeAssociatePharmacy Delegate:self];
    [self.myWebService getPostDataFromWebURLWithUrlString:urlStr dictionaryData:postData];
}

-(void) dataFromWebReceivedSuccessfully:(id) responseObj
{
    [SVProgressHUD dismiss];
    self.view.userInteractionEnabled = YES;
    if(self.myWebService.requestType == HTTPRequestTypeAssociatePharmacy)
    {
        NSLog(@"%@",responseObj);
        [User_Details sharedInstance].referenceAppUserPharmacyId = @"1234";
        [[NSUserDefaults standardUserDefaults] setObject:[User_Details sharedInstance].referenceAppUserPharmacyId forKey:@"referenceAppUserPharmacyId"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [self.slideMenuSharedManager createLeftGeneralSlideMenu];
        [self changeHomePage];
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

-(void) changeHomePage {
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *rootView = [UIViewController new];
    rootView = [sb instantiateViewControllerWithIdentifier:@"pharmaciaHome"];
    NavigationController *navigationController = [[NavigationController alloc] initWithRootViewController:rootView];
    navigationController.navigationBarHidden = YES;
    MainViewController *mainViewController = [MainViewController new];
    mainViewController.rootViewController = navigationController;
    mainViewController.leftViewController = [sb instantiateViewControllerWithIdentifier:@"leftMenu"];
    mainViewController.rightViewController = [sb instantiateViewControllerWithIdentifier:@"rightMenu"];
    mainViewController.leftViewBackgroundColor = [UIColor whiteColor];
    mainViewController.rightViewBackgroundColor = [UIColor whiteColor];
    mainViewController.leftViewWidth = 200.0;
    mainViewController.rightViewWidth = 200.0;
    mainViewController.swipeGestureArea = LGSideMenuSwipeGestureAreaFull;
    mainViewController.leftViewPresentationStyle = LGSideMenuPresentationStyleSlideAbove;
    mainViewController.rightViewPresentationStyle = LGSideMenuPresentationStyleSlideAbove;
    
    UIWindow *window = UIApplication.sharedApplication.delegate.window;
    window.rootViewController = mainViewController;
    
    [UIView transitionWithView:window
                      duration:0.3
                       options:UIViewAnimationOptionTransitionCrossDissolve
                    animations:nil
                    completion:nil];
}




- (IBAction)backButtonAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)rightSlideMenuAction:(id)sender {
    self.sideMenuController.rightViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"rightMenu"];
    [self.sideMenuController showRightViewAnimated:YES completionHandler:nil];
}

- (IBAction)PharmacyListBottomTabButtonAction:(UIButton *)sender {
    [[User_Details sharedInstance]makePushOrPopForBottomTabMenuToNavigationStack:self.navigationController forTag:sender.tag];
}

- (void)didHideRightView:(nonnull UIView *)rightView sideMenuController:(nonnull LGSideMenuController *)sideMenuController {
    if (self.slideMenuSharedManager.isListSelected) {
        self.pharmacyListTableview.hidden = NO;
        self.mapView.hidden = YES;
        self.orientationHeaderLabel.text = @"VISTA ELENCO";
    }
    else {
        self.pharmacyListTableview.hidden = YES;
        self.mapView.hidden = NO;
        self.orientationHeaderLabel.text = @"VISTA MAPPA";
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

- (IBAction)leftMenuButtonAction:(id)sender {
}

-(void) AssociateFromMapButtonAction:(UIButton *)sender {
    NSLog(@"id is %@", [[self.pharmacyArray objectAtIndex:sender.tag - 1000] valueForKey:@"pharmacyId"]);
}


@end

//@implementation DXAnnotation
//
//@end

