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
#import "RHWebServiceManager.h"
#import "SVProgressHUD.h"
#import "ProfileObject.h"
#import "ProfileEditViewController.h"

@interface ProfileViewController ()<UITableViewDataSource,UITableViewDelegate,LGSideMenuControllerDelegate,RHWebServiceDelegate>

@property (strong,nonatomic) NSMutableDictionary *profileDic;
@property (strong,nonatomic) NSArray *profileArray;
@property (strong,nonatomic) RHWebServiceManager *myWebService;
@property (strong,nonatomic) ProfileObject *profile;

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
    [self.profileDic setObject:@"" forKey:@"Username:"];
    [self.profileDic setObject:@"" forKey:@"Nome:"];
    [self.profileDic setObject:@"" forKey:@"Cognome:"];
    [self.profileDic setObject:@"" forKey:@"Data di nascita:"];
    [self.profileDic setObject:@"" forKey:@"Email:"];
    [self.profileDic setObject:@"" forKey:@"Indirizzo:"];
    [self.profileDic setObject:@"" forKey:@"Telefono:"];
    self.profileArray = [NSArray arrayWithObjects:@"Username:",@"Nome:",@"Cognome:",@"Data di nascita:",@"Email:",@"Indirizzo:",@"Telefono:", nil];
    [self.profileTableview reloadData];
}

-(void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.sideMenuController.delegate = self;
    self.sideMenuController.rightViewSwipeGestureEnabled = NO;
    [self CallProfileWebservice];
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
    if ([segue.identifier isEqualToString:@"profileModification"]) {
        ProfileEditViewController *vc = segue.destinationViewController;
        vc.profile = self.profile;
    }
}


-(void) CallProfileWebservice
{
    [SVProgressHUD show];
    NSString *urlStr = [NSString stringWithFormat:@"%@%@%@",BASE_URL_API,ProfileDetails_URL_API,[[NSUserDefaults standardUserDefaults] valueForKey:@"appUserId"]];
    self.myWebService = [[RHWebServiceManager alloc]initWebserviceWithRequestType:HTTPRequestypeProfileDetails Delegate:self];
    [self.myWebService getDataFromWebURLWithUrlString:urlStr];
    
}

-(void) dataFromWebReceivedSuccessfully:(id) responseObj
{
    [SVProgressHUD dismiss];
    self.view.userInteractionEnabled = YES;
    if(self.myWebService.requestType == HTTPRequestypeProfileDetails)
    {
        self.profile = responseObj;
        [self.profileDic setObject:self.profile.userName forKey:@"Username:"];
        [self.profileDic setObject:self.profile.firstname forKey:@"Nome:"];
        [self.profileDic setObject:self.profile.lastName forKey:@"Cognome:"];
        [self.profileDic setObject:self.profile.birthDate forKey:@"Data di nascita:"];
        [self.profileDic setObject:self.profile.email forKey:@"Email:"];
        [self.profileDic setObject:self.profile.address forKey:@"Indirizzo:"];
        [self.profileDic setObject:self.profile.phone forKey:@"Telefono:"];
    }
    [self.profileTableview reloadData];
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
    [User_Details sharedInstance].currentlySelectedLeftSlideMenu = @"";
}

- (void)didHideLeftView:(nonnull UIView *)leftView sideMenuController:(nonnull LGSideMenuController *)sideMenuController {
    if ([User_Details sharedInstance].currentlySelectedLeftSlideMenu.length > 0) {
        [[User_Details sharedInstance] makePushOrPopViewControllertoNavigationStack:self.navigationController];
    }
}

@end
