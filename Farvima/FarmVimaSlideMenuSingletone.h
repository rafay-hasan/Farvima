//
//  FarmVimaSlideMenuSingletone.h
//  Farvima
//
//  Created by Rafay Hasan on 11/22/17.
//  Copyright © 2017 Rafay Hasan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FarmVimaSlideMenuSingletone : NSObject

@property (nonatomic) BOOL isListSelected;
@property (strong,nonatomic) NSMutableArray *rightSideMenuArray;
@property (strong,nonatomic) NSMutableArray *leftSideMenuArray;
+ (id)sharedManager;
-(void) createLeftGeneralSlideMenu;
-(void) createLeftGeneralSPpelizedSlideMenuWithArray:(NSMutableArray *)menuArray;
@end
