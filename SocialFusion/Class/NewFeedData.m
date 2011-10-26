//
//  NewFeedData.m
//  SocialFusion
//
//  Created by He Ruoyun on 11-10-9.
//  Copyright 2011年 TJU. All rights reserved.
//

#import "NewFeedData.h"
#import "RenrenClient.h"

@implementation NewFeedData


-(void)dealloc
{
    
    
    [post_Status release];
    [post_Name release];
    [post_ID release];
    
    
    
    [message release];
    [super dealloc];
    
}

-(NSString*)getPostMessage
{
    NSString* tempString=[[[NSString alloc] initWithFormat:@""] autorelease];
    
    int nameLength=[post_Name length];
    
    for (int i=0;i<nameLength;i++)
    {
        
        if ([post_Name characterAtIndex:i]<512)
        {
            tempString=[tempString stringByAppendingString:@" "];
        }
        else
        {
            tempString=[tempString stringByAppendingString:@"  "];
        }
    }
    
    
    
    
    // NSLog(@"%@",[tempString stringByAppendingFormat:@"%@",post_Status]);
    return [tempString stringByAppendingFormat:@":%@",post_Status] ;
    
    
}


-(NSString*)getPostName
{
    return post_Name;
}


-(NSString*)getName
{
    
    
    //if (description==nil)
    //description=@"";
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
    
    
    
    
    
    return [tempString stringByAppendingFormat:@":%@",message]  ;
    
}
-(id)initWithDictionary:(NSDictionary*)feedDic
{
    self=[super initWithDictionary:feedDic]; 
    
    
    
    NSArray* attachments=[feedDic objectForKey:@"attachment"];
    if ([attachments count]!=0)
    {
        NSDictionary* attachment=[attachments objectAtIndex:0];
        if ([attachment count]!=0)
        {
            post_ID=[[[attachment objectForKey:@"owner_id"] stringValue] retain];
            
            post_Name=[[attachment objectForKey:@"owner_name"] retain];
            
            
            post_Status=[[attachment objectForKey:@"content"] retain];
            
            post_StatusID=[[[attachment objectForKey:@"media_id"] stringValue] retain];
            // NSLog(@"%@",attachment)
        }
        
    }
    
    
    
	
    
    
    message=[feedDic objectForKey:@"message"];
    [message retain];
    
    return self;
    
}

-(id)initWithSelfDic:(NSDictionary*)feedDic andStyle:(int)iStyle
{
    //NewFeedData* newFeedData=[[NewFeedData alloc] init];
    actor_ID=[[feedDic objectForKey:@"actor_ID"] retain];
    update_Time=[[feedDic objectForKey:@"update"] retain];
    owner_Name=[[feedDic objectForKey:@"owner_Name"] retain];
    message=[[feedDic objectForKey:@"post_Status"] retain];
    source_ID=[[feedDic objectForKey:@"post_StatusID"] retain];
    
    // comment_Count=iCount;
    
    style=iStyle;
    return self;
}


-(NewFeedData*)getOriginalFeed
{
    
    /*  
     if (style==0)
     {
     RenrenClient *renren = [RenrenClient client];
     [renren setCompletionBlock:^(RenrenClient *client) {
     if(!client.hasError) {
     NSDictionary *dic = client.responseJSONObject;
     //  NSLog(@"renren friend count:%d", array.count);
     //NSLog(@"add finished");
     
     int post_Count=[[dic objectForKey:@"comment_count"] intValue];
     }
     
     
     // [self doneLoadingTableViewData];
     //  _loading = NO;
     
     
     }];
     [renren getStatus:post_ID status_ID:post_StatusID];
     
     
     }
     
     */ 
    
    
    NSDictionary* tempDictionary=[[NSDictionary alloc] initWithObjectsAndKeys:post_ID,@"actor_ID",
                                  update_Time,@"update",
                                  post_Name,@"owner_Name",
                                  post_Status,@"post_Status",post_StatusID,@"post_StatusID",
                                  nil];
    
    NewFeedData* data=[[NewFeedData alloc] initWithSelfDic:tempDictionary andStyle:style];
    
    [tempDictionary release];
    
    return data;
    
    
}

-(id)initWithSinaDictionary:(NSDictionary*)feedDic
{
    
    self=[super initWithSinaDictionary:feedDic]; 
    
    NSDictionary* attachment=[feedDic objectForKey:@"retweeted_status"];
    if ([attachment count]!=0)
    {
        
        if ([attachment count]!=0)
        {
            post_ID=[[[[attachment  objectForKey:@"user"] objectForKey:@"id"] stringValue] retain];
            
            
            post_StatusID=[[[attachment objectForKey:@"id"] stringValue ]retain];
            
            
            
            post_Name=[[[attachment objectForKey:@"user"] objectForKey:@"screen_name"] retain];
            
            
            
            post_Status=[[attachment objectForKey:@"text"] retain];
            
            
            //  post_Count=[[attachment objectForKey:@"comment_count"]  intValue];
            
            NSLog(@"%@",attachment);
        }
        
    }
    
    
    
	
    
    
    message=[feedDic objectForKey:@"text"];
    [message retain];
    
    
    
    
    return self;
}



@end
