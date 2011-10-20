//
//  DragRefreshTableViewController.m
//  SocialFusion
//
//  Created by He Ruoyun on 11-10-18.
//  Copyright (c) 2011年 TJU. All rights reserved.
//

#import "DragRefreshTableViewController.h"
#import "NavigationToolBar.h"
@implementation DragRefreshTableViewController
@synthesize egoHeaderView = _egoHeaderView;
@synthesize loadMoreDataButton = _loadMoreDataButton;
@synthesize tableView = _tableView;
@synthesize tableViewBackground = _tableViewBackground;
#define kCustomRowCount 8

#define kUserDefaultKeyFirstTimeUsingEGOView @"kUserDefaultKeyFirstTimeUsingEGOView"




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
    
    [self showLoadMoreDataButton];
    
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




- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
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
    [self hideLoadMoreDataButton];
    

    
    [self configureToolbar];
    self.navigationController.toolbarHidden = NO; 
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
    
   // [self configureToolbar];
    // NSLog(@"friend list view did load");

    
    self.egoHeaderView.textColor = [UIColor whiteColor];
    _topShadowImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"tableviewCellTopShadow.png"]];
    _topShadowImageView.frame = CGRectMake(0, -20, 320, 20);
    [self.view addSubview:_topShadowImageView];
    _bottomShadowImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"tableviewCellBottomShadow.png"]];
    _bottomShadowImageView.frame = CGRectMake(0, 460, 320, 20);
    [self.view addSubview:_bottomShadowImageView];    
    
    
    [self refresh];
    
    
}



-(void)viewWillAppear:(BOOL)animated
{

}
- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}



- (void)loadExtraDataForOnscreenRowsHelp:(NSIndexPath *)indexPath
{
    return;
}


- (void)loadMoreData
{
    return;
}
- (void)refresh
{
    return;
}




- (void)loadExtraDataForOnscreenRows
{
    return;
}
- (IBAction)backButtonPressed:(id)sender
{
    return;
}





@end
