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
#import <MapKit/MapKit.h>

@interface DXAnnotation : NSObject <MKAnnotation>

@property(nonatomic, assign) CLLocationCoordinate2D coordinate;

@end

@interface PharmacyListViewController () <UITableViewDelegate,UITableViewDataSource,LGSideMenuControllerDelegate,MKMapViewDelegate>

@property (strong,nonatomic) FarmVimaSlideMenuSingletone *slideMenuSharedManager;
@property (strong, nonatomic) SearchPharmacyObject *object;

- (IBAction)associateButtonAction:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *orientationHeaderLabel;
- (IBAction)backButtonAction:(id)sender;
- (IBAction)rightSlideMenuAction:(id)sender;
@property (weak, nonatomic) IBOutlet UITableView *pharmacyListTableview;
@property (weak, nonatomic) IBOutlet UIView *mapContainerView;
@property (weak, nonatomic) IBOutlet MKMapView *pharmacyMapView;


@end

@implementation PharmacyListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.object = [SearchPharmacyObject new];
    self.mapContainerView.hidden = YES;
    self.pharmacyListTableview.hidden = NO;
    [self resetSlideRightmenu];
    [self setMapLocation];
    
}

-(void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    NSLog(@"View did appear called");
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
    
    for(SearchPharmacyObject *object in self.pharmacyArray) {
        DXAnnotation *annotation = [DXAnnotation new];
        annotation.coordinate = CLLocationCoordinate2DMake([object.latitude doubleValue], [object.longlitude doubleValue]);
        [self.pharmacyMapView addAnnotation:annotation];
    }
    if(self.pharmacyArray.count > 0)
    {
        DXAnnotation *annotation = [DXAnnotation new];
        SearchPharmacyObject *object = [self.pharmacyArray objectAtIndex:0];
        annotation.coordinate = CLLocationCoordinate2DMake([object.latitude doubleValue], [object.longlitude doubleValue]);
       // [self.pharmacyMapView setRegion:MKCoordinateRegionMakeWithDistance(annotation.coordinate, 10000, 10000)];
        [self.pharmacyMapView setCenterCoordinate:annotation.coordinate animated:YES];
        //[self.pharmacyMapView setZoomEnabled:YES];
    }
    
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
    static NSString *identifier = @"MyAnnotationView";
    
    if ([annotation isKindOfClass:[MKUserLocation class]]) {
        return nil;
    }
    
    MKPinAnnotationView *view = (id)[mapView dequeueReusableAnnotationViewWithIdentifier:identifier];
    if (view) {
        view.annotation = annotation;
    } else {
        view = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifier];
        view.canShowCallout = false;  // note, we're not going to use the system callout
        view.animatesDrop = true;
    }
    
    return view;
}

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view {
//    PopoverController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"AnnotationPopover"];
//    controller.modalPresentationStyle = UIModalPresentationPopover;
//
//    controller.popoverPresentationController.sourceView = view;
//
//    // adjust sourceRect so it's centered over the annotation
//
//    CGRect sourceRect = CGRectZero;
//    sourceRect.origin.x += [mapView convertCoordinate:view.annotation.coordinate toPointToView:mapView].x - view.frame.origin.x;
//    sourceRect.size.height = view.frame.size.height;
//    controller.popoverPresentationController.sourceRect = sourceRect;
//
//    controller.annotation = view.annotation;
//
//    [self presentViewController:controller animated:TRUE completion:nil];
//
//    [mapView deselectAnnotation:view.annotation animated:true];  // deselect the annotation so that when we dismiss the popover, the annotation won't still be selected
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

- (IBAction)backButtonAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)rightSlideMenuAction:(id)sender {
    self.sideMenuController.rightViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"rightMenu"];
    [self.sideMenuController showRightViewAnimated:YES completionHandler:nil];
}

- (void)didHideRightView:(nonnull UIView *)rightView sideMenuController:(nonnull LGSideMenuController *)sideMenuController {
    if (self.slideMenuSharedManager.isListSelected) {
        self.pharmacyListTableview.hidden = NO;
        self.mapContainerView.hidden = YES;
        self.orientationHeaderLabel.text = @"VISTA ELENCO";
    }
    else {
        self.pharmacyListTableview.hidden = YES;
        self.mapContainerView.hidden = NO;
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

- (IBAction)associateButtonAction:(id)sender {
    
    FarmaciaHomeViewController *notificationVc = [FarmaciaHomeViewController new];
    if (![self isControllerAlreadyOnNavigationControllerStack:notificationVc]) {
        //push controller
        FarmaciaHomeViewController *newView = [self.storyboard instantiateViewControllerWithIdentifier:@"pharmaciaHome"];
        [self.navigationController pushViewController:newView animated:YES];
        
    }
}



@end

@implementation DXAnnotation

@end
