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

@interface SearchResultViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout, LGSideMenuControllerDelegate, UITableViewDataSource, UITableViewDelegate,RHWebServiceDelegate>

@property (strong, nonatomic) FarmVimaSlideMenuSingletone *slideMenuSharedManager;
@property (strong,nonatomic) RHWebServiceManager *myWebService;
@property (strong,nonatomic) NSMutableArray *categoryMenuArray;
- (IBAction)backButtonAction:(id)sender;
- (IBAction)productSearchButtonAction:(id)sender;
- (IBAction)leftSliderButtonAction:(id)sender;
- (IBAction)categoryLeftSlideButtonAction:(id)sender;

@property (weak, nonatomic) IBOutlet UICollectionView *productSearchCollectionView;
- (IBAction)productOrientationButtonAction:(id)sender;
@property (weak, nonatomic) IBOutlet UITableView *searchResultTableview;


@end

@implementation SearchResultViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.searchResultTableview.hidden = NO;
    self.productSearchCollectionView.hidden = YES;
    [self resetSlideRightmenuForSearchResultPage];
    self.categoryMenuArray = [NSMutableArray new];
    [self CallSlideMenuCategoryWebservice];
}

- (void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:YES];
    self.sideMenuController.rightViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"rightMenu"];
    self.sideMenuController.leftViewSwipeGestureEnabled = NO;
    self.sideMenuController.rightViewSwipeGestureEnabled = YES;
}

-(void) viewDidDisappear:(BOOL)animated {
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
    return 15;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SearchResultTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"searchResultCell" forIndexPath:indexPath];
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

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 15;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    SearchResultCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"searchResultCell" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor clearColor];
    return cell;
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



- (IBAction)backButtonAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)productSearchButtonAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)leftSliderButtonAction:(id)sender {
    [self.slideMenuSharedManager createLeftGeneralSlideMenu];
    self.sideMenuController.leftViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"leftMenu"];
    [[self sideMenuController] showLeftViewAnimated:sender];
}

- (IBAction)categoryLeftSlideButtonAction:(id)sender {
    [self.slideMenuSharedManager createLeftGeneralSPpelizedSlideMenuWithArray:self.categoryMenuArray];
    self.sideMenuController.leftViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"leftMenu"];
    [[self sideMenuController] showLeftViewAnimated:sender];
    
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
@end
