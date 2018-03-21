//
//  ProfileViewController.m
//  Farvima
//
//  Created by Rafay Hasan on 12/3/18.
//  Copyright © 2018 Rafay Hasan. All rights reserved.
//

#import "ProfileViewController.h"
#import "User Details.h"
#import "ProfileTableViewCell.h"
#import "UIViewController+LGSideMenuController.h"

@interface ProfileViewController ()<UITableViewDataSource,UITableViewDelegate,LGSideMenuControllerDelegate>

@property (strong,nonatomic) NSMutableDictionary *profileDic;
@property (strong,nonatomic) NSArray *profileArray;
@property (weak, nonatomic) IBOutlet UITableView *profileTableview;

- (IBAction)backButtonAction:(id)sender;
- (IBAction)profilePageBottomTabButtonAction:(UIButton *)sender;
- (IBAction)leftMenySlideButtonAction:(id)sender;

@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.profileDic = [NSMutableDictionary dictionary];
    [self.profileDic setObject:@"Test Username" forKey:@"Username:"];
    [self.profileDic setObject:@"Test name" forKey:@"Nome:"];
    [self.profileDic setObject:@"Test Cogname" forKey:@"Cognome:"];
    [self.profileDic setObject:@"15-0--1991" forKey:@"Data di nascita:"];
    [self.profileDic setObject:@"test@gmail.com" forKey:@"Email:"];
    [self.profileDic setObject:@"Via pentani,3,Perugia" forKey:@"Indirizzo:"];
    [self.profileDic setObject:@"+39 348 9194413" forKey:@"Telefono:"];
    self.profileArray = [NSArray arrayWithObjects:@"Username:",@"Nome:",@"Cognome:",@"Data di nascita:",@"Email:",@"Indirizzo:",@"Telefono:", nil];
    [self.profileTableview reloadData];
}

-(void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.sideMenuController.delegate = self;
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

- (IBAction)backButtonAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)profilePageBottomTabButtonAction:(UIButton *)sender {
    [[User_Details sharedInstance] makePushOrPopForBottomTabMenuToNavigationStack:self.navigationController forTag:sender.tag];
}

- (IBAction)leftMenySlideButtonAction:(id)sender {
    [[self sideMenuController] showLeftViewAnimated:sender];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.profileArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ProfileTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"profileCell" forIndexPath:indexPath];
    cell.keyLabel.text = [self.profileArray objectAtIndex:indexPath.row];
    cell.valueLabel.text = [self.profileDic valueForKey:[self.profileArray objectAtIndex:indexPath.row]];
    if (indexPath.row == 2) {
        cell.dividerView.backgroundColor = [UIColor colorWithRed:145.0/255.0 green:146.0/255.0 blue:147.0/255.0 alpha:1];
    }
    else {
        cell.dividerView.backgroundColor = [UIColor whiteColor];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
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

- (void)willShowLeftView:(nonnull UIView *)leftView sideMenuController:(nonnull LGSideMenuController *)sideMenuController {
    [User_Details sharedInstance].appUserId = @"";
}

- (void)didHideLeftView:(nonnull UIView *)leftView sideMenuController:(nonnull LGSideMenuController *)sideMenuController {
    [[User_Details sharedInstance] makePushOrPopViewControllertoNavigationStack:self.navigationController];
}

@end
