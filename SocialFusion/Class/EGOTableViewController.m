//
//  EGOTableViewController.m
//  PushBox
//
//  Created by Xie Hasky on 11-7-30.
//  Copyright 2011年 同济大学. All rights reserved.
//

#import "EGOTableViewController.h"

#define kUserDefaultKeyFirstTimeUsingEGOView @"kUserDefaultKeyFirstTimeUsingEGOView"

@implementation EGOTableViewController

@synthesize egoHeaderView = _egoHeaderView;
@synthesize loadMoreDataButton = _loadMoreDataButton;

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

- (void)viewDidLoad
{
    [super viewDidLoad];
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
}

- (void)loadMoreData
{
    
}

- (void)refresh
{
    
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

@end
