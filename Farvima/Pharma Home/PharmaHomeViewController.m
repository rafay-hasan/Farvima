//
//  PharmaHomeViewController.m
//  Farvima
//
//  Created by Rafay Hasan on 10/22/17.
//  Copyright © 2017 Rafay Hasan. All rights reserved.
//

#import "PharmaHomeViewController.h"
#import "MessageViewController.h"
@interface PharmaHomeViewController ()

- (IBAction)messageButtonAction:(id)sender;

@end

@implementation PharmaHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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

- (IBAction)messageButtonAction:(id)sender {
    if (![self isControllerAlreadyOnNavigationControllerStack]) {
        //push controller
        MessageViewController *newView = [self.storyboard instantiateViewControllerWithIdentifier:@"messaggi"];
        [self.navigationController pushViewController:newView animated:YES];
        
    }
}

-(BOOL)isControllerAlreadyOnNavigationControllerStack{
    MessageViewController *messageVc = [MessageViewController new];
    for (UIViewController *vc in self.navigationController.viewControllers) {
        if ([vc isKindOfClass:messageVc.class]) {
            [self.navigationController popToViewController:vc animated:NO];
            return YES;
        }
    }
    return NO;
}



@end
