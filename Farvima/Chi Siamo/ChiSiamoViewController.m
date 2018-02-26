//
//  ChiSiamoViewController.m
//  Farvima
//
//  Created by Rafay Hasan on 12/11/17.
//  Copyright © 2017 Rafay Hasan. All rights reserved.
//

#import "ChiSiamoViewController.h"
#import "RHWebServiceManager.h"
#import "SVProgressHUD.h"
#import "User Details.h"
#import "UIViewController+LGSideMenuController.h"

@interface ChiSiamoViewController ()<RHWebServiceDelegate,LGSideMenuControllerDelegate>

@property (strong,nonatomic) RHWebServiceManager *myWebService;

- (IBAction)backButtonAction:(id)sender;
- (IBAction)leftMenuButtonAction:(id)sender;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *scrollContainerHeight;
@property (weak, nonatomic) IBOutlet UITextView *aboutUsTextView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *aboutUsTextViewHeight;

@end

@implementation ChiSiamoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self CallChiSiamoWebservice];
}

-(void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.sideMenuController.delegate = self;
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

- (IBAction)leftMenuButtonAction:(id)sender {
    [[self sideMenuController] showLeftViewAnimated:sender];
}

#pragma mark All Web service

-(void) CallChiSiamoWebservice
{
    [SVProgressHUD show];
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",BASE_URL_API,ChiSiamo_URL_API];
    self.myWebService = [[RHWebServiceManager alloc]initWebserviceWithRequestType:HTTPRequestTypeChiSiamo Delegate:self];
    [self.myWebService getDataFromWebURLWithUrlString:urlStr];
    
}

-(void) dataFromWebReceivedSuccessfully:(id) responseObj
{
    [SVProgressHUD dismiss];
    self.view.userInteractionEnabled = YES;
    if(self.myWebService.requestType == HTTPRequestTypeChiSiamo)
    {
        //NSArray *tempArray = [(NSArray *)responseObj valueForKey:@"about_us_details"];
        //NSLog(@"%@",tempArray);
        self.aboutUsTextView.text = [responseObj valueForKey:@"about_us_details"];
        [self adjustLayoutForViewController];
    }
}

-(void) dataFromWebReceiptionFailed:(NSError*) error
{
    [SVProgressHUD dismiss];
    self.view.userInteractionEnabled = YES;
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"Message", Nil) message:error.localizedDescription preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
        
        [alert dismissViewControllerAnimated:YES completion:nil];
    }];
    [alert addAction:ok];
    [self presentViewController:alert animated:YES completion:nil];
}

-(void) adjustLayoutForViewController {
    [self.view layoutIfNeeded];
    self.aboutUsTextView.scrollEnabled = NO;
    CGSize sizeThatFitsTextView = [self.aboutUsTextView sizeThatFits:CGSizeMake(self.aboutUsTextView.frame.size.width, MAXFLOAT)];
    self.aboutUsTextViewHeight.constant = sizeThatFitsTextView.height;
    self.scrollContainerHeight.constant = self.aboutUsTextView.frame.origin.y + self.aboutUsTextViewHeight.constant + 16;
    [self.view layoutIfNeeded];
}

-(BOOL)isControllerAlreadyOnNavigationControllerStack:(UIViewController *)targetViewController{
   // MainViewController *mainViewController = [MainViewController new];
    //UINavigationController *nav = (UINavigationController *) mainViewController.rootViewController;
    for (UIViewController *vc in self.navigationController.viewControllers) {
        if ([vc isKindOfClass:targetViewController.class]) {
            [self.navigationController popToViewController:vc animated:NO];
            return YES;
        }
    }
    return NO;
}

- (void)willShowLeftView:(nonnull UIView *)leftView sideMenuController:(nonnull LGSideMenuController *)sideMenuController {
    [User_Details sharedInstance].appUserId = @"";
}

- (void)didHideLeftView:(nonnull UIView *)leftView sideMenuController:(nonnull LGSideMenuController *)sideMenuController {
    [[User_Details sharedInstance] makePushOrPopViewControllertoNavigationStack:self.navigationController];
}

@end
