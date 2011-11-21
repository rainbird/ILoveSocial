//
//  StatusCommentCell.h
//  SocialFusion
//
//  Created by He Ruoyun on 11-10-18.
//  Copyright (c) 2011年 TJU. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StatusCommentData+StatusCommentData_Addition.h"
@interface StatusCommentCell : UITableViewCell
{
    UIImageView* _defaultHeadImageView;
    UIImageView* _headImageView;
    UIButton* _userName;
    UILabel* _status;
    UILabel* _time;
}

@property(nonatomic, retain) IBOutlet UIImageView* defaultHeadImageView;
@property(nonatomic, retain) IBOutlet UIImageView* headImageView;
@property(nonatomic, retain) IBOutlet UIButton* userName;
@property(nonatomic, retain) IBOutlet UILabel* status;
@property(nonatomic, retain) IBOutlet UILabel* time;


+(float)heightForCell:(StatusCommentData*)feedData;
-(void)configureCell:(StatusCommentData*)feedData;
@end
