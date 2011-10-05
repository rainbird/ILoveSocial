//
//  FriendProfileViewController.h
//  SocialFusion
//
//  Created by Blue Bitch on 11-8-28.
//  Copyright 2011年 TJU. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGOTableViewController.h"

typedef enum {
    RelationshipViewTypeWeiboFriends,
    RelationshipViewTypeWeiboFollowers,
    RelationshipViewTypeRenrenFriends,
} RelationshipViewType;

@interface FriendProfileViewController : EGOTableViewController {
    int _nextCursor;
    RelationshipViewType _type;
}

@property (nonatomic, retain) IBOutlet UIImageView *tableViewBackground;

- (id)initWithType:(RelationshipViewType)type;
- (void)showHeadImageAnimation:(UIImageView *)imageView;
- (void)loadExtraDataForOnscreenRowsHelp:(NSIndexPath *)indexPath;

@end
