//
//  User.h
//  SocialFusion
//
//  Created by Blue Bitch on 11-10-5.
//  Copyright (c) 2011年 TJU. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface User : NSManagedObject {
@private
}
@property (nonatomic, retain) NSString * userID;
@property (nonatomic, retain) NSDate * updateDate;
@property (nonatomic, retain) NSString * tinyURL;
@property (nonatomic, retain) NSString * pinyinName;
@property (nonatomic, retain) NSString * latestStatus;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSSet *statuses;
@property (nonatomic, retain) NSManagedObject *detailInformation;
@end

@interface User (CoreDataGeneratedAccessors)
- (void)addStatusesObject:(NSManagedObject *)value;
- (void)removeStatusesObject:(NSManagedObject *)value;
- (void)addStatuses:(NSSet *)value;
- (void)removeStatuses:(NSSet *)value;

@end
