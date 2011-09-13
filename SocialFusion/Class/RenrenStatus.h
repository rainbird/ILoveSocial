//
//  RenrenStatus.h
//  SocialFusion
//
//  Created by Blue Bitch on 11-9-12.
//  Copyright (c) 2011年 TJU. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class RenrenUser;

@interface RenrenStatus : NSManagedObject {
@private
}
@property (nonatomic, retain) NSDate * createdAt;
@property (nonatomic, retain) NSString * userID;
@property (nonatomic, retain) NSString * statusID;
@property (nonatomic, retain) NSString * text;
@property (nonatomic, retain) NSString * commentsCount;
@property (nonatomic, retain) NSString * url;
@property (nonatomic, retain) NSString * forwardMessage;
@property (nonatomic, retain) NSString * rootStatusID;
@property (nonatomic, retain) NSString * rootText;
@property (nonatomic, retain) NSString * rootUserID;
@property (nonatomic, retain) NSString * rootUserName;
@property (nonatomic, retain) RenrenUser *author;
@property (nonatomic, retain) RenrenUser *isFriendStatusOf;

+ (RenrenStatus *)insertStatus:(NSDictionary *)dict inManagedObjectContext:(NSManagedObjectContext *)context;
+ (RenrenStatus *)statusWithID:(NSString *)statusID inManagedObjectContext:(NSManagedObjectContext *)context;

@end
