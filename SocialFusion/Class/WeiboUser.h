//
//  WeiboUser.h
//  SocialFusion
//
//  Created by Blue Bitch on 11-9-9.
//  Copyright (c) 2011年 TJU. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class WeiboStatus, WeiboUser;

@interface WeiboUser : NSManagedObject {
@private
}
@property (nonatomic, retain) NSString * pinyinName;
@property (nonatomic, retain) NSString * userID;
@property (nonatomic, retain) NSString * blogURL;
@property (nonatomic, retain) NSString * city;
@property (nonatomic, retain) NSDate * createAt;
@property (nonatomic, retain) NSString * domainURL;
@property (nonatomic, retain) NSString * favouritesCount;
@property (nonatomic, retain) NSNumber * following;
@property (nonatomic, retain) NSString * friendsCount;
@property (nonatomic, retain) NSString * gender;
@property (nonatomic, retain) NSString * location;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * profileImageURL;
@property (nonatomic, retain) NSString * province;
@property (nonatomic, retain) NSString * selfDescription;
@property (nonatomic, retain) NSString * statusesCount;
@property (nonatomic, retain) NSNumber * verified;
@property (nonatomic, retain) NSSet *friends;
@property (nonatomic, retain) NSSet *followers;
@property (nonatomic, retain) NSSet *statuses;
@property (nonatomic, retain) NSSet *friendsStatuses;
@property (nonatomic, retain) NSSet *favorites;
@property (nonatomic, retain) NSString * followersCount;

+ (WeiboUser *)insertUser:(NSDictionary *)dict inManagedObjectContext:(NSManagedObjectContext *)context;
+ (WeiboUser *)userWithID:(NSString *)userID inManagedObjectContext:(NSManagedObjectContext *)context;
+ (void)deleteAllObjectsInManagedObjectContext:(NSManagedObjectContext *)context;
- (BOOL)isEqualToUser:(WeiboUser *)user;
+ (NSArray *)allUsersInManagedObjectContext:(NSManagedObjectContext *)context;

@end

@interface WeiboUser (CoreDataGeneratedAccessors)
- (void)addFriendsObject:(WeiboUser *)value;
- (void)removeFriendsObject:(WeiboUser *)value;
- (void)addFriends:(NSSet *)value;
- (void)removeFriends:(NSSet *)value;
- (void)addFollowersObject:(WeiboUser *)value;
- (void)removeFollowersObject:(WeiboUser *)value;
- (void)addFollowers:(NSSet *)value;
- (void)removeFollowers:(NSSet *)value;
- (void)addStatusesObject:(WeiboStatus *)value;
- (void)removeStatusesObject:(WeiboStatus *)value;
- (void)addStatuses:(NSSet *)value;
- (void)removeStatuses:(NSSet *)value;
- (void)addFriendsStatusesObject:(WeiboStatus *)value;
- (void)removeFriendsStatusesObject:(WeiboStatus *)value;
- (void)addFriendsStatuses:(NSSet *)value;
- (void)removeFriendsStatuses:(NSSet *)value;
- (void)addFavoritesObject:(WeiboStatus *)value;
- (void)removeFavoritesObject:(WeiboStatus *)value;
- (void)addFavorites:(NSSet *)value;
- (void)removeFavorites:(NSSet *)value;

@end
