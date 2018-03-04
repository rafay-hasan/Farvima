//
//  SearchResultViewController.m
//  Farvima
//
//  Created by Rafay Hasan on 10/29/17.
//  Copyright © 2017 Rafay Hasan. All rights reserved.
//

#import "SearchResultViewController.h"
#import "SearchResultCollectionViewCell.h"
#import <LGSideMenuController/UIViewController+LGSideMenuController.h>
#import <LGSideMenuController/LGSideMenuController.h>
#import "FarmVimaSlideMenuSingletone.h"
#import "SearchResultTableViewCell.h"
#import "RHWebServiceManager.h"
#import "SVProgressHUD.h"
#import "User Details.h"
#import "AllProductObject.h"
#import "ProductSearchViewController.h"
#import "SearchProductDetailsViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface SearchResultViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UITableViewDataSource, UITableViewDelegate,RHWebServiceDelegate,ProductSearchControllerDelegate,LGSideMenuControllerDelegate>

@property (strong, nonatomic) FarmVimaSlideMenuSingletone *slideMenuSharedManager;
@property (strong,nonatomic) RHWebServiceManager *myWebService;
@property (strong,nonatomic) NSMutableArray *categoryMenuArray,*categoryMenuIdArray;
@property (strong,nonatomic) NSMutableArray *productsArray;
@property (strong,nonatomic) User_Details *userManager;
@property (strong,nonatomic) AllProductObject *productObject;
@property (nonatomic) BOOL generalLeftMenuSelected;
- (IBAction)backButtonAction:(id)sender;
- (IBAction)productSearchButtonAction:(id)sender;
- (IBAction)leftSliderButtonAction:(id)sender;
- (IBAction)categoryLeftSlideButtonAction:(id)sender;

@property (weak, nonatomic) IBOutlet UICollectionView *productSearchCollectionView;
- (IBAction)productOrientationButtonAction:(id)sender;
@property (weak, nonatomic) IBOutlet UITableView *searchResultTableview;
@property (strong,nonatomic) NSString *currentlySelected;
@property (strong,nonatomic) NSString *selectedCategoryId;


@end

@implementation SearchResultViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.userManager = [User_Details sharedInstance];
    self.productObject = [AllProductObject new];
    self.productsArray = [NSMutableArray new];
    self.currentlySelected = @"";
    self.selectedCategoryId = @"";
    
    self.searchResultTableview.hidden = NO;
    self.productSearchCollectionView.hidden = YES;
    [self resetSlideRightmenuForSearchResultPage];
    self.categoryMenuArray = [NSMutableArray new];
    self.categoryMenuIdArray = [NSMutableArray new];
    [self CallSlideMenuCategoryWebservice];
}

-(void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.sideMenuController.delegate = self;
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


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
//    if ([segue.identifier isEqualToString:@"productDetails"]) {
//        int *index = (int *)sender;
//        SearchProductDetailsViewController *vc = [segue destinationViewController];
//        vc.productObject = [self.productsArray objectAtIndex:index];
//    }
}


-(void) resetSlideRightmenuForSearchResultPage {
    self.slideMenuSharedManager = [FarmVimaSlideMenuSingletone sharedManager];
    [self.slideMenuSharedManager.rightSideMenuArray removeAllObjects];
    [self.slideMenuSharedManager.rightSideMenuArray addObject:@"VISTA ELENCO"];
    [self.slideMenuSharedManager.rightSideMenuArray addObject:@"VISTA GRIGLIA"];
    self.slideMenuSharedManager.isListSelected = YES;
    self.sideMenuController.delegate = self;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.productsArray.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SearchResultTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"searchResultCell" forIndexPath:indexPath];
    self.productObject = [self.productsArray objectAtIndex:indexPath.section];
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
    vc.productObject = [self.productsArray objectAtIndex:indexPath.section];
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
    footerView.backgroundColor = [UIColor colorWithRed:6.0/255.0 green:39.0/255.0 blue:156.0/255.0 alpha:1];
    return footerView;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.productsArray.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    SearchResultCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"searchResultCell" forIndexPath:indexPath];
    self.productObject = [self.productsArray objectAtIndex:indexPath.row];
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
    vc.productObject = [self.productsArray objectAtIndex:indexPath.row];
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

#pragma mark All Web service

-(void) CallCategoryProductsWebservicewithCategoryId:(NSString *)categoryId
{
    [SVProgressHUD show];
    self.view.userInteractionEnabled = NO;
    self.currentlySelected = @"Category Products";
    NSString *startingLimit = [NSString stringWithFormat:@"%li",self.productsArray.count];
    NSString *urlStr = [NSString stringWithFormat:@"%@%@%@/%@/%@",BASE_URL_API,CategoryProducts_URL_API,self.userManager.appUserId,categoryId,startingLimit];
    self.myWebService = [[RHWebServiceManager alloc]initWebserviceWithRequestType:HTTPRequestTypeCategoryProducts Delegate:self];
    [self.myWebService getDataFromWebURLWithUrlString:urlStr];
    
}

