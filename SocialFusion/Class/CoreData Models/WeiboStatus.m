//
//  WeiboStatus.m
//  SocialFusion
//
//  Created by He Ruoyun on 11-10-4.
//  Copyright (c) 2011年 TJU. All rights reserved.
//

#import "WeiboStatus.h"
#import "WeiboStatus.h"
#import "WeiboUser.h"


@implementation WeiboStatus
@dynamic thumbnailPicURL;
@dynamic bmiddlePicURL;
@dynamic source;
@dynamic repostsCount;
@dynamic updateDate;
@dynamic favorited;
@dynamic commentsCount;
@dynamic originalPicURL;
@dynamic isFriendStatuesOf;
@dynamic favoritedBy;
@dynamic repostBy;
@dynamic repostStatus;



- (void)addRepostByObject:(WeiboStatus *)value {    
    NSSet *changedObjects = [[NSSet alloc] initWithObjects:&value count:1];
    [self willChangeValueForKey:@"repostBy" withSetMutation:NSKeyValueUnionSetMutation usingObjects:changedObjects];
    [[self primitiveValueForKey:@"repostBy"] addObject:value];
    [self didChangeValueForKey:@"repostBy" withSetMutation:NSKeyValueUnionSetMutation usingObjects:changedObjects];
    [changedObjects release];
}

- (void)removeRepostByObject:(WeiboStatus *)value {
    NSSet *changedObjects = [[NSSet alloc] initWithObjects:&value count:1];
    [self willChangeValueForKey:@"repostBy" withSetMutation:NSKeyValueMinusSetMutation usingObjects:changedObjects];
    [[self primitiveValueForKey:@"repostBy"] removeObject:value];
    [self didChangeValueForKey:@"repostBy" withSetMutation:NSKeyValueMinusSetMutation usingObjects:changedObjects];
    [changedObjects release];
}

- (void)addRepostBy:(NSSet *)value {    
    [self willChangeValueForKey:@"repostBy" withSetMutation:NSKeyValueUnionSetMutation usingObjects:value];
    [[self primitiveValueForKey:@"repostBy"] unionSet:value];
    [self didChangeValueForKey:@"repostBy" withSetMutation:NSKeyValueUnionSetMutation usingObjects:value];
}

- (void)removeRepostBy:(NSSet *)value {
    [self willChangeValueForKey:@"repostBy" withSetMutation:NSKeyValueMinusSetMutation usingObjects:value];
    [[self primitiveValueForKey:@"repostBy"] minusSet:value];
    [self didChangeValueForKey:@"repostBy" withSetMutation:NSKeyValueMinusSetMutation usingObjects:value];
}



@end
