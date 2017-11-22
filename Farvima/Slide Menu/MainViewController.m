//
//  MainViewController.m
//  Farvima
//
//  Created by Rafay Hasan on 11/21/17.
//  Copyright © 2017 Rafay Hasan. All rights reserved.
//

#import "MainViewController.h"
#import "LeftSlideMenuViewController.h"
#import "RightSideMenuViewController.h"

@interface MainViewController ()

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupWithType {
    
    self.leftViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"leftMenu"];
    self.rightViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"rightMenu"];
    self.leftViewBackgroundColor = [UIColor whiteColor];
    self.rightViewBackgroundColor = [UIColor whiteColor];
    self.leftViewWidth = 180.0;
    self.rightViewWidth = 180.0;
    self.swipeGestureArea = LGSideMenuSwipeGestureAreaFull;
    self.leftViewPresentationStyle = LGSideMenuPresentationStyleSlideAbove;
    self.rightViewPresentationStyle = LGSideMenuPresentationStyleSlideAbove;

}
- (void)leftViewWillLayoutSubviewsWithSize:(CGSize)size {
    [super leftViewWillLayoutSubviewsWithSize:size];
    
    if (!self.isLeftViewStatusBarHidden) {
        self.leftView.frame = CGRectMake(0.0, 20.0, size.width, size.height-20.0);
    }
}

- (void)rightViewWillLayoutSubviewsWithSize:(CGSize)size {
    [super rightViewWillLayoutSubviewsWithSize:size];
    
    if (!self.isRightViewStatusBarHidden ||
        (self.rightViewAlwaysVisibleOptions & LGSideMenuAlwaysVisibleOnPadLandscape &&
         UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad &&
         UIInterfaceOrientationIsLandscape(UIApplication.sharedApplication.statusBarOrientation))) {
            self.rightView.frame = CGRectMake(0.0, 20.0, size.width, size.height-20.0);
        }
}

- (BOOL)isLeftViewStatusBarHidden {
//    if (self.type == 8) {
//        return UIInterfaceOrientationIsLandscape(UIApplication.sharedApplication.statusBarOrientation) && UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone;
//    }
    
    return super.isLeftViewStatusBarHidden;
}

- (BOOL)isRightViewStatusBarHidden {
//    if (self.type == 8) {
//        return UIInterfaceOrientationIsLandscape(UIApplication.sharedApplication.statusBarOrientation) && UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone;
//    }
    
    return super.isRightViewStatusBarHidden;
}

- (void)dealloc {
    NSLog(@"MainViewController deallocated");
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
