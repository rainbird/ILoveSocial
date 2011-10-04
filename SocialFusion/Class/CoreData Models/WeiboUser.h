//
//  WeiboUser.h
//  SocialFusion
//
//  Created by He Ruoyun on 11-10-4.
//  Copyright (c) 2011年 TJU. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "User.h"

@class WeiboStatus, WeiboUser;

@interface WeiboUser : User {
@private
}
@property (nonatomic, retain) NSString * statusesCount;
@property (nonatomic, retain) NSString * profileImageURL;
@property (nonatomic, retain) NSString * followersCount;
@property (nonatomic, retain) NSNumber * verified;
@property (nonatomic, retain) NSString * province;
@property (nonatomic, retain) NSDate * createAt;
@property (nonatomic, retain) NSString * friendsCount;
@property (nonatomic, retain) NSString * favouritesCount;
@property (nonatomic, retain) NSString * location;
@property (nonatomic, retain) NSString * domainURL;
@property (nonatomic, retain) NSString * city;
@property (nonatomic, retain) NSNumber * following;
@property (nonatomic, retain) NSString * selfDescription;
@property (nonatomic, retain) NSString * blogURL;
@property (nonatomic, retain) NSString * gender;
@property (nonatomic, retain) NSSet* favorites;
@property (nonatomic, retain) NSSet* friendsStatuses;
@property (nonatomic, retain) NSSet* friends;
@property (nonatomic, retain) NSSet* followers;

@end
