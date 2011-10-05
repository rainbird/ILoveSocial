//
//  WeiboUser.h
//  SocialFusion
//
//  Created by Blue Bitch on 11-9-9.
//  Copyright (c) 2011年 TJU. All rights reserved.
//

#import "WeiboUser.h"

@interface WeiboUser (Addition)

+ (WeiboUser *)insertUser:(NSDictionary *)dict inManagedObjectContext:(NSManagedObjectContext *)context;
+ (WeiboUser *)userWithID:(NSString *)userID inManagedObjectContext:(NSManagedObjectContext *)context;
+ (void)deleteAllObjectsInManagedObjectContext:(NSManagedObjectContext *)context;
- (BOOL)isEqualToUser:(WeiboUser *)user;
+ (NSArray *)allUsersInManagedObjectContext:(NSManagedObjectContext *)context;

@end
