//
//  NewFeedRootData.m
//  SocialFusion
//
//  Created by He Ruoyun on 11-10-14.
//  Copyright 2011年 TJU. All rights reserved.
//

#import "NewFeedRootData.h"


@implementation NewFeedRootData

-(NSString*)getBlog
{
    return nil;
}
-(id)initWithDictionary:(NSDictionary*)feedDic
{

    actor_ID=[[feedDic objectForKey:@"actor_id"] retain];
    
    owner_Head= [[feedDic objectForKey:@"headurl"] retain];
    
    owner_Name=[feedDic objectForKey:@"name"];
    [owner_Name retain];

    
    NSDateFormatter *form = [[NSDateFormatter alloc] init];
    [form setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    
    NSString* dateString=[feedDic objectForKey:@"update_time"];
	update_Time=[[form dateFromString: dateString] retain];
    
    comment_Count=[[[feedDic objectForKey:@"comments"] objectForKey:@"count"] intValue];
    
    source_ID= [[feedDic objectForKey:@"source_id"] retain];
    
    return self;
    
}

-(NSDate*)getDate
{
    return update_Time;
}




-(NSString*)getFeedName
{
    return owner_Name;
}



-(NSString*)getHeadURL
{
    return owner_Head;
}



@end
