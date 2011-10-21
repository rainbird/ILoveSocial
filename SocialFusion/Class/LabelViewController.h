//
//  LabelViewController.h
//  SocialFusion
//
//  Created by Blue Bitch on 11-9-24.
//  Copyright 2011年 TJU. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LableViewControllerDelegate;

@interface LabelViewController : UIViewController<UITableViewDataSource, UITableViewDelegate> {
    UITableView *_tableView;
    NSMutableArray *_labelName;
    NSIndexPath *_currentCellIndexPath;
}

@property (nonatomic, retain) IBOutlet UITableView *tableView;
@property (nonatomic, assign) id<LableViewControllerDelegate> delegate;
@property (nonatomic, retain) NSMutableArray *labelName;

@end

@protocol LableViewControllerDelegate <NSObject>

@required
- (void)didSelectLabelAtIndexPath:(NSIndexPath *) indexPath;

@end