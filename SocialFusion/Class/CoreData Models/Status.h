//
//  Status.h
//  SocialFusion
//
//  Created by Blue Bitch on 11-9-27.
//  Copyright (c) 2011年 TJU. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class User;

@interface Status : NSManagedObject {
@private
}
@property (nonatomic, retain) NSDate * createdAt;
@property (nonatomic, retain) NSString * statusID;
@property (nonatomic, retain) NSString * text;
@property (nonatomic, retain) User *author;

@end
