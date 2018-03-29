//
//  AppDelegate.h
//  Farvima
//
//  Created by Rafay Hasan on 10/15/17.
//  Copyright © 2017 Rafay Hasan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

-(BOOL) saveProductDetailsWithID:(NSString *)productId forProductName:(NSString *)name productPrice:(NSString *)price productType:(NSString *)type;
- (NSArray *) retrieveAllOrder ;
- (void) RemoveAllDataOfOrder;

-(BOOL)checkIfNotificationisNew:(NSString *)notificationId;
-(NSMutableDictionary *) getAllValuesfromNotification;
-(BOOL) savNotificationDetailsWithID:(NSString *)notificationId Status:(NSNumber *)value;
-(void) removeAllNotificationData;
-(void) updateNotificationStatusforNotificationId:(NSString *)notificationId;

#pragma mark - Core data for messages vriable
@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (readonly, strong) NSPersistentContainer *persistentContainer;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;


@end

