//
//  NewFeedStatusCell.h
//  SocialFusion
//
//  Created by He Ruoyun on 11-10-9.
//  Copyright 2011年 TJU. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface NewFeedStatusCell : UITableViewCell {
    UIImageView *_defaultHeadImageView;
    UIImageView *_headImageView;
    UILabel *_Status;

    UILabel *_Time;
    
    CGPoint _beginPoint;
    BOOL _buttonViewShowed;
    IBOutlet UIView* _buttonView;


    
}


@property(nonatomic, retain) IBOutlet UIImageView* defaultHeadImageView;
@property(nonatomic, retain) IBOutlet UIImageView* headImageView;
@property(nonatomic, retain) IBOutlet UIButton* userName;
@property(nonatomic, retain) IBOutlet UILabel* status;

@property(nonatomic, retain) IBOutlet UILabel* time;


- (IBAction)cancelButton:(id)sender;
@end
