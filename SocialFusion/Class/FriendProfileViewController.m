//
//  FriendProfileViewController.m
//  SocialFusion
//
//  Created by Blue Bitch on 11-8-28.
//  Copyright 2011年 TJU. All rights reserved.
//

#import "FriendProfileViewController.h"
#import "FriendProfileTableViewCell.h"
#import <QuartzCore/QuartzCore.h>
#import "UIImageView+DispatchLoad.h"
#import "RenrenUser+Addition.h"
#import "RenrenStatus+Addition.h"
#import "WeiboUser+Addition.h"
#import "Image+Addition.h"
#import "User+Addition.h"
#import "RenrenClient.h"
#import "WeiboClient.h"
#import "NavigationToolBar.h"
#import "MainPageViewController.h"

#define kCustomRowCount 8

@interface FriendProfileViewController()
- (void)clearData;
@end

@implementation FriendProfileViewController

- (id)initWithType:(RelationshipViewType)type
{
    self = [super init];
    if(self) {
        _type = type;
    }
    return self;
}

#pragma mark - EGORefresh Method
- (void)refresh {
    [self hideLoadMoreDataButton];
    [self clearData];
    [self loadMoreData];
}

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
    ((NavigationToolBar *)self.navigationController.toolbar).respondView = self.tableView;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self configureToolbar];
    NSLog(@"friend profile view did load");
    self.navigationController.toolbarHidden = NO;
    _topShadowImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"tableviewCellTopShadow.png"]];
    _topShadowImageView.frame = CGRectMake(0, -20, 320, 20);
    [self.view addSubview:_topShadowImageView];
    _bottomShadowImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"tableviewCellBottomShadow.png"]];
    _bottomShadowImageView.frame = CGRectMake(0, 460, 320, 20);
    [self.view addSubview:_bottomShadowImageView];
    
    if(_type == RelationshipViewTypeRenrenFriends && self.currentRenrenUser.friends.count > 0)
        return;
    [self refresh];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    NSLog(@"clear all cache");
    [Image clearAllCacheInContext:self.managedObjectContext];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)dealloc {
    [_topShadowImageView release];
    [_bottomShadowImageView release];
    [super dealloc];
}

- (void)configureRequest:(NSFetchRequest *)request
{
    [request setEntity:[NSEntityDescription entityForName:@"User" inManagedObjectContext:self.managedObjectContext]];
    NSPredicate *predicate;
    NSSortDescriptor *sort;
    if(_type == RelationshipViewTypeRenrenFriends) {
        predicate = [NSPredicate predicateWithFormat:@"SELF IN %@", self.currentRenrenUser.friends];
        sort = [[NSSortDescriptor alloc] initWithKey:@"pinyinName" ascending:YES];
    }
    else if(_type == RelationshipViewTypeWeiboFriends) {
        predicate = [NSPredicate predicateWithFormat:@"SELF IN %@", self.currentWeiboUser.friends];
        sort = [[NSSortDescriptor alloc] initWithKey:@"updateDate" ascending:YES];
    }
    else if(_type == RelationshipViewTypeWeiboFollowers) {
        predicate = [NSPredicate predicateWithFormat:@"SELF IN %@", self.currentWeiboUser.followers];
        sort = [[NSSortDescriptor alloc] initWithKey:@"updateDate" ascending:YES];
    }
    [request setPredicate:predicate];
    NSArray *descriptors = [NSArray arrayWithObject:sort]; 
    [request setSortDescriptors:descriptors]; 
    [sort release];
    [request setFetchBatchSize:kCustomRowCount * 4];
}

- (void)showHeadImageAnimation:(UIImageView *)imageView {
    imageView.alpha = 0;
    [UIView animateWithDuration:.3 animations:^(void) {
        imageView.alpha = 1;
    } completion:nil];
}

