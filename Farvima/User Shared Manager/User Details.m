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



@end
