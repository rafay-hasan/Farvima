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

@interface PharmacyListViewController () <UITableViewDelegate,UITableViewDataSource,LGSideMenuControllerDelegate>

@property (strong,nonatomic) FarmVimaSlideMenuSingletone *slideMenuSharedManager;
@property (strong, nonatomic) SearchPharmacyObject *object;

- (IBAction)associateButtonAction:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *orientationHeaderLabel;
- (IBAction)backButtonAction:(id)sender;
- (IBAction)rightSlideMenuAction:(id)sender;
@property (weak, nonatomic) IBOutlet UITableView *pharmacyListTableview;
@property (weak, nonatomic) IBOutlet UIView *mapContainerView;

@end

@implementation PharmacyListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.object = [SearchPharmacyObject new];
    self.mapContainerView.hidden = YES;
    self.pharmacyListTableview.hidden = NO;
    [self resetSlideRightmenu];
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
