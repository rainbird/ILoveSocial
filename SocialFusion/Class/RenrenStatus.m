//
//  RenrenStatus.m
//  SocialFusion
//
//  Created by Blue Bitch on 11-9-12.
//  Copyright (c) 2011年 TJU. All rights reserved.
//

#import "RenrenStatus.h"
#import "RenrenUser.h"


@implementation RenrenStatus
@dynamic createdAt;
@dynamic userID;
@dynamic statusID;
@dynamic text;
@dynamic commentsCount;
@dynamic url;
@dynamic forwardMessage;
@dynamic rootStatusID;
@dynamic rootText;
@dynamic rootUserID;
@dynamic rootUserName;
@dynamic author;
@dynamic isFriendStatusOf;

+ (RenrenStatus *)insertStatus:(NSDictionary *)dict inManagedObjectContext:(NSManagedObjectContext *)context {
    NSString *statusID = [[dict objectForKey:@"status_id"] stringValue];
    if (!statusID || [statusID isEqualToString:@""]) {
        return nil;
    }
    
    RenrenStatus *result = [RenrenStatus statusWithID:statusID inManagedObjectContext:context];
    if (!result) {
        result = [NSEntityDescription insertNewObjectForEntityForName:@"RenrenStatus" inManagedObjectContext:context];
    }
    
    
    result.statusID = statusID;
    result.userID = [[dict objectForKey:@"uid"] stringValue];
    result.text = [NSString stringWithFormat:@"%@",[dict objectForKey:@"message"]];
    
    result.author = [RenrenUser userWithID:result.userID inManagedObjectContext:context];
    
    return result;
}

+ (RenrenStatus *)statusWithID:(NSString *)statusID inManagedObjectContext:(NSManagedObjectContext *)context
{
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    
    [request setEntity:[NSEntityDescription entityForName:@"RenrenStatus" inManagedObjectContext:context]];
    [request setPredicate:[NSPredicate predicateWithFormat:@"statusID == %@", statusID]];
    
    RenrenStatus *res = [[context executeFetchRequest:request error:NULL] lastObject];
    
    [request release];
    
    return res;
}

@end
