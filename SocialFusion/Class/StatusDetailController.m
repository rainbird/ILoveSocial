//
//  StatusDetailController.m
//  SocialFusion
//
//  Created by He Ruoyun on 11-10-18.
//  Copyright (c) 2011年 TJU. All rights reserved.
//
#import "NavigationToolBar.h"
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
#import "StatusCommentData+StatusCommentData_Addition.h"

@implementation StatusDetailController

@synthesize feedData=_feedData;


-(void)addOriStatus
{
    _nameLabel.text=[_feedData getFeedName];
    
    _statusLabel.text=_feedData.message;
    
    CGSize size = CGSizeMake(271, 1000);
    CGSize labelSize = [_statusLabel.text sizeWithFont:_statusLabel.font 
                                    constrainedToSize:size];
    _statusLabel.frame = CGRectMake(_statusLabel.frame.origin.x, _statusLabel.frame.origin.y,
                                  _statusLabel.frame.size.width, labelSize.height);
    _statusLabel.lineBreakMode = UILineBreakModeWordWrap;
    _statusLabel.numberOfLines = 0;
    
    
    NSData *imageData = nil;
    if([Image imageWithURL:_feedData.owner_Head inManagedObjectContext:self.managedObjectContext]) {
        imageData = [Image imageWithURL:_feedData.owner_Head inManagedObjectContext:self.managedObjectContext].imageData.data;
    }
    if(imageData != nil) {
        _headImage.image = [UIImage imageWithData:imageData];
    }
  
        if (_feedData.pic_URL!=nil)
        {
            if([Image imageWithURL:_feedData.pic_URL inManagedObjectContext:self.managedObjectContext]) {
                imageData = [Image imageWithURL:_feedData.pic_URL inManagedObjectContext:self.managedObjectContext].imageData.data;
            }
            if(imageData != nil) {
                _picImage.image = [UIImage imageWithData:imageData];
                     }
        }
    
    if (_picImage.image!=nil)
    {
    _picImage.frame=CGRectMake(20,_statusLabel.frame.origin.y+_statusLabel.frame.size.height+10,266, 266/_picImage.image.size.width*_picImage.image.size.height);
    }
    else
    {
        _picImage.frame=CGRectMake(20,_statusLabel.frame.origin.y+_statusLabel.frame.size.height+10,0,0);

    }
    
    _replyButton.frame=CGRectMake(_replyButton.frame.origin.x, _picImage.frame.origin.y+_picImage.frame.size.height+20, _replyButton.frame.size.width, _replyButton.frame.size.height);
    
    _repostButton.frame=CGRectMake(_repostButton.frame.origin.x, _picImage.frame.origin.y+_picImage.frame.size.height+20, _repostButton.frame.size.width, _repostButton.frame.size.height);
    
   
    
    [(UIScrollView*)self.view setContentSize:CGSizeMake(self.view.frame.size.width*2, _repostButton.frame.origin.y+70)];
    
    
    ((UIScrollView*)self.view).pagingEnabled=YES;
    ((UIScrollView*)self.view).showsVerticalScrollIndicator=NO;
   
    ((UIScrollView*)self.view).directionalLockEnabled=YES;
    self.tableView.frame=CGRectMake(306, 0, 306, 390);
    [((UIScrollView*)self.view) addSubview:self.tableView];
    
    ((UIScrollView*)self.view).delegate=self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
       // _commentArray=[[NSMutableArray alloc] init];
        
    }
    return self;
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
      [self addOriStatus ];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
  
    // if(_type == RelationshipViewTypeRenrenFriends && self.currentRenrenUser.friends.count > 0)
    //  return;
    //return;
    
    
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
    _pageNumber=0;
  //  [self refresh];
}
- (void)viewDidUnload
{
 
    [super viewDidUnload];
}

-(void)viewDidDisappear:(BOOL)animated
{
    //[_feedStatusCel removeFromSuperview];
    //[_feedStatusCel release];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    NSLog(@"clear all cache");
    [Image clearAllCacheInContext:self.managedObjectContext];
}


- (void)dealloc {
    [_feedData release];
    //[_feedStatusCel release];
    [super dealloc];
}


