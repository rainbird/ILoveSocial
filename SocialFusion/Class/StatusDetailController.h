//
//  StatusDetailController.h
//  SocialFusion
//
//  Created by He Ruoyun on 11-10-18.
//  Copyright (c) 2011年 TJU. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DragRefreshTableViewController.h"
#import "NewFeedData.h"
#import "StatusCommentCell.h"
#import "NewFeedStatusCell.h"
#import "NewFeedStatusWithRepostcell.h"
@interface StatusDetailController : DragRefreshTableViewController<UITableViewDataSource,UITableViewDelegate>
{
     IBOutlet StatusCommentCell *_commentCel;
        IBOutlet NewFeedStatusWithRepostcell *_feedRepostStatusCel;
    IBOutlet NewFeedStatusCell* _feedStatusCel;
    NSMutableArray* _commentArray;
    int _pageNumber;
    
    BOOL _showMoreButton;
    
 //   BOOL _completing;
}
@property (nonatomic, retain) NewFeedData* feedData;
-(void)loadData;
@end
