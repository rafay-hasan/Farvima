//
//  GalleryDetailsViewController.m
//  Farvima
//
//  Created by Rafay Hasan on 3/29/18.
//  Copyright © 2018 Rafay Hasan. All rights reserved.
//

#import "GalleryDetailsViewController.h"
#import "UIViewController+LGSideMenuController.h"
#import "User Details.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface GalleryDetailsViewController ()<LGSideMenuControllerDelegate>


@property (weak, nonatomic) IBOutlet UIImageView *galleryImageview;
@property (weak, nonatomic) IBOutlet UILabel *galleryTitleLabel;
@property (weak, nonatomic) IBOutlet UITextView *galleryDetailsTextView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *galleryTextViewHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *scrollContainerViewHeight;

- (IBAction)backButtonAction:(id)sender;
- (IBAction)leftSlideButtonAction:(id)sender;
- (IBAction)bottomTabGalleryDetailsButtonAction:(UIButton *)sender;


@end

@implementation GalleryDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if (self.gallery.imageUel.length > 0) {
        [self.galleryImageview sd_setImageWithURL:[NSURL URLWithString:self.gallery.imageUel]
                                 placeholderImage:[UIImage imageNamed:@"placeholder"]];
    }
    else {
        self.galleryImageview.image = nil;
    }
    
    self.galleryTitleLabel.text = self.gallery.name;
    self.galleryDetailsTextView.text = self.gallery.details;
    self.galleryDetailsTextView.scrollEnabled = NO;
    CGSize sizeThatFitsTextView = [self.galleryDetailsTextView sizeThatFits:CGSizeMake(self.galleryDetailsTextView.frame.size.width, MAXFLOAT)];
    self.galleryTextViewHeight.constant = sizeThatFitsTextView.height;
    self.scrollContainerViewHeight.constant = self.galleryDetailsTextView.frame.origin.y + self.galleryTextViewHeight.constant;
}

-(void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.sideMenuController.delegate = self;
}

-(void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.view layoutIfNeeded];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)backButtonAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)leftSlideButtonAction:(id)sender {
    [[self sideMenuController] showLeftViewAnimated:sender];
}

- (IBAction)bottomTabGalleryDetailsButtonAction:(UIButton *)sender {
    
     [[User_Details sharedInstance]makePushOrPopForBottomTabMenuToNavigationStack:self.navigationController forTag:sender.tag];
}

- (void)willShowLeftView:(nonnull UIView *)leftView sideMenuController:(nonnull LGSideMenuController *)sideMenuController {
    [User_Details sharedInstance].appUserId = @"";
}

- (void)didHideLeftView:(nonnull UIView *)leftView sideMenuController:(nonnull LGSideMenuController *)sideMenuController {
    [[User_Details sharedInstance] makePushOrPopViewControllertoNavigationStack:self.navigationController];
}

@end
