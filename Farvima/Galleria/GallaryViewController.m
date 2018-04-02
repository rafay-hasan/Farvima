//
//  GallaryViewController.m
//  Farvima
//
//  Created by Rafay Hasan on 10/23/17.
//  Copyright © 2017 Rafay Hasan. All rights reserved.
//

#import "GallaryViewController.h"
#import "RHWebServiceManager.h"
#import "SVProgressHUD.h"
#import "User Details.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "GalleryObject.h"
#import "GallaryCollectionViewCell.h"
#import "UIViewController+LGSideMenuController.h"
#import "GalleryDetailsViewController.h"

@interface GallaryViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,RHWebServiceDelegate,LGSideMenuControllerDelegate>

@property (strong,nonatomic) RHWebServiceManager *myWebService;
@property (strong,nonatomic) GalleryObject *galleryObject;
@property (strong,nonatomic) NSMutableArray *gallaryArray;
@property (weak, nonatomic) IBOutlet UICollectionView *galleryCollectionView;

- (IBAction)backButtonAction:(id)sender;
- (IBAction)leftSliderButtonAction:(id)sender;
- (IBAction)galleryBottomTabMenuButtonAction:(UIButton *)sender;

@end

@implementation GallaryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.galleryObject = [GalleryObject new];
    self.gallaryArray = [NSMutableArray new];
    [self CallGalleryWebservice];
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




#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
}


- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.gallaryArray.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    GallaryCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"gallaryCell" forIndexPath:indexPath];
    self.galleryObject = [self.gallaryArray objectAtIndex:indexPath.row];
    if (self.galleryObject.imageUel.length > 0) {
        [cell.galleryImageView sd_setImageWithURL:[NSURL URLWithString:self.galleryObject.imageUel]
                     placeholderImage:[UIImage imageNamed:@"placeholder"]];
    }
    else {
        cell.galleryImageView.image = nil;
    }
    cell.backgroundColor = [UIColor clearColor];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    self.galleryObject = [self.gallaryArray objectAtIndex:indexPath.row];
    GalleryDetailsViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"galleryDetails"];
    vc.gallery = self.galleryObject;
    [self.navigationController pushViewController:vc animated:YES];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger size = (int)[[UIScreen mainScreen] nativeBounds].size.height;
    NSLog(@"%li",size);
    if (size == 1136) {
        printf("iPhone 5 or 5S or 5C");
        return CGSizeMake(135, 135);
    }
    else if (size == 1334) {
        printf("iPhone 6/6S/7/8");
        return CGSizeMake(155, 155);
    }
    else if (size == 2208) {
        printf("iPhone 6+/6S+/7+/8+");
        return CGSizeMake(170, 170);
    }
    else if (size == 2436) {
        printf("iPhone X");
        return CGSizeMake(160, 160);
    }
    else {
        printf("unknown");
        return CGSizeMake(170, 170);
    }
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section;
{
    return UIEdgeInsetsMake(0, 0, 0, 0);
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 16.0;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 16.0;
}

- (IBAction)backButtonAction:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)leftSliderButtonAction:(id)sender {
    [[self sideMenuController] showLeftViewAnimated:sender];
    
}

- (IBAction)galleryBottomTabMenuButtonAction:(UIButton *)sender {
    [[User_Details sharedInstance]makePushOrPopForBottomTabMenuToNavigationStack:self.navigationController forTag:sender.tag];
}

#pragma mark All Web service

-(void) CallGalleryWebservice
{
    [SVProgressHUD show];
    NSString *startingLimit = [NSString stringWithFormat:@"%li",self.gallaryArray.count];
    NSString *urlStr = [NSString stringWithFormat:@"%@%@%@/%@",BASE_URL_API,Gallery_URL_API,[[NSUserDefaults standardUserDefaults] valueForKey:@"appUserId"],startingLimit];
    self.myWebService = [[RHWebServiceManager alloc]initWebserviceWithRequestType:HTTPRequestTypeGallery Delegate:self];
    [self.myWebService getDataFromWebURLWithUrlString:urlStr];
    
}

-(void) dataFromWebReceivedSuccessfully:(id) responseObj
{
    [SVProgressHUD dismiss];
    self.view.userInteractionEnabled = YES;
    if(self.myWebService.requestType == HTTPRequestTypeGallery)
    {
        [self.gallaryArray addObjectsFromArray:(NSArray *)responseObj];
        
    }
    [self.galleryCollectionView reloadData];
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


- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    
    NSInteger currentOffset = scrollView.contentOffset.y;
    NSInteger maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height;
    if (maximumOffset - currentOffset <= -40) {
        
        [self CallGalleryWebservice];
        
    }
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
