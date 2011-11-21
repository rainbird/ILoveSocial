//
//  StatusCommentData+StatusCommentData_Addition.m
//  SocialFusion
//
//  Created by He Ruoyun on 11-11-21.
//  Copyright (c) 2011年 TJU. All rights reserved.
//

#import "StatusCommentData+StatusCommentData_Addition.h"

@implementation StatusCommentData (StatusCommentData_Addition)
+ (StatusCommentData *)insertNewComment:(int)style Dic:(NSDictionary *)dict inManagedObjectContext:(NSManagedObjectContext *)context
{
    
    if (style==0)
    {
  
        
        NSString  *comment_ID= [[dict objectForKey:@"comment_id"] stringValue] ;   
        
        
        if (!comment_ID || [comment_ID isEqualToString:@""]) {
            return nil;
        }
        
        StatusCommentData *result = [StatusCommentData feedWithID:comment_ID inManagedObjectContext:context];
        if (!result) {
            result = [NSEntityDescription insertNewObjectForEntityForName:@"StatusCommentData" inManagedObjectContext:context];
        }
        
        

    
        
    
    
    result.actor_ID=[[dict objectForKey:@"uid"] stringValue] ;
    
    result.owner_Head= [dict objectForKey:@"tinyurl"];
    
    result.owner_Name=[dict objectForKey:@"name"];
    
    
    NSDateFormatter *form = [[NSDateFormatter alloc] init];
    [form setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    
    NSString* dateString=[dict objectForKey:@"time"];
	result.update_Time=[form dateFromString: dateString];
    
    
    [form release];
    
    
    
    result.comment_ID= [[dict objectForKey:@"comment_id"] stringValue];
    
    result.text=[dict objectForKey:@"text"];
    
    return result;

    }
    else
    {
        
        NSString  *comment_ID= [[dict objectForKey:@"id"] stringValue] ;   
        
        
        if (!comment_ID || [comment_ID isEqualToString:@""]) {
            return nil;
        }
        
        StatusCommentData *result = [StatusCommentData feedWithID:comment_ID inManagedObjectContext:context];
        if (!result) {
            result = [NSEntityDescription insertNewObjectForEntityForName:@"StatusCommentData" inManagedObjectContext:context];
        }
        
        
        
        
        
        
        
        result.actor_ID=[[[dict objectForKey:@"user"] objectForKey:@"id"] stringValue] ;
        
        result.owner_Head= [[dict objectForKey:@"user"] objectForKey:@"profile_image_url"];
        
        result.owner_Name=[[dict objectForKey:@"user"] objectForKey:@"screen_name"];
        
        
        NSDateFormatter *form = [[NSDateFormatter alloc] init];
        [form setDateFormat:@"EEE MMM d HH:mm:ss ZZZ yyyy"];
        
        // Sat Oct 15 21:22:56 +0800 2011
        
        NSLocale* tempLocale=[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
        [form setLocale:tempLocale];
        [tempLocale release];
        
        NSString* dateString=[dict objectForKey:@"created_at"];
        //NSLog(@"%@",dateString);
        
        
        //NSDate* date=[NSDate dateWithTimeIntervalSinceNow:0];
        //NSLog(@"%@",[form stringFromDate:date]);
        //NSDate* aaa=[[form dateFromString: dateString] retain];
        //NSLog(@"%@",aaa);
        result.update_Time=[form dateFromString: dateString] ;
        [form release];
        
        
        result.comment_ID= [dict objectForKey:@"id"] ;
        
        result.text=[dict objectForKey:@"text"] ;
        
        return result;        
        
    }
    
}
+ (StatusCommentData *)feedWithID:(NSString *)statusID inManagedObjectContext:(NSManagedObjectContext *)context;
{
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:[NSEntityDescription entityForName:@"StatusCommentData" inManagedObjectContext:context]];
    [request setPredicate:[NSPredicate predicateWithFormat:@"comment_ID == %@", statusID]];
    StatusCommentData *res = [[context executeFetchRequest:request error:NULL] lastObject];
    [request release];
    return res;
}

-(NSDate*)getUpdateTime
{
    return self.update_Time;
}
-(NSString*)getOwner_Name
{
    return self.owner_Name;
}
-(NSString*)getOwner_HEAD
{
    return self.owner_Head;
}
-(NSString*)getText
{
    
    NSString* tempString=[[[NSString alloc] initWithFormat:@""] autorelease];
    
    int nameLength=[self.owner_Name length];
    
    for (int i=0;i<nameLength;i++)
    {
        
        if ([self.owner_Name characterAtIndex:i]<512)
        {
            tempString=[tempString stringByAppendingString:@" "];
        }
        else
        {
            tempString=[tempString stringByAppendingString:@"  "];
        }
    }
    
    
    
    
    // NSLog(@"%@",[tempString stringByAppendingFormat:@"%@",post_Status]);
    return [tempString stringByAppendingFormat:@":%@",self.text] ;
    
    
    
    
    
}
-(NSString*)getHeadURL
{
    return self.owner_Head;
}



@end
