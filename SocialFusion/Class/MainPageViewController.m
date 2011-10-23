//
//  MainPageViewController.m
//  SocialFusion
//
//  Created by Blue Bitch on 11-9-7.
//  Copyright 2011年 TJU. All rights reserved.
//

#import "MainPageViewController.h"
#import "NavigationToolBar.h"
#import "FriendListViewController.h"
#import "NewFeedListController.h"

@implementation MainPageViewController
@synthesize lableViewController = _lableViewController;
@synthesize viewControllers = _viewControllers;

///////////////////////////////////////////////////////////////////////////////////////////////////
// UIViewController
- (void)selectDefaultLable {
    NSIndexPath *defaultIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    _firstLoad = YES;
    [self.lableViewController.tableView selectRowAtIndexPath:defaultIndexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
    [self performSelector:@selector(didSelectLabelAtIndexPath:) withObject:defaultIndexPath afterDelay:0.1];
}

- (void)setRenrenWeiboUser:(NSArray *)array {
    for(id vc in array) {
        if([vc isKindOfClass:[CoreDataViewController class]]) {
            CoreDataViewController *cd = (CoreDataViewController *)vc;
            cd.currentRenrenUser = self.currentRenrenUser;
            cd.currentWeiboUser = self.currentWeiboUser;
        }
    }
}

- (void)configureViewControllers {
    _viewControllers = [[NSMutableArray alloc] init];
    NewFeedListController *newFeedList = [[NewFeedListController alloc] init];
    FriendListViewController *renrenFriendList = [[FriendListViewController alloc] initWithType:RelationshipViewTypeRenrenFriends];
    FriendListViewController *weiboFriendList = [[FriendListViewController alloc] initWithType:RelationshipViewTypeWeiboFriends];
    FriendListViewController *weiboFollowerList = [[FriendListViewController alloc] initWithType:RelationshipViewTypeWeiboFollowers];
    NSArray *viewControllers = [NSArray arrayWithObjects:newFeedList, renrenFriendList, weiboFriendList, weiboFollowerList, nil];
    [self.viewControllers addObjectsFromArray:viewControllers];
    [self setRenrenWeiboUser:self.viewControllers];
    [self selectDefaultLable];
}

- (void)configureLabelViewController {
    self.lableViewController = [[[LabelViewController alloc] init] autorelease];
    //[NSArray arrayWithObjects:@"首页", @"新鲜事", @"好友", @"关注", @"资料", @"留言板", @"访客", @"日志", @"相册", @"状态", @"分享", nil];
    [self.lableViewController.labelName addObjectsFromArray:[NSArray arrayWithObjects:@"新鲜事", @"人人好友", @"微博关注", @"微博粉丝", nil]];
    self.lableViewController.delegate = self;
    [self.view addSubview:self.lableViewController.view];
}

- (void)viewDidLoad {
    NSLog(@"main page view did load");
    [super viewDidLoad];
    [self configureLabelViewController];
    [self performSelector:@selector(configureViewControllers) withObject:nil afterDelay:0.3];
}

- (void)dealloc {
    NSLog(@"main page dealloc");
    [_lableViewController release];
    [_viewControllers release];
    [super dealloc];
}

#pragma mark - Label View Controller Delegate

- (void)didSelectLabelAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger row = indexPath.row;
    if(row > _viewControllers.count - 1)
        return;
    
    if(!_firstLoad) {
        NSArray *subviews = [self.view subviews];
        NSLog(@"subviews count:%d", [subviews count]);
        UIView *view = [subviews objectAtIndex:1];
        [view removeFromSuperview];
    }
    _firstLoad = NO;
    
    UIViewController *viewController = ((UIViewController *)[_viewControllers objectAtIndex:row]);
    [self.view insertSubview:viewController.view belowSubview:self.lableViewController.view];
}

@end
