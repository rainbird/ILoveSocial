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

typedef enum {
    RelationshipViewTypeWeiboFriends,
    RelationshipViewTypeWeiboFollowers,
    RelationshipViewTypeRenrenFriends,
} RelationshipViewType;

@interface FriendProfileViewController : EGOTableViewController {
    UIImageView *_topShadowImageView;
    UIImageView *_buttomShadowImageView;
    
    int _nextCursor;
    RelationshipViewType _type;
}

- (IBAction)backButtonPressed:(id)sender;
- (id)initWithType:(RelationshipViewType)type;

@end
