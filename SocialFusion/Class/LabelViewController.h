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
}

@property (nonatomic, retain) UITableView *tableView;
@property (nonatomic, assign) id<LableViewControllerDelegate> delegate;

@end

@protocol LableViewControllerDelegate <NSObject>

@required
- (void)didSelectLabelAtIndexPath:(NSIndexPath *) indexPath;

@end