//
//  FriendProfileViewController.h
//  SocialFusion
//
//  Created by Blue Bitch on 11-8-28.
//  Copyright 2011年 TJU. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGOTableViewController.h"
#import "User.h"

@protocol FriendProfileViewControllerDelegate;

typedef enum {
    RelationshipViewTypeWeiboFriends,
    RelationshipViewTypeWeiboFollowers,
    RelationshipViewTypeRenrenFriends,
} RelationshipViewType;

@interface FriendProfileViewController : EGOTableViewController {
    int _nextCursor;
    RelationshipViewType _type;
    id<FriendProfileViewControllerDelegate> _delegate;
}

@property (nonatomic, assign) id<FriendProfileViewControllerDelegate> delegate;

- (id)initWithType:(RelationshipViewType)type;
- (void)showHeadImageAnimation:(UIImageView *)imageView;
- (void)loadExtraDataForOnscreenRowsHelp:(NSIndexPath *)indexPath;

@end

@protocol FriendProfileViewControllerDelegate <NSObject>

@required
- (void)didSelectFriend:(User *)user withRelationType:(RelationshipViewType)type;

@end