- (void)updateCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {    
    FriendProfileTableViewCell *relationshipCell = (FriendProfileTableViewCell *)cell;
    User *usr = [self.fetchedResultsController objectAtIndexPath:indexPath];
    if(![relationshipCell.latestStatus.text isEqualToString:usr.latestStatus]) {
        relationshipCell.latestStatus.text = usr.latestStatus;
        relationshipCell.latestStatus.alpha = 0.3f;
        [UIView animateWithDuration:0.3f delay:0 options:UIViewAnimationOptionAllowUserInteraction animations:^(void) {
            relationshipCell.latestStatus.alpha = 1;
        } completion:nil];
    }
}

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    FriendProfileTableViewCell *relationshipCell = (FriendProfileTableViewCell *)cell;
    relationshipCell.headImageView.image = nil;
    relationshipCell.latestStatus.text = nil;
    User *usr = [self.fetchedResultsController objectAtIndexPath:indexPath];
    relationshipCell.userName.text = usr.name;
    if(_type == RelationshipViewTypeRenrenFriends && !usr.latestStatus) {
        if (self.tableView.dragging == NO && self.tableView.decelerating == NO) {
            if(indexPath.row < kCustomRowCount) {
                [RenrenStatus loadLatestStatus:usr inManagedObjectContext:self.managedObjectContext];
            }
        }
    }
    else {
        relationshipCell.latestStatus.text = usr.latestStatus;
    }
    
    NSData *imageData = nil;
    if([Image imageWithURL:usr.tinyURL inManagedObjectContext:self.managedObjectContext]) {
        imageData = [Image imageWithURL:usr.tinyURL inManagedObjectContext:self.managedObjectContext].data;
    }
    if(imageData == nil) {
        if (self.tableView.dragging == NO && self.tableView.decelerating == NO) {
            if(indexPath.row < kCustomRowCount) {
                [relationshipCell.headImageView loadImageFromURL:usr.tinyURL completion:^{
                    [self showHeadImageAnimation:relationshipCell.headImageView];
                } cacheInContext:self.managedObjectContext];
            }
        }
    }
    else {
        relationshipCell.headImageView.image = [UIImage imageWithData:imageData];
    }
}

- (NSString *)customCellClassName
{
    return @"FriendProfileTableViewCell";
}

- (void)clearData
{
    if(_type == RelationshipViewTypeRenrenFriends) {
        _firstLoadFlag = YES;
        [self.currentRenrenUser removeFriends:self.currentRenrenUser.friends];
    }
    else if(_type == RelationshipViewTypeWeiboFriends) {
        _nextCursor = -1;
        [self.currentWeiboUser removeFriends:self.currentWeiboUser.friends];
    }
    else if(_type == RelationshipViewTypeWeiboFollowers) {
        _nextCursor = -1;
        [self.currentWeiboUser removeFollowers:self.currentWeiboUser.followers];
    }
}

- (void)loadMoreData {
    if(_loading)
        return;
    _loading = YES;
    if(_type == RelationshipViewTypeRenrenFriends) {
        RenrenClient *renren = [RenrenClient client];
        [renren setCompletionBlock:^(RenrenClient *client) {
            if(!client.hasError) {
                NSArray *array = client.responseJSONObject;
                NSMutableSet *friendSet = [NSMutableSet set];
                for(NSDictionary *dict in array) {
                    RenrenUser *friend = [RenrenUser insertFriend:dict inManagedObjectContext:self.managedObjectContext];
                    [friendSet addObject:friend];
                    
                }
                [self.currentRenrenUser addFriends:friendSet];
                NSLog(@"add finished");
            }
            
            [self doneLoadingTableViewData];
            _loading = NO;
        }];
        [renren getFriendsProfile];
    }
    else {
        WeiboClient *client = [WeiboClient client];
        [client setCompletionBlock:^(WeiboClient *client) {
            if (!client.hasError) {
                NSArray *dictArray = [client.responseJSONObject objectForKey:@"users"];
                for (NSDictionary *dict in dictArray) {
                    WeiboUser *usr = [WeiboUser insertUser:dict inManagedObjectContext:self.managedObjectContext];
                    if (_type == RelationshipViewTypeWeiboFollowers) {
                        [self.currentWeiboUser addFollowersObject:usr];
                    }
                    else if (_type == RelationshipViewTypeWeiboFriends) {
                        [self.currentWeiboUser addFriendsObject:usr];
                    }
                }
                _nextCursor = [[client.responseJSONObject objectForKey:@"next_cursor"] intValue];
                if (_nextCursor == 0) {
                    [self hideLoadMoreDataButton];
                }
                else {
                    [self showLoadMoreDataButton];
                }
                [self doneLoadingTableViewData];
                _loading = NO;
            }
        }];
        if (_type == RelationshipViewTypeWeiboFriends) {
            [client getFriendsOfUser:self.currentWeiboUser.userID cursor:_nextCursor count:20];
        }
        else if(_type == RelationshipViewTypeWeiboFollowers) {
            [client getFollowersOfUser:self.currentWeiboUser.userID cursor:_nextCursor count:20];
        }
    }
}


