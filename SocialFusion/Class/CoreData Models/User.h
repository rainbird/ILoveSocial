//
//  User.h
//  SocialFusion
//
//  Created by He Ruoyun on 11-10-4.
//  Copyright (c) 2011年 TJU. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Status;

@interface User : NSManagedObject {
@private
}
@property (nonatomic, retain) NSString * userID;
@property (nonatomic, retain) NSDate * updateDate;
@property (nonatomic, retain) NSString * tinyURL;
@property (nonatomic, retain) NSString * pinyinName;
@property (nonatomic, retain) NSString * latestStatus;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSSet* statuses;

@end
