//
//  FriendProfileViewController.h
//  SocialFusion
//
//  Created by Blue Bitch on 11-8-28.
//  Copyright 2011年 TJU. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CoreDataTableViewController.h"

@interface FriendProfileViewController : CoreDataTableViewController {
    BOOL _isLoading;
    UIImageView *_topShadowImageView;
    UIImageView *_buttomShadowImageView;
    UIButton *_backButton;
}

@property (nonatomic, retain) IBOutlet UIButton *backButton;
- (IBAction)backButtonPressed:(id)sender;

@end
