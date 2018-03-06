//
//  OfferViewController.m
//  Farvima
//
//  Created by Rafay Hasan on 10/24/17.
//  Copyright © 2017 Rafay Hasan. All rights reserved.
//

#import "OfferViewController.h"
#import "MessageViewController.h"
#import "NotificationViewController.h"
#import "UIViewController+LGSideMenuController.h"
#import "ProductSearchViewController.h"
#import "User Details.h"
#import "RHWebServiceManager.h"
#import "SVProgressHUD.h"
#import "AllOfferObject.h"
#import "OfferTableViewCell.h"
#import "FileDownloader.h"
#import "AllOfersViewController.h"

@interface OfferViewController ()<UITableViewDelegate,UITableViewDataSource,LGSideMenuControllerDelegate,RHWebServiceDelegate,fileDownloaderDelegate,UIDocumentInteractionControllerDelegate>

@property (weak, nonatomic) IBOutlet UITableView *offerTableview;
@property (weak, nonatomic) IBOutlet UIView *downloaderBgView;
@property (weak, nonatomic) IBOutlet UIView *downloadProgressContainerView;
@property (weak, nonatomic) IBOutlet UILabel *totalFileSizeLabel;
@property (weak, nonatomic) IBOutlet UILabel *downloadedFikeSizeLabel;
@property (weak, nonatomic) IBOutlet UIProgressView *downloadProgressSlider;

@property (strong,nonatomic) FileDownloader *objDownloader;
@property (retain,nonatomic) UIDocumentInteractionController *docController;
@property (strong,nonatomic) RHWebServiceManager *myWebService;
@property (strong,nonatomic) AllOfferObject *offerObject;
@property (strong,nonatomic) NSMutableArray *offerArray;
@property (nonatomic) BOOL downloading;
@property (strong,nonatomic) NSString* selectedDownloadFileName;

- (IBAction)backButtonAction:(id)sender;
- (IBAction)messageButtonAction:(id)sender;
- (IBAction)notificationButtonAction:(id)sender;
- (IBAction)showLeftMenuAction:(id)sender;
- (IBAction)searchProductButtonAction:(id)sender;
- (IBAction)busketButtonAction:(id)sender;
- (IBAction)downloadCancelButtonAction:(id)sender;


@end

@implementation OfferViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.offerTableview.estimatedRowHeight = 90;
    self.offerTableview.rowHeight = UITableViewAutomaticDimension;
    self.offerTableview.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.offerArray = [NSMutableArray new];
    [self CallOfferWebservice];
}

-(void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.sideMenuController.delegate = self;
    self.downloadProgressContainerView.layer.cornerRadius = 3;
    self.downloadProgressContainerView.layer.masksToBounds = YES;
    self.downloaderBgView.hidden = YES;
    self.downloadProgressContainerView.hidden = YES;
    self.downloadProgressSlider.progress = 0.0;
    self.downloading = NO;
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
    
    if ([segue.identifier isEqualToString:@"pdfOffers"]) {
        NSIndexPath *selectedIndexPath = [self.offerTableview indexPathForSelectedRow];
        self.offerObject = [self.offerArray objectAtIndex:selectedIndexPath.row];
        AllOfersViewController *vc = [segue destinationViewController];
        vc.offerUrlString = [NSString stringWithFormat:@"%@%@%@",BASE_URL_API,PDF_OfferList_URL_API,self.offerObject.offerId];
    }
    else if ([segue.identifier isEqualToString:@"allOfer"]) {
        AllOfersViewController *vc = [segue destinationViewController];
        vc.offerUrlString = [NSString stringWithFormat:@"%@%@%@",BASE_URL_API,All_OfferList_URL_API,[User_Details sharedInstance].appUserId];
    }
}


#pragma mark All Web service

