//
//  LabelTableViewCell.h
//  SocialFusion
//
//  Created by Blue Bitch on 11-9-24.
//  Copyright 2011年 TJU. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LabelTableViewCell : UITableViewCell

@property (nonatomic, retain) IBOutlet UILabel *labelName;
@property (nonatomic, retain) IBOutlet UIImageView *midLabelImage;
@property (nonatomic, retain) IBOutlet UIImageView *leftLabelImage;
@property (nonatomic, retain) IBOutlet UIImageView *rightLabelImage;
@property (nonatomic, retain) IBOutlet UIImageView *highlightLeftLabelImage;

@end

