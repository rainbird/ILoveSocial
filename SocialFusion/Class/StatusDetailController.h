//
//  StatusDetailController.h
//  SocialFusion
//
//  Created by He Ruoyun on 11-10-18.
//  Copyright (c) 2011年 TJU. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "NewFeedData.h"
#import "StatusCommentCell.h"
#import "NewFeedStatusCell.h"
#import "NewFeedStatusWithRepostcell.h"
#import "EGOTableViewController.h"
#import "NewFeedRootData.h"
@interface StatusDetailController : EGOTableViewController<UIScrollViewDelegate>
{
    IBOutlet StatusCommentCell *_commentCel;
 
   
    int _pageNumber;
    BOOL _showMoreButton;
    NewFeedData* _feedData;
    
    
    IBOutlet UIImageView* _headImage;
    IBOutlet UIImageView* _picImage;
    IBOutlet UILabel* _nameLabel;
    IBOutlet UILabel* _statusLabel;
    
    IBOutlet UIScrollView *_firstView;
    IBOutlet UIButton* _repostButton;
    IBOutlet UIButton* _replyButton;
    //   BOOL _completing;
}
@property (nonatomic, retain) NewFeedData* feedData;
@property (nonatomic,retain) NewFeedStatusCell* feedStatusCel;
-(void)loadData;
@end
