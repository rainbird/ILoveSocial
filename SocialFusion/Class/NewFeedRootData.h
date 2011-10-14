//
//  NewFeedRootData.h
//  SocialFusion
//
//  Created by He Ruoyun on 11-10-14.
//  Copyright 2011年 TJU. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NewFeedRootData : NSObject {
    //作者id
    NSString*   actor_ID;
    //更新时间
    NSDate*         update_Time;
    //作者名字
    NSString*       owner_Name;
    //作者头像
    NSString*          owner_Head;
    //评论数量
    int             comment_Count;
    //主体id
    NSString*   source_ID;
}

//初始化
-(id)initWithDictionary:(NSDictionary*)feedDic;

-(NSString*)getFeedName;
-(NSString*)getHeadURL;
-(NSDate*)getDate;

-(NSString*)getBlog;
@end
