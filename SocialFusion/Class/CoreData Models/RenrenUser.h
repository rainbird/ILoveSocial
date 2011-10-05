//
//  RenrenUser.h
//  SocialFusion
//
//  Created by Blue Bitch on 11-10-5.
//  Copyright (c) 2011年 TJU. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "User.h"

@class RenrenUser;

@interface RenrenUser : User {
@private
}
@property (nonatomic, retain) NSSet *friends;
@end

@interface RenrenUser (CoreDataGeneratedAccessors)
- (void)addFriendsObject:(RenrenUser *)value;
- (void)removeFriendsObject:(RenrenUser *)value;
- (void)addFriends:(NSSet *)value;
- (void)removeFriends:(NSSet *)value;

@end