-(void) CallOfferWebservice
{
    [SVProgressHUD show];
    NSString *startingLimit = [NSString stringWithFormat:@"%li",self.offerArray.count];
    NSString *urlStr = [NSString stringWithFormat:@"%@%@%@/%@",BASE_URL_API,Offer_URL_API,[User_Details sharedInstance].appUserId,startingLimit];
    self.myWebService = [[RHWebServiceManager alloc]initWebserviceWithRequestType:HTTPRequestTypeOffer Delegate:self];
    [self.myWebService getDataFromWebURLWithUrlString:urlStr];
    
}

-(void) dataFromWebReceivedSuccessfully:(id) responseObj
{
    [SVProgressHUD dismiss];
    self.view.userInteractionEnabled = YES;
    if(self.myWebService.requestType == HTTPRequestTypeOffer)
    {
        [self.offerArray addObjectsFromArray:(NSArray *)responseObj];
    }
    [self.offerTableview reloadData];
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


//- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
//
//    NSInteger currentOffset = scrollView.contentOffset.y;
//    NSInteger maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height;
//    if (maximumOffset - currentOffset <= -40) {
//
//        [self CallGalleryWebservice];
//
//    }
//}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.offerArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    OfferTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"offerCell" forIndexPath:indexPath];
    self.offerObject = [self.offerArray objectAtIndex:indexPath.row];
    cell.pdfTitleLabel.text = self.offerObject.offerTitle;
    cell.categoryTypeImageview.image = [UIImage imageNamed:self.offerObject.offerType];
    cell.dateTimeLabel.text = self.offerObject.endTime;
    cell.downloadBtn.tag = 1000 + indexPath.row;
    [cell.downloadBtn addTarget:self action:@selector(pdfDownloadAction:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(void) pdfDownloadAction :(UIButton *) sender {
    
//    NSString* documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
//    NSString *downloadedFile = [documentsPath stringByAppendingPathComponent:self.selectedDownloadFileName];
//    BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:downloadedFile];
//    if(fileExists)
//    {
//        dispatch_async(dispatch_get_main_queue(), ^{
//            self.docController = [UIDocumentInteractionController interactionControllerWithURL:[NSURL fileURLWithPath:downloadedFile]];
//            self.docController.delegate = self;
//            [self.docController presentOpenInMenuFromRect:CGRectZero inView:self.view animated:YES];
//            });
//    }
//    else {
//        self.offerObject = [self.offerArray objectAtIndex:sender.tag - 1000];
//        self.selectedDownloadFileName = [NSString stringWithFormat:@"%@.pdf",self.offerObject.offerTitle];
//        self.objDownloader = [[FileDownloader alloc] init];
//        [self.objDownloader setDelegate:self];
//        [self.objDownloader downloadFromURL:self.offerObject.offerPdfLink];
//    }
 
    self.offerObject = [self.offerArray objectAtIndex:sender.tag - 1000];
    self.selectedDownloadFileName = [NSString stringWithFormat:@"%@.pdf",self.offerObject.offerTitle];
    self.objDownloader = [[FileDownloader alloc] init];
    [self.objDownloader setDelegate:self];
    [self.objDownloader downloadFromURL:self.offerObject.offerPdfLink];
}

- (IBAction)backButtonAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)messageButtonAction:(id)sender {
    MessageViewController *messageVc = [MessageViewController new];
    if (![self isControllerAlreadyOnNavigationControllerStack:messageVc]) {
        //push controller
        MessageViewController *newView = [self.storyboard instantiateViewControllerWithIdentifier:@"messaggi"];
        [self.navigationController pushViewController:newView animated:YES];
        
    }
}

- (IBAction)notificationButtonAction:(id)sender {
    NotificationViewController *notificationVc = [NotificationViewController new];
    if (![self isControllerAlreadyOnNavigationControllerStack:notificationVc]) {
        //push controller
        NotificationViewController *newView = [self.storyboard instantiateViewControllerWithIdentifier:@"notification"];
        [self.navigationController pushViewController:newView animated:YES];
        
    }
}

- (IBAction)showLeftMenuAction:(id)sender {
    [[self sideMenuController] showLeftViewAnimated:sender];
}

- (IBAction)searchProductButtonAction:(id)sender {
    
    ProductSearchViewController *messageVc = [ProductSearchViewController new];
    if (![self isControllerAlreadyOnNavigationControllerStack:messageVc]) {
        //push controller
        ProductSearchViewController *newView = [self.storyboard instantiateViewControllerWithIdentifier:@"productSearch"];
        [self.navigationController pushViewController:newView animated:YES];
        
    }
}

- (IBAction)busketButtonAction:(id)sender {
}

- (IBAction)downloadCancelButtonAction:(id)sender {
    
    if(self.downloading)
    {
        [self.objDownloader cancelDownload];
        self.downloading = NO;
    }
    
    self.downloaderBgView.hidden = YES;
    self.downloadProgressContainerView.hidden = YES;
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

- (void)willShowLeftView:(nonnull UIView *)leftView sideMenuController:(nonnull LGSideMenuController *)sideMenuController {
    [User_Details sharedInstance].appUserId = @"";
}

- (void)didHideLeftView:(nonnull UIView *)leftView sideMenuController:(nonnull LGSideMenuController *)sideMenuController {
    [[User_Details sharedInstance] makePushOrPopViewControllertoNavigationStack:self.navigationController];
}

#pragma Mark Downloader Delegate methods

- (void)downloadingStarted
{
    self.downloading = YES;
    self.downloaderBgView.hidden = NO;
    self.downloadProgressContainerView.hidden = NO;
    self.downloadProgressSlider.progress = 0.0;
}
- (void)downloadingFinishedFor:(NSURL *)url andData:(NSData *)data
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString  *filePath = [NSString stringWithFormat:@"%@/%@", documentsDirectory,self.selectedDownloadFileName];
    //saving is done on main thread
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [data writeToFile:filePath atomically:YES];
        //[SVProgressHUD dismiss];
        self.downloaderBgView.hidden = YES;
        self.downloadProgressContainerView.hidden = YES;
        self.downloading = NO;
        NSString* documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        NSString *downloadedFile = [documentsPath stringByAppendingPathComponent:self.selectedDownloadFileName];
        BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:downloadedFile];
        if(fileExists)
        {
            self.docController = [UIDocumentInteractionController interactionControllerWithURL:[NSURL fileURLWithPath:downloadedFile]];
            self.docController.delegate = self;
            [self.docController presentOpenInMenuFromRect:CGRectZero inView:self.view animated:YES];
        }
    });
    
    
}
- (void)downloadingFailed:(NSURL *)url
{
    self.downloading = NO;
    self.downloaderBgView.hidden = YES;
    self.downloadProgressContainerView.hidden = YES;
    self.downloadProgressSlider.progress = 0.0;
}

