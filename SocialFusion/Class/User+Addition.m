//
//  User+Addition.m
//  SocialFusion
//
//  Created by Blue Bitch on 11-9-17.
//  Copyright 2011年 TJU. All rights reserved.
//

#import "User+Addition.h"
#import "NSString+Pinyin.h"

@implementation User (Addition)

+ (User *)insertRenrenFriend:(NSDictionary *)dict inManagedObjectContext:(NSManagedObjectContext *)context {
    NSString *userID = [[dict objectForKey:@"id"] stringValue];
    if (!userID || [userID isEqualToString:@""]) {
        return nil;
    }
    
    User *result = [User userWithID:userID inManagedObjectContext:context];
    if (!result) {
        result = [NSEntityDescription insertNewObjectForEntityForName:@"RenrenUser" inManagedObjectContext:context];
    }
    
    
    result.userID = userID;
    
    result.name = [NSString stringWithFormat:@"%@", [dict objectForKey:@"name"]];
    result.pinyinName = [result.name pinyinFirstLetterArray];
    result.tinyURL = [dict objectForKey:@"tinyurl"];    
    return result;
}

+ (User *)userWithID:(NSString *)userID inManagedObjectContext:(NSManagedObjectContext *)context
{
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    
    [request setEntity:[NSEntityDescription entityForName:@"User" inManagedObjectContext:context]];
    [request setPredicate:[NSPredicate predicateWithFormat:@"userID == %@", userID]];
    
    User *res = [[context executeFetchRequest:request error:NULL] lastObject];
    
    [request release];
    
    return res;
}

@end
