//
//  AllOfersViewController.m
//  Farvima
//
//  Created by Rafay Hasan on 26/2/18.
//  Copyright © 2018 Rafay Hasan. All rights reserved.
//

#import "AllOfersViewController.h"
#import "SearchResultTableViewCell.h"
#import "SearchResultCollectionViewCell.h"
#import "UIViewController+LGSideMenuController.h"
#import "User Details.h"
#import "RHWebServiceManager.h"
#import "ProductSearchViewController.h"
#import "OrderDetailsViewController.h"
#import "SVProgressHUD.h"
#import "OfferTypeObject.h"
#import "SearchProductDetailsViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "FarmVimaSlideMenuSingletone.h"

@interface AllOfersViewController ()<RHWebServiceDelegate,UITableViewDelegate,UITableViewDataSource,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,LGSideMenuControllerDelegate>

@property (strong, nonatomic) FarmVimaSlideMenuSingletone *slideMenuSharedManager;
@property (strong,nonatomic) OfferTypeObject *productObject;
@property (strong,nonatomic) RHWebServiceManager *myWebService;
@property (strong,nonatomic) NSMutableArray *offerArray;
@property (strong,nonatomic) NSMutableArray *categoryMenuArray,*categoryMenuIdArray;
@property (nonatomic) BOOL generalLeftMenuSelected;
@property (strong,nonatomic) NSString *selectedCategoryId;
@property (strong,nonatomic) NSString *currentlySelected;
- (IBAction)productSearchButtonAction:(id)sender;
- (IBAction)busketButtonAction:(id)sender;
- (IBAction)ledtGeneralSlideButtonAction:(id)sender;
- (IBAction)leftSpecialCategoryButtonAction:(id)sender;
- (IBAction)rightSlideButtonAction:(id)sender;

- (IBAction)backButtonAction:(id)sender;
@property (weak, nonatomic) IBOutlet UITableView *offerTypeTableview;
@property (weak, nonatomic) IBOutlet UICollectionView *offerTypeCollectionview;
- (IBAction)allOfferBottomTabButtonAction:(UIButton *)sender;

@property (weak, nonatomic) IBOutlet UILabel *categoryLabel;


@end

@implementation AllOfersViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.currentlySelected = [NSString new];
    [self resetSlideRightmenuForSearchResultPage];
    self.offerTypeTableview.hidden = NO;
    self.offerTypeCollectionview.hidden = YES;
    self.selectedCategoryId = @"";
    self.categoryMenuArray = [NSMutableArray new];
    self.categoryMenuIdArray = [NSMutableArray new];
    self.offerArray = [NSMutableArray new];
    [self CallSlideMenuCategoryWebservice];
}

-(void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.sideMenuController.delegate = self;
    self.currentlySelected = @"All Offer";
}


- (void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:YES];
    self.sideMenuController.rightViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"rightMenu"];
    self.sideMenuController.leftViewSwipeGestureEnabled = NO;
    self.sideMenuController.rightViewSwipeGestureEnabled = YES;
}


-(void) viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    self.sideMenuController.leftViewSwipeGestureEnabled = YES;
    self.sideMenuController.rightViewSwipeGestureEnabled = NO;
    [self.slideMenuSharedManager createLeftGeneralSlideMenu];
    self.sideMenuController.leftViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"leftMenu"];
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

- (IBAction)productSearchButtonAction:(id)sender {
    ProductSearchViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"productSearch"];
    if (![self isControllerAlreadyOnNavigationControllerStack:vc]) {
        //push controller
        [self.navigationController pushViewController:vc animated:YES];
        
    }
}

- (IBAction)busketButtonAction:(id)sender {
    OrderDetailsViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"confirmOrder"];
    if (![self isControllerAlreadyOnNavigationControllerStack:vc]) {
        //push controller
        [self.navigationController pushViewController:vc animated:YES];
        
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

- (IBAction)ledtGeneralSlideButtonAction:(id)sender {
    self.generalLeftMenuSelected = YES;
    [self.slideMenuSharedManager createLeftGeneralSlideMenu];
    self.sideMenuController.leftViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"leftMenu"];
    [[self sideMenuController] showLeftViewAnimated:sender];
}

- (IBAction)leftSpecialCategoryButtonAction:(id)sender {
    self.generalLeftMenuSelected = NO;
    [self.slideMenuSharedManager createLeftGeneralSPpelizedSlideMenuWithArray:self.categoryMenuArray];
    self.sideMenuController.leftViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"leftMenu"];
    [[self sideMenuController] showLeftViewAnimated:sender];
}

- (IBAction)rightSlideButtonAction:(id)sender {
    [self.sideMenuController showRightViewAnimated:YES completionHandler:nil];
}

- (IBAction)backButtonAction:(id)sender {
    self.sideMenuController.leftViewSwipeGestureEnabled = NO;
    self.sideMenuController.rightViewSwipeGestureEnabled = YES;
    [self.slideMenuSharedManager createLeftGeneralSlideMenu];
    self.sideMenuController.leftViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"leftMenu"];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)willShowLeftView:(nonnull UIView *)leftView sideMenuController:(nonnull LGSideMenuController *)sideMenuController {
    [User_Details sharedInstance].currentlySelectedLeftSlideMenu = @"";
}

