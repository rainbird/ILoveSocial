//
//  DisplayViewController.m
//  SocialFusion
//
//  Created by Blue Bitch on 11-10-25.
//  Copyright 2011年 TJU. All rights reserved.
//

#import "DisplayViewController.h"
#import "NewFeedListController.h"
#import "FriendListViewController.h"

@interface DisplayViewController()
@end

@implementation DisplayViewController
@synthesize viewControllers = _viewControllers;

- (void)dealloc {
    [_viewControllers release];
    [_viewControllerMap release];
    [super dealloc];
}

- (void)setRenrenWeiboUser {
    for(id vc in self.viewControllers) {
        if([vc isKindOfClass:[CoreDataViewController class]]) {
            CoreDataViewController *cd = (CoreDataViewController *)vc;
            cd.currentRenrenUser = self.currentRenrenUser;
            cd.currentWeiboUser = self.currentWeiboUser;
            cd.renrenUser = self.renrenUser;
            cd.weiboUser = self.weiboUser;
        }
    }
}

- (void)configureViewControllers {
    [self setRenrenWeiboUser];
    [self.view addSubview:((UIViewController *)[self.viewControllers objectAtIndex:0]).view];
}

- (void)createViewControllers {
    switch (_type) {
        case DisplayViewTypeSelf: {
            NewFeedListController *newFeedList = [[[NewFeedListController alloc] init] autorelease];
            [_viewControllerMap setValue:newFeedList forKey:@"新鲜事"];
            FriendListViewController *renrenFriendList = [[(FriendListViewController *)[FriendListViewController alloc] initWithType:RelationshipViewTypeRenrenFriends] autorelease];
            [_viewControllerMap setValue:renrenFriendList forKey:@"人人好友"];
            FriendListViewController *weiboFriendList = [[(FriendListViewController *)[FriendListViewController alloc] initWithType:RelationshipViewTypeWeiboFriends] autorelease];
            [_viewControllerMap setValue:weiboFriendList forKey:@"微博关注"];
            FriendListViewController *weiboFollowerList = [[(FriendListViewController *)[FriendListViewController alloc] initWithType:RelationshipViewTypeWeiboFollowers] autorelease];
            [_viewControllerMap setValue:weiboFollowerList forKey:@"微博粉丝"];
            NSArray *viewControllers = [NSArray arrayWithObjects:newFeedList, renrenFriendList, weiboFriendList, weiboFollowerList, nil];
            [self.viewControllers addObjectsFromArray:viewControllers];
            break;
        }
        case DisplayViewTypeWeibo: {
            FriendListViewController *weiboFriendList = [[(FriendListViewController *)[FriendListViewController alloc] initWithType:RelationshipViewTypeWeiboFriends] autorelease];
            [_viewControllerMap setValue:weiboFriendList forKey:@"微博关注"];
            FriendListViewController *weiboFollowerList = [[(FriendListViewController *)[FriendListViewController alloc] initWithType:RelationshipViewTypeWeiboFollowers] autorelease];
            [_viewControllerMap setValue:weiboFollowerList forKey:@"微博粉丝"];
            NSArray *viewControllers = [NSArray arrayWithObjects:weiboFriendList, weiboFollowerList, nil];
            [self.viewControllers addObjectsFromArray:viewControllers];
            break;
        }
        case DisplayViewTypeRenren: {
            FriendListViewController *renrenFriendList = [[(FriendListViewController *)[FriendListViewController alloc] initWithType:RelationshipViewTypeRenrenFriends] autorelease];
            [_viewControllerMap setValue:renrenFriendList forKey:@"人人好友"];
            NSArray *viewControllers = [NSArray arrayWithObjects:renrenFriendList, nil];
            [self.viewControllers addObjectsFromArray:viewControllers];
            break;
        }
        default:
            break;
    }
}

- (id)initWithType:(DisplayViewType)type {
    self = [super init];
    if(self) {
        _type = type;
        _viewControllers = [[NSMutableArray alloc] init];
        _viewControllerMap = [[NSMutableDictionary alloc] init];
        [self createViewControllers];
    }
    return self;
}

#pragma mark - View lifecycle

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    NSLog(@"display view controller view did load");
    [super viewDidLoad];
    [self configureViewControllers];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)setDelegate:(id<FriendProfileViewControllerDelegate>)delegate {
    for(id vc in self.viewControllers) {
        if([vc isKindOfClass:[FriendProfileViewController class]]) {
            FriendProfileViewController *fp = (FriendProfileViewController *)vc;
            fp.delegate = delegate;
        }
    }
}

#pragma mark - Main Page View Controller Delegate
- (void)didSelectLabelAtIndexPath:(NSIndexPath *)indexPath withLabelName:(NSString *)name {
    NSInteger row = indexPath.row;
    NSArray *subviews = [self.view subviews];
    NSInteger insertIndex = [subviews count] - 1;
    NSLog(@"subviews count:%d", [subviews count]);
    UIView *view = [subviews objectAtIndex:insertIndex];
    [view removeFromSuperview];
    
    UIViewController *viewController = (UIViewController *)([_viewControllers objectAtIndex:row]);
    [self.view insertSubview:viewController.view atIndex:insertIndex];
}

@end
