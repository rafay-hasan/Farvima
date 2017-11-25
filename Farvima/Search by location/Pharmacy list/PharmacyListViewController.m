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

@interface PharmacyListViewController () <UITableViewDelegate,UITableViewDataSource>

@property (strong,nonatomic) FarmVimaSlideMenuSingletone *slideMenuSharedManager;

- (IBAction)backButtonAction:(id)sender;
- (IBAction)rightSlideMenuAction:(id)sender;


@end

@implementation PharmacyListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self resetSlideRightmenu];
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
    return 15;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PharmacyListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PharmacyListCell" forIndexPath:indexPath];
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
@end
