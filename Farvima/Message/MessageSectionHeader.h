//
//  MessageSectionHeader.h
//  Farvima
//
//  Created by Rafay Hasan on 10/28/17.
//  Copyright © 2017 Rafay Hasan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MessageSectionHeader : UITableViewHeaderFooterView
@property (weak, nonatomic) IBOutlet UIImageView *messageCategoryImageview;

@property (weak, nonatomic) IBOutlet UILabel *categotyNameLabel;

@end
