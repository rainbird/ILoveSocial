//
//  NewFeedDetailViewCell.h
//  SocialFusion
//
//  Created by He Ruoyun on 11-11-21.
//  Copyright (c) 2011年 TJU. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StatusDetailController.h"
@interface NewFeedDetailViewCell : UITableViewCell
{
    IBOutlet StatusDetailController* detailController;
}
-(void)initWithFeedData:(NewFeedData*)_feedData  context:(NSManagedObjectContext*)context;
@end
