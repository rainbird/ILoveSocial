//
//  StatusCommentData+StatusCommentData_Addition.h
//  SocialFusion
//
//  Created by He Ruoyun on 11-11-21.
//  Copyright (c) 2011年 TJU. All rights reserved.
//

#import "StatusCommentData.h"

@interface StatusCommentData (StatusCommentData_Addition)
+ (StatusCommentData *)insertNewComment:(int)style Dic:(NSDictionary *)dict inManagedObjectContext:(NSManagedObjectContext *)context;
+ (StatusCommentData *)feedWithID:(NSString *)statusID inManagedObjectContext:(NSManagedObjectContext *)context;

@end
