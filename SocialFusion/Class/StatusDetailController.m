//
//  StatusDetailController.m
//  SocialFusion
//
//  Created by He Ruoyun on 11-10-18.
//  Copyright (c) 2011年 TJU. All rights reserved.
//

#import "StatusDetailController.h"
#import "WeiboClient.h"
#import "RenrenClient.h"
#import "StatusCommentData.h"
#import "NewFeedStatusCell.h"
#import "NewFeedStatusWithRepostcell.h"
#import "NewFeedRootData+NewFeedRootData_Addition.h"
#import "NewFeedData+NewFeedData_Addition.h"
#import "NewFeedBlog+NewFeedBlog_Addition.h"
#import "Image+Addition.h"
#import "UIImageView+DispatchLoad.h"
#import "StatusDetailController.h"


@implementation StatusDetailController

@synthesize feedData=_feedData;

- (void)viewDidLoad
{
    [super viewDidLoad];
    // if(_type == RelationshipViewTypeRenrenFriends && self.currentRenrenUser.friends.count > 0)
    //  return;
    //return;
    _pageNumber=0;
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
    NSSortDescriptor *sort2;
    predicate = [NSPredicate predicateWithFormat:@"SELF IN %@||SELF IN %@", self.currentWeiboUser.newFeed, self.currentRenrenUser.newFeed];
    //  sort = [[NSSortDescriptor alloc] initWithKey:@"1" ascending:YES];
    sort = [[NSSortDescriptor alloc] initWithKey:@"update_Time" ascending:NO];
    sort2 = [[NSSortDescriptor alloc] initWithKey:@"get_Time" ascending:YES];
    
    
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sort2, sort, nil];
    
    [request setSortDescriptors:sortDescriptors];
    
    
    //   [request setSortDescriptors:nil];
    [request setPredicate:predicate];
    NSArray *descriptors = [NSArray arrayWithObject:sort]; 
    // [request setSortDescriptors:descriptors]; 
    [sort release];
    request.fetchBatchSize = 5;
}

#pragma mark - EGORefresh Method
- (void)refresh {
    NSLog(@"refresh!");
    _pageNumber=0;
    //  [self hideLoadMoreDataButton];
    if (_currentTime!=nil)
    {
        [_currentTime release];
    }
    [self clearData];
    [self loadMoreData];
}

- (void)showHeadImageAnimation:(UIImageView *)imageView {
    imageView.alpha = 0;
    [UIView animateWithDuration:0.3f delay:0 options:UIViewAnimationOptionAllowUserInteraction animations:^(void) {
        imageView.alpha = 1;
    } completion:nil];
}





@end
