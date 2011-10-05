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

#define kCustomRowCount 8

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
    [self configureToolbar];
    NSLog(@"friend list view did load");
    self.navigationController.toolbarHidden = NO;
    self.egoHeaderView.textColor = [UIColor whiteColor];
    _topShadowImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"tableviewCellTopShadow.png"]];
    _topShadowImageView.frame = CGRectMake(0, -20, 320, 20);
    [self.view addSubview:_topShadowImageView];
    _bottomShadowImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"tableviewCellBottomShadow.png"]];
    _bottomShadowImageView.frame = CGRectMake(0, 460, 320, 20);
    [self.view addSubview:_bottomShadowImageView];    
}

- (void)dealloc {
    [_topShadowImageView release];
    [_bottomShadowImageView release];
    [super dealloc];
}

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    FriendListTableViewCell *relationshipCell = (FriendListTableViewCell *)cell;
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
    cell.selected = NO;
    cell.highlighted = NO;
    [self.tableView reloadData];
    MainPageViewController *vc = [[[MainPageViewController alloc] init] autorelease];
    vc.currentWeiboUser = self.currentWeiboUser;
    vc.currentRenrenUser = self.currentRenrenUser;
    vc.toolbarItems = self.toolbarItems;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    // 控制shadow显示
    //NSLog(@"offset:%f, height:%f", scrollView.contentOffset.y, scrollView.contentSize.height);
    [super scrollViewDidScroll:scrollView];
    if(scrollView.contentOffset.y < 0 && scrollView.contentSize.height > 0 && !_reloading) {
        _topShadowImageView.alpha = 1;
        //NSLog(@"top!!!!!");
        _topShadowImageView.frame = CGRectMake(0, - scrollView.contentOffset.y - 20, 320, 20);
    }
    else {
        _topShadowImageView.alpha = 0;
    }
    if(scrollView.contentOffset.y >= scrollView.contentSize.height - self.tableView.frame.size.height && scrollView.contentSize.height > 0 && !_reloading) {
        _bottomShadowImageView.alpha = 1;
        //NSLog(@"bottom!!!!!");
        _bottomShadowImageView.frame = CGRectMake(0, scrollView.contentSize.height - scrollView.contentOffset.y, 320, 20);
        if(self.tableView.tableFooterView != nil) {
            ((NavigationToolBar *)self.navigationController.toolbar).respondView = self.tableView.tableFooterView;
        }
    }
    else {
        if(scrollView.contentOffset.y < scrollView.contentSize.height - self.tableView.frame.size.height - 60) {
            ((NavigationToolBar *)self.navigationController.toolbar).respondView = self.tableView;
        }
        _bottomShadowImageView.alpha = 0;
    }
    if(_reloading) {
        //NSLog(@"set alpha 0");
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
