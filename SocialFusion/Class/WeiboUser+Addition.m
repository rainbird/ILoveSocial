//
//  WeiboUser.m
//  SocialFusion
//
//  Created by Blue Bitch on 11-9-9.
//  Copyright (c) 2011年 TJU. All rights reserved.
//

#import "WeiboUser+Addition.h"
#import "NSString+Pinyin.h"


@implementation WeiboUser (Addition)

+ (WeiboUser *)insertUser:(NSDictionary *)dict inManagedObjectContext:(NSManagedObjectContext *)context
{
    NSString *userID = [[dict objectForKey:@"id"] stringValue];
    
    if (!userID || [userID isEqualToString:@""]) {
        return nil;
    }
    
    WeiboUser *result = [WeiboUser userWithID:userID inManagedObjectContext:context];
    if (!result) {
        result = [NSEntityDescription insertNewObjectForEntityForName:@"WeiboUser" inManagedObjectContext:context];
    }
    
    result.updateDate = [NSDate date];
    
    result.userID = userID;
    result.name = [NSString stringWithFormat:@"%@", [dict objectForKey:@"screen_name"]];
    result.pinyinName = [result.name pinyinFirstLetterArray];
    NSDictionary *statusDict = [dict objectForKey:@"status"];
    result.latestStatus = [statusDict objectForKey:@"text"];
    
    //NSString *dateString = [dict objectForKey:@"created_at"];
    //result.createdAt = [NSDate dateFromStringRepresentation:dateString];
    
    //result.profileImageURL = [dict objectForKey:@"profile_image_url"];
    result.tinyURL = [dict objectForKey:@"profile_image_url"];
    result.gender = [dict objectForKey:@"gender"];
    result.selfDescription = [dict objectForKey:@"description"];
    result.location = [dict objectForKey:@"location"];
    result.verified = [NSNumber numberWithBool:[[dict objectForKey:@"verified"] boolValue]];
    
    result.domainURL = [dict objectForKey:@"domain"];
    result.blogURL = [dict objectForKey:@"url"];
    
    result.friendsCount = [[dict objectForKey:@"friends_count"] stringValue];
    result.followersCount = [[dict objectForKey:@"followers_count"] stringValue];
    result.statusesCount = [[dict objectForKey:@"statuses_count"] stringValue];
    result.favouritesCount = [[dict objectForKey:@"favourites_count"] stringValue];
    
    BOOL following = [[dict objectForKey:@"following"] boolValue];
    
    result.following = [NSNumber numberWithBool:following];
    
    return result;
}

+ (WeiboUser *)userWithID:(NSString *)userID inManagedObjectContext:(NSManagedObjectContext *)context
{
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    
    [request setEntity:[NSEntityDescription entityForName:@"WeiboUser" inManagedObjectContext:context]];
    [request setPredicate:[NSPredicate predicateWithFormat:@"userID == %@", userID]];
    
    WeiboUser *res = [[context executeFetchRequest:request error:NULL] lastObject];
    
    [request release];
    
    return res;
}

+ (NSArray *)allUsersInManagedObjectContext:(NSManagedObjectContext *)context {
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    
    [request setEntity:[NSEntityDescription entityForName:@"RenrenUser" inManagedObjectContext:context]];
    NSArray *res = [context executeFetchRequest:request error:NULL];
    [request release];
    
    return res;
}

+ (void)deleteAllObjectsInManagedObjectContext:(NSManagedObjectContext *)context
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"User" inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    
    NSArray *items = [context executeFetchRequest:fetchRequest error:NULL];
    [fetchRequest release];
    
    for (NSManagedObject *managedObject in items) {
        [context deleteObject:managedObject];
    }
}

- (BOOL)isEqualToUser:(WeiboUser *)user
{
    return [self.userID isEqualToString:user.userID];
}

@end
