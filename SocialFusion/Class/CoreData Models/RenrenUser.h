//
//  RenrenUser.h
//  SocialFusion
//
//  Created by Blue Bitch on 11-9-17.
//  Copyright (c) 2011年 TJU. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "User.h"

@class RenrenUser;

@interface RenrenUser : User {
@private
}
@property (nonatomic, retain) NSString * birthday;
@property (nonatomic, retain) NSString * emailHash;
@property (nonatomic, retain) NSString * gender;
@property (nonatomic, retain) NSString * headURL;
@property (nonatomic, retain) NSString * hometownLocation;
@property (nonatomic, retain) NSString * mainURL;
@property (nonatomic, retain) NSString * universityHistory;
@property (nonatomic, retain) NSString * workHistory;
@property (nonatomic, retain) NSSet *friends;
@end

@interface RenrenUser (CoreDataGeneratedAccessors)
- (void)addFriendsObject:(RenrenUser *)value;
- (void)removeFriendsObject:(RenrenUser *)value;
- (void)addFriends:(NSSet *)value;
- (void)removeFriends:(NSSet *)value;

@end
