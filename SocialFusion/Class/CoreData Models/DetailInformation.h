//
//  DetailInformation.h
//  SocialFusion
//
//  Created by He Ruoyun on 11-11-18.
//  Copyright (c) 2011年 TJU. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class User;

@interface DetailInformation : NSManagedObject

@property (nonatomic, retain) NSString * ownerID;
@property (nonatomic, retain) User *owner;

@end
