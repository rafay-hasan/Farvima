//
//  User Details.h
//  ReadyTech
//
//  Created by Muhammod Rafay on 3/16/16.
//  Copyright (c) 2016 Rafay. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface User_Details : NSObject
@property (retain,strong) NSString *appUserId,*pharmacyId,*referenceAppUserPharmacyId,*currentlySelectedLeftSlideMenu;
+ (User_Details *) sharedInstance;
-(void) makeSaltaButtonAction;
-(BOOL)isControllerAlreadyOnNavigationControllerStack:(UIViewController *)targetViewController navigationController:(UINavigationController *)navController;
-(void) makePushOrPopViewControllertoNavigationStack:(UINavigationController *)navigatiionController;
-(void) makePushOrPopForBottomTabMenuToNavigationStack:(UINavigationController *)navigatiionController forTag:(NSInteger )buttonTag;
@end
