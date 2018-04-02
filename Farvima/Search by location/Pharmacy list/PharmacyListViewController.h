//
//  PharmacyListViewController.h
//  Farvima
//
//  Created by Rafay Hasan on 11/25/17.
//  Copyright © 2017 Rafay Hasan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SearchPharmacyObject.h"

@interface PharmacyListViewController : UIViewController

@property (strong,nonatomic) NSArray *pharmacyArray;
@property (nonatomic) BOOL forCurrentLocation;

@end
