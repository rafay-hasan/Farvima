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
#import "OfferViewController.h"
#import "NewsViewController.h"
#import "SearchResultViewController.h"
#import "EventViewController.h"
#import "GallaryViewController.h"
#import "ChiSiamoViewController.h"
#import "FarmaciaViewController.h"
#import "MessageViewController.h"
#import "NotificationViewController.h"
#import "ChooseYourPharmacyViewController.h"
#import "ProfileViewController.h"

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


-(BOOL)isControllerAlreadyOnNavigationControllerStack:(UIViewController *)targetViewController navigationController:(UINavigationController *)navController{
    for (UIViewController *vc in navController.viewControllers) {
        if ([vc isKindOfClass:targetViewController.class]) {
            [navController popToViewController:vc animated:NO];
            return YES;
        }
    }
    return NO;
}

-(void) makePushOrPopViewControllertoNavigationStack:(UINavigationController *)navigatiionController {
    NSString *menuname = self.currentlySelectedLeftSlideMenu;
    UIStoryboard *mystoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    if ([menuname isEqualToString:@"OFFERTE"]) {
        OfferViewController *vc = [OfferViewController new];
        if (![self isControllerAlreadyOnNavigationControllerStack:vc navigationController:navigatiionController]) {
            OfferViewController *newView = [mystoryboard instantiateViewControllerWithIdentifier:@"offerte"];
            [navigatiionController pushViewController:newView animated:YES];
            
        }
    }
    else if ([menuname isEqualToString:@"NEWS"]) {
        NewsViewController *vc = [NewsViewController new];
        if (![self isControllerAlreadyOnNavigationControllerStack:vc navigationController:navigatiionController]) {
            NewsViewController *newView = [mystoryboard instantiateViewControllerWithIdentifier:@"news"];
            [navigatiionController pushViewController:newView animated:YES];
            
        }
    }
    else if ([menuname isEqualToString:@"PRENOTA E RITIRA"]) {
        SearchResultViewController *vc = [SearchResultViewController new];
        if (![self isControllerAlreadyOnNavigationControllerStack:vc navigationController:navigatiionController]) {
            SearchResultViewController *newView = [mystoryboard instantiateViewControllerWithIdentifier:@"AllProducts"];
            [navigatiionController pushViewController:newView animated:YES];
            
        }
    }
    else if ([menuname isEqualToString:@"EVENTI"]) {
        EventViewController *vc = [EventViewController new];
        if (![self isControllerAlreadyOnNavigationControllerStack:vc navigationController:navigatiionController]) {
            EventViewController *newView = [mystoryboard instantiateViewControllerWithIdentifier:@"event"];
            [navigatiionController pushViewController:newView animated:YES];
            
        }
    }
    else if ([menuname isEqualToString:@"GALERIA"]) {
        GallaryViewController *vc = [GallaryViewController new];
        if (![self isControllerAlreadyOnNavigationControllerStack:vc navigationController:navigatiionController]) {
            GallaryViewController *newView = [mystoryboard instantiateViewControllerWithIdentifier:@"galleria"];
            [navigatiionController pushViewController:newView animated:YES];
            
        }
    }
    else if ([menuname isEqualToString:@"CHI SIAMO"]) {
        ChiSiamoViewController *vc = [ChiSiamoViewController new];
        if (![self isControllerAlreadyOnNavigationControllerStack:vc navigationController:navigatiionController]) {
            ChiSiamoViewController *newView = [mystoryboard instantiateViewControllerWithIdentifier:@"chi Siamo"];
            [navigatiionController pushViewController:newView animated:YES];
            
        }
    }
    else if ([menuname isEqualToString:@"FARMACIA"]) {
        FarmaciaViewController *vc = [FarmaciaViewController new];
        if (![self isControllerAlreadyOnNavigationControllerStack:vc navigationController:navigatiionController]) {
            FarmaciaViewController *newView = [mystoryboard instantiateViewControllerWithIdentifier:@"pharmacy"];
            [navigatiionController pushViewController:newView animated:YES];
            
        }
    }
}

-(void) makePushOrPopForBottomTabMenuToNavigationStack:(UINavigationController *)navigatiionController forTag:(NSInteger )buttonTag {
    UIStoryboard *mystoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *targetViewController = [UIViewController new];
    if(buttonTag == 1001) {
        targetViewController = [mystoryboard instantiateViewControllerWithIdentifier:@"choosePharmacy"];
    }
    else if (buttonTag == 1002) {
        targetViewController = [mystoryboard instantiateViewControllerWithIdentifier:@"messaggi"];
    }
    else if (buttonTag == 1003) {
        targetViewController = [mystoryboard instantiateViewControllerWithIdentifier:@"notification"];
    }
    else if (buttonTag == 1004) {
        targetViewController = [mystoryboard instantiateViewControllerWithIdentifier:@"profile"];
    }
    
    if (![self isControllerAlreadyOnNavigationControllerStack:targetViewController navigationController:navigatiionController]) {
        if (buttonTag == 1001) {
            ChooseYourPharmacyViewController *choosePharmacyView = [mystoryboard instantiateViewControllerWithIdentifier:@"choosePharmacy"];
            [navigatiionController pushViewController:choosePharmacyView animated:YES];
        }
        else if (buttonTag == 1002) {
            MessageViewController *messageView = [mystoryboard instantiateViewControllerWithIdentifier:@"messaggi"];
            [navigatiionController pushViewController:messageView animated:YES];
        }
        else if (buttonTag == 1003) {
            NotificationViewController *notificationView = [mystoryboard instantiateViewControllerWithIdentifier:@"notification"];
            [navigatiionController pushViewController:notificationView animated:YES];
        }
        else if (buttonTag == 1004) {
            ProfileViewController *profileView = [mystoryboard instantiateViewControllerWithIdentifier:@"profile"];
            [navigatiionController pushViewController:profileView animated:YES];
        }
    }
    
}


@end
