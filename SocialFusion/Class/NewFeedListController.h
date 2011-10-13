//
//  NewFeedListController.h
//  SocialFusion
//
//  Created by He Ruoyun on 11-10-7.
//  Copyright 2011年 TJU. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGORefreshTableHeaderView.h"
#import "RenrenUser+Addition.h"
#import "WeiboUser+Addition.h"
#import "NewFeedStatusCell.h"
#import "NewFeedStatusWithRepostcell.h"
@interface NewFeedListController : UIViewController<UITableViewDataSource,UITableViewDelegate,EGORefreshTableHeaderDelegate,NSFetchedResultsControllerDelegate> {
    EGORefreshTableHeaderView *_egoHeaderView;
    BOOL _reloading;
    BOOL _loading;
    UIImageView *_topShadowImageView;
    UIImageView *_bottomShadowImageView;
    UITableView *_tableView;
    UIButton *_loadMoreDataButton;

    
        NSManagedObjectContext *_managedObjectContext;
    
    NSMutableArray* _feedArray;
    
    
    
    RenrenUser *_currentRenrenUser;
    WeiboUser *_currentWeibosUser;

    NSMutableArray* _heightArray;
    
    IBOutlet NewFeedStatusCell *_feedStatusCel;
    IBOutlet NewFeedStatusWithRepostcell *_feedRepostStatusCel;
        
    int _pageNumber;
}

@property (nonatomic, retain) RenrenUser *currentRenrenUser;
@property (nonatomic, retain) WeiboUser *currentWeiboUser;

@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;

@property(nonatomic, retain) EGORefreshTableHeaderView *egoHeaderView;
@property(nonatomic, retain) UIButton *loadMoreDataButton;

@property (nonatomic, retain) IBOutlet UIImageView *tableViewBackground;
@property (nonatomic, retain) IBOutlet UITableView *tableView;

- (void)showHeadImageAnimation:(UIImageView *)imageView;
- (void)loadExtraDataForOnscreenRowsHelp:(NSIndexPath *)indexPath;
-(void)loadMoreRenrenData;

-(void)loadRenrenData;
- (void)showHeadImageAnimation:(UIImageView *)imageView ;
//to override
- (void)loadMoreData;
- (void)refresh;
- (void)doneLoadingTableViewData;
- (void)showLoadMoreDataButton;
- (void)hideLoadMoreDataButton;




- (IBAction)backButtonPressed:(id)sender;
@end
