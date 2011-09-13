//
//  SocialFusionAppDelegate.h
//  SocialFusion
//
//  Created by Blue Bitch on 11-9-13.
//  Copyright 2011年 TJU. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SocialFusionAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

@end
