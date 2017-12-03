//
//  EventTableViewCell.h
//  Farvima
//
//  Created by Rafay Hasan on 10/28/17.
//  Copyright © 2017 Rafay Hasan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EventTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *eventImageView;

@property (weak, nonatomic) IBOutlet UILabel *eventname;
@property (weak, nonatomic) IBOutlet UILabel *eventLocation;
@property (weak, nonatomic) IBOutlet UILabel *eventDate;
@property (weak, nonatomic) IBOutlet UIImageView *pharmacyTYpeImageview;

@end
