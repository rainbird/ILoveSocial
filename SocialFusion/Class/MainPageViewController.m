//
//  MainPageViewController.m
//  SocialFusion
//
//  Created by Blue Bitch on 11-9-7.
//  Copyright 2011年 TJU. All rights reserved.
//

#import "MainPageViewController.h"
#import "FriendListViewController.h"
#import "NewFeedListController.h"
#import "DisplayViewController.h"

@implementation MainPageViewController
@synthesize lableViewController = _lableViewController;
@synthesize delegate = _delegate;

///////////////////////////////////////////////////////////////////////////////////////////////////
// UIViewController

- (id)init {
    self = [super init];
    if(self) {
        _lableViewController = [[LabelViewController alloc] init];
    }
    return self;
}

- (void)configureLabelViewController {
    //[NSArray arrayWithObjects:@"首页", @"新鲜事", @"好友", @"关注", @"资料", @"留言板", @"访客", @"日志", @"相册", @"状态", @"分享", nil];
    
    [self.lableViewController pushLabels:[NSMutableArray arrayWithObjects:@"新鲜事", @"人人好友", @"微博关注", @"微博粉丝", nil]];
    self.lableViewController.delegate = self;
    [self.view addSubview:self.lableViewController.view];
}

- (void)pushLabelViewControllerWithType:(DisplayViewType)type withBackLabelName:(NSString *)backLabelName{
    if(type == DisplayViewTypeRenren) {
        [self.lableViewController pushLabels:[NSMutableArray arrayWithObjects:_displayUserName, @"人人好友", nil]];
    }
    else if(type == DisplayViewTypeWeibo) {
        [self.lableViewController pushLabels:[NSMutableArray arrayWithObjects:_displayUserName, @"微博关注", @"微博粉丝", nil]];
    }
    _displayUserName = backLabelName;
}

- (void)popLabelViewController {
    _displayUserName = self.lableViewController.backLabelName;
    [self.lableViewController popLabels];
}

- (DisplayViewController *)getDisplayViewControllerWithType:(DisplayViewType)type andUser:(User *)user {
    DisplayViewController *displayViewController = [[((DisplayViewController *)[DisplayViewController alloc]) initWithType:type] autorelease];
    displayViewController.currentWeiboUser = self.currentWeiboUser;
    displayViewController.currentRenrenUser = self.currentRenrenUser;
    if(type == DisplayViewTypeRenren) 
        displayViewController.renrenUser = (RenrenUser *)user;
    else if(type == DisplayViewTypeWeibo) 
        displayViewController.weiboUser = (WeiboUser *)user;
    else if(type == DisplayViewTypeSelf) {
        displayViewController.weiboUser = self.currentWeiboUser;
        displayViewController.renrenUser = self.currentRenrenUser;
    }
    self.delegate = displayViewController;
    return displayViewController;
}

- (void)configureDisplayViewController {
    // default is current user;
    DisplayViewController *displayViewController = [self getDisplayViewControllerWithType:DisplayViewTypeSelf andUser:nil];
    self.lableViewController.delegate = self;
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:displayViewController];
    navigationController.navigationBarHidden = YES;
    navigationController.view.frame = CGRectMake(7, 64, 306, 389);
    _navigationController = navigationController;
    [self.view addSubview:_navigationController.view];
}

- (void)viewDidLoad {
    NSLog(@"main page view did load");
    [super viewDidLoad];
    _displayUserName = self.currentRenrenUser.name;
    [self configureDisplayViewController];
    [self configureLabelViewController];
    
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center addObserver:self selector:@selector(didSelectFriend:) 
                   name:kDidSelectFriendNotification 
                 object:nil];
}

- (void)dealloc {
    //NSLog(@"main page dealloc");
    _delegate = nil;
    [_lableViewController release];
    [_navigationController release];
    [super dealloc];
}

#pragma mark - Label View Controller Delegate
- (void)didSelectLabelAtIndexPath:(NSIndexPath *)indexPath withLabelName:(NSString *)name {
    [self.delegate didSelectLabelAtIndexPath:indexPath withLabelName:name];
}

- (void)didSelectBackLabel {
    [self popLabelViewController];
    [_navigationController popViewControllerAnimated:YES];
    self.delegate = (id<MainPageViewControllerDelegate>)[_navigationController topViewController];
}

#pragma mark - handle notifications
- (void)didSelectFriend:(NSNotification *)notification {
    //(User *)user withRelationType:(RelationshipViewType)type
    User* user = notification.object;
    NSNumber *typeContainer = ((NSNumber *)[notification.userInfo objectForKey:kDisSelectFirendType]);
    RelationshipViewType type = typeContainer.intValue;
    DisplayViewController *displayViewController;
    if(type == RelationshipViewTypeRenrenFriends) {
        displayViewController = [self getDisplayViewControllerWithType:DisplayViewTypeRenren andUser:user];
        [self pushLabelViewControllerWithType:DisplayViewTypeRenren withBackLabelName:user.name];
    }
    else if(type == RelationshipViewTypeWeiboFollowers || type == RelationshipViewTypeWeiboFriends){
        displayViewController = [self getDisplayViewControllerWithType:DisplayViewTypeWeibo andUser:user];
        [self pushLabelViewControllerWithType:DisplayViewTypeWeibo withBackLabelName:user.name];
    }
    else {
        NSLog(@"error while receiving notification");
        return;
    }
    self.delegate = displayViewController;
    [_navigationController pushViewController:displayViewController animated:YES];
}

@end
