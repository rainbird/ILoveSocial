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
#import "NewFeedData.h"
#import "Image+Addition.h"
#import "UIImageView+DispatchLoad.h"
#import "NewFeedBlog.h"
#import "StatusDetailController.h"

static NSInteger SoryArrayByTime(NewFeedRootData* data1, NewFeedRootData* data2, void *context)
{
    return ([[data2 getDate] compare:[data1 getDate]]);
}



@implementation NewFeedListController






-(id)init
{
    self=[super init];
    _feedArray=[[NSMutableArray alloc] init];
     _tempArray=[[NSMutableArray alloc] init];
  //  NSLog(@"a");
    return self;
}



- (void)dealloc
{
    
     [_feedArray release];
     [_tempArray release];
    [super dealloc];
}










- (void)loadMoreData
{
    if(_loading)
        return;
    _loading = YES;
    //if(_type == RelationshipViewTypeRenrenFriends) {
        [self loadMoreRenrenData];
   // }
   // else {
    //    [self loadMoreWeiboData];
   // }
}





- (void)loadWeiboData {
    WeiboClient *client = [WeiboClient client];
    [client setCompletionBlock:^(WeiboClient *client) {
        if (!client.hasError) {
         //   NSLog(@"dict:%@", client.responseJSONObject);
            
            NSArray *array = client.responseJSONObject;
            for(NSDictionary *dict in array) {
                NewFeedData* feedData=[[NewFeedData alloc] initWithSinaDictionary:dict];
                 
                [_tempArray addObject:feedData];
                [feedData release];
               
            }
            
            if (_pageNumber==1)
            {
            [_feedArray removeAllObjects];
            }
            [_feedArray addObjectsFromArray:   [_tempArray sortedArrayUsingFunction:SoryArrayByTime context:NULL]];
            
            [self doneLoadingTableViewData];
            _loading = NO;
           // [self.tableView scrollsToTop:YES];
            //[self.tableView scrollsToTop];
                  [ self loadExtraDataForOnscreenRows ];

         //   [self.tableView reloadData];
        }
    }];
    // if (_type == RelationshipViewTypeWeiboFriends) {
    //    [client getFriendsOfUser:self.currentWeiboUser.userID cursor:_nextCursor count:20];
    // }
    // else if(_type == RelationshipViewTypeWeiboFollowers) {
    //    [client getFollowersOfUser:self.currentWeiboUser.userID cursor:_nextCursor count:20];
    [client getFriendsTimelineSinceID:nil maxID:nil startingAtPage:_pageNumber count:30 feature:0];
}






-(void)loadRenrenData
{
    _pageNumber=0;
    
       
    [self loadMoreRenrenData];
}

-(void)loadMoreRenrenData
{
    _pageNumber++;
    [_tempArray removeAllObjects];
    RenrenClient *renren = [RenrenClient client];
    [renren setCompletionBlock:^(RenrenClient *client) {
        if(!client.hasError) {
           NSArray *array = client.responseJSONObject;
            for(NSDictionary *dict in array) {
             
                if ([[dict objectForKey:@"feed_type"] intValue]==10)
                {
                    NewFeedData* feedData=[[NewFeedData alloc] initWithDictionary:dict];
                   [_tempArray addObject:feedData];
                    [feedData release];
                }
                
              else if (([[dict objectForKey:@"feed_type"] intValue]==20)||([[dict objectForKey:@"feed_type"] intValue]==21))
                {
                    NewFeedBlog* feedBlog=[[NewFeedBlog alloc] initWithDictionary:dict];
                     [_tempArray addObject:feedBlog];         
                    [feedBlog release];
                }
             
            }
          //  NSLog(@"renren friend count:%d", array.count);
            //NSLog(@"add finished");
        }
    
       // [self doneLoadingTableViewData];
      //  _loading = NO;
        
           [self loadWeiboData];
    }];
    [renren getNewFeed:_pageNumber];
    

}

- (void)refresh
{
    //_loading=NO;
   // _reloading=NO;
    NSLog(@"refresh!");

   // [self hideLoadMoreDataButton];
  
    //   [self loadMoreData];

    if(_loading)
        return;
    _loading = YES;
    //if(_type == RelationshipViewTypeRenrenFriends) {
    [self loadRenrenData];
   
 
    // }
    // else {
    //    [self loadMoreWeiboData];
    // }

}




- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {	
	[self.egoHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
    
    if (!decelerate)
	{
        [ self loadExtraDataForOnscreenRows ];
        
        
        
        
        CGPoint offset = scrollView.contentOffset;       
        CGRect bounds = scrollView.bounds;       
        CGSize size = scrollView.contentSize;       
        UIEdgeInsets inset = scrollView.contentInset;       
        float y = offset.y + bounds.size.height - inset.bottom;       
        float h = size.height;       
        float reload_distance = 10;       
        if(y > h + reload_distance) {           
            //NSLog(@"load more rows");  
            [self loadMoreData];
        }   

       // NSLog(@"12345");
    }
    
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    //NSLog(@"scrollViewDidEndDecelerating");
         //  NSLog(@"12345");
    [ self loadExtraDataForOnscreenRows ];
    CGPoint offset = scrollView.contentOffset;       
    CGRect bounds = scrollView.bounds;       
    CGSize size = scrollView.contentSize;       
    UIEdgeInsets inset = scrollView.contentInset;       
    float y = offset.y + bounds.size.height - inset.bottom;       
    float h = size.height;       
    float reload_distance = -10;       
    if(y > h + reload_distance) {           
        //NSLog(@"load more rows");  
        
        [self loadMoreData];
    }   

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



- (void)loadExtraDataForOnscreenRowsHelp:(NSIndexPath *)indexPath {
    if(self.tableView.dragging || self.tableView.decelerating || _reloading)
        return;
    //User *usr = [self.fetchedResultsController objectAtIndexPath:indexPath];
    //Image *image = [Image imageWithURL:[[_feedArray objectAtIndex:indexPath.row] getHeadURL] inManagedObjectContext:self.managedObjectContext];
    
    [NSThread detachNewThreadSelector:@selector(updateImageForCellAtIndexPath:) toTarget:self withObject:indexPath];

    
    
      
      //  FriendListTableViewCell *relationshipCell = (FriendListTableViewCell *)[self.tableView cellForRowAtIndexPath:indexPath];
      //  [relationshipCell.headImageView loadImageFromURL:usr.tinyURL completion:^{
        //    [self showHeadImageAnimation:relationshipCell.headImageView];
       // } cacheInContext:self.managedObjectContext];
    
  //  if(_type == RelationshipViewTypeRenrenFriends && !usr.latestStatus) {
   //     [RenrenStatus loadLatestStatus:usr inManagedObjectContext:self.managedObjectContext];
   // }
}








- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
  
    _pageNumber=1;
    [super viewDidLoad]; 

}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    // Return the number of rows in the section.
    return [_feedArray count];
}