- (void)downloadProgres:(NSNumber *)percent forObject:(id)object totalFileSize:(NSNumber *)fileSize
{
    double fileSizeinMb = [fileSize doubleValue] / (1024.0 * 1024.0);
    double downloadedSizeinMb = [percent doubleValue] / (1024.0 * 1024.0);
    self.downloadedFikeSizeLabel.text = [NSString stringWithFormat:@"%.2lf MB",downloadedSizeinMb];
    self.totalFileSizeLabel.text = [NSString stringWithFormat:@"%.2lf MB",fileSizeinMb];
    float percentt = [percent floatValue] / [fileSize floatValue];
    self.downloadProgressSlider.progress = percentt;
}

- (UIViewController *)documentInteractionControllerViewControllerForPreview:(UIDocumentInteractionController *)controller {
    return  self;
}

- (void)documentInteractionController:(UIDocumentInteractionController *)controller willBeginSendingToApplication:(NSString *)application{
    
    NSLog(@"willBeginSendingToApplication");
}

- (void)documentInteractionController:(UIDocumentInteractionController *)controller didEndSendingToApplication:(NSString *)application{
    NSLog(@"didEndSendingToApplication");
    
}

- (void)documentInteractionControllerDidDismissOpenInMenu:(UIDocumentInteractionController *)controller{
    NSLog(@"documentInteractionControllerDidDismissOpenInMenu");
    
}

@end
