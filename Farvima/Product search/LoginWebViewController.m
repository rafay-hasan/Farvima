//
//  LoginWebViewController.m
//  Farvima
//
//  Created by Rafay Hasan on 4/2/18.
//  Copyright © 2018 Rafay Hasan. All rights reserved.
//

#import "LoginWebViewController.h"
#import "UIViewController+LGSideMenuController.h"
#import "User Details.h"
#import "SVProgressHUD.h"

@interface LoginWebViewController ()<LGSideMenuControllerDelegate,UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *loginWebview;
- (IBAction)backButtonAction:(id)sender;
- (IBAction)leftSlideButtonAction:(id)sender;
- (IBAction)loginWebviewBottomTabSlideMenuAction:(UIButton *)sender;

@end

@implementation LoginWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

-(void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.sideMenuController.delegate = self;
    self.sideMenuController.rightViewSwipeGestureEnabled = NO;
}

-(void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    NSString *urlString = self.webLinkStr;
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
    [self.loginWebview loadRequest:urlRequest];
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

- (IBAction)leftSlideButtonAction:(id)sender {
     [[self sideMenuController] showLeftViewAnimated:sender];
}

- (IBAction)loginWebviewBottomTabSlideMenuAction:(UIButton *)sender {
     [[User_Details sharedInstance]makePushOrPopForBottomTabMenuToNavigationStack:self.navigationController forTag:sender.tag];
}

- (void)willShowLeftView:(nonnull UIView *)leftView sideMenuController:(nonnull LGSideMenuController *)sideMenuController {
    [User_Details sharedInstance].currentlySelectedLeftSlideMenu = @"";
}

- (void)didHideLeftView:(nonnull UIView *)leftView sideMenuController:(nonnull LGSideMenuController *)sideMenuController {
    if ([User_Details sharedInstance].currentlySelectedLeftSlideMenu.length > 0) {
        [[User_Details sharedInstance] makePushOrPopViewControllertoNavigationStack:self.navigationController];
    }
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
    [SVProgressHUD show];
}
- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [SVProgressHUD dismiss];
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"Message", Nil) message:error.localizedDescription preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
        
        [alert dismissViewControllerAnimated:YES completion:nil];
    }];
    [alert addAction:ok];
    [self presentViewController:alert animated:YES completion:nil];
}


@end
