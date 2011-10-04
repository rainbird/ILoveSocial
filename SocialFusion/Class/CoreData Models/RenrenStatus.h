//
//  RenrenStatus.h
//  SocialFusion
//
//  Created by He Ruoyun on 11-10-4.
//  Copyright (c) 2011年 TJU. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "Status.h"


@interface RenrenStatus : Status {
@private
}
@property (nonatomic, retain) NSString * rootStatusID;
@property (nonatomic, retain) NSString * prefix;
@property (nonatomic, retain) NSString * rootUserID;
@property (nonatomic, retain) NSString * rootText;
@property (nonatomic, retain) NSString * forwardMessage;
@property (nonatomic, retain) NSString * commentsCount;
@property (nonatomic, retain) NSString * rootUserName;
@property (nonatomic, retain) NSString * likeCount;
@property (nonatomic, retain) NSString * feedType;
@property (nonatomic, retain) NSString * url;

@end
