//
//  NewFeedData.h
//  SocialFusion
//
//  Created by He Ruoyun on 11-10-9.
//  Copyright 2011年 TJU. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NewFeedData : NSObject {
    NSDate*         update_Time;
    long long       post_ID;
    long long       actor_ID;
    NSString*       title;
    NSString*       description;
    NSString*       owner_Name;
    NSString*          owner_Head;
    int             comment_Count;
    int             likes_Count;
    
    NSString*       prefix;
    //int             type;
    NSString*       message;
}
@property(nonatomic,retain) NSString* owner_Name;

-(id)initWithDictionary:(NSDictionary*)feedDic;


-(NSDate*)getDate;
-(NSString*)getName;
-(NSString*)getFeedName;
-(NSString*)getHeadURL;
@end
