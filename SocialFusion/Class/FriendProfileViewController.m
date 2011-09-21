//
//  FriendProfileViewController.m
//  SocialFusion
//
//  Created by Blue Bitch on 11-8-28.
//  Copyright 2011年 TJU. All rights reserved.
//

#import "FriendProfileViewController.h"
#import "RenrenFreindProfileTabelViewCell.h"
#import <QuartzCore/QuartzCore.h>
#import "UIImageView+DispatchLoad.h"
#import "RenrenUser+Addition.h"
#import "RenrenStatus+Addition.h"
#import "Image+Addition.h"
#import "User+Addition.h"
#import "RenrenClient.h"

#define kCustomRowCount     8

@interface FriendProfileViewController()
- (void)clearData;
- (void)loadFriends;
@end

@implementation FriendProfileViewController

@synthesize backButton = _backButton;

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSLog(@"friend profile view did load");
    _topShadowImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"tableviewCellTopShadow.png"]];
    _topShadowImageView.frame = CGRectMake(0, -20, 320, 20);
    [self.view addSubview:_topShadowImageView];
    _buttomShadowImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"tableviewCellBottomShadow.png"]];
    _buttomShadowImageView.frame = CGRectMake(0, 460, 320, 20);
    [self.view addSubview:_buttomShadowImageView];
    [self.backButton setImage:[UIImage imageNamed:@"backButton-highlight.png"] forState:UIControlStateHighlighted];
    if(self.currentRenrenUser.friends.count == 0)
        [self loadFriends];
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
    [_backButton release];
    [_topShadowImageView release];
    [_buttomShadowImageView release];
    [super dealloc];
}

- (void)configureRequest:(NSFetchRequest *)request
{
    [request setEntity:[NSEntityDescription entityForName:@"User" inManagedObjectContext:self.managedObjectContext]];
    NSSortDescriptor *sort = [[NSSortDescriptor alloc] initWithKey:@"pinyinName" 
                                                         ascending:YES]; 
    NSArray *descriptors = [NSArray arrayWithObject:sort]; 
    [request setSortDescriptors:descriptors]; 
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF IN %@", self.currentRenrenUser.friends];
    [request setPredicate:predicate];
    
    [request setFetchBatchSize:kCustomRowCount * 3];
}

- (void)showHeadImageAnimation:(UIImageView *)imageView {
    imageView.alpha = 0;
    [UIView animateWithDuration:0.3f delay:0 options:UIViewAnimationOptionAllowUserInteraction animations:^(void) {
        imageView.alpha = 1;
    } completion:nil];
}

- (void)updateCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    RenrenFreindProfileTabelViewCell *relationshipCell = (RenrenFreindProfileTabelViewCell *)cell;
    RenrenUser *usr = [self.fetchedResultsController objectAtIndexPath:indexPath];
    if(![relationshipCell.latestStatus.text isEqualToString:[usr latestStatus].text]) {
        relationshipCell.latestStatus.text = [usr latestStatus].text;
        relationshipCell.latestStatus.alpha = 0.3f;
        [UIView animateWithDuration:0.3f delay:0 options:UIViewAnimationOptionAllowUserInteraction animations:^(void) {
            relationshipCell.latestStatus.alpha = 1;
        } completion:nil];
    }
}

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    RenrenFreindProfileTabelViewCell *relationshipCell = (RenrenFreindProfileTabelViewCell *)cell;
    RenrenUser *usr = [self.fetchedResultsController objectAtIndexPath:indexPath];
    relationshipCell.userName.text = usr.name;
    if(![usr latestStatus]) {
        if (self.tableView.dragging == NO && self.tableView.decelerating == NO)
            if(indexPath.row < kCustomRowCount)
                [RenrenStatus loadStatus:usr inManagedObjectContext:self.managedObjectContext];
    }
    relationshipCell.latestStatus.text = [usr latestStatus].text;
    
    NSData *imageData = nil;
    if([Image imageWithURL:usr.tinyURL inManagedObjectContext:self.managedObjectContext])
        imageData = [Image imageWithURL:usr.tinyURL inManagedObjectContext:self.managedObjectContext].data;
    if(imageData == nil){
        if (self.tableView.dragging == NO && self.tableView.decelerating == NO) {
            if(indexPath.row < kCustomRowCount) {
                [relationshipCell.headImageView loadImageFromURL:usr.tinyURL completion:^{
                    [self showHeadImageAnimation:relationshipCell.headImageView];
                }cacheInContext:self.managedObjectContext];
            }
        }
    }
    else {
        relationshipCell.headImageView.image = [UIImage imageWithData:imageData];
    }
}

