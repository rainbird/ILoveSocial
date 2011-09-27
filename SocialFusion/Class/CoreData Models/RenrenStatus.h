//
//  RenrenStatus.h
//  SocialFusion
//
//  Created by Blue Bitch on 11-9-27.
//  Copyright (c) 2011年 TJU. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "Status.h"


@interface RenrenStatus : Status {
@private
}
@property (nonatomic, retain) NSString * commentsCount;
@property (nonatomic, retain) NSString * forwardMessage;
@property (nonatomic, retain) NSString * rootStatusID;
@property (nonatomic, retain) NSString * rootText;
@property (nonatomic, retain) NSString * rootUserID;
@property (nonatomic, retain) NSString * rootUserName;
@property (nonatomic, retain) NSString * url;

@end
