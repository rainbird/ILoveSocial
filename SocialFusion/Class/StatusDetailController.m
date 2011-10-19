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
@implementation StatusDetailController

@synthesize feedData=_feedData;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _commentArray=[[NSMutableArray alloc] init];
        
    }
    return self;
}





- (void)dealloc
{
    [_feedData release];
    [_commentArray release];

    [super dealloc];
}










- (void)loadMoreData
{
    if(_loading)
        return;
    _loading = YES;
    
    
    if ([_feedData getStyle]==0)
    {
        _pageNumber--;
    }
        else
        {
            _pageNumber++;
        }
    [self loadData];
    //if(_type == RelationshipViewTypeRenrenFriends) {

    // }
    // else {
    //    [self loadMoreWeiboData];
    // }
}






- (void)refresh
{
    //_loading=NO;
    // _reloading=NO;
    NSLog(@"refresh!");
    
    if ([_feedData getStyle]==0)
    {
          _pageNumber=[_feedData getComment_Count]/10+1;
    }
    else
    {
        _pageNumber=1;
    }
    

    // [self hideLoadMoreDataButton];
    
    //   [self loadMoreData];
    
    if(_loading)
        return;
    _loading = YES;
    //if(_type == RelationshipViewTypeRenrenFriends) {
    [self loadData];
    
    
    // }
    // else {
    //    [self loadMoreWeiboData];
    // }
    
}


-(void)loadData
{
    if ([_feedData getStyle]==0)
    {
        RenrenClient *renren = [RenrenClient client];
        [renren setCompletionBlock:^(RenrenClient *client) {
            if(!client.hasError) {
                NSArray *array = client.responseJSONObject;
                for(NSDictionary *dict in array) {
                    StatusCommentData* feedData=[[StatusCommentData alloc] initWithDictionary:dict];
                    [_commentArray insertObject:feedData atIndex:0];
                    
                    [feedData release];
                }
                
                if (_pageNumber!=1)
                {
                    _showMoreButton=YES;
                }
                else
                {
                    _showMoreButton=NO;
                }
                _loading=NO;
                [self.tableView reloadData];
            }
            

            
        }];
        
        
        [renren getComments:[_feedData getActor_ID] status_ID:[_feedData getSource_ID] pageNumber:_pageNumber];
        
    }
    
    else
    {
        WeiboClient *weibo = [WeiboClient client];
        [weibo setCompletionBlock:^(WeiboClient *client) {
            if(!client.hasError) {
                
                //NSLog(@"%@",client.responseJSONObject);
                NSArray *array = client.responseJSONObject;
                             for(NSDictionary *dict in array) {
                    StatusCommentData* feedData=[[StatusCommentData alloc] initWithSinaDictionary:dict];
                    [_commentArray insertObject:feedData atIndex:0];
                    [feedData release];
                }
    
     

                if ([_commentArray count]<[_feedData getComment_Count])
                {
                    _showMoreButton=YES;
                }
                else
                {
                    _showMoreButton=NO;
                }
                _loading=NO;
                [self.tableView reloadData];
            }
            
            
         
            
         
            
        }];
        [weibo getCommentsOfStatus:[_feedData getSource_ID] page:_pageNumber count:10];
    }



    
}





- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {	
	[self.egoHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
    
    if (!decelerate)
	{
        [ self loadExtraDataForOnscreenRows ];

        
                }   
        
        // NSLog(@"12345");
    
    
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    //NSLog(@"scrollViewDidEndDecelerating");
    //  NSLog(@"12345");
    [ self loadExtraDataForOnscreenRows ];

       
    
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
    
    
}



- (void)updateImageForCellAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    
    
    
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    NSURL *url; 
     if (_showMoreButton==YES)
         
    {
        if (indexPath.row>1)
        {
                url = [NSURL URLWithString: [[_commentArray objectAtIndex:indexPath.row-2] getHeadURL]];
        }
        else
        {
            return;
        }
    }
    else
    {
        if (indexPath.row>0)
        {
            url = [NSURL URLWithString: [[_commentArray objectAtIndex:indexPath.row-1] getHeadURL]];

        }
        else
        {
            return;
        }
    }
    UIImage *image =[UIImage imageWithData: [NSData dataWithContentsOfURL:url]];
    StatusCommentCell *cell;
    if (_showMoreButton==YES)
    {
        if (indexPath.row>1)
        {
 cell   = (StatusCommentCell*)[self.tableView cellForRowAtIndexPath:indexPath];
        }
        else
        {
            return;
        }
    }
    else
    {
        if (indexPath.row>0)
        {
     cell = (StatusCommentCell*)[self.tableView cellForRowAtIndexPath:indexPath];      
        }
        else
        {
            return;
            
        }
        }
    
    [cell performSelectorOnMainThread:@selector(setUserHeadImage:) withObject:image waitUntilDone:NO];
    [pool release];
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
    if ( _showMoreButton==YES)
    {
    return [_commentArray count]+2;
    }
    else
    {
        return [_commentArray count]+1;
    }
}



