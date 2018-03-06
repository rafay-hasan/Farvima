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
#import "CustomAnnotation.h"
#import "PharmaciaMapInfoPopOverViewController.h"
#import <MapKit/MapKit.h>
#import <MessageUI/MessageUI.h>

@interface FarmaciaViewController ()<RHWebServiceDelegate,MKMapViewDelegate,InfoPopOverDelegate,UIPopoverPresentationControllerDelegate,MFMailComposeViewControllerDelegate>

@property(nonatomic,retain)UIPopoverPresentationController *dateTimePopover8;
@property (weak, nonatomic) IBOutlet UIButton *infoButton;
@property (strong,nonatomic) RHWebServiceManager *myWebService;
@property (strong,nonatomic) PharmacyObject *pharmacy;
@property (strong,nonatomic) EventObject *eventObject;
- (IBAction)backButtonAction:(id)sender;
@property (weak, nonatomic) IBOutlet UITableView *pharmacyEventTable;
@property (weak, nonatomic) IBOutlet MKMapView *pharmacyMapview;
- (IBAction)FarmaciaInfoPageBottomTabMenuButtonAction:(UIButton *)sender;


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


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    NSString *identifier = segue.identifier;
    if ([identifier isEqualToString:@"mapPopOver"]) {
        PharmaciaMapInfoPopOverViewController *dvc = segue.destinationViewController;
        dvc.object = self.pharmacy;
        dvc.delegate = self;
        dvc.preferredContentSize = CGSizeMake(220.0, 116.0);
        UIPopoverPresentationController *ppc = dvc.popoverPresentationController;
        if (ppc) {
            if ([sender isKindOfClass:[UIButton class]]) { // Assumes the popover is being triggered by a UIButton
                ppc.sourceView = (UIButton *)sender;
                ppc.sourceRect = [(UIButton *)sender bounds];
            }
            ppc.delegate = self;
        }
    }
    
//    if ([segue.identifier isEqualToString:@"mapPopOver"]) {
//        UIViewController *dvc = segue.destinationViewController;
//        UIPopoverPresentationController *controller = dvc.popoverPresentationController;
//        if (controller) {
//            controller.delegate = self;
//        }
//    }
}


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
    
    CustomAnnotation *annotation = [CustomAnnotation new];
    annotation.coordinate = CLLocationCoordinate2DMake([self.pharmacy.latitude doubleValue], [self.pharmacy.longlititude doubleValue]);
    [self.pharmacyMapview addAnnotation:annotation];
    
    annotation.coordinate = CLLocationCoordinate2DMake([self.pharmacy.latitude doubleValue], [self.pharmacy.longlititude doubleValue]);
    MKCoordinateRegion region;
    region.center.latitude = [self.pharmacy.latitude doubleValue];
    region.center.longitude = [self.pharmacy.longlititude doubleValue];
    region.span.latitudeDelta = 0.02f;
    region.span.longitudeDelta = 0.02f;
    region = [self.pharmacyMapview regionThatFits:region];
    [self.pharmacyMapview setRegion:region animated:YES];
    [self.pharmacyMapview setZoomEnabled:YES];
    //[self.pharmacyMapview setRegion:MKCoordinateRegionMakeWithDistance(annotation.coordinate, 10000, 10000)];
    [self.pharmacyMapview setCenterCoordinate:annotation.coordinate animated:YES];
    
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
    static NSString *identifier = @"MyAnnotationView";
    
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
            customPinView.image = [UIImage imageNamed:@"custompin"];
            return customPinView;
        }
        else
        {
            pinView.annotation = annotation;
        }
        
        return pinView;
    }
}

- (void)mapView:(MKMapView *)mapView didAddAnnotationViews:(NSArray *)views {
    MKAnnotationView *aV;
    for (aV in views) {
        CGRect endFrame = aV.frame;
        
        aV.frame = CGRectMake(aV.frame.origin.x, aV.frame.origin.y - 230.0, aV.frame.size.width, aV.frame.size.height);
        
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.45];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
        [aV setFrame:endFrame];
        [UIView commitAnimations];
        
    }
}

-(void)valueSelectedFromOver:(NSUInteger )value {
    if (value == 1002) {
        NSString *phoneNumber = [@"telprompt://" stringByAppendingString:self.pharmacy.phone];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phoneNumber]];
    }
    else if (value == 1003) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString: self.pharmacy.webAddress]];
    }
    else if (value == 1004) {
        [self dismissViewControllerAnimated:YES completion:nil];
        NSArray *toRecipents = [NSArray arrayWithObject:self.pharmacy.emailAddress];
        if ([MFMailComposeViewController canSendMail]){
            MFMailComposeViewController *mc = [[MFMailComposeViewController alloc] init];
            mc.mailComposeDelegate = self;
            [mc setSubject:@""];
            [mc setMessageBody:@"" isHTML:NO];
            [mc setToRecipients:toRecipents];
            
            // Present mail view controller on screen
            [self presentViewController:mc animated:YES completion:NULL];
        }
    }
}
- (UIModalPresentationStyle)adaptivePresentationStyleForPresentationController:(UIPresentationController *)controller {
    
    return UIModalPresentationNone;
}

- (void) mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    switch (result)
    {
        case MFMailComposeResultCancelled:
            NSLog(@"Mail cancelled");
            break;
        case MFMailComposeResultSaved:
            NSLog(@"Mail saved");
            break;
        case MFMailComposeResultSent:
            NSLog(@"Mail sent");
            break;
        case MFMailComposeResultFailed:
            NSLog(@"Mail sent failure: %@", [error localizedDescription]);
            break;
        default:
            break;
    }
    
    // Close the Mail Interface
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (IBAction)FarmaciaInfoPageBottomTabMenuButtonAction:(UIButton *)sender {
    [[User_Details sharedInstance]makePushOrPopForBottomTabMenuToNavigationStack:self.navigationController forTag:sender.tag];
}
@end

