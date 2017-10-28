//
//  OfferViewController.m
//  Farvima
//
//  Created by Rafay Hasan on 10/24/17.
//  Copyright © 2017 Rafay Hasan. All rights reserved.
//

#import "OfferViewController.h"
#import "MessageViewController.h"

@interface OfferViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *offerTableview;

- (IBAction)backButtonAction:(id)sender;
- (IBAction)messageButtonAction:(id)sender;

@end

@implementation OfferViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.offerTableview.estimatedRowHeight = 90;
    self.offerTableview.rowHeight = UITableViewAutomaticDimension;
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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 15;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"offerCell" forIndexPath:indexPath];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (IBAction)backButtonAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

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
