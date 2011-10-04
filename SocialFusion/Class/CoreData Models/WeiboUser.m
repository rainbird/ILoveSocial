//
//  WeiboUser.m
//  SocialFusion
//
//  Created by He Ruoyun on 11-10-4.
//  Copyright (c) 2011年 TJU. All rights reserved.
//

#import "WeiboUser.h"
#import "WeiboStatus.h"
#import "WeiboUser.h"


@implementation WeiboUser
@dynamic statusesCount;
@dynamic profileImageURL;
@dynamic followersCount;
@dynamic verified;
@dynamic province;
@dynamic createAt;
@dynamic friendsCount;
@dynamic favouritesCount;
@dynamic location;
@dynamic domainURL;
@dynamic city;
@dynamic following;
@dynamic selfDescription;
@dynamic blogURL;
@dynamic gender;
@dynamic favorites;
@dynamic friendsStatuses;
@dynamic friends;
@dynamic followers;

- (void)addFavoritesObject:(WeiboStatus *)value {    
    NSSet *changedObjects = [[NSSet alloc] initWithObjects:&value count:1];
    [self willChangeValueForKey:@"favorites" withSetMutation:NSKeyValueUnionSetMutation usingObjects:changedObjects];
    [[self primitiveValueForKey:@"favorites"] addObject:value];
    [self didChangeValueForKey:@"favorites" withSetMutation:NSKeyValueUnionSetMutation usingObjects:changedObjects];
    [changedObjects release];
}

- (void)removeFavoritesObject:(WeiboStatus *)value {
    NSSet *changedObjects = [[NSSet alloc] initWithObjects:&value count:1];
    [self willChangeValueForKey:@"favorites" withSetMutation:NSKeyValueMinusSetMutation usingObjects:changedObjects];
    [[self primitiveValueForKey:@"favorites"] removeObject:value];
    [self didChangeValueForKey:@"favorites" withSetMutation:NSKeyValueMinusSetMutation usingObjects:changedObjects];
    [changedObjects release];
}

- (void)addFavorites:(NSSet *)value {    
    [self willChangeValueForKey:@"favorites" withSetMutation:NSKeyValueUnionSetMutation usingObjects:value];
    [[self primitiveValueForKey:@"favorites"] unionSet:value];
    [self didChangeValueForKey:@"favorites" withSetMutation:NSKeyValueUnionSetMutation usingObjects:value];
}

- (void)removeFavorites:(NSSet *)value {
    [self willChangeValueForKey:@"favorites" withSetMutation:NSKeyValueMinusSetMutation usingObjects:value];
    [[self primitiveValueForKey:@"favorites"] minusSet:value];
    [self didChangeValueForKey:@"favorites" withSetMutation:NSKeyValueMinusSetMutation usingObjects:value];
}


- (void)addFriendsStatusesObject:(WeiboStatus *)value {    
    NSSet *changedObjects = [[NSSet alloc] initWithObjects:&value count:1];
    [self willChangeValueForKey:@"friendsStatuses" withSetMutation:NSKeyValueUnionSetMutation usingObjects:changedObjects];
    [[self primitiveValueForKey:@"friendsStatuses"] addObject:value];
    [self didChangeValueForKey:@"friendsStatuses" withSetMutation:NSKeyValueUnionSetMutation usingObjects:changedObjects];
    [changedObjects release];
}

- (void)removeFriendsStatusesObject:(WeiboStatus *)value {
    NSSet *changedObjects = [[NSSet alloc] initWithObjects:&value count:1];
    [self willChangeValueForKey:@"friendsStatuses" withSetMutation:NSKeyValueMinusSetMutation usingObjects:changedObjects];
    [[self primitiveValueForKey:@"friendsStatuses"] removeObject:value];
    [self didChangeValueForKey:@"friendsStatuses" withSetMutation:NSKeyValueMinusSetMutation usingObjects:changedObjects];
    [changedObjects release];
}

- (void)addFriendsStatuses:(NSSet *)value {    
    [self willChangeValueForKey:@"friendsStatuses" withSetMutation:NSKeyValueUnionSetMutation usingObjects:value];
    [[self primitiveValueForKey:@"friendsStatuses"] unionSet:value];
    [self didChangeValueForKey:@"friendsStatuses" withSetMutation:NSKeyValueUnionSetMutation usingObjects:value];
}

- (void)removeFriendsStatuses:(NSSet *)value {
    [self willChangeValueForKey:@"friendsStatuses" withSetMutation:NSKeyValueMinusSetMutation usingObjects:value];
    [[self primitiveValueForKey:@"friendsStatuses"] minusSet:value];
    [self didChangeValueForKey:@"friendsStatuses" withSetMutation:NSKeyValueMinusSetMutation usingObjects:value];
}


- (void)addFriendsObject:(WeiboUser *)value {    
    NSSet *changedObjects = [[NSSet alloc] initWithObjects:&value count:1];
    [self willChangeValueForKey:@"friends" withSetMutation:NSKeyValueUnionSetMutation usingObjects:changedObjects];
    [[self primitiveValueForKey:@"friends"] addObject:value];
    [self didChangeValueForKey:@"friends" withSetMutation:NSKeyValueUnionSetMutation usingObjects:changedObjects];
    [changedObjects release];
}

- (void)removeFriendsObject:(WeiboUser *)value {
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


- (void)addFollowersObject:(WeiboUser *)value {    
    NSSet *changedObjects = [[NSSet alloc] initWithObjects:&value count:1];
    [self willChangeValueForKey:@"followers" withSetMutation:NSKeyValueUnionSetMutation usingObjects:changedObjects];
    [[self primitiveValueForKey:@"followers"] addObject:value];
    [self didChangeValueForKey:@"followers" withSetMutation:NSKeyValueUnionSetMutation usingObjects:changedObjects];
    [changedObjects release];
}

- (void)removeFollowersObject:(WeiboUser *)value {
    NSSet *changedObjects = [[NSSet alloc] initWithObjects:&value count:1];
    [self willChangeValueForKey:@"followers" withSetMutation:NSKeyValueMinusSetMutation usingObjects:changedObjects];
    [[self primitiveValueForKey:@"followers"] removeObject:value];
    [self didChangeValueForKey:@"followers" withSetMutation:NSKeyValueMinusSetMutation usingObjects:changedObjects];
    [changedObjects release];
}

- (void)addFollowers:(NSSet *)value {    
    [self willChangeValueForKey:@"followers" withSetMutation:NSKeyValueUnionSetMutation usingObjects:value];
    [[self primitiveValueForKey:@"followers"] unionSet:value];
    [self didChangeValueForKey:@"followers" withSetMutation:NSKeyValueUnionSetMutation usingObjects:value];
}

- (void)removeFollowers:(NSSet *)value {
    [self willChangeValueForKey:@"followers" withSetMutation:NSKeyValueMinusSetMutation usingObjects:value];
    [[self primitiveValueForKey:@"followers"] minusSet:value];
    [self didChangeValueForKey:@"followers" withSetMutation:NSKeyValueMinusSetMutation usingObjects:value];
}


@end
