//
//  ProfileEditViewController.m
//  Farvima
//
//  Created by Rafay Hasan on 12/3/18.
//  Copyright © 2018 Rafay Hasan. All rights reserved.
//

#import "ProfileEditViewController.h"
#import "User Details.h"
#import "UIViewController+LGSideMenuController.h"
#import "RHWebServiceManager.h"
#import "SVProgressHUD.h"

@interface ProfileEditViewController ()<LGSideMenuControllerDelegate,RHWebServiceDelegate>
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UITextField *addressTextfield;
@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;

@property (weak, nonatomic) IBOutlet UITextField *dateTextField;
- (IBAction)backButtonAction:(id)sender;
- (IBAction)profileEditBottomTabMenuButtonAction:(UIButton *)sender;
- (IBAction)leftMenuSlideButtonAction:(id)sender;
@property (strong,nonatomic) UIDatePicker *datePicker;
@property (strong,nonatomic) RHWebServiceManager *myWebserviceManager;
- (IBAction)profileModificationButtonAction:(id)sender;


@end

@implementation ProfileEditViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                          action:@selector(dismissKeyboard)];
    
    [self.view addGestureRecognizer:tap];
    
    self.datePicker = [[UIDatePicker alloc]init];
    [self.datePicker setDate:[NSDate date]];
    self.datePicker.datePickerMode = UIDatePickerModeDate;
    [self.datePicker addTarget:self action:@selector(dateTextField:) forControlEvents:UIControlEventValueChanged];
    [self.dateTextField setInputView:self.datePicker];
    
    UIToolbar *toolBar=[[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44)];
    [toolBar setTintColor:[UIColor grayColor]];
    UIBarButtonItem *doneBtn=[[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(ShowSelectedDate)];
    UIBarButtonItem *space=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    [toolBar setItems:[NSArray arrayWithObjects:space,doneBtn, nil]];
    
    [self.dateTextField setInputAccessoryView:toolBar];
    
    self.dateTextField.text = self.profile.birthDate;
    self.emailTextField.text = self.profile.email;
    self.addressTextfield.text = self.profile.address;
    self.phoneTextField.text = self.profile.phone;
}

-(void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.sideMenuController.delegate = self;
    self.sideMenuController.rightViewSwipeGestureEnabled = NO;
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


-(void)dismissKeyboard {
    [self.dateTextField resignFirstResponder];
    [self.emailTextField resignFirstResponder];
    [self.addressTextfield resignFirstResponder];
    [self.phoneTextField resignFirstResponder];
}

-(void) dateTextField:(id)sender
{
    UIDatePicker *picker = (UIDatePicker*)self.dateTextField.inputView;
    [picker setMaximumDate:[NSDate date]];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    NSDate *eventDate = picker.date;
    [dateFormat setDateFormat:@"dd MMM, yyyy"];
    
    NSString *dateString = [dateFormat stringFromDate:eventDate];
    self.dateTextField.text = [NSString stringWithFormat:@"%@",dateString];
}

-(void) ShowSelectedDate {
    [self.dateTextField resignFirstResponder];
}

- (IBAction)backButtonAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)profileEditBottomTabMenuButtonAction:(UIButton *)sender {
    [[User_Details sharedInstance]makePushOrPopForBottomTabMenuToNavigationStack:self.navigationController forTag:sender.tag];
}

- (IBAction)leftMenuSlideButtonAction:(id)sender {
    [[self sideMenuController] showLeftViewAnimated:sender];
}

- (void)willShowLeftView:(nonnull UIView *)leftView sideMenuController:(nonnull LGSideMenuController *)sideMenuController {
    [User_Details sharedInstance].currentlySelectedLeftSlideMenu = @"";
}

- (void)didHideLeftView:(nonnull UIView *)leftView sideMenuController:(nonnull LGSideMenuController *)sideMenuController {
    if ([User_Details sharedInstance].currentlySelectedLeftSlideMenu.length > 0) {
        [[User_Details sharedInstance] makePushOrPopViewControllertoNavigationStack:self.navigationController];
    }
}

- (IBAction)profileModificationButtonAction:(id)sender {
    NSString *message = @"";
    if (self.dateTextField.text.length > 0 && self.emailTextField.text.length > 0 && self.addressTextfield.text.length > 0 && self.phoneTextField.text.length > 0 && [self NSStringIsValidEmail:self.emailTextField.text]) {
        [self UpdateProfileDetailsWebService];
    }
    else if (self.dateTextField.text.length == 0) {
        message = @"Please enter your date of birth";
    }
    else if (self.addressTextfield.text.length == 0) {
        message = @"Please enter your Address";
    }
    else if (self.emailTextField.text.length == 0) {
        message = @"Please enter your email address";
    }
    else if (![self NSStringIsValidEmail:self.emailTextField.text]) {
        message = @"Please enter a valid email address";
    }
    else if (self.phoneTextField.text.length == 0) {
        message = @"Please enter your phone number";
    }
    
    if (message.length > 0) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"Message", Nil) message:message preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            
            
            [alert dismissViewControllerAnimated:YES completion:nil];
        }];
        [alert addAction:ok];
        [self presentViewController:alert animated:YES completion:nil];
    }
}

-(BOOL) NSStringIsValidEmail:(NSString *)checkString
{
    BOOL stricterFilter = NO; // Discussion http://blog.logichigh.com/2010/09/02/validating-an-e-mail-address/
    NSString *stricterFilterString = @"^[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}$";
    NSString *laxString = @"^.+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2}[A-Za-z]*$";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:checkString];
}

-(void) UpdateProfileDetailsWebService
{
//    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//    [dateFormatter setDateFormat:@"dd MMM, yyyy"];
//    NSDate *date = [dateFormatter dateFromString:self.dateTextField.text];
//    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    
    NSDictionary *postData = [NSDictionary dictionaryWithObjectsAndKeys:self.dateTextField.text,@"app_user_birth_date",self.addressTextfield.text,@"app_user_address",self.emailTextField.text,@"app_user_email",self.phoneTextField.text,@"app_user_cell_phone",nil];
    [SVProgressHUD show];
    NSString *urlStr = [NSString stringWithFormat:@"%@%@%@",BASE_URL_API,ProfileModification_URL_API,[[NSUserDefaults standardUserDefaults] valueForKey:@"appUserId"]];
    self.myWebserviceManager = [[RHWebServiceManager alloc]initWebserviceWithRequestType:HTTPRequestypeProfileModification Delegate:self];
    [self.myWebserviceManager getPostDataFromWebURLWithUrlString:urlStr dictionaryData:postData];
}

-(void) dataFromWebReceivedSuccessfully:(id) responseObj
{
    [SVProgressHUD dismiss];
    self.view.userInteractionEnabled = YES;
    if(self.myWebserviceManager.requestType == HTTPRequestypeProfileModification)
    {
        NSLog(@"Response is %@",responseObj);
        [self.navigationController popViewControllerAnimated:YES];
    }
}

-(void) dataFromWebReceiptionFailed:(NSError*) error
{
    [SVProgressHUD dismiss];
    self.view.userInteractionEnabled = YES;
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"Message", Nil) message:error.debugDescription preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
        
        [alert dismissViewControllerAnimated:YES completion:nil];
    }];
    [alert addAction:ok];
    [self presentViewController:alert animated:YES completion:nil];
}




@end
