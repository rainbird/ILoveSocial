//
//  NewFeedData.h
//  SocialFusion
//
//  Created by He Ruoyun on 11-10-9.
//  Copyright 2011年 TJU. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NewFeedRootData.h"

@interface NewFeedData : NewFeedRootData {
    
    
    //原信息
    NSString*       post_Status;
    //原作者
    NSString*       post_Name;
    //原作者id
    NSString*       post_ID;
    
    
    //
   // NSString*       description;

 //   int             likes_Count;
    
   // NSString*       prefix;
    //int             type;
    
    //消息
    NSString*       message;
}


-(id)initWithDictionary:(NSDictionary*)feedDic;
-(id)initWithSinaDictionary:(NSDictionary*)feedDic;

-(NSString*)getPostMessage;
-(NSString*)getPostName;


-(NSString*)getName;

@end
