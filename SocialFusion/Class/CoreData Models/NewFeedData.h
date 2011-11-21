//
//  NewFeedData.h
//  SocialFusion
//
//  Created by He Ruoyun on 11-11-21.
//  Copyright (c) 2011年 TJU. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "NewFeedRootData.h"


@interface NewFeedData : NewFeedRootData

@property (nonatomic, retain) NSString * repost_StatusID;
@property (nonatomic, retain) NSString * message;
@property (nonatomic, retain) NSString * repost_Status;
@property (nonatomic, retain) NSString * repost_ID;
@property (nonatomic, retain) NSString * pic_URL;
@property (nonatomic, retain) NSString * repost_Name;

@end
