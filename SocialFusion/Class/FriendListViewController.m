//
//  FriendListViewController.m
//  SocialFusion
//
//  Created by Blue Bitch on 11-10-4.
//  Copyright 2011年 TJU. All rights reserved.
//

#import "FriendListViewController.h"
#import "FriendListTableViewCell.h"
#import "RenrenUser+Addition.h"
#import "RenrenStatus+Addition.h"
#import "WeiboUser+Addition.h"
#import "Image+Addition.h"
#import "UIImageView+DispatchLoad.h"
#import "User+Addition.h"
#import "RenrenClient.h"
#import "WeiboClient.h"
#import "NavigationToolBar.h"
#import "MainPageViewController.h"
#import "MainPageViewController.h"

#define kCustomRowCount 7

@implementation FriendListViewController

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

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"friend list view did load");
    self.egoHeaderView.textColor = [UIColor grayColor];
    /*_topShadowImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"tableviewCellTopShadow.png"]];
    _topShadowImageView.frame = CGRectMake(0, -20, 320, 20);
    [self.view addSubview:_topShadowImageView];
    _bottomShadowImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"tableviewCellBottomShadow.png"]];
    _bottomShadowImageView.frame = CGRectMake(0, 460, 320, 20);
    [self.view addSubview:_bottomShadowImageView];*/
}

- (void)dealloc {
    //[_topShadowImageView release];
    //[_bottomShadowImageView release];
    [super dealloc];
}

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    FriendListTableViewCell *relationshipCell = (FriendListTableViewCell *)cell;
    relationshipCell.headImageView.image = nil;
    relationshipCell.latestStatus.text = nil;
    User *usr = [self.fetchedResultsController objectAtIndexPath:indexPath];
    relationshipCell.userName.text = usr.name;
    //NSLog(@"cell name:%@", usr.name);
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
        imageData = [Image imageWithURL:usr.tinyURL inManagedObjectContext:self.managedObjectContext].imageData.data;
    }
    if(imageData == nil) {
        if(self.tableView.dragging == NO && self.tableView.decelerating == NO) {
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
    return @"FriendListTableViewCell";
}

- (void)loadExtraDataForOnscreenRowsHelp:(NSIndexPath *)indexPath {
    if(self.tableView.dragging || self.tableView.decelerating || _reloading)
        return;
    User *usr = [self.fetchedResultsController objectAtIndexPath:indexPath];
    Image *image = [Image imageWithURL:usr.tinyURL inManagedObjectContext:self.managedObjectContext];
    if (!image)
    {
        FriendListTableViewCell *relationshipCell = (FriendListTableViewCell *)[self.tableView cellForRowAtIndexPath:indexPath];
        [relationshipCell.headImageView loadImageFromURL:usr.tinyURL completion:^{
            [self showHeadImageAnimation:relationshipCell.headImageView];
        } cacheInContext:self.managedObjectContext];
    }
    if(_type == RelationshipViewTypeRenrenFriends && !usr.latestStatus) {
        [RenrenStatus loadLatestStatus:usr inManagedObjectContext:self.managedObjectContext];
    }
}

- (void)updateCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {    
    FriendListTableViewCell *relationshipCell = (FriendListTableViewCell *)cell;
    User *usr = [self.fetchedResultsController objectAtIndexPath:indexPath];
    NSLog(@"update user name:%@", usr.name);
    if(![relationshipCell.latestStatus.text isEqualToString:usr.latestStatus]) {
        relationshipCell.latestStatus.text = usr.latestStatus;
        relationshipCell.latestStatus.alpha = 0.3f;
        [UIView animateWithDuration:0.3f delay:0 options:UIViewAnimationOptionAllowUserInteraction animations:^(void) {
            relationshipCell.latestStatus.alpha = 1;
        } completion:nil];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    // 清空选中状态
    cell.highlighted = NO;
    cell.selected = NO;
    [self.tableView reloadData];

    User *usr = [self.fetchedResultsController objectAtIndexPath:indexPath];
    NSDictionary *dic = [NSMutableDictionary dictionary];
    [dic setValue:[NSNumber numberWithInt:_type] forKey:kDisSelectFirendType];
    [[NSNotificationCenter defaultCenter] postNotificationName:kDidSelectFriendNotification object:usr userInfo:dic];
}

@end
