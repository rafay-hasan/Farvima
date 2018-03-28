//
//  OfferViewController.h
//  Farvima
//
//  Created by Rafay Hasan on 10/24/17.
//  Copyright © 2017 Rafay Hasan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AllOfferObject.h"

@interface OfferViewController : UIViewController
@property (nonatomic) BOOL fromNotificationPage;
@property (strong,nonatomic) AllOfferObject *offerObject;
@end
