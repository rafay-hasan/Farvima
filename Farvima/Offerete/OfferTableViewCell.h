//
//  OfferTableViewCell.h
//  Farvima
//
//  Created by Rafay Hasan on 10/24/17.
//  Copyright © 2017 Rafay Hasan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OfferTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *pdfTitleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *categoryTypeImageview;
@property (weak, nonatomic) IBOutlet UIImageView *pdfDownloadButton;
@property (weak, nonatomic) IBOutlet UILabel *dateTimeLabel;


@end
