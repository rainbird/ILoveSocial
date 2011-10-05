//
//  WeiboUser.h
//  SocialFusion
//
//  Created by Blue Bitch on 11-10-5.
//  Copyright (c) 2011年 TJU. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "User.h"

@class WeiboStatus, WeiboUser;

@interface WeiboUser : User {
@private
}
@property (nonatomic, retain) NSSet *followers;
@property (nonatomic, retain) NSSet *friends;
@property (nonatomic, retain) WeiboStatus *favorites;
@end

@interface WeiboUser (CoreDataGeneratedAccessors)
- (void)addFollowersObject:(WeiboUser *)value;
- (void)removeFollowersObject:(WeiboUser *)value;
- (void)addFollowers:(NSSet *)value;
- (void)removeFollowers:(NSSet *)value;
- (void)addFriendsObject:(WeiboUser *)value;
- (void)removeFriendsObject:(WeiboUser *)value;
- (void)addFriends:(NSSet *)value;
- (void)removeFriends:(NSSet *)value;

@end
