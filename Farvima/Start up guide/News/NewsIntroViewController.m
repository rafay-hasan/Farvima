//
//  NewsIntroViewController.m
//  Farvima
//
//  Created by Rafay Hasan on 10/15/17.
//  Copyright © 2017 Rafay Hasan. All rights reserved.
//

#import "NewsIntroViewController.h"
#import "MainViewController.h"
#import "NavigationController.h"
#import "PharmaHomeViewController.h"

@interface NewsIntroViewController ()
- (IBAction)saltaButtonAction:(id)sender;

@end

@implementation NewsIntroViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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

- (IBAction)saltaButtonAction:(id)sender {
    
    PharmaHomeViewController *newView = [self.storyboard instantiateViewControllerWithIdentifier:@"farmaHome"];
    NavigationController *navigationController = [[NavigationController alloc] initWithRootViewController:newView];
    navigationController.navigationBarHidden = YES;
    MainViewController *mainViewController = [MainViewController new];
    mainViewController.rootViewController = navigationController;
    // [mainViewController setupWithType];
    mainViewController.leftViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"leftMenu"];
    mainViewController.rightViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"rightMenu"];
    mainViewController.leftViewBackgroundColor = [UIColor whiteColor];
    mainViewController.rightViewBackgroundColor = [UIColor whiteColor];
    mainViewController.leftViewWidth = 180.0;
    mainViewController.rightViewWidth = 180.0;
    mainViewController.swipeGestureArea = LGSideMenuSwipeGestureAreaFull;
    mainViewController.leftViewPresentationStyle = LGSideMenuPresentationStyleSlideAbove;
    mainViewController.rightViewPresentationStyle = LGSideMenuPresentationStyleSlideAbove;
    
    UIWindow *window = UIApplication.sharedApplication.delegate.window;
    window.rootViewController = mainViewController;
    
    [UIView transitionWithView:window
                      duration:0.3
                       options:UIViewAnimationOptionTransitionCrossDissolve
                    animations:nil
                    completion:nil];
}
@end
