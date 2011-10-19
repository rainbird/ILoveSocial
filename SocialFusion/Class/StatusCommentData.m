//
//  StatusCommentData.m
//  SocialFusion
//
//  Created by He Ruoyun on 11-10-18.
//  Copyright (c) 2011年 TJU. All rights reserved.
//

#import "StatusCommentData.h"


@implementation StatusCommentData


-(id)initWithSinaDictionary:(NSDictionary*)feedDic
{
    style=1;
    
    
    actor_ID=[[[[feedDic objectForKey:@"user"] objectForKey:@"id"] stringValue] retain];
    
    owner_Head= [[[feedDic objectForKey:@"user"] objectForKey:@"profile_image_url"] retain];
    
    owner_Name=[[feedDic objectForKey:@"user"] objectForKey:@"screen_name"];
    [owner_Name retain];
    
    
    NSDateFormatter *form = [[NSDateFormatter alloc] init];
    [form setDateFormat:@"EEE MMM d HH:mm:ss ZZZ yyyy"];
    
    // Sat Oct 15 21:22:56 +0800 2011
    
    NSLocale* tempLocale=[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
    [form setLocale:tempLocale];
    [tempLocale release];
    
    NSString* dateString=[feedDic objectForKey:@"created_at"];
    //NSLog(@"%@",dateString);
    
    
    //NSDate* date=[NSDate dateWithTimeIntervalSinceNow:0];
    //NSLog(@"%@",[form stringFromDate:date]);
    //NSDate* aaa=[[form dateFromString: dateString] retain];
    //NSLog(@"%@",aaa);
	update_Time=[[form dateFromString: dateString] retain];
    [form release];
    
    
    comment_ID= [[feedDic objectForKey:@"id"] retain];
    
    text=[[feedDic objectForKey:@"text"] retain];
    
    return self;

}
-(id)initWithDictionary:(NSDictionary*)feedDic
{
    
    
    style=0;
    
    
    actor_ID=[[feedDic objectForKey:@"uid"] retain];
    
    owner_Head= [[feedDic objectForKey:@"tinyurl"] retain];
    
    owner_Name=[feedDic objectForKey:@"name"];
    [owner_Name retain];
    
    
    NSDateFormatter *form = [[NSDateFormatter alloc] init];
    [form setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    
    NSString* dateString=[feedDic objectForKey:@"time"];
	update_Time=[[form dateFromString: dateString] retain];
    
    
    [form release];
    

    
    comment_ID= [[feedDic objectForKey:@"comment_id"] retain];
    
    text=[[feedDic objectForKey:@"text"] retain];
    
    return self;
    
}

-(NSDate*)getUpdateTime
{
    return update_Time;
}
-(NSString*)getOwner_Name
{
    return owner_Name;
}
-(NSString*)getOwner_HEAD
{
    return owner_Head;
}
-(NSString*)getText
{
    
    NSString* tempString=[[[NSString alloc] initWithFormat:@""] autorelease];
    
    int nameLength=[owner_Name length];
    
    for (int i=0;i<nameLength;i++)
    {
        
        if ([owner_Name characterAtIndex:i]<512)
        {
            tempString=[tempString stringByAppendingString:@" "];
        }
        else
        {
            tempString=[tempString stringByAppendingString:@"  "];
        }
    }
    
    
    
    
    // NSLog(@"%@",[tempString stringByAppendingFormat:@"%@",post_Status]);
    return [tempString stringByAppendingFormat:@":%@",text] ;
    

    
    

}
-(NSString*)getHeadURL
{
    return owner_Head;
}
@end
