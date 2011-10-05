//
//  MainPageViewController.m
//  SocialFusion
//
//  Created by Blue Bitch on 11-9-7.
//  Copyright 2011年 TJU. All rights reserved.
//

#import "MainPageViewController.h"
#import "NavigationToolBar.h"
#import "FriendHeadViewController.h"

@implementation MainPageViewController
@synthesize lableViewController = _lableViewController;
@synthesize viewControllers = _viewControllers;

///////////////////////////////////////////////////////////////////////////////////////////////////
// UIViewController

- (void)configureToolbar {
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backButton setImage:[UIImage imageNamed:@"backButton.png"] forState:UIControlStateNormal];
    [backButton setImage:[UIImage imageNamed:@"backButton-highlight.png"] forState:UIControlStateHighlighted];
    [backButton addTarget:self action:@selector(backButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    backButton.frame = CGRectMake(12, 12, 31, 34);
    UIBarButtonItem *backButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:backButton] autorelease];
    NSMutableArray *toolBarItems = [NSMutableArray array];
    [toolBarItems addObject:backButtonItem];
    self.toolbarItems = nil;
    self.toolbarItems = toolBarItems;
    ((NavigationToolBar *)self.navigationController.toolbar).respondView = self.view;
}

- (void)selectDefaultLable {
    NSIndexPath *defaultIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    _firstLoad = YES;
    [self.lableViewController.tableView selectRowAtIndexPath:defaultIndexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
    [self didSelectLabelAtIndexPath:defaultIndexPath];
    _firstLoad = NO;
}

- (void)configureViewControllers {
    _viewControllers = [[NSMutableArray alloc] init];
    
    FriendHeadViewController *wbFollowers = [[[FriendHeadViewController alloc] initWithType:RelationshipViewTypeWeiboFollowers] autorelease];
    wbFollowers.currentWeiboUser = self.currentWeiboUser;
    wbFollowers.view.frame = CGRectMake(0, 40, 320, 420 - 44);
    
    FriendHeadViewController *wbFriends = [[[FriendHeadViewController alloc] initWithType:RelationshipViewTypeWeiboFriends] autorelease];
    wbFriends.currentWeiboUser = self.currentWeiboUser;
    wbFriends.view.frame = CGRectMake(0, 40, 320, 420 - 44);
    
    FriendHeadViewController *rrFriends = [[[FriendHeadViewController alloc] initWithType:RelationshipViewTypeRenrenFriends] autorelease];
    rrFriends.currentRenrenUser = self.currentRenrenUser;
    rrFriends.view.frame = CGRectMake(0, 40, 320, 420 - 44);
    
    [_viewControllers addObject:wbFollowers];
    [_viewControllers addObject:wbFriends];
    [_viewControllers addObject:rrFriends];
    
    [self selectDefaultLable];
}

- (void)configureLabelViewController {
    self.lableViewController = [[[LabelViewController alloc] init] autorelease];
    self.lableViewController.delegate = self;
    [self.view addSubview:self.lableViewController.view];
}

- (void)viewDidLoad {
    NSLog(@"main page view did load");
    [super viewDidLoad];
    [self configureToolbar];
    //[self configureViewControllers];
    [self configureLabelViewController];
    [self performSelector:@selector(configureViewControllers) withObject:nil afterDelay:0.3];
}

- (void)dealloc {
    NSLog(@"main page dealloc");
    [_lableViewController release];
    [_viewControllers release];
    [super dealloc];
}

// IBAction
- (IBAction)backButtonPressed:(id)sender {
    UINavigationController *nav = self.navigationController;
    [self.navigationController popViewControllerAnimated:YES];
    [nav.topViewController performSelector:@selector(configureToolbar)];
}

#pragma mark - Label View Controller Delegate
- (void)didSelectLabelAtIndexPath:(NSIndexPath *)indexPath {
    if(!_firstLoad) {
        NSArray *subviews = [self.view subviews];
        NSLog(@"subviews count:%d", [subviews count]);
        UIView *view = [subviews objectAtIndex:0];
        [view removeFromSuperview];
    }
    NSInteger row = indexPath.row;
    UIViewController *viewController = ((UIViewController *)[_viewControllers objectAtIndex:row]);
    viewController.navigationController.toolbarHidden = YES;
    [self.view addSubview:viewController.view];
    [self.view exchangeSubviewAtIndex:0 withSubviewAtIndex:1];
}

@end
