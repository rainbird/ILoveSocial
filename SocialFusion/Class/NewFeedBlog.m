//
//  NewFeedBlog.m
//  SocialFusion
//
//  Created by He Ruoyun on 11-10-14.
//  Copyright 2011年 TJU. All rights reserved.
//

#import "NewFeedBlog.h"


@implementation NewFeedBlog



-(void )dealloc
{
     [prefix release];
     [title release];
 [description release];
    [super dealloc];
}
-(id)initWithDictionary:(NSDictionary*)feedDic
{
    self=[super initWithDictionary:feedDic]; 
    
    
    
    
    prefix=[[feedDic objectForKey:@"prefix"] retain];
    title=[[feedDic objectForKey:@"title"] retain];
    description=[[feedDic objectForKey:@"description"] retain];
    //likeCount=[[feedDic objectForKey:@"likes"]
    return self;
    
}


-(NSString*)getBlog
{
    return description;
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
    
    
    
    
    
    return [[tempString stringByAppendingFormat:@"%@",prefix] stringByAppendingFormat:@"%@",title]  ;
    
}



@end
