//
//  RenrenUser.m
//  SocialFusion
//
//  Created by He Ruoyun on 11-10-4.
//  Copyright (c) 2011年 TJU. All rights reserved.
//

#import "RenrenUser.h"
#import "RenrenUser.h"


@implementation RenrenUser
@dynamic gender;
@dynamic mainURL;
@dynamic headURL;
@dynamic hometownLocation;
@dynamic workHistory;
@dynamic birthday;
@dynamic emailHash;
@dynamic universityHistory;
@dynamic friends;

- (void)addFriendsObject:(RenrenUser *)value {    
    NSSet *changedObjects = [[NSSet alloc] initWithObjects:&value count:1];
    [self willChangeValueForKey:@"friends" withSetMutation:NSKeyValueUnionSetMutation usingObjects:changedObjects];
    [[self primitiveValueForKey:@"friends"] addObject:value];
    [self didChangeValueForKey:@"friends" withSetMutation:NSKeyValueUnionSetMutation usingObjects:changedObjects];
    [changedObjects release];
}

- (void)removeFriendsObject:(RenrenUser *)value {
    NSSet *changedObjects = [[NSSet alloc] initWithObjects:&value count:1];
    [self willChangeValueForKey:@"friends" withSetMutation:NSKeyValueMinusSetMutation usingObjects:changedObjects];
    [[self primitiveValueForKey:@"friends"] removeObject:value];
    [self didChangeValueForKey:@"friends" withSetMutation:NSKeyValueMinusSetMutation usingObjects:changedObjects];
    [changedObjects release];
}

- (void)addFriends:(NSSet *)value {    
    [self willChangeValueForKey:@"friends" withSetMutation:NSKeyValueUnionSetMutation usingObjects:value];
    [[self primitiveValueForKey:@"friends"] unionSet:value];
    [self didChangeValueForKey:@"friends" withSetMutation:NSKeyValueUnionSetMutation usingObjects:value];
}

- (void)removeFriends:(NSSet *)value {
    [self willChangeValueForKey:@"friends" withSetMutation:NSKeyValueMinusSetMutation usingObjects:value];
    [[self primitiveValueForKey:@"friends"] minusSet:value];
    [self didChangeValueForKey:@"friends" withSetMutation:NSKeyValueMinusSetMutation usingObjects:value];
}


@end
