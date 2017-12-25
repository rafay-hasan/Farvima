//
//  EventDetailsViewController.h
//  Farvima
//
//  Created by Rafay Hasan on 11/7/17.
//  Copyright © 2017 Rafay Hasan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EventObject.h"

@interface EventDetailsViewController : UIViewController

@property (strong,nonatomic) EventObject *object;
- (IBAction)leftMenuButtonAction:(id)sender;

@end
