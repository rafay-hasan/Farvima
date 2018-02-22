//
//  AppDelegate.m
//  Farvima
//
//  Created by Rafay Hasan on 10/15/17.
//  Copyright © 2017 Rafay Hasan. All rights reserved.
//

#import "AppDelegate.h"
#import "IQKeyboardManager.h"
#import "RHWebServiceManager.h"
#import "SVProgressHUD.h"
#import "User Details.h"

@interface AppDelegate ()<RHWebServiceDelegate>

@property (strong,nonatomic) RHWebServiceManager *myWebserviceManager;
@property (strong,nonatomic) User_Details *userManager;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [IQKeyboardManager sharedManager].enable = YES;
    self.userManager = [User_Details sharedInstance];
     [self CallUserDetailsWebserviceWithUDID:[[[UIDevice currentDevice] identifierForVendor] UUIDString] forDeviceToken:@"123456789"];
    
    [application registerForRemoteNotifications];
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
    {
        [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge) categories:nil]];
        
        [[UIApplication sharedApplication] registerForRemoteNotifications];
        
    }
    else
    {
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes: (UIRemoteNotificationTypeNewsstandContentAvailability| UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert)];
        NSLog(@"TESTING: %@", @"SUmon");
    }
    
//    UINavigationController *masterNavigationController = splitViewController.viewControllers[0];
//    MasterViewController *controller = (MasterViewController *)masterNavigationController.topViewController;
//    controller.managedObjectContext = self.persistentContainer.viewContext;
    return YES;
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    NSLog(@"Did Register for Remote Notifications with Device Token (%@)", deviceToken);
    NSString* myToken = [[[NSString stringWithFormat:@"%@",deviceToken]
                          stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]] stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    NSString *thisToken = [NSString stringWithFormat: @"%@", myToken];
    [self CallUserDetailsWebserviceWithUDID:[[[UIDevice currentDevice] identifierForVendor] UUIDString] forDeviceToken:thisToken];
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    
    NSLog(@"Did Fail to Register for Remote Notifications");
    NSLog(@"%@, %@", error, error.localizedDescription);
}

-(void) application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    NSLog(@"%@",userInfo);
}

-(void) CallUserDetailsWebserviceWithUDID:(NSString *)ID forDeviceToken:(NSString *)deviceToken
{
     NSDictionary *postData = [NSDictionary dictionaryWithObjectsAndKeys:@"53235789",@"device_unique_id",@"5340561869",@"device_push_token",nil];
    [SVProgressHUD show];
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",BASE_URL_API,UserDetails_URL_API];
    self.myWebserviceManager = [[RHWebServiceManager alloc]initWebserviceWithRequestType:HTTPRequestypeUserDetails Delegate:self];
    [self.myWebserviceManager getPostDataFromWebURLWithUrlString:urlStr dictionaryData:postData];
}

-(void) dataFromWebReceivedSuccessfully:(id) responseObj
{
    [SVProgressHUD dismiss];
    NSLog(@"%@",responseObj);

    if ([[responseObj valueForKey:@"app_user_id"] isKindOfClass:[NSString class]]) {
        self.userManager.appUserId = [responseObj valueForKey:@"app_user_id"];
        [[NSUserDefaults standardUserDefaults] setObject:[responseObj valueForKey:@"app_user_id"] forKey:@"appUserId"];
    }
    else {
        self.userManager.appUserId = @"";
    }
    
    if ([[responseObj valueForKey:@"app_user_pharmacy_id"] isKindOfClass:[NSString class]]) {
        self.userManager.pharmacyId = [responseObj valueForKey:@"app_user_pharmacy_id"];
        [[NSUserDefaults standardUserDefaults] setObject:[responseObj valueForKey:@"app_user_pharmacy_id"] forKey:@"pharmacyId"];
    }
    else {
        self.userManager.pharmacyId = nil;
    }
    
    if ([[responseObj valueForKey:@"ref_app_user_pharmacy_pharmacy_id"] isKindOfClass:[NSString class]]) {
        self.userManager.referenceAppUserPharmacyId = [responseObj valueForKey:@"ref_app_user_pharmacy_pharmacy_id"];
        [[NSUserDefaults standardUserDefaults] setObject:[responseObj valueForKey:@"ref_app_user_pharmacy_pharmacy_id"] forKey:@"referenceAppUserPharmacyId"];
    }
    else {
        self.userManager.referenceAppUserPharmacyId = nil;
    }
    [[NSUserDefaults standardUserDefaults] synchronize];;
}

-(void) dataFromWebReceiptionFailed:(NSError*) error
{
    [SVProgressHUD dismiss];
    if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"appUserId"] isKindOfClass:[NSString class]]) {
        self.userManager.appUserId = [[NSUserDefaults standardUserDefaults] valueForKey:@"appUserId"];
    }
//    if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"app_user_pharmacy_id"] isKindOfClass:[NSString class]]) {
//        self.userManager.pharmacyId = [[NSUserDefaults standardUserDefaults] valueForKey:@"app_user_pharmacy_id"];
//    }
    if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"ref_app_user_pharmacy_pharmacy_id"] isKindOfClass:[NSString class]]) {
        self.userManager.referenceAppUserPharmacyId = [[NSUserDefaults standardUserDefaults] valueForKey:@"ref_app_user_pharmacy_pharmacy_id"];
    }
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
}


#pragma mark - Core Data stack

@synthesize persistentContainer = _persistentContainer;

- (NSPersistentContainer *)persistentContainer {
    // The persistent container for the application. This implementation creates and returns a container, having loaded the store for the application to it.
    @synchronized (self) {
        if (_persistentContainer == nil) {
            _persistentContainer = [[NSPersistentContainer alloc] initWithName:@"Farvima"];
            [_persistentContainer loadPersistentStoresWithCompletionHandler:^(NSPersistentStoreDescription *storeDescription, NSError *error) {
                if (error != nil) {
                    // Replace this implementation with code to handle the error appropriately.
                    // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                    
                    /*
                     Typical reasons for an error here include:
                     * The parent directory does not exist, cannot be created, or disallows writing.
                     * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                     * The device is out of space.
                     * The store could not be migrated to the current model version.
                     Check the error message to determine what the actual problem was.
                    */
                    NSLog(@"Unresolved error %@, %@", error, error.userInfo);
                    abort();
                }
            }];
        }
    }
    
    return _persistentContainer;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *context = self.persistentContainer.viewContext;
    NSError *error = nil;
    if ([context hasChanges] && ![context save:&error]) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, error.userInfo);
        abort();
    }
}

@end
