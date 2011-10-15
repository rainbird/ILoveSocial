//
//  NewFeedStatusWithRepostcell.h
//  SocialFusion
//
//  Created by He Ruoyun on 11-10-13.
//  Copyright 2011年 TJU. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NewFeedStatusCell.h"

@interface NewFeedStatusWithRepostcell : NewFeedStatusCell {

}

@property(nonatomic, retain) IBOutlet UIButton* repostUserName;
@property(nonatomic, retain) IBOutlet UILabel* repostStatus;
@property(nonatomic, retain) IBOutlet UIButton* repostAreaButton;
@property(nonatomic, retain) IBOutlet UIButton* repostAreaButtonCursor;

@end
