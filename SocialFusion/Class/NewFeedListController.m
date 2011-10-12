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
#import "NewFeedData.h"
#import "Image+Addition.h"
#import "UIImageView+DispatchLoad.h"
#define kCustomRowCount 8

#define kUserDefaultKeyFirstTimeUsingEGOView @"kUserDefaultKeyFirstTimeUsingEGOView"


@implementation NewFeedListController
@synthesize managedObjectContext = _managedObjectContext;
@synthesize egoHeaderView = _egoHeaderView;
@synthesize loadMoreDataButton = _loadMoreDataButton;
@synthesize tableView = _tableView;
@synthesize tableViewBackground = _tableViewBackground;

@synthesize currentRenrenUser = _currentRenrenUser;
@synthesize currentWeiboUser = _currentWeibosUser;



- (void)setCurrentRenrenUser:(RenrenUser *)renrenUser
{
    if (_currentRenrenUser != renrenUser) {
        [_currentRenrenUser release];
        _currentRenrenUser = [renrenUser retain];
        if (!self.managedObjectContext) {
            self.managedObjectContext = renrenUser.managedObjectContext;
        }
    }
}


-(id)init
{
    self=[super init];
    _feedArray=[[NSMutableArray alloc] init];
    NSLog(@"a");
    return self;
}

+ (void)initialize
{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
	NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:30];
    [dict setObject:[NSNumber numberWithBool:YES] forKey:kUserDefaultKeyFirstTimeUsingEGOView];
	[userDefault registerDefaults:dict];
}

- (void)dealloc
{
    [_egoHeaderView release];
    [_loadMoreDataButton release];
    [super dealloc];
}

- (void)showHelp
{
    UIImageView *helpImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"refresh_help"]];
    helpImageView.alpha = 0.7;
    [self.tableView addSubview:helpImageView];
    [helpImageView release];
    [UIView animateWithDuration:1 delay:2 options:0 animations:^{
        helpImageView.alpha = 0;
    } completion:^(BOOL fin){
        [helpImageView removeFromSuperview];
    }];
}

- (UIButton *)loadMoreDataButton
{
    if (!_loadMoreDataButton) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(0, 0, self.tableView.frame.size.width, 60);
        NSString *text = NSLocalizedString(@"加载更多数据", nil);
        [button setBackgroundImage:[UIImage imageNamed:@"tableviewCell.png"] forState:UIControlStateNormal];
        [button setBackgroundImage:[UIImage imageNamed:@"tableviewCell-highlight.png"] forState:UIControlStateHighlighted];
        [button setTitle:text forState:UIControlStateNormal];
        [button setTitle:text forState:UIControlStateHighlighted];
        [button setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
        [button addTarget:self action:@selector(loadMoreData) forControlEvents:UIControlEventTouchUpInside];
        self.loadMoreDataButton = button;
    }
    return _loadMoreDataButton;
}

- (void)showLoadMoreDataButton
{
    [self.tableView setTableFooterView:self.loadMoreDataButton];
}

- (void)hideLoadMoreDataButton
{
    [self.tableView setTableFooterView:nil];
}





