//
//  RenrenUser.h
//  SocialFusion
//
//  Created by Blue Bitch on 11-9-9.
//  Copyright (c) 2011年 TJU. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class RenrenStatus, RenrenUser;

@interface RenrenUser : NSManagedObject {
@private
}
@property (nonatomic, retain) NSString * pinyinName;
@property (nonatomic, retain) NSString * birthday;
@property (nonatomic, retain) NSString * emailHash;
@property (nonatomic, retain) NSString * gender;
@property (nonatomic, retain) NSString * headURL;
@property (nonatomic, retain) NSString * hometownLocation;
@property (nonatomic, retain) NSString * mainURL;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * tinyURL;
@property (nonatomic, retain) NSData * tinyURLData;
@property (nonatomic, retain) NSString * universityHistory;
@property (nonatomic, retain) NSString * userID;
@property (nonatomic, retain) NSString * workHistory;
@property (nonatomic, retain) NSSet *friends;
@property (nonatomic, retain) NSSet *statuses;
@property (nonatomic, retain) NSSet *friendsStatuses;

+ (RenrenUser *)insertUser:(NSDictionary *)dict inManagedObjectContext:(NSManagedObjectContext *)context;
+ (RenrenUser *)insertFriend:(NSDictionary *)dict inManagedObjectContext:(NSManagedObjectContext *)context;
+ (RenrenUser *)userWithID:(NSString *)userID inManagedObjectContext:(NSManagedObjectContext *)context;
+ (void)deleteAllObjectsInManagedObjectContext:(NSManagedObjectContext *)context;
- (BOOL)isEqualToUser:(RenrenUser *)user;
+ (NSArray *)allUsersInManagedObjectContext:(NSManagedObjectContext *)context;
+ (NSArray *)allFriendsInManagedObjectContext:(NSManagedObjectContext *)context;

@end

@interface RenrenUser (CoreDataGeneratedAccessors)
- (void)addFriendsObject:(RenrenUser *)value;
- (void)removeFriendsObject:(RenrenUser *)value;
- (void)addFriends:(NSSet *)value;
- (void)removeFriends:(NSSet *)value;
- (void)addStatusesObject:(RenrenStatus *)value;
- (void)removeStatusesObject:(RenrenStatus *)value;
- (void)addStatuses:(NSSet *)value;
- (void)removeStatuses:(NSSet *)value;
- (void)addFriendsStatusesObject:(RenrenStatus *)value;
- (void)removeFriendsStatusesObject:(RenrenStatus *)value;
- (void)addFriendsStatuses:(NSSet *)value;
- (void)removeFriendsStatuses:(NSSet *)value;

@end
