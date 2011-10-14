//
//  NewFeedBlog.h
//  SocialFusion
//
//  Created by He Ruoyun on 11-10-14.
//  Copyright 2011年 TJU. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NewFeedRootData.h"

@interface NewFeedBlog : NewFeedRootData {
    NSString* prefix;
    NSString* title;
    NSString* description;
    int likeCount;//暂时没有用
}
-(id)initWithDictionary:(NSDictionary*)feedDic;

-(NSString*)getBlog;
@end
