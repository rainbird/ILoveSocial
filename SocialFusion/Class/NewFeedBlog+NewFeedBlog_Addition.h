//
//  NewFeedBlog+NewFeedBlog_Addition.h
//  SocialFusion
//
//  Created by He Ruoyun on 11-11-7.
//  Copyright (c) 2011年 TJU. All rights reserved.
//

#import "NewFeedBlog.h"

@interface NewFeedBlog (NewFeedBlog_Addition)
+ (NewFeedBlog *)insertNewFeed:(int)sytle Owner:(User*)myUser Dic:(NSDictionary *)dict inManagedObjectContext:(NSManagedObjectContext *)context;
+ (NewFeedBlog *)feedWithID:(NSString *)statusID inManagedObjectContext:(NSManagedObjectContext *)context;
-(NSString*)getBlog;

@end
