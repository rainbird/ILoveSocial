//
//  NewFeedRootData+NewFeedRootData_Addition.m
//  SocialFusion
//
//  Created by He Ruoyun on 11-11-7.
//  Copyright (c) 2011年 TJU. All rights reserved.
//

#import "NewFeedRootData+NewFeedRootData_Addition.h"
#import "User.h"
#import "WeiboUser+Addition.h"
@implementation NewFeedRootData (NewFeedRootData_Addition)


-(NSString*)getBlog
{
    return nil;
}
-(NSString*)getActor_ID
{
    
    return self.actor_ID;
}
-(NSString*)getSource_ID
{
    return self.source_ID;
}

-(int)getComment_Count
{
    return [self.comment_Count intValue];
}


-(void)setCount:(int)count
{
    self.comment_Count=[NSNumber numberWithInt:  count];
}
-(NSDate*)getDate
{
    return self.update_Time;
}



-(int)getStyle
{
    return [self.style intValue];
}

-(NSString*)getFeedName
{
    return self.owner_Name;
}



-(NSString*)getHeadURL
{
    return self.owner_Head;
}



+ (NewFeedRootData *)insertNewFeed:(int)sytle getDate:(NSDate*)getDate Owner:(User*)myUser Dic:(NSDictionary *)dict inManagedObjectContext:(NSManagedObjectContext *)context
{
    
    
    
    if (sytle==0)//renren
    {
        NSString *statusID = [NSString stringWithFormat:@"%@", [[dict objectForKey:@"post_id"] stringValue]];
        if (!statusID || [statusID isEqualToString:@""]) {
            return nil;
        }
        
        NewFeedRootData *result = [NewFeedRootData feedWithID:statusID inManagedObjectContext:context];
        if (!result) {
            result = [NSEntityDescription insertNewObjectForEntityForName:@"NewFeedRootData" inManagedObjectContext:context];
        }
        
        
        result.post_ID = statusID;
        
        
        result.style=[NSNumber numberWithInt:sytle];
        
        
        result.actor_ID=[[dict objectForKey:@"actor_id"] stringValue];
        
        
        result.owner_Head= [dict objectForKey:@"headurl"] ;
        
        result.owner_Name=[dict objectForKey:@"name"] ;
        
        
        
        NSDateFormatter *form = [[NSDateFormatter alloc] init];
        [form setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        
        
        NSString* dateString=[dict objectForKey:@"update_time"];
        result.update_Time=[form dateFromString: dateString];
        
        
        [form release];
        
        
        result.comment_Count=[NSNumber numberWithInt:    [[[dict objectForKey:@"comments"] objectForKey:@"count"] intValue]
                              ];
        
        result.source_ID= [[dict objectForKey:@"source_id"] stringValue];
        
        result.owner=myUser;
        
        
        
        result.get_Time=getDate;
        return result;
        
        // 将自己添加到对应user的statuses里
        // NSString *authorID = [NSString stringWithFormat:@"%@", [dict objectForKey:@"uid"]];
        // result.author = [RenrenUser userWithID:authorID inManagedObjectContext:context];
    }
    else//weibo
    {
        
        
        NSString *statusID = [NSString stringWithFormat:@"%@", [dict objectForKey:@"id"]];
        
        //   NSLog(@"%@",statusID);
        if (!statusID || [statusID isEqualToString:@""]) {
            return nil;
        }
        
        NewFeedRootData *result = [NewFeedRootData feedWithID:statusID inManagedObjectContext:context];
        if (!result) {
            result = [NSEntityDescription insertNewObjectForEntityForName:@"NewFeedRootData" inManagedObjectContext:context];
        }
        
        
        result.owner_Name= [[dict objectForKey:@"user"] objectForKey:@"screen_name"];
        result.post_ID = statusID;
        
        
        result.style=[NSNumber numberWithInt:sytle];
        
        
        // NSLog(@"%@",result.style);
        result.actor_ID=[[[dict objectForKey:@"user"] objectForKey:@"id"] stringValue] ;
        
        result.owner_Head=[[dict objectForKey:@"user"] objectForKey:@"profile_image_url"];
        
        
        
        
        
        NSDateFormatter *form = [[NSDateFormatter alloc] init];
        [form setDateFormat:@"EEE MMM dd HH:mm:ss ZZZ yyyy"];
        
        // Sat Oct 15 21:22:56 +0800 2011
        
        NSLocale* tempLocale=[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
        [form setLocale:tempLocale];
        [tempLocale release];
        
        //  [form setShortStandaloneWeekdaySymbols:[NSArray arrayWithObjects:@"Mon",@"Tue",@"Fri",@"Sat",@"Sun",nil]];
        NSString* dateString=[dict objectForKey:@"created_at"];
        
        
        
        result.update_Time=[form dateFromString: dateString];
        
        
        [form release];
        
        
        
        
        result.comment_Count=[NSNumber numberWithInt:   [[dict objectForKey:@"comment_count"] intValue]];
        
        result.source_ID= [[dict objectForKey:@"id"] stringValue];
        
        
        
        
        //  NSString *authorID =    result.actor_ID;
        // result.owner = [WeiboUser userWithID:authorID inManagedObjectContext:context];
        // result.owner=nil;
        result.owner=myUser;
        
        
        
        result.get_Time=getDate;
        //      NSLog(@"%@",result);
        
        return result;
        
        
        
        
        
    }
    
    
    
    
    
    
    
    
    
    
}


+ (NewFeedRootData *)feedWithID:(NSString *)statusID inManagedObjectContext:(NSManagedObjectContext *)context
{
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:[NSEntityDescription entityForName:@"NewFeedRootData" inManagedObjectContext:context]];
    [request setPredicate:[NSPredicate predicateWithFormat:@"post_ID == %@", statusID]];
    NewFeedRootData *res = [[context executeFetchRequest:request error:NULL] lastObject];
    [request release];
    return res;
}




@end