- (void)showHeadImageAnimation:(UIImageView *)imageView {
    imageView.alpha = 0;
    [UIView animateWithDuration:0.3f delay:0 options:UIViewAnimationOptionAllowUserInteraction animations:^(void) {
        imageView.alpha = 1;
    } completion:nil];
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
-(void)loadRenrenData
{
    _pageNumber=1;
    
   
    RenrenClient *renren = [RenrenClient client];
    [renren setCompletionBlock:^(RenrenClient *client) {
         [_feedArray removeAllObjects];
        if(!client.hasError) {
            NSArray *array = client.responseJSONObject;
            for(NSDictionary *dict in array) {
                
                NewFeedData* feedData=[[NewFeedData alloc] initWithDictionary:dict];
                [_feedArray addObject:feedData];
                [feedData release];
            }
            //  NSLog(@"renren friend count:%d", array.count);
            //NSLog(@"add finished");
        }
        
        [self doneLoadingTableViewData];
        _loading = NO;
    }];
    [renren getNewFeed:_pageNumber];
    
    
}



-(void)loadMoreRenrenData
{
    _pageNumber++;
    RenrenClient *renren = [RenrenClient client];
    [renren setCompletionBlock:^(RenrenClient *client) {
        if(!client.hasError) {
           NSArray *array = client.responseJSONObject;
            for(NSDictionary *dict in array) {
             
                NewFeedData* feedData=[[NewFeedData alloc] initWithDictionary:dict];
                [_feedArray addObject:feedData];
                [feedData release];
            }
          //  NSLog(@"renren friend count:%d", array.count);
            //NSLog(@"add finished");
        }
    
        [self doneLoadingTableViewData];
        _loading = NO;
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

- (void)reloadTableViewDataSource {
	_reloading = YES;
	[self refresh];
}

- (void)doneLoadingTableViewData {
    [UIView animateWithDuration:.2 animations:^(void) {
        [self.tableView setContentInset:UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, 0.0f)];
    } completion:^(BOOL finished) {
        _reloading = NO;
    }];
	[self.egoHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading];
  
  //  NSLog(@"%@",_feedArray);
   [_tableView reloadData];
     
}

- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView*)view {
	[self reloadTableViewDataSource];
}

- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView*)view {
	return _reloading; // should return if data source model is reloading
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{	
	[self.egoHeaderView egoRefreshScrollViewDidScroll:scrollView];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {	
	[self.egoHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
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





- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
 
    [self showLoadMoreDataButton];
    _pageNumber=1;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
 
    
    
    //NSLog(@"bound width:%f, bound height:%f", self.tableView.bounds.size.width,self.tableView.bounds.size.height);
    _egoHeaderView = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, 
                                                                                 0.0f - self.tableView.bounds.size.height, 
                                                                                 self.tableView.frame.size.width, 
                                                                                 self.tableView.bounds.size.height)];
    self.egoHeaderView.delegate = self;
    [self.tableView addSubview:self.egoHeaderView];
    
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    BOOL firstime = [userDefault boolForKey:kUserDefaultKeyFirstTimeUsingEGOView];
    
    if (firstime) {
        [self showHelp];
        [userDefault setBool:NO forKey:kUserDefaultKeyFirstTimeUsingEGOView];
        [userDefault synchronize];
    }
    
    _reloading = NO;
    _loading = NO;
    
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
    
    
    [self refresh];
 

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
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return [_feedArray count];
}



-(float) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    NSString* tempString=[[_feedArray objectAtIndex:indexPath.row] getName];
    CGSize size = CGSizeMake(212, 1000);
    CGSize labelSize = [tempString sizeWithFont:[UIFont fontWithName:@"Helvetica" size:12]
                                    constrainedToSize:size];
    
    if (labelSize.height<50)
    {
        return 60;
    }
    return labelSize.height+10;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *cellID = @"NewFeedStatusCell";
    NewFeedStatusCell *cell = (NewFeedStatusCell *)[tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
		[[NSBundle mainBundle] loadNibNamed:@"NewFeedStatusCell" owner:self options:nil];
        cell = _feedStatusCel;
       // cell=[[NewFeedStatusCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
            
    }
    
    
    
    cell.status.text=[[_feedArray objectAtIndex:indexPath.row] getName];
    [cell.userName setTitle:[[_feedArray objectAtIndex:indexPath.row] getFeedName] forState:UIControlStateNormal];
    
   // [cell.status sizeToFit];
   
    
    
    CGSize size = CGSizeMake(212, 1000);
    
    
    CGSize labelSize = [cell.status.text sizeWithFont:cell.status.font 
                                 constrainedToSize:size];
    
    cell.status.frame = CGRectMake(cell.status.frame.origin.x, cell.status.frame.origin.y,
                                cell.status.frame.size.width, labelSize.height);
    
    cell.status.lineBreakMode = UILineBreakModeWordWrap;
    cell.status.numberOfLines = 0;
    
    if (cell.frame.size.height<60)
    {
    cell.frame=CGRectMake(cell.frame.origin.x, cell.frame.origin.y, cell.frame.size.width, labelSize.height+10);
    }
    
    NSData *imageData = nil;

    if(imageData == nil) {
        if(self.tableView.dragging == NO && self.tableView.decelerating == NO) {
            if(indexPath.row < kCustomRowCount) {
                [cell.headImageView loadImageFromURL:[[_feedArray objectAtIndex:indexPath.row] getHeadURL] completion:^{
                    [self showHeadImageAnimation:cell.headImageView];
                } cacheInContext:_managedObjectContext];
            }
        }
    }

    
   //cell.status.frame = [cell.status textRectForBounds:cell.status.frame limitedToNumberOfLines:10];
    

// Configure the cell...
    
    return cell;
}


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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     DetailViewController *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     [detailViewController release];
     */
}


- (IBAction)backButtonPressed:(id)sender {
    self.navigationController.toolbarHidden = YES;
    [self.navigationController popViewControllerAnimated:YES];
}

@end
