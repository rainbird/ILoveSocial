//
//  NewFeedData.m
//  SocialFusion
//
//  Created by He Ruoyun on 11-10-9.
//  Copyright 2011年 TJU. All rights reserved.
//

#import "NewFeedData.h"


@implementation NewFeedData
@synthesize owner_Name;

-(NSString*)getFeedName
{
    return owner_Name;
}
-(NSString*)getName
{
    
    if (prefix==nil)
        prefix=@"";
    if (title==nil)
        title=@"";
    if (message==nil)
        message=@"";
    //if (description==nil)
    //description=@"";
    
    NSString* tempString=@"";

    
    int nameLength=[owner_Name length];
    
    for (int i=0;i<nameLength;i++)
    {
            tempString=[tempString stringByAppendingString:@"    "];
    }


    
    
    
    return [[[tempString stringByAppendingFormat:@"%@",prefix] stringByAppendingFormat:@"%@",title] stringByAppendingFormat:@"%@",message] ;
    
}
-(NSString*)getHeadURL
{
    return owner_Head;
}
-(id)initWithDictionary:(NSDictionary*)feedDic
{
    post_ID=[[feedDic objectForKey:@"post_id"] longLongValue];
    
    actor_ID=[[feedDic objectForKey:@"actor_id"] longLongValue];
    
    title=[feedDic objectForKey:@"title"];
    
    [title retain];
    
   owner_Head= [[feedDic objectForKey:@"headurl"] retain];
 
    
    prefix=[feedDic objectForKey:@"prefix"];
    [prefix retain];
    
    description=[feedDic objectForKey:@"description"];
    [description retain];
    
    owner_Name=[feedDic objectForKey:@"name"];
    [owner_Name retain];
    
    comment_Count=[[[feedDic objectForKey:@"comments"] objectForKey:@"count"] intValue];
    
    likes_Count=[[feedDic objectForKey:@"total_count"] intValue];
    
    
    NSDateFormatter *form = [[NSDateFormatter alloc] init];
    [form setDateFormat:@"yyyy-MM-dd HH:mm:ss"];

    
    NSString* dateString=[feedDic objectForKey:@"update_time"];
	update_Time=[[form dateFromString: dateString] retain];
    
    
	
    //  NSDate* TempDate=[NSDate dateWithString:@"2011-08-03 21:01:00 +0900"];
   // NSLog(@"%@",update_Time);
    
    // NSDate*         update_Time;
    
    message=[feedDic objectForKey:@"message"];
    [message retain];
    
    return self;
    
}


-(NSDate*)getDate
{
    return update_Time;
}


@end
