//
//  DragRefreshTableViewController.h
//  SocialFusion
//
//  Created by He Ruoyun on 11-10-18.
//  Copyright (c) 2011年 TJU. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGORefreshTableHeaderView.h"
@interface DragRefreshTableViewController : UIViewController<EGORefreshTableHeaderDelegate>
{
    EGORefreshTableHeaderView *_egoHeaderView;
    BOOL _reloading;
    BOOL _loading;
    UIImageView *_topShadowImageView;
    UIImageView *_bottomShadowImageView;
    UITableView *_tableView;
    UIButton *_loadMoreDataButton;

}

@property(nonatomic, retain) EGORefreshTableHeaderView *egoHeaderView;
@property(nonatomic, retain) UIButton *loadMoreDataButton;

@property (nonatomic, retain) IBOutlet UIImageView *tableViewBackground;
@property (nonatomic, retain) IBOutlet UITableView *tableView;

- (void)showHeadImageAnimation:(UIImageView *)imageView;
- (void)loadExtraDataForOnscreenRowsHelp:(NSIndexPath *)indexPath;

- (void)showHeadImageAnimation:(UIImageView *)imageView ;
//to override
- (void)loadMoreData;
- (void)refresh;
- (void)doneLoadingTableViewData;
- (void)showLoadMoreDataButton;
- (void)hideLoadMoreDataButton;

- (void)loadExtraDataForOnscreenRows;
- (IBAction)backButtonPressed:(id)sender;


@end
