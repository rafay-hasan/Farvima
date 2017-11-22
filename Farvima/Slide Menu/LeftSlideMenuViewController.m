//
//  LeftSlideMenuViewController.m
//  Farvima
//
//  Created by Rafay Hasan on 11/22/17.
//  Copyright © 2017 Rafay Hasan. All rights reserved.
//

#import "LeftSlideMenuViewController.h"
#import "LeftMenuTableViewCell.h"

@interface LeftSlideMenuViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (strong, nonatomic) NSArray *menuArray;

@end

@implementation LeftSlideMenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.menuArray = [[NSArray alloc]initWithObjects:@"CATEGORIA 1", @"CATEGORIA 2", @"CATEGORIA 3", @"CATEGORIA 4", @"CATEGORIA 5",nil];
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
    LeftMenuTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"leftMenuCell" forIndexPath:indexPath];
    cell.categoryNameLabel.text = self.menuArray[indexPath.row];
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
    footerView.backgroundColor = [UIColor clearColor];
    return footerView;
}


@end