-(void) CallAllProductsWebservice
{
    [SVProgressHUD show];
    self.view.userInteractionEnabled = NO;
    self.currentlySelected = @"All Products";
    NSString *startingLimit = [NSString stringWithFormat:@"%li",self.productsArray.count];
    NSString *urlStr = [NSString stringWithFormat:@"%@%@%@/%@",BASE_URL_API,AllProducts_URL_API,self.userManager.appUserId,startingLimit];
    self.myWebService = [[RHWebServiceManager alloc]initWebserviceWithRequestType:HTTPRequestTypeAllProducts Delegate:self];
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

-(void) dataFromWebReceivedSuccessfully:(id) responseObj
{
    [SVProgressHUD dismiss];
    self.view.userInteractionEnabled = YES;
    if(self.myWebService.requestType == HTTPRequestTypeSlideMenuCategory)
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
        NSLog(@"id is %@",self.categoryMenuIdArray);
        [self CallAllProductsWebservice];
    }
    else {
        [self.productsArray addObjectsFromArray:(NSArray *)responseObj];
        [self.searchResultTableview reloadData];
        [self.productSearchCollectionView reloadData];
        NSLog(@"total product count is %lu",(unsigned long)self.productsArray.count);
    }
}

-(void) dataFromWebReceiptionFailed:(NSError*) error
{
    if (self.myWebService.requestType == HTTPRequestTypeSlideMenuCategory) {
        [self CallAllProductsWebservice];
    }
    else {
        [self.searchResultTableview reloadData];
        [self.productSearchCollectionView reloadData];
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



- (IBAction)backButtonAction:(id)sender {
    self.sideMenuController.leftViewSwipeGestureEnabled = NO;
    self.sideMenuController.rightViewSwipeGestureEnabled = YES;
    [self.slideMenuSharedManager createLeftGeneralSlideMenu];
    self.sideMenuController.leftViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"leftMenu"];
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)productSearchButtonAction:(id)sender {
    ProductSearchViewController *newView = [self.storyboard instantiateViewControllerWithIdentifier:@"productSearch"];
    newView.delegate = self;
    [self.navigationController pushViewController:newView animated:YES];
}

- (void)resultOfSearchedData:(NSArray *)dataArray {
    self.currentlySelected = @"";
    [self.productsArray removeAllObjects];
    [self.productsArray addObjectsFromArray:(NSArray *)dataArray];
    for(AllProductObject *object in self.productsArray)
    {
        NSLog(@"name is %@",object.name);
    }
    [self.searchResultTableview reloadData];
    [self.productSearchCollectionView reloadData];
}

- (IBAction)leftSliderButtonAction:(id)sender {
    self.generalLeftMenuSelected = YES;
    [self.slideMenuSharedManager createLeftGeneralSlideMenu];
    self.sideMenuController.leftViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"leftMenu"];
    [[self sideMenuController] showLeftViewAnimated:sender];
}

- (IBAction)categoryLeftSlideButtonAction:(id)sender {
    self.generalLeftMenuSelected = NO;
    [self.slideMenuSharedManager createLeftGeneralSPpelizedSlideMenuWithArray:self.categoryMenuArray];
    self.sideMenuController.leftViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"leftMenu"];
    [[self sideMenuController] showLeftViewAnimated:sender];
}

-(BOOL)isControllerAlreadyOnNavigationControllerStack:(UIViewController *)targetViewController{
    for (UIViewController *vc in self.navigationController.viewControllers) {
        NSLog(@"%@",vc);
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
    NSLog(@"showed");
    NSString *menuname = [User_Details sharedInstance].currentlySelectedLeftSlideMenu;
    
    if (self.generalLeftMenuSelected) {
        [[User_Details sharedInstance] makePushOrPopViewControllertoNavigationStack:self.navigationController];
    }
    else {
        for (id object in self.categoryMenuIdArray) {
            if ([[object valueForKey:@"descrizione"] isEqualToString:[User_Details sharedInstance].currentlySelectedLeftSlideMenu]) {
                self.selectedCategoryId = [object valueForKey:@"codice_categoria"];
                [self.productsArray removeAllObjects];
                [self CallCategoryProductsWebservicewithCategoryId:self.selectedCategoryId];
                break;
            }
        }
    }
}

- (void)didHideRightView:(nonnull UIView *)rightView sideMenuController:(nonnull LGSideMenuController *)sideMenuController {
    if (self.slideMenuSharedManager.isListSelected) {
        self.searchResultTableview.hidden = NO;
        self.productSearchCollectionView.hidden = YES;
    }
    else {
        self.searchResultTableview.hidden = YES;
        self.productSearchCollectionView.hidden = NO;
    }
}
- (IBAction)productOrientationButtonAction:(id)sender {
    [self.sideMenuController showRightViewAnimated:YES completionHandler:nil];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    
    NSInteger currentOffset = scrollView.contentOffset.y;
    NSInteger maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height;
    if (maximumOffset - currentOffset <= -40) {
        if ([self.currentlySelected isEqualToString:@"All Products"]) {
            [self CallAllProductsWebservice];
        }
        else if ([self.currentlySelected isEqualToString:@"Category Products"]) {
            [self CallCategoryProductsWebservicewithCategoryId:self.selectedCategoryId];
        }
        
    }
}

@end