- (NSString *)customCellClassName
{
    return @"RenrenFriendProfileTableViewCell";
}

- (void)clearData
{
    [self.currentRenrenUser removeFriends:self.currentRenrenUser.friends];
}

- (void)loadFriends {
    RenrenClient *renren = [RenrenClient client];
    [renren setCompletionBlock:^(RenrenClient *client) {
        if(!client.hasError) {
            NSArray *array = client.responseJSONObject;
            NSMutableSet *friendSet = [NSMutableSet set];
            for(NSDictionary *dict in array) {
                User *friend = [User insertRenrenFriend:dict inManagedObjectContext:self.managedObjectContext];
                [friendSet addObject:friend];
                
            }
            [self.currentRenrenUser addFriends:friendSet];
            NSLog(@"add finished");
        }
    }];
    [renren getFriendsProfile];
}


- (void)loadExtraDataForOnscreenRows 
{
    NSArray *visiblePaths = [self.tableView indexPathsForVisibleRows];
    for (NSIndexPath *indexPath in visiblePaths)
    {
        RenrenUser *friend = [self.fetchedResultsController objectAtIndexPath:indexPath];
        Image *image = [Image imageWithURL:friend.tinyURL inManagedObjectContext:self.managedObjectContext];
        if (!image.data)
        {
            RenrenFreindProfileTabelViewCell *relationshipCell = (RenrenFreindProfileTabelViewCell *)[self.tableView cellForRowAtIndexPath:indexPath];
            [relationshipCell.headImageView loadImageFromURL:friend.tinyURL completion:^{
                [self showHeadImageAnimation:relationshipCell.headImageView];
            }cacheInContext:self.managedObjectContext];
        }
        if(![friend latestStatus]) 
        {
            [RenrenStatus loadStatus:friend inManagedObjectContext:self.managedObjectContext];
        }
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //RenrenFreindProfileTabelViewCell *relationshipCell = (RenrenFreindProfileTabelViewCell *)[self.tableView cellForRowAtIndexPath:indexPath];
}

#pragma mark - Deferred image loading (UIScrollViewDelegate)
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (!decelerate)
	{
        [self loadExtraDataForOnscreenRows];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self loadExtraDataForOnscreenRows];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    // 控制shadow显示
    //NSLog(@"offset:%f, height:%f", scrollView.contentOffset.y, scrollView.contentSize.height);
    if(scrollView.contentOffset.y < 0 && scrollView.contentSize.height > 0) {
        _topShadowImageView.alpha = 1;
        _topShadowImageView.frame = CGRectMake(0, - scrollView.contentOffset.y - 20, 320, 20);
    }
    else {
         _topShadowImageView.alpha = 0;
    }
    if(scrollView.contentOffset.y > scrollView.contentSize.height - 460 && scrollView.contentSize.height > 0) {
        _buttomShadowImageView.alpha = 1;
        _buttomShadowImageView.frame = CGRectMake(0, scrollView.contentSize.height - scrollView.contentOffset.y, 320, 20);
    }
    else {
        _buttomShadowImageView.alpha = 0;
    }
}

// IBAction
- (IBAction)backButtonPressed:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
