//
//  NewFeedRootData.h
//  SocialFusion
//
//  Created by He Ruoyun on 11-11-21.
//  Copyright (c) 2011年 TJU. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class StatusCommentData, User;

@interface NewFeedRootData : NSManagedObject

@property (nonatomic, retain) NSNumber * style;
@property (nonatomic, retain) NSString * actor_ID;
@property (nonatomic, retain) NSString * post_ID;
@property (nonatomic, retain) NSString * source_ID;
@property (nonatomic, retain) NSNumber * comment_Count;
@property (nonatomic, retain) NSDate * get_Time;
@property (nonatomic, retain) NSString * owner_Name;
@property (nonatomic, retain) NSDate * update_Time;
@property (nonatomic, retain) NSString * owner_Head;
@property (nonatomic, retain) User *owner;
@property (nonatomic, retain) NSSet *comments;
@end

@interface NewFeedRootData (CoreDataGeneratedAccessors)

- (void)addCommentsObject:(StatusCommentData *)value;
- (void)removeCommentsObject:(StatusCommentData *)value;
- (void)addComments:(NSSet *)values;
- (void)removeComments:(NSSet *)values;
@end
