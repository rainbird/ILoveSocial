//
//  RenrenStatus.m
//  SocialFusion
//
//  Created by Blue Bitch on 11-9-12.
//  Copyright (c) 2011年 TJU. All rights reserved.
//

#import "RenrenStatus+Addition.h"
#import "RenrenUser+Addition.h"
#import "RenrenClient.h"

@implementation RenrenStatus (Addition)

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
    result.text = [NSString stringWithFormat:@"%@",[dict objectForKey:@"message"]];
    
    // 将自己添加到对应user的statuses里
    NSString *authorID = [[dict objectForKey:@"uid"] stringValue];
    result.author = [RenrenUser userWithID:authorID inManagedObjectContext:context];
    
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

+ (void)loadStatus:(RenrenUser *)user inManagedObjectContext:(NSManagedObjectContext *)context{
    NSString *userID = user.userID;
    RenrenClient *renren = [RenrenClient client];
    [renren setCompletionBlock:^(RenrenClient *client) {
        if(!client.hasError) {
            NSDictionary *dict = client.responseJSONObject;
            [RenrenStatus insertStatus:dict inManagedObjectContext:context];
            // 这里不需要将status添加到对应的user中 因为已经在insertStatus时执行过
        }
    }];
    [renren getLatestStatus:userID];
}

@end