- (void)didHideLeftView:(nonnull UIView *)leftView sideMenuController:(nonnull LGSideMenuController *)sideMenuController {
    if ([User_Details sharedInstance].currentlySelectedLeftSlideMenu.length > 0) {
        if (self.generalLeftMenuSelected) {
            self.categoryLabel.text = @"TUTTE LE CATEGORIE";
            [[User_Details sharedInstance] makePushOrPopViewControllertoNavigationStack:self.navigationController];
            self.currentlySelected = @"All Offer";
        }
        else {
            self.categoryLabel.text = [User_Details sharedInstance].currentlySelectedLeftSlideMenu;
            for (id object in self.categoryMenuIdArray) {
                if ([[object valueForKey:@"descrizione"] isEqualToString:[User_Details sharedInstance].currentlySelectedLeftSlideMenu]) {
                    self.selectedCategoryId = [object valueForKey:@"codice_categoria"];
                    [self.offerArray removeAllObjects];
                    self.currentlySelected = @"Category Offer";
                    [self CallCategoryOfferWebservicewithCategoryId:self.selectedCategoryId];
                    break;
                }
            }
        }
    }
}

- (void)didHideRightView:(nonnull UIView *)rightView sideMenuController:(nonnull LGSideMenuController *)sideMenuController {
    if (self.slideMenuSharedManager.isListSelected) {
        self.offerTypeTableview.hidden = NO;
        self.offerTypeCollectionview.hidden = YES;
    }
    else {
        self.offerTypeTableview.hidden = YES;
        self.offerTypeCollectionview.hidden = NO;
    }
}

-(void) resetSlideRightmenuForSearchResultPage {
    self.slideMenuSharedManager = [FarmVimaSlideMenuSingletone sharedManager];
    [self.slideMenuSharedManager.rightSideMenuArray removeAllObjects];
    [self.slideMenuSharedManager.rightSideMenuArray addObject:@"VISTA ELENCO"];
    [self.slideMenuSharedManager.rightSideMenuArray addObject:@"VISTA GRIGLIA"];
    self.slideMenuSharedManager.isListSelected = YES;
    self.sideMenuController.delegate = self;
}

#pragma mark All Web service

-(void) CallCategoryOfferWebservicewithCategoryId:(NSString *)categoryId
{
    [SVProgressHUD show];
    self.view.userInteractionEnabled = NO;
    NSString *startingLimit = [NSString stringWithFormat:@"%li",self.offerArray.count];
    NSString *urlStr = [NSString stringWithFormat:@"%@%@%@/%@/%@",BASE_URL_API,CategoryOfferProducts_URL_API,[[NSUserDefaults standardUserDefaults] valueForKey:@"appUserId"],categoryId,startingLimit];
    self.myWebService = [[RHWebServiceManager alloc]initWebserviceWithRequestType:HTTPRequestTypeCategoryOfferProducts Delegate:self];
    [self.myWebService getDataFromWebURLWithUrlString:urlStr];
    
}

-(void) CallSlideMenuCategoryWebservice
{
    [SVProgressHUD show];
    self.view.userInteractionEnabled = NO;
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",BASE_URL_API,SideMenuCategories_URL_API];
    self.myWebService = [[RHWebServiceManager alloc]initWebserviceWithRequestType:HTTPRequestTypeSlideMenuCategory Delegate:self];
    [self.myWebService getDataFromWebURLWithUrlString:urlStr];
}

-(void) CallAllOfferWebservice
{
    [SVProgressHUD show];
    self.myWebService = [[RHWebServiceManager alloc]initWebserviceWithRequestType:HTTPRequestTypeAllOffer Delegate:self];
    NSString *startingLimit = [NSString stringWithFormat:@"%li",self.offerArray.count];
    NSString *urlString = [NSString stringWithFormat:@"%@/%@",self.offerUrlString,startingLimit];
    [self.myWebService getDataFromWebURLWithUrlString:urlString];
}

-(void) dataFromWebReceivedSuccessfully:(id) responseObj
{
    [SVProgressHUD dismiss];
    self.view.userInteractionEnabled = YES;
    if(self.myWebService.requestType == HTTPRequestTypeAllOffer || self.myWebService.requestType == HTTPRequestTypeCategoryOfferProducts)
    {
        [self.offerArray addObjectsFromArray:(NSArray *)responseObj];
        [self.offerTypeTableview reloadData];
        [self.offerTypeCollectionview reloadData];
    }
    else if(self.myWebService.requestType == HTTPRequestTypeSlideMenuCategory)
    {
        NSArray *tempArray = (NSArray *)responseObj;
        NSSortDescriptor *sortDescriptor;
        sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"posizione"
                                                     ascending:YES];
        NSArray *sortedArray = [tempArray sortedArrayUsingDescriptors:@[sortDescriptor]];
        for (id object in sortedArray) {
            [self.categoryMenuArray addObject:[object valueForKey:@"descrizione"]];
            [self.categoryMenuIdArray addObject:object];
        }
        [self CallAllOfferWebservice];
    }
}

