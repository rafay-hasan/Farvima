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
#import "FarmVimaSlideMenuSingletone.h"

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
    NSDictionary *postData = [NSDictionary dictionaryWithObjectsAndKeys:ID,@"device_unique_id",deviceToken,@"device_push_token",nil];
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
    [[NSUserDefaults standardUserDefaults] synchronize];
    [[FarmVimaSlideMenuSingletone sharedManager] createLeftGeneralSlideMenu];
    //self.userManager.appUserId = @"6";
}

-(void) dataFromWebReceiptionFailed:(NSError*) error
{
    NSLog(@"%@",error.debugDescription);
    [SVProgressHUD dismiss];
    if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"appUserId"] isKindOfClass:[NSString class]]) {
        NSString *str = [[NSUserDefaults standardUserDefaults] valueForKey:@"appUserId"];
        if (str.length > 0) {
            self.userManager.appUserId = str;
        }
    }
//    if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"app_user_pharmacy_id"] isKindOfClass:[NSString class]]) {
//        self.userManager.pharmacyId = [[NSUserDefaults standardUserDefaults] valueForKey:@"app_user_pharmacy_id"];
//    }
    if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"ref_app_user_pharmacy_pharmacy_id"] isKindOfClass:[NSString class]]) {
        
        NSString *str = [[NSUserDefaults standardUserDefaults] valueForKey:@"ref_app_user_pharmacy_pharmacy_id"];
        if (str.length > 0) {
            self.userManager.referenceAppUserPharmacyId = str;
        }
    }
    [[FarmVimaSlideMenuSingletone sharedManager] createLeftGeneralSlideMenu];
    self.userManager.appUserId = @"6"; // Need to remove this line after testing
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


#pragma mark - Core Data Saving support

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;
@synthesize persistentContainer = _persistentContainer;

- (NSURL *)applicationDocumentsDirectory {
    // The directory the application uses to store the Core Data store file. This code uses a directory named "Your Bundle Indentifier" in the application's documents directory.
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSManagedObjectModel *)managedObjectModel {
    // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"Farvima" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    // The persistent store coordinator for the application. This implementation creates and returns a coordinator, having added the store for the application to it.
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    // Create the coordinator and store
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"Use your core data file name.sqlite"];
    NSError *error = nil;
    NSString *failureReason = @"There was an error creating or loading the application's saved data.";
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        // Report any error we got.
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
        dict[NSLocalizedFailureReasonErrorKey] = failureReason;
        dict[NSUnderlyingErrorKey] = error;
        error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        // Replace this with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}


- (NSManagedObjectContext *)managedObjectContext {
    // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.)
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
        return nil;
    }
    _managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    return _managedObjectContext;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    
    //Check current version.
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 10.0){
        
        NSManagedObjectContext *context =_persistentContainer.viewContext;
        
        if (context != nil) {
            NSError *error = nil;
            if ([context hasChanges] && ![context save:&error]) {
                // Replace this implementation with code to handle the error appropriately.
                // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
                abort();
            }
        }
    }else{
        NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
        if (managedObjectContext != nil) {
            NSError *error = nil;
            if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
                // Replace this implementation with code to handle the error appropriately.
                // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
                abort();
            }
        }
    }
}

-(BOOL) saveProductDetailsWithID:(NSString *)productId forProductName:(NSString *)name productPrice:(NSString *)price productType:(NSString *)type {
    
    NSManagedObjectContext *context = [self managedObjectContext];
    NSManagedObject *object = [NSEntityDescription insertNewObjectForEntityForName:@"Order" inManagedObjectContext:context];
    
    [object setValue:productId forKey:@"orderId"];
    [object setValue:name forKey:@"name"];
    [object setValue:price forKey:@"price"];
    [object setValue:type forKey:@"type"];
//    [object setValue:[NSNumber numberWithBool:NO] forKey:@"isSynced"];
    
    // Save the context
    NSError *error = nil;
    if (![context save:&error]) {
        NSLog(@"Save Failed! %@ %@", error, [error localizedDescription]);
        return NO;
    }
    else {
        return YES;
    }

}

- (NSArray *) retrieveAllOrder {
    NSManagedObjectContext *context = [self managedObjectContext];
    //NSManagedObject *object = [NSEntityDescription insertNewObjectForEntityForName:@"Order" inManagedObjectContext:context];
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"Order"];
    //request.predicate = [NSPredicate predicateWithFormat:@"city == %@ && id == %d", @"Pune", 3];
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"orderId" ascending:YES]];
    
    NSArray *results = [context executeFetchRequest:request error:nil];
    return  results;
}

- (void) RemoveAllDataOfOrder {
    NSManagedObjectContext *context = [self managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Order"];
    [fetchRequest setIncludesPropertyValues:NO]; //only fetch the managedObjectID
    
    NSError *error;
    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
    for (NSManagedObject *object in fetchedObjects)
    {
        [context deleteObject:object];
    }
    
    error = nil;
    [context save:&error];
}

@end
