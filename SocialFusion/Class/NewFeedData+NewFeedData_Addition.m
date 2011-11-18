//
//  NewFeedData+NewFeedData_Addition.m
//  SocialFusion
//
//  Created by He Ruoyun on 11-11-7.
//  Copyright (c) 2011年 TJU. All rights reserved.
//

#import "NewFeedData+NewFeedData_Addition.h"
#import "NewFeedRootData+NewFeedRootData_Addition.h"
@implementation NewFeedData (NewFeedData_Addition)

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
    self.comment_Count=[NSNumber numberWithInt:count];
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


-(NSString*)getPostMessage
{
    NSString* tempString=[[[NSString alloc] initWithFormat:@""] autorelease];
    
    int nameLength=[self.repost_Name length];
    
    for (int i=0;i<nameLength;i++)
    {
        
        if ([self.repost_Name characterAtIndex:i]<512)
        {
            tempString=[tempString stringByAppendingString:@" "];
        }
        else
        {
            tempString=[tempString stringByAppendingString:@"  "];
        }
    }
    
    
    
    
    // NSLog(@"%@",[tempString stringByAppendingFormat:@"%@",post_Status]);
    return [tempString stringByAppendingFormat:@":%@",self.repost_Status] ;
    
    
}


-(NSString*)getPostName
{
    return self.repost_Name;
}


-(NSString*)getName
{
    
    
    //if (description==nil)
    //description=@"";
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
    
    
    
    
    
    return [tempString stringByAppendingFormat:@":%@",self.message]  ;
    
}




+ (NewFeedData *)insertNewFeed:(int)sytle Owner:(User*)myUser Dic:(NSDictionary *)dict inManagedObjectContext:(NSManagedObjectContext *)context
{
    
    if (sytle==0)//renren
    {
        NSString *statusID = [NSString stringWithFormat:@"%@", [[dict objectForKey:@"post_id"] stringValue]];
        if (!statusID || [statusID isEqualToString:@""]) {
            return nil;
        }
        
        NewFeedData *result = [NewFeedData feedWithID:statusID inManagedObjectContext:context];
        if (!result) {
            result = [NSEntityDescription insertNewObjectForEntityForName:@"NewFeedData" inManagedObjectContext:context];
        }
        
        
        result.post_ID = statusID;
        
        
        result.style=[NSNumber numberWithInt:sytle];
        
        NSLog(@"%@",result.style);
        
        result.actor_ID=[[dict objectForKey:@"actor_id"] stringValue];
        
        result.owner_Head= [dict objectForKey:@"headurl"] ;
        
        result.owner_Name=[dict objectForKey:@"name"] ;
        
        
        
        NSDateFormatter *form = [[NSDateFormatter alloc] init];
        [form setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        
        
        NSString* dateString=[dict objectForKey:@"update_time"];
        result.update_Time=[form dateFromString: dateString];
        
        
        [form release];
        
        
        result.comment_Count=[NSNumber numberWithInt:    [ [[dict objectForKey:@"comments"] objectForKey:@"count"] intValue]];
        
        result.source_ID= [[dict objectForKey:@"source_id"] stringValue];
        
        result.owner=myUser;
        
        
        
        
        NSArray* attachments=[dict objectForKey:@"attachment"];
        if ([attachments count]!=0)
        {
            NSDictionary* attachment=[attachments objectAtIndex:0];
            if ([attachment count]!=0)
            {
                result.repost_ID=[[attachment objectForKey:@"owner_id"] stringValue] ;
                
                result.repost_Name=[attachment objectForKey:@"owner_name"];
                
                
                result.repost_Status=[attachment objectForKey:@"content"] ;
                
                result.repost_StatusID=[[attachment objectForKey:@"media_id"] stringValue] ;
                // NSLog(@"%@",attachment)
            }
            
        }

            result.message=[dict objectForKey:@"message"];
        
        
        return result;
        
        // 将自己添加到对应user的statuses里
        // NSString *authorID = [NSString stringWithFormat:@"%@", [dict objectForKey:@"uid"]];
        // result.author = [RenrenUser userWithID:authorID inManagedObjectContext:context];
    }
    else
    {
        
        
        NSString *statusID = [NSString stringWithFormat:@"%@", [dict objectForKey:@"id"]];
        
        //   NSLog(@"%@",statusID);
        if (!statusID || [statusID isEqualToString:@""]) {
            return nil;
        }
        
        NewFeedData *result = [NewFeedData feedWithID:statusID inManagedObjectContext:context];
        if (!result) {
            result = [NSEntityDescription insertNewObjectForEntityForName:@"NewFeedData" inManagedObjectContext:context];
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
        
        
        
        //      NSLog(@"%@",result);
        
        
        
        NSDictionary* attachment=[dict objectForKey:@"retweeted_status"];
        if ([attachment count]!=0)
        {
            
            if ([attachment count]!=0)
            {
                result.repost_ID=[[[attachment  objectForKey:@"user"] objectForKey:@"id"] stringValue];
                
                
                result.repost_StatusID=[[attachment objectForKey:@"id"] stringValue ];
                
                
                
                result.repost_Name=[[attachment objectForKey:@"user"] objectForKey:@"screen_name"] ;
                
                
                
                result.repost_Status=[attachment objectForKey:@"text"] ;
                
                
                //  post_Count=[[attachment objectForKey:@"comment_count"]  intValue];
                
            //    NSLog(@"%@",attachment);
            }
            
        }

        
        
       result.message=[dict objectForKey:@"text"];
        
        return result;
        
        
        
        
        
    }
    
    
    
    
    
    
    
    
    
    
}


+ (NewFeedData *)feedWithID:(NSString *)statusID inManagedObjectContext:(NSManagedObjectContext *)context
{
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:[NSEntityDescription entityForName:@"NewFeedData" inManagedObjectContext:context]];
    [request setPredicate:[NSPredicate predicateWithFormat:@"post_ID == %@", statusID]];
    NewFeedData *res = [[context executeFetchRequest:request error:NULL] lastObject];
    [request release];
    return res;
}



@end
