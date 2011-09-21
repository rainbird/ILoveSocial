//
//  User+Addition.h
//  SocialFusion
//
//  Created by Blue Bitch on 11-9-17.
//  Copyright 2011年 TJU. All rights reserved.
//

#import "User.h"

@interface User (Addition)

+ (User *)insertRenrenFriend:(NSDictionary *)dict inManagedObjectContext:(NSManagedObjectContext *)context;
+ (User *)userWithID:(NSString *)userID inManagedObjectContext:(NSManagedObjectContext *)context;

@end