-(void) dataFromWebReceiptionFailed:(NSError*) error
{
    if(self.myWebService.requestType == HTTPRequestTypeSlideMenuCategory)
    {
        [self CallAllOfferWebservice];
    }
    else {
        [self.offerTypeTableview reloadData];
        [self.offerTypeCollectionview reloadData];
        [SVProgressHUD dismiss];
        self.view.userInteractionEnabled = YES;
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"Message", Nil) message:error.localizedDescription preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            [alert dismissViewControllerAnimated:YES completion:nil];
        }];
        [alert addAction:ok];
        [self presentViewController:alert animated:YES completion:nil];
    }
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.offerArray.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SearchResultTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"allPdfAndOfferCell" forIndexPath:indexPath];
    self.productObject = [self.offerArray objectAtIndex:indexPath.section];
    //self.productObject.imageUel = [self.productObject.imageUel re]
    if (self.productObject.imageUel.length > 0) {
        [cell.productImageView sd_setImageWithURL:[NSURL URLWithString:self.productObject.imageUel]
                                 placeholderImage:[UIImage imageNamed:@"placeholder"]];
    }
    else {
        cell.productImageView.image = [UIImage imageNamed:@"placeholder"];
    }
    
    if (self.productObject.name.length > 0) {
        cell.productNameLabel.text = self.productObject.name;
    }
    else {
        cell.productNameLabel.text = nil;
    }
    
    if (self.productObject.price.length > 0) {
        cell.productPriceLabel.text = self.productObject.price;
    }
    else {
        cell.productPriceLabel.text = nil;
    }
    
    if([self.productObject.pharmacyCategoryType isEqualToString:@"farmacia logo"]) {
        cell.categoryTypeImage.image = [UIImage imageNamed:@"farmacia logo"];
    }
    else {
        cell.categoryTypeImage.image = [UIImage imageNamed:@"farma logo"];
    }
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    SearchProductDetailsViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"productDetails"];
    vc.productObject = [self.offerArray objectAtIndex:indexPath.section];
    [self.navigationController pushViewController:vc animated:YES];
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UIView *headerView = [[UIView alloc] init];
    headerView.backgroundColor = [UIColor clearColor];
    return headerView;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *footerView = [[UIView alloc] init];
    footerView.backgroundColor = [UIColor colorWithRed:145.0/255.0 green:146.0/255.0 blue:147.0/255.0 alpha:1];
    return footerView;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.offerArray.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    SearchResultCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"offerTypeListCell" forIndexPath:indexPath];
    self.productObject = [self.offerArray objectAtIndex:indexPath.row];
    if (self.productObject.imageUel.length > 0) {
        [cell.productImageView sd_setImageWithURL:[NSURL URLWithString:self.productObject.imageUel]
                                 placeholderImage:[UIImage imageNamed:@"placeholder"]];
    }
    else {
        cell.productImageView.image = [UIImage imageNamed:@"placeholder"];
    }
    
    if (self.productObject.name.length > 0) {
        cell.nameLabel.text = self.productObject.name;
    }
    else {
        cell.nameLabel.text = nil;
    }
    
    if (self.productObject.price.length > 0) {
        cell.priceLabel.text = self.productObject.price;
    }
    else {
        cell.priceLabel.text = nil;
    }
    
    if([self.productObject.pharmacyCategoryType isEqualToString:@"farmacia logo"]) {
        cell.categoryImageview.image = [UIImage imageNamed:@"farmacia logo"];
    }
    else {
        cell.categoryImageview.image = [UIImage imageNamed:@"farma logo"];
    }
    cell.backgroundColor = [UIColor clearColor];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    SearchProductDetailsViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"productDetails"];
    vc.productObject = [self.offerArray objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:vc animated:YES];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger size = (int)[[UIScreen mainScreen] nativeBounds].size.height;
    if (size == 1136) {
        //printf("iPhone 5 or 5S or 5C");
        return CGSizeMake(110, 170);
    }
    else if (size == 1334) {
        //printf("iPhone 6/6S/7/8");
        return CGSizeMake(110, 170);
    }
    else if (size == 2208) {
        // printf("iPhone 6+/6S+/7+/8+");
        return CGSizeMake(110, 170);
    }
    else if (size == 2436) {
        //printf("iPhone X");
        return CGSizeMake(110, 170);
    }
    else {
        //printf("unknown");
        return CGSizeMake(110, 170);
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

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    
    NSInteger currentOffset = scrollView.contentOffset.y;
    NSInteger maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height;
    if (maximumOffset - currentOffset <= -40) {
        if ([self.currentlySelected isEqualToString:@"All Offer"]) {
            [self CallAllOfferWebservice];
        }
        else if ([self.currentlySelected isEqualToString:@"Category Offer"]) {
            [self CallCategoryOfferWebservicewithCategoryId:self.selectedCategoryId];
        }
        
    }
}


- (IBAction)allOfferBottomTabButtonAction:(UIButton *)sender {
    [[User_Details sharedInstance]makePushOrPopForBottomTabMenuToNavigationStack:self.navigationController forTag:sender.tag];
}
@end
