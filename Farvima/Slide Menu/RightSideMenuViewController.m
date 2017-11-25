//
//  RightSideMenuViewController.m
//  Farvima
//
//  Created by Rafay Hasan on 11/21/17.
//  Copyright © 2017 Rafay Hasan. All rights reserved.
//

#import "RightSideMenuViewController.h"
#import "RightMenuTableViewCell.h"
#import "FarmVimaSlideMenuSingletone.h"

@interface RightSideMenuViewController () <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) FarmVimaSlideMenuSingletone *slideMenuSharedManager;

@property (strong, nonatomic) NSArray *menuArray;

@end

@implementation RightSideMenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.slideMenuSharedManager = [FarmVimaSlideMenuSingletone sharedManager];
    self.menuArray = [[NSArray alloc]initWithArray:self.slideMenuSharedManager.rightSideMenuArray];
    NSLog(@"Menu array is %@",self.menuArray);
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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.menuArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    RightMenuTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"rightMenuCell" forIndexPath:indexPath];
    cell.categoryNameLabel.text = self.menuArray[indexPath.row];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 0) {
        self.slideMenuSharedManager.isListSelected = true;
    }
    else {
        self.slideMenuSharedManager.isListSelected = false;
    }
    NSLog(@"%d",self.slideMenuSharedManager.isListSelected);
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UIView *headerView = [[UIView alloc] init];
    headerView.backgroundColor = [UIColor clearColor];
    return headerView;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *footerView = [[UIView alloc] init];
    footerView.backgroundColor = [UIColor clearColor];
    return footerView;
}



@end