- (void)configureRequest:(NSFetchRequest *)request
{
    [request setEntity:[NSEntityDescription entityForName:@"StatusCommentData" inManagedObjectContext:self.managedObjectContext]];
    NSPredicate *predicate;
    NSSortDescriptor *sort;
  
    predicate = [NSPredicate predicateWithFormat:@"SELF IN %@",_feedData.comments];
    sort = [[NSSortDescriptor alloc] initWithKey:@"update_Time" ascending:NO];
    [request setPredicate:predicate];
    NSArray *descriptors = [NSArray arrayWithObject:sort]; 
    [request setSortDescriptors:descriptors]; 
    [sort release];
    request.fetchBatchSize = 5;

}

#pragma mark - EGORefresh Method
- (void)refresh {
    
   // [self clearData];
    if ([_feedData getStyle]==0)
    {
        _pageNumber=[_feedData getComment_Count]/10+1;
    }
    else
    {
        _pageNumber=1;
    }
    
    

    
    if(_loading)
        return;
    _loading = YES;

    [self loadData];
    
    


}

- (void)showHeadImageAnimation:(UIImageView *)imageView {
    imageView.alpha = 0;
    [UIView animateWithDuration:0.3f delay:0 options:UIViewAnimationOptionAllowUserInteraction animations:^(void) {
        imageView.alpha = 1;
    } completion:nil];
}






-(void)loadData
{
    if ([_feedData getStyle]==0)
    {
        
        //  [renren1 getComments:[_feedData getActor_ID] status_ID:[_feedData getSource_ID] pageNumber:_pageNumber];
        
        
        
        
        RenrenClient *renren = [RenrenClient client];
        [renren setCompletionBlock:^(RenrenClient *client) {
            if(!client.hasError) {
                NSArray *array = client.responseJSONObject;
                for(NSDictionary *dict in array) {
                    
                    
                    StatusCommentData* commentsData=[StatusCommentData insertNewComment:0 Dic:dict inManagedObjectContext:self.managedObjectContext];
                    [_feedData addCommentsObject:commentsData];
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
                /*
                 if(_completing==YES)
                 {
                 
                 }
                 else
                 {
                 _completing=YES;
                 }
                 */
            }
            
            
            
        }];
        
        
        [renren getComments:[_feedData getActor_ID] status_ID:[_feedData getSource_ID] pageNumber:_pageNumber];
        
    }
    
    else
    {
        WeiboClient *weibo = [WeiboClient client];
        [weibo setCompletionBlock:^(WeiboClient *client) {
            if(!client.hasError) {
                
                NSLog(@"%@",client.responseJSONObject);
                NSArray *array = client.responseJSONObject;
                for(NSDictionary *dict in array) {
                    
                    StatusCommentData* commentsData=[StatusCommentData insertNewComment:1 Dic:dict inManagedObjectContext:self.managedObjectContext];
                    [_feedData addCommentsObject:commentsData];
                
                }
                
                
                
                if ([_feedData.comments count]<[_feedData getComment_Count])
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
        
        //NSLog(@"%@",[_feedData getSource_ID]);
        [weibo getCommentsOfStatus:[_feedData getSource_ID] page:_pageNumber count:10];
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




- (void)loadMoreData {
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
    [self loadData]    ;
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
               // indexPath=[[indexPath indexPathByRemovingLastIndex] indexPathByRemovingLastIndex];
                return [StatusCommentCell heightForCell:[self.fetchedResultsController objectAtIndexPath:indexPath]];
            }
        }
        else
        {
       //     indexPath=[indexPath indexPathByRemovingLastIndex];
            return [StatusCommentCell heightForCell:[self.fetchedResultsController objectAtIndexPath:indexPath]];
            
        }
    }

    
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    // Return the number of sections.
    return 1;
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
             //   cell=_feedStatusCel; 
            }
            
            
        }
        else
        {
            cell = (NewFeedStatusWithRepostcell *)[tableView dequeueReusableCellWithIdentifier:RepostStatusCell];   
            if (cell == nil) {
                [[NSBundle mainBundle] loadNibNamed:@"NewFeedStatusWithRepostcell" owner:self options:nil] ;
              //  cell=_feedRepostStatusCel; 
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
//            indexPath=[[indexPath indexPathByRemovingLastIndex] indexPathByRemovingLastIndex];

            [cell configureCell:[self.fetchedResultsController objectAtIndexPath:indexPath]];
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
        
       // indexPath=[indexPath indexPathByRemovingLastIndex];
        
        [cell configureCell:[self.fetchedResultsController objectAtIndexPath:indexPath]];
        return cell;
        
    }
    
}



- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
   // if (self.tableView.)
   // self.tableView.frame=CGRectMake(306, scrollView.contentOffset.y, 306, 390);
    
}

    @end
