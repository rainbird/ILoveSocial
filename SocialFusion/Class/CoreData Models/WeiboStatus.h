//
//  WeiboStatus.h
//  SocialFusion
//
//  Created by He Ruoyun on 11-11-18.
//  Copyright (c) 2011年 TJU. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "Status.h"

@class WeiboStatus, WeiboUser;

@interface WeiboStatus : Status

@property (nonatomic, retain) NSString * source;
@property (nonatomic, retain) NSString * thumbnailPicURL;
@property (nonatomic, retain) NSDate * updateDate;
@property (nonatomic, retain) NSString * bmiddlePicURL;
@property (nonatomic, retain) NSNumber * favorited;
@property (nonatomic, retain) NSString * commentsCount;
@property (nonatomic, retain) NSString * originalPicURL;
@property (nonatomic, retain) NSString * repostsCount;
@property (nonatomic, retain) WeiboUser *favoritedBy;
@property (nonatomic, retain) NSSet *repostBy;
@property (nonatomic, retain) WeiboStatus *repostStatus;
@end

@interface WeiboStatus (CoreDataGeneratedAccessors)

- (void)addRepostByObject:(WeiboStatus *)value;
- (void)removeRepostByObject:(WeiboStatus *)value;
- (void)addRepostBy:(NSSet *)values;
- (void)removeRepostBy:(NSSet *)values;
@end
