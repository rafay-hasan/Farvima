//
//  FarmVimaSlideMenuSingletone.m
//  Farvima
//
//  Created by Rafay Hasan on 11/22/17.
//  Copyright © 2017 Rafay Hasan. All rights reserved.
//

#import "FarmVimaSlideMenuSingletone.h"
#import "User Details.h"
@implementation FarmVimaSlideMenuSingletone

#pragma mark Singleton Methods

+ (id)sharedManager {
    static FarmVimaSlideMenuSingletone *sharedMyManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyManager = [[self alloc] init];
    });
    return sharedMyManager;
}

- (id)init {
    if (self = [super init]) {
        self.isListSelected = false;
        self.rightSideMenuArray = [NSMutableArray new];
        self.leftSideMenuArray = [NSMutableArray new];
    }
    return self;
}

-(void) createLeftGeneralSlideMenu {
    NSLog(@"%@",[User_Details sharedInstance].appUserId);
    [self.leftSideMenuArray removeAllObjects];
    if ([User_Details sharedInstance].referenceAppUserPharmacyId.length > 0) {
        [self.leftSideMenuArray addObject:@"FARMACIA"];
    }
    else {
        [self.leftSideMenuArray addObject:@"CHI SIAMO"];
    }
    [self.leftSideMenuArray addObject:@"OFFERTE"];
    [self.leftSideMenuArray addObject:@"NEWS"];
    [self.leftSideMenuArray addObject:@"PRENOTA E RITIRA"];
    [self.leftSideMenuArray addObject:@"EVENTI"];
    [self.leftSideMenuArray addObject:@"GALERIA"];
}

-(void) createLeftGeneralSPpelizedSlideMenuWithArray:(NSMutableArray *)menuArray {
    [self.leftSideMenuArray removeAllObjects];
    [self.leftSideMenuArray addObjectsFromArray:menuArray];
    //self.leftSideMenuArray = [self.leftSideMenuArra
//    [self.leftSideMenuArray addObject:@"CATEGORIA 1"];
//    [self.leftSideMenuArray addObject:@"CATEGORIA 2"];
//    [self.leftSideMenuArray addObject:@"CATEGORIA 3"];
//    [self.leftSideMenuArray addObject:@"CATEGORIA 4"];
//    [self.leftSideMenuArray addObject:@"CATEGORIA 5"];
//    [self.leftSideMenuArray addObject:@"CATEGORIA 6"];
}

@end
