//
//  User Details.m
//  ReadyTech
//
//  Created by Muhammod Rafay on 3/16/16.
//  Copyright (c) 2016 Rafay. All rights reserved.
//

#import "User Details.h"
#import "MainViewController.h"
#import "NavigationController.h"
#import "PharmaHomeViewController.h"
#import "FarmaciaHomeViewController.h"


@implementation User_Details

+ (User_Details *) sharedInstance
{
    static dispatch_once_t pred;
    static User_Details *sharedInstance = nil;
    
    dispatch_once(&pred, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

-(id) init
{
    self.appUserId = [NSString new];
    self.pharmacyId = [NSString new];
    self.referenceAppUserPharmacyId = [NSString new];
    self.currentlySelectedLeftSlideMenu = [NSString new];
    return self;
}

-(void) makeSaltaButtonAction
{
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *rootView = [UIViewController new];
    if (self.referenceAppUserPharmacyId.length > 0) {
        rootView = [sb instantiateViewControllerWithIdentifier:@"pharmaciaHome"];
    }
    else {
        rootView = [sb instantiateViewControllerWithIdentifier:@"farmaHome"];
    }
    NavigationController *navigationController = [[NavigationController alloc] initWithRootViewController:rootView];
    navigationController.navigationBarHidden = YES;
    MainViewController *mainViewController = [MainViewController new];
    mainViewController.rootViewController = navigationController;
    // [mainViewController setupWithType];
    mainViewController.leftViewController = [sb instantiateViewControllerWithIdentifier:@"leftMenu"];
    mainViewController.rightViewController = [sb instantiateViewControllerWithIdentifier:@"rightMenu"];
    mainViewController.leftViewBackgroundColor = [UIColor whiteColor];
    mainViewController.rightViewBackgroundColor = [UIColor whiteColor];
    mainViewController.leftViewWidth = 200.0;
    mainViewController.rightViewWidth = 200.0;
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
