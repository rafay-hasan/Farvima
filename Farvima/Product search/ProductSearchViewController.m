//
//  ProductSearchViewController.m
//  Farvima
//
//  Created by Rafay Hasan on 10/29/17.
//  Copyright © 2017 Rafay Hasan. All rights reserved.
//

#import "ProductSearchViewController.h"
#import "UIViewController+LGSideMenuController.h"
#import "EventDetailsViewController.h"
#import "GallaryViewController.h"
#import "NewsViewController.h"
#import "EventViewController.h"
#import "OfferViewController.h"
#import "ChiSiamoViewController.h"
@interface ProductSearchViewController ()

- (IBAction)backButtonAction:(id)sender;
- (IBAction)searchButtonAction:(id)sender;
- (IBAction)leftSliderButtonAction:(id)sender;


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *scrollContainerViewHeight;
@property (weak, nonatomic) IBOutlet UIButton *searchButton;

@end

@implementation ProductSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

-(void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:YES];
    self.scrollContainerViewHeight.constant = self.searchButton.frame.origin.y + self.searchButton.frame.size.height + 20;
    [[NSNotificationCenter defaultCenter]
     addObserver:self selector:@selector(LeftSlideMenutriggerAction:) name:@"leftSlideSelectedMenu" object:nil];
}


-(void) viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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

- (IBAction)searchButtonAction:(id)sender {
    [self performSegueWithIdentifier:@"searchResult" sender:self];
}

- (IBAction)leftSliderButtonAction:(id)sender {
     [[self sideMenuController] showLeftViewAnimated:sender];
}

-(void) LeftSlideMenutriggerAction:(NSNotification *) notification {
    NSDictionary *dict = notification.userInfo;
    NSString *menuname = [dict valueForKey:@"currentlySelectedLeftSlideMenu"];
    if ([menuname isEqualToString:@"GALERIA"]) {
        GallaryViewController *vc = [GallaryViewController new];
        if (![self isControllerAlreadyOnNavigationControllerStack:vc]) {
            GallaryViewController *newView = [self.storyboard instantiateViewControllerWithIdentifier:@"galleria"];
            [self.navigationController pushViewController:newView animated:YES];
            
        }
    }
    else if ([menuname isEqualToString:@"OFFERTE"]) {
        OfferViewController *vc = [OfferViewController new];
        if (![self isControllerAlreadyOnNavigationControllerStack:vc]) {
            OfferViewController *newView = [self.storyboard instantiateViewControllerWithIdentifier:@"offerte"];
            [self.navigationController pushViewController:newView animated:YES];
            
        }
    }
    else if ([menuname isEqualToString:@"EVENTI"]) {
        EventViewController *vc = [EventViewController new];
        if (![self isControllerAlreadyOnNavigationControllerStack:vc]) {
            EventViewController *newView = [self.storyboard instantiateViewControllerWithIdentifier:@"event"];
            [self.navigationController pushViewController:newView animated:YES];
            
        }
    }
    else if ([menuname isEqualToString:@"NEWS"]) {
        NewsViewController *vc = [NewsViewController new];
        if (![self isControllerAlreadyOnNavigationControllerStack:vc]) {
            NewsViewController *newView = [self.storyboard instantiateViewControllerWithIdentifier:@"news"];
            [self.navigationController pushViewController:newView animated:YES];
            
        }
    }
    else if ([menuname isEqualToString:@"CHI SIAMO"]) {
        ChiSiamoViewController *vc = [ChiSiamoViewController new];
        if (![self isControllerAlreadyOnNavigationControllerStack:vc]) {
            ChiSiamoViewController *newView = [self.storyboard instantiateViewControllerWithIdentifier:@"chi Siamo"];
            [self.navigationController pushViewController:newView animated:YES];
            
        }
    }
}

-(BOOL)isControllerAlreadyOnNavigationControllerStack:(UIViewController *)targetViewController{
    for (UIViewController *vc in self.navigationController.viewControllers) {
        if ([vc isKindOfClass:targetViewController.class]) {
            [self.navigationController popToViewController:vc animated:NO];
            return YES;
        }
    }
    return NO;
}

@end