-(float) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
 //这里有点乱，需要改
    /*
    if ([[_feedArray objectAtIndex:indexPath.row] class]==[NewFeedData class] )
    {
        if ([[_feedArray objectAtIndex:indexPath.row] getPostName]==nil)
        {
            NSString* tempString=[[_feedArray objectAtIndex:indexPath.row] getName];
            CGSize size = CGSizeMake(212, 1000);
            CGSize labelSize = [tempString sizeWithFont:[UIFont fontWithName:@"Courier New" size:14]
                                      constrainedToSize:size];
            
            if (labelSize.height<50)
            {
                return 70;
            }

            return labelSize.height+20;
        }
        else
        {
            NSString* tempString=[[_feedArray objectAtIndex:indexPath.row] getName];
            CGSize size = CGSizeMake(212, 1000);
            CGSize labelSize = [tempString sizeWithFont:[UIFont fontWithName:@"Courier New" size:14]
                                      constrainedToSize:size];
            
            
            NSString* tempString1=[[_feedArray objectAtIndex:indexPath.row] getPostMessage];
            CGSize size1 = CGSizeMake(200, 1000);
            CGSize labelSize1 = [tempString1 sizeWithFont:[UIFont fontWithName:@"Courier New" size:12]
                                        constrainedToSize:size1];
            return labelSize.height+labelSize1.height+50;
        }
    }
    else if ([[_feedArray objectAtIndex:indexPath.row] class]==[NewFeedBlog class] )
    {
        NSString* tempString=[[_feedArray objectAtIndex:indexPath.row] getName];
        CGSize size = CGSizeMake(212, 1000);
        CGSize labelSize = [tempString sizeWithFont:[UIFont fontWithName:@"Courier New" size:14]
                                  constrainedToSize:size];
        
        
        NSString* tempString1=[[_feedArray objectAtIndex:indexPath.row] getBlog];
        CGSize size1 = CGSizeMake(212, 1000);
        CGSize labelSize1 = [tempString1 sizeWithFont:[UIFont fontWithName:@"Courier New" size:12]
                                    constrainedToSize:size1];
        return labelSize.height+labelSize1.height+30;
        
        
    }
    return 0;
     */
    return [NewFeedStatusCell heightForCell:[_feedArray objectAtIndex:indexPath.row]];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *StatusCell = @"NewFeedStatusCell";
    static NSString *RepostStatusCell=@"NewFeedRepostCell";
    static NSString *BlogCell=@"NewFeedBlogCell";
    

    NewFeedStatusCell* cell;

    
    if ([[_feedArray objectAtIndex:indexPath.row] class]==[NewFeedData class])
    {
        if ([[_feedArray objectAtIndex:indexPath.row] getPostName]==nil)
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
    
    else if ([[_feedArray objectAtIndex:indexPath.row] class]==[NewFeedBlog class])
    {
        cell=(NewFeedBlogCell*)[tableView dequeueReusableCellWithIdentifier:BlogCell];
        if (cell == nil) {
            [[NSBundle mainBundle] loadNibNamed:@"NewFeedBlogCell" owner:self options:nil];
            cell = _newFeedBlogCel;
        }
    }
    
    
    
    
    [cell configureCell:[_feedArray objectAtIndex:indexPath.row]];
    return cell;
    
}


- (void)updateImageForCellAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    

    
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    NSURL *url = [NSURL URLWithString: [[_feedArray objectAtIndex:indexPath.row] getHeadURL]];

    UIImage *image =[UIImage imageWithData: [NSData dataWithContentsOfURL:url]];
    NewFeedStatusCell *cell = (NewFeedStatusCell*)[self.tableView cellForRowAtIndexPath:indexPath];

    [cell performSelectorOnMainThread:@selector(setUserHeadImage:) withObject:image waitUntilDone:NO];
    [pool release];
}



#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    
    
    [tableView cellForRowAtIndexPath:indexPath].selected=false;
    
     StatusDetailController *detailViewController = [[StatusDetailController alloc] initWithNibName:@"StatusDetailController" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
    detailViewController.toolbarItems=self.toolbarItems;
    detailViewController.feedData=[_feedArray objectAtIndex:indexPath.row];
     [self.navigationController pushViewController:detailViewController animated:YES];
     [detailViewController release];
     
}


- (IBAction)backButtonPressed:(id)sender {
    self.navigationController.toolbarHidden = YES;
    [self.navigationController popViewControllerAnimated:YES];
}







@end
