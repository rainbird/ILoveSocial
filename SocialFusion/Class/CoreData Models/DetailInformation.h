//
//  DetailInformation.h
//  SocialFusion
//
//  Created by Blue Bitch on 11-10-5.
//  Copyright (c) 2011年 TJU. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class User;

@interface DetailInformation : NSManagedObject {
@private
}
@property (nonatomic, retain) NSString * ownerID;
@property (nonatomic, retain) User *owner;

@end