-(float) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
if (indexPath.row==0)
{
    return [NewFeedStatusCell heightForCell:_feedData];
}
    else
    {
        if (_showMoreButton==YES)
        {
            
            if (indexPath.row==1)
            {
                return 60;
            }
            else
            {
                return [StatusCommentCell heightForCell:[_commentArray objectAtIndex:indexPath.row-2]];
            }
        }
        else
        {
            return  [StatusCommentCell heightForCell:[_commentArray objectAtIndex:indexPath.row-1]];

        }
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *StatusComentCell = @"StatusCommentCell";
    static NSString *StatusCell = @"NewFeedStatusCell";
    static NSString *RepostStatusCell=@"NewFeedRepostCell";

    
    if (indexPath.row==0)
    {
        NewFeedStatusCell* cell;
        if ([_feedData getPostName]==nil)
        {
            cell = (NewFeedStatusCell *)[tableView dequeueReusableCellWithIdentifier:StatusCell];   
            if (cell == nil) {
                [[NSBundle mainBundle] loadNibNamed:@"NewFeedStatusCell" owner:self options:nil] ;
                cell=_feedStatusCel; 
            }
            
            
        }
              else
        {
            cell = (NewFeedStatusWithRepostcell *)[tableView dequeueReusableCellWithIdentifier:RepostStatusCell];   
            if (cell == nil) {
                [[NSBundle mainBundle] loadNibNamed:@"NewFeedStatusWithRepostcell" owner:self options:nil] ;
                cell=_feedRepostStatusCel; 
            }
        }
        
        [cell configureCell:_feedData];
        return cell;        
    }

    
    
           if (_showMoreButton==YES)
           {
               
           
                if (indexPath.row==1)
    {
 
        UITableViewCell* cell=[[UITableViewCell alloc] initWithFrame:CGRectMake(0, 0, 320, 60)]; 
        [cell.contentView addSubview:self.loadMoreDataButton];
        return cell;
    }

    else 
    {
        
        StatusCommentCell* cell;
        
        cell = (StatusCommentCell *)[tableView dequeueReusableCellWithIdentifier:StatusComentCell];
        if (cell == nil) {
            [[NSBundle mainBundle] loadNibNamed:@"StatusCommentCell" owner:self options:nil];
            cell = _commentCel;
        }
        
        [cell configureCell:[_commentArray objectAtIndex:indexPath.row-2]];
        return cell;
    }
           }
    else
    {
        
        StatusCommentCell* cell;
        
        cell = (StatusCommentCell *)[tableView dequeueReusableCellWithIdentifier:StatusComentCell];
        if (cell == nil) {
            [[NSBundle mainBundle] loadNibNamed:@"StatusCommentCell" owner:self options:nil];
            cell = _commentCel;
        }
        
        [cell configureCell:[_commentArray objectAtIndex:indexPath.row-1]];
        return cell;

    }
}
/*
 - (void)updateImageForCellAtIndexPath:(NSIndexPath *)indexPath
 {
 
 
 
 
 
 NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
 NSURL *url = [NSURL URLWithString: [[_feedArray objectAtIndex:indexPath.row] getHeadURL]];
 
 UIImage *image =[UIImage imageWithData: [NSData dataWithContentsOfURL:url]];
    NewFeedStatusCell *cell = (NewFeedStatusCell*)[self.tableView cellForRowAtIndexPath:indexPath];
    
    [cell performSelectorOnMainThread:@selector(setUserHeadImage:) withObject:image waitUntilDone:NO];
    [pool release];
}
*/


/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
 {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
 }   
 else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }   
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
 {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

#pragma mark - Table view delegate



- (IBAction)backButtonPressed:(id)sender {
    self.navigationController.toolbarHidden = YES;
    [self.navigationController popViewControllerAnimated:YES];
}





@end
