//
//  NewFeedRootData+NewFeedRootData_Addition.h
//  SocialFusion
//
//  Created by He Ruoyun on 11-11-7.
//  Copyright (c) 2011年 TJU. All rights reserved.
//

#import "NewFeedRootData.h"

@interface NewFeedRootData (NewFeedRootData_Addition)
+ (NewFeedRootData *)insertNewFeed:(int)sytle Owner:(User*)myUser Dic:(NSDictionary *)dict inManagedObjectContext:(NSManagedObjectContext *)context;
+ (NewFeedRootData *)feedWithID:(NSString *)statusID inManagedObjectContext:(NSManagedObjectContext *)context;
-(NSString*)getFeedName;
-(NSString*)getHeadURL;
-(NSDate*)getDate;
-(NSString*)getActor_ID;
-(NSString*)getSource_ID;
-(NSString*)getBlog;
-(int)getComment_Count;
-(int)getStyle;
-(void)setCount:(int)count;
@end
