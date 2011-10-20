//
//  NewFeedListController.h
//  SocialFusion
//
//  Created by He Ruoyun on 11-10-7.
//  Copyright 2011年 TJU. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DragRefreshTableViewController.h"

#import "RenrenUser+Addition.h"
#import "WeiboUser+Addition.h"
#import "NewFeedStatusCell.h"
#import "NewFeedStatusWithRepostcell.h"
#import "NewFeedBlogCell.h"
@interface NewFeedListController : DragRefreshTableViewController<UITableViewDataSource,UITableViewDelegate> {

    
  
    
    NSMutableArray* _feedArray;
    NSMutableArray* _tempArray;
    
    

    
    IBOutlet NewFeedStatusCell *_feedStatusCel;
    IBOutlet NewFeedStatusWithRepostcell *_feedRepostStatusCel;
    IBOutlet NewFeedBlogCell *_newFeedBlogCel;
    
    int _pageNumber;


}

-(void)loadMoreRenrenData;

-(void)loadRenrenData;


-(IBAction)gotoRepostStatus:(id)sender;

@end
