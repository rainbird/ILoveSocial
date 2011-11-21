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
@interface StatusDetailController : EGOTableViewController
{
    IBOutlet StatusCommentCell *_commentCel;
    IBOutlet NewFeedStatusWithRepostcell *_feedRepostStatusCel;
    IBOutlet NewFeedStatusCell* _feedStatusCel;
   
    int _pageNumber;
    BOOL _showMoreButton;
    NewFeedData* _feedData;
    
    
    //   BOOL _completing;
}
@property (nonatomic, retain) NewFeedData* feedData;
-(void)loadData;
@end
