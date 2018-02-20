//
//  ProductSearchViewController.h
//  Farvima
//
//  Created by Rafay Hasan on 10/29/17.
//  Copyright © 2017 Rafay Hasan. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ProductSearchControllerDelegate <NSObject>
@required
- (void)resultOfSearchedData:(NSArray *)dataArray;
@end

@interface ProductSearchViewController : UIViewController

@property (nonatomic, weak) id<ProductSearchControllerDelegate> delegate;

@end
