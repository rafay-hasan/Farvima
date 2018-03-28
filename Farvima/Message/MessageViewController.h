//
//  MessageViewController.h
//  Farvima
//
//  Created by Rafay Hasan on 10/28/17.
//  Copyright © 2017 Rafay Hasan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MessageObject.h"
@interface MessageViewController : UIViewController

@property (strong,nonatomic) MessageObject *messageObject;
@property (nonatomic) BOOL fromNotificationPage;

@end
