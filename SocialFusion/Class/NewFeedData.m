//
//  NewFeedData.m
//  SocialFusion
//
//  Created by He Ruoyun on 11-10-9.
//  Copyright 2011年 TJU. All rights reserved.
//

#import "NewFeedData.h"


@implementation NewFeedData




-(NSString*)getPostMessage
{
    NSString* tempString=@"";
   
    int nameLength=[post_Name length];
    
    for (int i=0;i<nameLength;i++)
    {
        
        if ([post_Name characterAtIndex:i]<256)
        {
            tempString=[tempString stringByAppendingString:@"   "];
        }
        else
        {
            tempString=[tempString stringByAppendingString:@"    "];
        }
    }
    
    
    
    
   // NSLog(@"%@",[tempString stringByAppendingFormat:@"%@",post_Status]);
    return [tempString stringByAppendingFormat:@" %@",post_Status] ;
    

}


-(NSString*)getPostName
{
    return post_Name;
}


-(NSString*)getName
{


    //if (description==nil)
    //description=@"";
    
    NSString* tempString=@"";

    
    int nameLength=[owner_Name length];
    
    for (int i=0;i<nameLength;i++)
    {
        
        if ([owner_Name characterAtIndex:i]<256)
        {
              tempString=[tempString stringByAppendingString:@"   "];
        }
        else
        {
            tempString=[tempString stringByAppendingString:@"    "];
        }
    }


    
    
    
    return [tempString stringByAppendingFormat:@" %@",message]  ;
    
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
            post_ID=[[attachment objectForKey:@"owner_id"] retain];
            
            post_Name=[[attachment objectForKey:@"owner_name"] retain];
            
            
            post_Status=[[attachment objectForKey:@"content"] retain];
        }

    }


    
	

    
    message=[feedDic objectForKey:@"message"];
    [message retain];
    
    return self;
    
}

-(id)initWithSinaDictionary:(NSDictionary*)feedDic
{
    
    self=[super initWithSinaDictionary:feedDic]; 
    
    NSDictionary* attachment=[feedDic objectForKey:@"retweeted_status"];
    if ([attachment count]!=0)
    {
   
        if ([attachment count]!=0)
        {
            post_ID=[[[attachment  objectForKey:@"user"] objectForKey:@"id"] retain];
            
            
            
    
            
            
            post_Name=[[[attachment objectForKey:@"user"] objectForKey:@"screen_name"] retain];

            
            
            post_Status=[[attachment objectForKey:@"text"] retain];
        }
        
    }
    
    
    
	
    
    
    message=[feedDic objectForKey:@"text"];
    [message retain];
    

    
    
    return self;
}



@end
