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

    
    style=0;
    
    
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

-(id)initWithSinaDictionary:(NSDictionary*)feedDic
{
    style=1;
    
    actor_ID=[[[feedDic objectForKey:@"user"] objectForKey:@"id"] retain];

    
    owner_Head= [[[feedDic objectForKey:@"user"] objectForKey:@"profile_image_url"] retain];
    
    
    
    owner_Name= [[feedDic objectForKey:@"user"] objectForKey:@"screen_name"];
    
    [owner_Name retain];
    
    
    NSDateFormatter *form = [[NSDateFormatter alloc] init];
    [form setDateFormat:@"ccc MMM dd HH:mm:ss zzzz yyyy"];
    
    
    NSString* dateString=[feedDic objectForKey:@"created_at"];
	update_Time=[[form dateFromString: dateString] retain];
    
    comment_Count=[[feedDic objectForKey:@"comments_count"] intValue];
    
    source_ID= [[feedDic objectForKey:@"id"] retain];
    
    return self;
    
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
