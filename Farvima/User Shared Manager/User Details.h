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
@property (strong,nonatomic) NSString *appUserId,*pharmacyId,*referenceAppUserPharmacyId,*currentlySelectedLeftSlideMenu;
+ (User_Details *) sharedInstance;
-(void) makeSaltaButtonAction;
@end
