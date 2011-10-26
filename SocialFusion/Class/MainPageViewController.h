//
//  MainPageViewController.h
//  SocialFusion
//
//  Created by Blue Bitch on 11-9-7.
//  Copyright 2011年 TJU. All rights reserved.
//

#import "LabelViewController.h"
#import "FriendProfileViewController.h"

#define kDidSelectFriendNotification @"kDidSelectFriendNotification"
#define kDidSelectNewFeedNotification @"kDidSelectNewFeedNotification"
#define kDisSelectFirendType @"kDisSelectFirendType"

@protocol MainPageViewControllerDelegate;

@interface MainPageViewController : CoreDataViewController<LableViewControllerDelegate> {
    UINavigationController *_navigationController;
    id<MainPageViewControllerDelegate> _delegate;
    NSString *_displayUserName;
}

@property (nonatomic, retain) LabelViewController *lableViewController;
@property (nonatomic, assign) id<MainPageViewControllerDelegate> delegate;

@end

@protocol MainPageViewControllerDelegate <NSObject>

@required
- (void)didSelectLabelAtIndexPath:(NSIndexPath *)indexPath withLabelName:(NSString *)name;

@end