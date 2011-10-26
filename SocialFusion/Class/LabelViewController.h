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
    NSInteger _currentCellIndex;
    NSMutableArray *_cellIndexStack;
    NSString *_backLabelName;
    id<LableViewControllerDelegate> _delegate;
    NSMutableArray *_labelStack;
}

@property (nonatomic, retain) IBOutlet UITableView *tableView;
@property (nonatomic, assign) id<LableViewControllerDelegate> delegate;
@property (nonatomic, copy) NSString *backLabelName;

- (void)pushLabels:(NSMutableArray *)labels;
- (void)popLabels;

@end

@protocol LableViewControllerDelegate <NSObject>

@required
- (void)didSelectLabelAtIndexPath:(NSIndexPath *)indexPath withLabelName:(NSString *)name;
- (void)didSelectBackLabel;

@end