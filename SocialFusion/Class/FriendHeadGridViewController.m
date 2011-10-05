//
//  FriendHeadGridViewController.m
//  SocialFusion
//
//  Created by Blue Bitch on 11-10-4.
//  Copyright 2011年 TJU. All rights reserved.
//

#import "FriendHeadGridViewController.h"
#import <QuartzCore/QuartzCore.h>

@implementation FriendHeadGridViewController

@synthesize defaultHeadImageView = _defaultHeadImageView;
@synthesize headImageView = _headImageView;
@synthesize userName = _userName;

- (void)dealloc {
    //NSLog(@"FriendHeadGridViewController dealloc");
    [_defaultHeadImageView release];
    [_headImageView release];
    [_userName release];
    [super dealloc];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"FriendHeadGridViewController view did load");
    self.defaultHeadImageView.layer.masksToBounds = YES;
    self.defaultHeadImageView.layer.cornerRadius = 5.0f;  
    self.headImageView.layer.masksToBounds = YES;
    self.headImageView.layer.cornerRadius = 5.0f;
}

@end
