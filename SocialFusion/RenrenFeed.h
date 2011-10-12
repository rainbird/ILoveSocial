//
//  RenrenFeed.h
//  SocialFusion
//
//  Created by He Ruoyun on 11-10-5.
//  Copyright (c) 2011年 TJU. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "Status.h"


@interface RenrenFeed : Status {
@private
}
@property (nonatomic, retain) NSString * commentsCount;
@property (nonatomic, retain) NSString * Message;
@property (nonatomic, retain) NSString * likeCount;
@property (nonatomic, retain) NSString * url;
@property (nonatomic, retain) NSString * prefix;
@property (nonatomic, retain) NSString * sourceID;
@property (nonatomic, retain) NSString * feedType;

@end
