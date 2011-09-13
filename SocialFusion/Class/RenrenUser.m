//
//  RenrenUser.m
//  SocialFusion
//
//  Created by Blue Bitch on 11-9-9.
//  Copyright (c) 2011年 TJU. All rights reserved.
//

#import "RenrenUser.h"
#import "RenrenStatus.h"
#import "RenrenUser.h"
#import "NSString+Pinyin.h"

@implementation RenrenUser
@dynamic pinyinName;
@dynamic birthday;
@dynamic emailHash;
@dynamic gender;
@dynamic headURL;
@dynamic hometownLocation;
@dynamic mainURL;
@dynamic name;
@dynamic tinyURL;
@dynamic tinyURLData;
@dynamic universityHistory;
@dynamic userID;
@dynamic workHistory;
@dynamic friends;
@dynamic statuses;
@dynamic friendsStatuses;

+ (RenrenUser *)insertUserHelp:(NSDictionary *)dict userID:(NSString *)userID inManagedObjectContext:(NSManagedObjectContext *)context {
    if (!userID || [userID isEqualToString:@""]) {
        return nil;
    }
    
    RenrenUser *result = [RenrenUser userWithID:userID inManagedObjectContext:context];
    if (!result) {
        result = [NSEntityDescription insertNewObjectForEntityForName:@"RenrenUser" inManagedObjectContext:context];
    }
    
    
    result.userID = userID;
    
    NSString *sex = [dict objectForKey:@"sex"];
    if(sex) {
        bool isMan = [sex boolValue];
        if(isMan)
            result.gender = [NSString stringWithString:@"男"];
        else
            result.gender = [NSString stringWithString:@"女"];
    }
    result.name = [NSString stringWithFormat:@"%@", [dict objectForKey:@"name"]];
    result.pinyinName = [result.name pinyinFirstLetterArray];
    NSLog(@"name:%@, pinyin:%@", result.name, result.pinyinName);
    result.birthday = [dict objectForKey:@"birthday"];
    
    result.tinyURL = [dict objectForKey:@"tinyurl"];
    result.headURL = [dict objectForKey:@"headurl"];
    result.mainURL = [dict objectForKey:@"mainurl"];
    
    NSDictionary *hometown = [dict objectForKey:@"hometown_location"];
    NSString *province = [hometown objectForKey:@"province"];
    NSString *city = [hometown objectForKey:@"city"];
    NSString *hometownLocation = [NSString stringWithFormat:@"%@ %@", province, city];
    result.hometownLocation = hometownLocation;
    
    NSDictionary *university = [[dict objectForKey:@"university_history"] lastObject];
    if(university) {
        NSString *department = [university objectForKey:@"department"];
        NSString *name = [university objectForKey:@"name"];
        NSString *year = [university objectForKey:@"year"];
        NSString *universityInfo = [NSString stringWithFormat:@"%@, %@, %@", name, department, year];
        result.universityHistory = universityInfo;
    }
    
    return result;
}

+ (RenrenUser *)insertFriend:(NSDictionary *)dict inManagedObjectContext:(NSManagedObjectContext *)context {
    NSString *userID = [[dict objectForKey:@"id"] stringValue];
    return [RenrenUser insertUserHelp:dict userID:userID inManagedObjectContext:context];
}

+ (RenrenUser *)insertUser:(NSDictionary *)dict inManagedObjectContext:(NSManagedObjectContext *)context
{
    NSString *userID = [[dict objectForKey:@"uid"] stringValue];
    return [RenrenUser insertUserHelp:dict userID:userID inManagedObjectContext:context];
}

+ (RenrenUser *)userWithID:(NSString *)userID inManagedObjectContext:(NSManagedObjectContext *)context
{
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    
    [request setEntity:[NSEntityDescription entityForName:@"RenrenUser" inManagedObjectContext:context]];
    [request setPredicate:[NSPredicate predicateWithFormat:@"userID == %@", userID]];
    
    RenrenUser *res = [[context executeFetchRequest:request error:NULL] lastObject];
    
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
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"RenrenUser" inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    
    NSArray *items = [context executeFetchRequest:fetchRequest error:NULL];
    [fetchRequest release];
    
    for (NSManagedObject *managedObject in items) {
        [context deleteObject:managedObject];
    }
}

- (BOOL)isEqualToUser:(RenrenUser *)user
{
    return [self.userID isEqualToString:user.userID];
}

+ (NSArray *)allFriendsInManagedObjectContext:(NSManagedObjectContext *)context {
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    
    [request setEntity:[NSEntityDescription entityForName:@"RenrenUser" inManagedObjectContext:context]];
    NSSortDescriptor *sort = [[NSSortDescriptor alloc] initWithKey:@"pinyinName" 
                                                      ascending:YES]; 
    NSArray *descriptors = [NSArray arrayWithObject:sort]; 
    [request setSortDescriptors:descriptors]; 
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSString *currentUserID = [ud objectForKey:@"renren_ID"];
    NSLog(@"current user id:%@", currentUserID);
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"userID <> '%@'", currentUserID];
    [request setPredicate:predicate];
    NSArray *res = [context executeFetchRequest:request error:NULL];
    [request release];
    
    return res;
}

@end
