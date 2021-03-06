//
//  NewFeedStatusCell.h
//  SocialFusion
//
//  Created by He Ruoyun on 11-10-9.
//  Copyright 2011年 TJU. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NewFeedData+NewFeedData_Addition.h"

@interface NewFeedStatusCell : UITableViewCell {
    NewFeedRootData* _feedData;
    CGPoint _beginPoint;
    BOOL _buttonViewShowed;
    IBOutlet UIView* _buttonView;
    IBOutlet UIImageView* _styleView;
    IBOutlet UILabel* _commentCount;
   
    
    
    UIImageView* _picView;
    
    
    
    UIImageView* _defaultHeadImageView;
    UIImageView* _headImageView;
    UIButton* _userName;
    UILabel* _status;
    UILabel* _time;
}

@property(nonatomic, retain) IBOutlet UIImageView* picView;
@property(nonatomic, retain) IBOutlet UIImageView* defaultHeadImageView;
@property(nonatomic, retain) IBOutlet UIImageView* headImageView;
@property(nonatomic, retain) IBOutlet UIButton* userName;
@property(nonatomic, retain) IBOutlet UILabel* status;
@property(nonatomic, retain) IBOutlet UILabel* time;

+(float)heightForCell:(NewFeedData*)feedData;
-(NewFeedRootData*) getFeedData;
- (IBAction)cancelButton:(id)sender;
-(void)configureCell:(NewFeedData*)feedData;
@end
