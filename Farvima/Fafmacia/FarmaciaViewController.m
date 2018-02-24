//
//  FarmaciaViewController.m
//  Farvima
//
//  Created by Rafay Hasan on 2/23/18.
//  Copyright © 2018 Rafay Hasan. All rights reserved.
//

#import "FarmaciaViewController.h"
#import "RHWebServiceManager.h"
#import "SVProgressHUD.h"
#import "User Details.h"
#import "PharmacyObject.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "EventObject.h"
#import "EventTableViewCell.h"
#import "UILabel+FormattedText.h"
#import <MapKit/MapKit.h>

@interface DXAnnotation : NSObject <MKAnnotation>

@property(nonatomic, assign) CLLocationCoordinate2D coordinate;
@end


@interface FarmaciaViewController ()<RHWebServiceDelegate,MKMapViewDelegate>

@property (strong,nonatomic) RHWebServiceManager *myWebService;
@property (strong,nonatomic) PharmacyObject *pharmacy;
@property (strong,nonatomic) EventObject *eventObject;
- (IBAction)backButtonAction:(id)sender;
@property (weak, nonatomic) IBOutlet UITableView *pharmacyEventTable;
@property (weak, nonatomic) IBOutlet MKMapView *pharmacyMapview;

@end

@implementation FarmaciaViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self CallPharmacyDetailsWebservice];
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

#pragma mark All Web service

-(void) CallPharmacyDetailsWebservice
{
    [SVProgressHUD show];
    NSString *urlStr = [NSString stringWithFormat:@"%@%@%@",BASE_URL_API,PharmacyDetails_URL_API,[User_Details sharedInstance].appUserId];
    self.myWebService = [[RHWebServiceManager alloc]initWebserviceWithRequestType:HTTPRequestTypePharmacyDetails Delegate:self];
    [self.myWebService getDataFromWebURLWithUrlString:urlStr];
    
}

-(void) dataFromWebReceivedSuccessfully:(id) responseObj
{
    [SVProgressHUD dismiss];
    self.view.userInteractionEnabled = YES;
    if(self.myWebService.requestType == HTTPRequestTypePharmacyDetails)
    {
        self.pharmacy = (PharmacyObject *) responseObj;
        [self.pharmacyEventTable reloadData];
        if (self.pharmacy.latitude.length > 0 && self.pharmacy.longlititude.length > 0)
        {
            [self setMap];
        }
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


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.pharmacy.eventArray.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    EventTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"pharmacyEventCell" forIndexPath:indexPath];
    self.eventObject = [self.pharmacy.eventArray objectAtIndex:indexPath.section];
    
    if (self.eventObject.imageUel.length > 0) {
        [cell.eventImageView sd_setImageWithURL:[NSURL URLWithString:self.eventObject.imageUel]
                               placeholderImage:[UIImage imageNamed:@"placeholder"]];
    }
    else {
        cell.eventImageView.image = nil;
    }
    
    if (self.eventObject.name.length > 0) {
        cell.eventname.text = self.eventObject.name;
    }
    else {
        cell.eventname.text = nil;
    }
    
    if (self.eventObject.referencePharmacyId.length > 0) {
        cell.pharmacyTYpeImageview.image = [UIImage imageNamed:@"farmacia logo"];
    }
    else {
        cell.pharmacyTYpeImageview.image = [UIImage imageNamed:@"farma logo"];
    }
    
    if (self.eventObject.location.length > 0) {
        cell.eventLocation.text = [NSString stringWithFormat:@"presso %@",self.eventObject.location];
        [cell.eventLocation setTextColor:[UIColor colorWithRed:40.0/255.0 green:67.0/255.0 blue:135.0/255.0 alpha:1] String:@"presso "];
        [cell.eventLocation setFont:[UIFont systemFontOfSize:15 weight:UIFontWeightSemibold] afterOccurenceOfString:@"presso "];
        [cell.eventLocation setTextColor:[UIColor colorWithRed:0.0/255.0 green:41.0/255.0 blue:128.0/255.0 alpha:1] String:self.eventObject.location];
        [cell.eventLocation setFont:[UIFont preferredFontForTextStyle:UIFontTextStyleCaption1] beforeOccurenceOfString:self.eventObject.location];
        
    }
    else {
        cell.eventLocation.text = @"presso ";
    }
    
    if (self.eventObject.locationDate.length > 0) {
        cell.eventDate.text = [NSString stringWithFormat:@"data %@",self.eventObject.locationDate];
        [cell.eventDate setTextColor:[UIColor colorWithRed:40.0/255.0 green:67.0/255.0 blue:135.0/255.0 alpha:1] String:@"data "];
        [cell.eventDate setFont:[UIFont systemFontOfSize:15 weight:UIFontWeightSemibold] afterOccurenceOfString:@"data "];
        [cell.eventDate setTextColor:[UIColor colorWithRed:0.0/255.0 green:41.0/255.0 blue:128.0/255.0 alpha:1] String:self.eventObject.locationDate];
        [cell.eventDate setFont:[UIFont preferredFontForTextStyle:UIFontTextStyleCaption1] beforeOccurenceOfString:self.eventObject.locationDate];
        
    }
    else {
        cell.eventDate.text = @"data ";
    }
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self performSegueWithIdentifier:@"pharmacyEventDetails" sender:indexPath];
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UIView *headerView = [[UIView alloc] init];
    headerView.backgroundColor = [UIColor clearColor];
    return headerView;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *footerView = [[UIView alloc] init];
    if (section == self.pharmacy.eventArray.count) {
        footerView.backgroundColor = [UIColor clearColor];
    }
    else {
        footerView.backgroundColor = [UIColor colorWithRed:11.0/255.0 green:72.0/255.0 blue:155.0/255.0 alpha:1];
    }
    return footerView;
}

- (void) setMap {
    
    DXAnnotation *annotation = [DXAnnotation new];
    annotation.coordinate = CLLocationCoordinate2DMake([self.pharmacy.latitude doubleValue], [self.pharmacy.longlititude doubleValue]);
    [self.pharmacyMapview addAnnotation:annotation];
    
    annotation.coordinate = CLLocationCoordinate2DMake([self.pharmacy.latitude doubleValue], [self.pharmacy.longlititude doubleValue]);
    [self.pharmacyMapview setRegion:MKCoordinateRegionMakeWithDistance(annotation.coordinate, 10000, 10000)];
    [self.pharmacyMapview setCenterCoordinate:annotation.coordinate animated:YES];
    
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
    static NSString *identifier = @"MyAnnotationView";
    
//    if ([annotation isKindOfClass:[MKUserLocation class]]) {
//        return nil;
//    }
//
//    MKPinAnnotationView *view = (id)[mapView dequeueReusableAnnotationViewWithIdentifier:identifier];
//    if (view) {
//        view.annotation = annotation;
//    } else {
//        view = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifier];
//        view.canShowCallout = false;  // note, we're not going to use the system callout
//        view.animatesDrop = true;
//    }
//
//    return view;
    
    if ([annotation isKindOfClass:[MKUserLocation class]]) {
        return nil;
    }
    else
    {
        MKAnnotationView *pinView = (MKAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:identifier];
        if (!pinView)
        {
            // if an existing pin view was not available, create one
            MKAnnotationView *customPinView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"annot"];
            customPinView.image = [UIImage imageNamed:@"customPin"];
            
            return customPinView;
        }
        else
        {
            pinView.annotation = annotation;
        }
        
        return pinView;
    }
    
    
}




@end

@implementation DXAnnotation

@end

