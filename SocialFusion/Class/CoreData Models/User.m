//
//  User.m
//  SocialFusion
//
//  Created by He Ruoyun on 11-10-4.
//  Copyright (c) 2011年 TJU. All rights reserved.
//

#import "User.h"
#import "Status.h"


@implementation User
@dynamic userID;
@dynamic updateDate;
@dynamic tinyURL;
@dynamic pinyinName;
@dynamic latestStatus;
@dynamic name;
@dynamic statuses;

- (void)addStatusesObject:(Status *)value {    
    NSSet *changedObjects = [[NSSet alloc] initWithObjects:&value count:1];
    [self willChangeValueForKey:@"statuses" withSetMutation:NSKeyValueUnionSetMutation usingObjects:changedObjects];
    [[self primitiveValueForKey:@"statuses"] addObject:value];
    [self didChangeValueForKey:@"statuses" withSetMutation:NSKeyValueUnionSetMutation usingObjects:changedObjects];
    [changedObjects release];
}

- (void)removeStatusesObject:(Status *)value {
    NSSet *changedObjects = [[NSSet alloc] initWithObjects:&value count:1];
    [self willChangeValueForKey:@"statuses" withSetMutation:NSKeyValueMinusSetMutation usingObjects:changedObjects];
    [[self primitiveValueForKey:@"statuses"] removeObject:value];
    [self didChangeValueForKey:@"statuses" withSetMutation:NSKeyValueMinusSetMutation usingObjects:changedObjects];
    [changedObjects release];
}

- (void)addStatuses:(NSSet *)value {    
    [self willChangeValueForKey:@"statuses" withSetMutation:NSKeyValueUnionSetMutation usingObjects:value];
    [[self primitiveValueForKey:@"statuses"] unionSet:value];
    [self didChangeValueForKey:@"statuses" withSetMutation:NSKeyValueUnionSetMutation usingObjects:value];
}

- (void)removeStatuses:(NSSet *)value {
    [self willChangeValueForKey:@"statuses" withSetMutation:NSKeyValueMinusSetMutation usingObjects:value];
    [[self primitiveValueForKey:@"statuses"] minusSet:value];
    [self didChangeValueForKey:@"statuses" withSetMutation:NSKeyValueMinusSetMutation usingObjects:value];
}


@end
