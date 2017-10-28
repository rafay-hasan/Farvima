//
//  NewsDetailsViewController.m
//  Farvima
//
//  Created by Rafay Hasan on 10/28/17.
//  Copyright © 2017 Rafay Hasan. All rights reserved.
//

#import "NewsDetailsViewController.h"
#import "MessageViewController.h"
#import "NotificationViewController.h"

@interface NewsDetailsViewController ()

- (IBAction)backButtonAction:(id)sender;
- (IBAction)messageButtonAction:(id)sender;
- (IBAction)notificationButtonAction:(id)sender;

@property (weak, nonatomic) IBOutlet UIImageView *newsImageView;
@property (weak, nonatomic) IBOutlet UILabel *newsHeaderLabel;
@property (weak, nonatomic) IBOutlet UILabel *newsPublisDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *newsDetailsLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *ScrollContainerViewHeight;


@end

@implementation NewsDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self loadNewsDetailsView];
    
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

- (void) loadNewsDetailsView
{
    self.newsDetailsLabel.text = @"C'era un'atmosfera sombera negli stadi italiani il mercoledì sera durante un minuto di silenzio, seguito da quegli estratti del diario di Anne Frank, vittima dell'olocausto, che veniva letto attraverso altoparlanti prima di tutte le principali partite di calcio. I giocatori indossavano magliette con lo slogan No all'antisemitismo, con una foto di Anne Frank stampata su di essi, mentre le copie del suo diario sono state distribuite ai tifosi dello stadio.";
    self.ScrollContainerViewHeight.constant = self.newsDetailsLabel.frame.origin.y + self.newsDetailsLabel.frame.size.height;
}

- (IBAction)backButtonAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)messageButtonAction:(id)sender {
    MessageViewController *messageVc = [MessageViewController new];
    if (![self isControllerAlreadyOnNavigationControllerStack:messageVc]) {
        //push controller
        MessageViewController *newView = [self.storyboard instantiateViewControllerWithIdentifier:@"messaggi"];
        [self.navigationController pushViewController:newView animated:YES];
        
    }
}

- (IBAction)notificationButtonAction:(id)sender {
    NotificationViewController *notificationVc = [NotificationViewController new];
    if (![self isControllerAlreadyOnNavigationControllerStack:notificationVc]) {
        //push controller
        NotificationViewController *newView = [self.storyboard instantiateViewControllerWithIdentifier:@"notification"];
        [self.navigationController pushViewController:newView animated:YES];
        
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
