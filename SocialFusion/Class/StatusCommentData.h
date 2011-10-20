//
//  StatusCommentData.h
//  SocialFusion
//
//  Created by He Ruoyun on 11-10-18.
//  Copyright (c) 2011年 TJU. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StatusCommentData : NSObject
{
    //数据来源 人人或新浪 0为人人
    int style;
    
    
    //作者id
    NSString*   actor_ID;
    
    
    //更新时间
    NSDate*         update_Time;
    
    
    //作者名字
    NSString*       owner_Name;
    
    
    //作者头像
    NSString*          owner_Head;
    
    //评论id
    NSString*   comment_ID;
    
    //评论内容
    NSString* text;
}
-(id)initWithDictionary:(NSDictionary*)feedDic;
-(id)initWithSinaDictionary:(NSDictionary*)feedDic;
-(NSDate*)getUpdateTime;
-(NSString*)getOwner_Name;
-(NSString*)getOwner_HEAD;
-(NSString*)getText;
-(NSString*)getHeadURL;
@end
