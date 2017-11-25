//
//  FarmVimaSlideMenuSingletone.m
//  Farvima
//
//  Created by Rafay Hasan on 11/22/17.
//  Copyright © 2017 Rafay Hasan. All rights reserved.
//

#import "FarmVimaSlideMenuSingletone.h"

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
    }
    return self;
}
@end
