//
//  NewFeedStatusCell.h
//  SocialFusion
//
//  Created by He Ruoyun on 11-10-9.
//  Copyright 2011年 TJU. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NewFeedData.h"

@interface NewFeedStatusCell : UITableViewCell {
    

    

    
    
    
    
    CGPoint _beginPoint;
    
    BOOL _buttonViewShowed;
    
    IBOutlet UIView* _buttonView;


    IBOutlet UIImageView* _styleView;

    IBOutlet UILabel* _commentCount;
}


@property(nonatomic, retain) IBOutlet UIImageView* defaultHeadImageView;
@property(nonatomic, retain) IBOutlet UIImageView* headImageView;
@property(nonatomic, retain) IBOutlet UIButton* userName;
@property(nonatomic, retain) IBOutlet UILabel* status;

@property(nonatomic, retain) IBOutlet UILabel* time;

+(NSString*)getTimeBefore:(NSDate*)date;

- (IBAction)cancelButton:(id)sender;
-(void)configureCell:(NewFeedData*)feedData;
@end
