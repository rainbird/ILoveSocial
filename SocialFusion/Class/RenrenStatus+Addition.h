//
//  RenrenStatus.h
//  SocialFusion
//
//  Created by Blue Bitch on 11-9-12.
//  Copyright (c) 2011年 TJU. All rights reserved.
//

#import "RenrenStatus.h"
#import "RenrenUser.h"

@interface RenrenStatus (Addition)

+ (RenrenStatus *)insertStatus:(NSDictionary *)dict inManagedObjectContext:(NSManagedObjectContext *)context;
+ (RenrenStatus *)statusWithID:(NSString *)statusID inManagedObjectContext:(NSManagedObjectContext *)context;
+ (void)loadStatus:(RenrenUser *)user inManagedObjectContext:(NSManagedObjectContext *)context;

@end
