//
//  FriendHeadTabelViewCell.h
//  SocialFusion
//
//  Created by Blue Bitch on 11-10-4.
//  Copyright 2011年 TJU. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FriendHeadGridViewController.h"

@interface FriendHeadTableViewCell : UITableViewCell {
    NSMutableArray *_headGridArray;
}

@property (nonatomic,retain, readonly) NSMutableArray *headGridArray;

@end
