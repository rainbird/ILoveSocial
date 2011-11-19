//
//  NewFeedListController.m
//  SocialFusion
//
//  Created by He Ruoyun on 11-10-7.
//  Copyright 2011年 TJU. All rights reserved.
//

#import "NewFeedListController.h"
#import "NavigationToolBar.h"

#import "RenrenClient.h"
#import "WeiboClient.h"
#import "NewFeedRootData+NewFeedRootData_Addition.h"
#import "NewFeedData+NewFeedData_Addition.h"
#import "NewFeedBlog+NewFeedBlog_Addition.h"
#import "Image+Addition.h"
#import "UIImageView+DispatchLoad.h"
#import "NewFeedBlog.h"
#import "StatusDetailController.h"

static NSInteger SoryArrayByTime(NewFeedRootData* data1, NewFeedRootData* data2, void *context)
{
    return ([data2.update_Time compare:data1.update_Time]);
}



@implementation NewFeedListController







- (void)viewDidLoad
{
    [super viewDidLoad];
    // if(_type == RelationshipViewTypeRenrenFriends && self.currentRenrenUser.friends.count > 0)
    //  return;
    //return;
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

- (void)dealloc {
    [super dealloc];
}

- (void)configureRequest:(NSFetchRequest *)request
{
    [request setEntity:[NSEntityDescription entityForName:@"NewFeedRootData" inManagedObjectContext:self.managedObjectContext]];
    //  NSLog(<#NSString *format, ...#>)[request entity];
    NSPredicate *predicate;
    NSSortDescriptor *sort;
    
    predicate = [NSPredicate predicateWithFormat:@"SELF IN %@||SELF IN %@", self.currentWeiboUser.newFeed, self.currentRenrenUser.newFeed];
    //  sort = [[NSSortDescriptor alloc] initWithKey:@"1" ascending:YES];
    sort = [[NSSortDescriptor alloc] initWithKey:@"update_Time" ascending:NO];
    //   [request setSortDescriptors:nil];
    [request setPredicate:predicate];
    NSArray *descriptors = [NSArray arrayWithObject:sort]; 
    [request setSortDescriptors:descriptors]; 
    [sort release];
    request.fetchBatchSize = 5;
}

#pragma mark - EGORefresh Method
- (void)refresh {
    NSLog(@"refresh!");
    [self hideLoadMoreDataButton];
    [self clearData];
    [self loadMoreData];
}

- (void)showHeadImageAnimation:(UIImageView *)imageView {
    imageView.alpha = 0;
    [UIView animateWithDuration:0.3f delay:0 options:UIViewAnimationOptionAllowUserInteraction animations:^(void) {
        imageView.alpha = 1;
    } completion:nil];
}

- (void)clearData
{
    
    
    _firstLoadFlag = YES;
    // [self.currentRenrenUser ];
    
    
    
    
}

/*
 - (void)loadMoreRenrenData {
 RenrenClient *renren = [RenrenClient client];
 [renren setCompletionBlock:^(RenrenClient *client) {
 if(!client.hasError) {
 NSArray *array = client.responseJSONObject;
 for(NSDictionary *dict in array) {
 RenrenUser *friend = [RenrenUser insertFriend:dict inManagedObjectContext:self.managedObjectContext];
 [self.currentRenrenUser addFriendsObject:friend];
 }
 NSLog(@"renren friend count:%d", array.count);
 //NSLog(@"add finished");
 }
 [self doneLoadingTableViewData];
 
 _loading = NO;
 
 }];
 [renren getFriendsProfile];
 }
 
 */
- (void)loadMoreWeiboData {
    WeiboClient *client = [WeiboClient client];
    [client setCompletionBlock:^(WeiboClient *client) {
        if (!client.hasError) {
            //NSLog(@"dict:%@", client.responseJSONObject);
            
            NSArray *array = client.responseJSONObject;
            for(NSDictionary *dict in array) {
                NewFeedData* data = [NewFeedData insertNewFeed:1 Owner:self.currentWeiboUser  Dic:dict inManagedObjectContext:self.managedObjectContext];
                
                [self.currentWeiboUser addNewFeedObject:data];
                
            }
            
            
            
            //  NSArray *dictArray = [client.responseJSONObject objectForKey:@"users"];
            
            //_nextCursor = [[client.responseJSONObject objectForKey:@"next_cursor"] intValue];
            // NSLog(@"new cursor:%d", _nextCursor);
            //if (_nextCursor == 0) {
            //    [self hideLoadMoreDataButton];
            // }
            // else {
            //    [self showLoadMoreDataButton];
            // }
            [self doneLoadingTableViewData];
            _loading = NO;
        }
    }];
    
    [client getFriendsTimelineSinceID:nil maxID:nil startingAtPage:1 count:30 feature:0];
    
}
- (void)loadExtraDataForOnscreenRows 
{
    NSArray *visiblePaths = [self.tableView indexPathsForVisibleRows];
    NSTimeInterval i = 0;
    for (NSIndexPath *indexPath in visiblePaths)
    {
        i += 0.05;
        [self performSelector:@selector(loadExtraDataForOnscreenRowsHelp:) withObject:indexPath afterDelay:i];
    }
}


- (void)loadMoreRenrenData {
    RenrenClient *renren = [RenrenClient client];

    [renren setCompletionBlock:^(RenrenClient *client) {
        if (!client.hasError) {
            //NSLog(@"dict:%@", client.responseJSONObject);
            
            NSArray *array = client.responseJSONObject;
            for(NSDictionary *dict in array) {
                
                if ([[dict objectForKey:@"feed_type"] intValue]==10)
                {
                NewFeedData* data = [NewFeedData insertNewFeed:0 Owner:self.currentRenrenUser  Dic:dict inManagedObjectContext:self.managedObjectContext];
                
                [self.currentRenrenUser addNewFeedObject:data];
                }
                else if (([[dict objectForKey:@"feed_type"] intValue]==20)||([[dict objectForKey:@"feed_type"] intValue]==21))
                {
                    NewFeedBlog* data = [NewFeedBlog insertNewFeed:0 Owner:self.currentRenrenUser  Dic:dict inManagedObjectContext:self.managedObjectContext];
                    
                    [self.currentRenrenUser addNewFeedObject:data]; 
                }
            }
            
            
            
            //  NSArray *dictArray = [client.responseJSONObject objectForKey:@"users"];
            
            //_nextCursor = [[client.responseJSONObject objectForKey:@"next_cursor"] intValue];
            // NSLog(@"new cursor:%d", _nextCursor);
            //if (_nextCursor == 0) {
            //    [self hideLoadMoreDataButton];
            // }
            // else {
            //    [self showLoadMoreDataButton];
            // }
            [self doneLoadingTableViewData];
            _loading = NO;
        }
    }];
    
    [renren getNewFeed:1];

    
}

- (void)loadMoreData {
    if(_loading)
        return;
    _loading = YES;
    
    [self loadMoreRenrenData];
    [self loadMoreWeiboData];
    
}
-(float) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [NewFeedStatusCell heightForCell:[self.fetchedResultsController objectAtIndexPath:indexPath]];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    // Return the number of sections.
    return 1;
}









- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *StatusCell = @"NewFeedStatusCell";
    static NSString *RepostStatusCell=@"NewFeedRepostCell";
    static NSString *BlogCell=@"NewFeedBlogCell";
    
    
    NewFeedStatusCell* cell;
    
    //  if ([self.fetchedResultsController objectAtIndexPath:indexPath])
    NSObject* a= [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    if ([a class]==[NewFeedData class])
    {
        if ([a getPostName]==nil)
        {
            cell = (NewFeedStatusCell *)[tableView dequeueReusableCellWithIdentifier:StatusCell];
            if (cell == nil) {
                [[NSBundle mainBundle] loadNibNamed:@"NewFeedStatusCell" owner:self options:nil];
                cell = _feedStatusCel;
                
            }
        }
        
        else
        {
            cell = (NewFeedStatusWithRepostcell *)[tableView dequeueReusableCellWithIdentifier:RepostStatusCell];
            if (cell == nil) {
                [[NSBundle mainBundle] loadNibNamed:@"NewFeedStatusWithRepostcell" owner:self options:nil];
                cell = _feedRepostStatusCel;
            }
            
        }
    }
    
    else if ([a class]==[NewFeedBlog class])
    {
        cell=(NewFeedBlogCell*)[tableView dequeueReusableCellWithIdentifier:BlogCell];
        if (cell == nil) {
            [[NSBundle mainBundle] loadNibNamed:@"NewFeedBlogCell" owner:self options:nil];
            cell = _newFeedBlogCel;
        }
    }
    
    
    
    
    [cell configureCell:a];
    return cell;
    
}


- (void)loadExtraDataForOnscreenRowsHelp:(NSIndexPath *)indexPath {
    if(self.tableView.dragging || self.tableView.decelerating || _reloading)
        return;
    NewFeedRootData *data = [self.fetchedResultsController objectAtIndexPath:indexPath];
    Image *image = [Image imageWithURL:data.owner_Head inManagedObjectContext:self.managedObjectContext];
    if (!image)
    {
        NewFeedStatusCell *statusCell = (NewFeedStatusCell *)[self.tableView cellForRowAtIndexPath:indexPath];
        [statusCell.headImageView loadImageFromURL:data.owner_Head completion:^{
            [self showHeadImageAnimation:statusCell.headImageView];
        } cacheInContext:self.managedObjectContext];
    }
   
}

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






@end
