//
//  RenrenDetail+Addition.h
//  SocialFusion
//
//  Created by Blue Bitch on 11-10-5.
//  Copyright 2011年 TJU. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RenrenDetail.h"

@interface RenrenDetail (Addition)

+ (RenrenDetail *)insertDetailInformation:(NSDictionary *)dict userID:(NSString *)userID inManagedObjectContext:(NSManagedObjectContext *)context;
+ (RenrenDetail *)detailWithID:(NSString *)userID inManagedObjectContext:(NSManagedObjectContext *)context;

@end
