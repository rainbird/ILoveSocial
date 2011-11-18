//
//  User.h
//  SocialFusion
//
//  Created by He Ruoyun on 11-11-18.
//  Copyright (c) 2011年 TJU. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class DetailInformation, NewFeedRootData, Status;

@interface User : NSManagedObject

@property (nonatomic, retain) NSString * userID;
@property (nonatomic, retain) NSDate * updateDate;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * tinyURL;
@property (nonatomic, retain) NSString * pinyinName;
@property (nonatomic, retain) NSString * latestStatus;
@property (nonatomic, retain) DetailInformation *detailInformation;
@property (nonatomic, retain) NSSet *statuses;
@property (nonatomic, retain) NSSet *newFeed;
@end

@interface User (CoreDataGeneratedAccessors)

- (void)addStatusesObject:(Status *)value;
- (void)removeStatusesObject:(Status *)value;
- (void)addStatuses:(NSSet *)values;
- (void)removeStatuses:(NSSet *)values;
- (void)addNewFeedObject:(NewFeedRootData *)value;
- (void)removeNewFeedObject:(NewFeedRootData *)value;
- (void)addNewFeed:(NSSet *)values;
- (void)removeNewFeed:(NSSet *)values;
@end