- (void)loadExtraDataForOnscreenRows 
{
    NSArray *visiblePaths = [self.tableView indexPathsForVisibleRows];
    for (NSIndexPath *indexPath in visiblePaths)
    {
        User *usr = [self.fetchedResultsController objectAtIndexPath:indexPath];
        Image *image = [Image imageWithURL:usr.tinyURL inManagedObjectContext:self.managedObjectContext];
        if (!image.data)
        {
            FriendProfileTableViewCell *relationshipCell = (FriendProfileTableViewCell *)[self.tableView cellForRowAtIndexPath:indexPath];
            [relationshipCell.headImageView loadImageFromURL:usr.tinyURL completion:^{
                [self showHeadImageAnimation:relationshipCell.headImageView];
            } cacheInContext:self.managedObjectContext];
        }
        if(_type == RelationshipViewTypeRenrenFriends && !usr.latestStatus) {
            [RenrenStatus loadLatestStatus:usr inManagedObjectContext:self.managedObjectContext];
        }
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    cell.selected = NO;
    cell.highlighted = NO;
    [self.tableView reloadData];
    MainPageViewController *vc = [[[MainPageViewController alloc] init] autorelease];
    vc.toolbarItems = self.toolbarItems;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - Deferred image loading (UIScrollViewDelegate)
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    //NSLog(@"scrollViewDidEndDragging");
    [super scrollViewDidEndDragging:scrollView willDecelerate:decelerate];
    if (!decelerate)
	{
        [self loadExtraDataForOnscreenRows];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    //NSLog(@"scrollViewDidEndDecelerating");
    [self loadExtraDataForOnscreenRows];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    // 控制shadow显示
    NSLog(@"offset:%f, height:%f", scrollView.contentOffset.y, scrollView.contentSize.height);
    [super scrollViewDidScroll:scrollView];
    if(scrollView.contentOffset.y < 0 && scrollView.contentSize.height > 0 && !_reloading) {
        _topShadowImageView.alpha = 1;
        NSLog(@"top!!!!!");
        _topShadowImageView.frame = CGRectMake(0, - scrollView.contentOffset.y - 20, 320, 20);
    }
    else {
        _topShadowImageView.alpha = 0;
    }
    if(scrollView.contentOffset.y >= scrollView.contentSize.height - 460 && scrollView.contentSize.height > 0 && !_reloading) {
        _bottomShadowImageView.alpha = 1;
        NSLog(@"bottom!!!!!");
        _bottomShadowImageView.frame = CGRectMake(0, scrollView.contentSize.height - scrollView.contentOffset.y, 320, 20);
        if(self.tableView.tableFooterView != nil) {
            ((NavigationToolBar *)self.navigationController.toolbar).respondView = self.tableView.tableFooterView;
        }
    }
    else {
        if(scrollView.contentOffset.y < scrollView.contentSize.height - 460 - 60) {
            ((NavigationToolBar *)self.navigationController.toolbar).respondView = self.tableView;
        }
        _bottomShadowImageView.alpha = 0;
    }
    if(_reloading) {
        NSLog(@"set alpha 0");
        _topShadowImageView.alpha = 0;
        _bottomShadowImageView.alpha = 0;
    }
}

#pragma mark - IBAction
- (IBAction)backButtonPressed:(id)sender {
    self.navigationController.toolbarHidden = YES;
    [self.navigationController popViewControllerAnimated:YES];
}

@end
