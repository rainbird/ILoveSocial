//
//  FreindProfileTabelViewCell.m
//  SocialFusion
//
//  Created by Blue Bitch on 11-8-29.
//  Copyright 2011年 TJU. All rights reserved.
//

#import "RenrenFreindProfileTabelViewCell.h"
#import <QuartzCore/QuartzCore.h>


@implementation RenrenFreindProfileTabelViewCell
@synthesize defaultHeadImageView = _defaultHeadImageView;
@synthesize headImageView = _headImageView;
@synthesize userName = _userName;
@synthesize latestStatus = _latestStatus;
@synthesize commentButton = _commentButton;


- (void)awakeFromNib
{
    self.defaultHeadImageView.layer.masksToBounds = YES;
    self.defaultHeadImageView.layer.cornerRadius = 5.0f;  
    self.headImageView.layer.masksToBounds = YES;
    self.headImageView.layer.cornerRadius = 5.0f;    
    [self.commentButton setImage:[UIImage imageNamed:@"messageButton-highlight.png"] forState:UIControlStateHighlighted];
}

- (void)dealloc {
    NSLog(@"Renren Friend Profile Cell Dealloc");
    [_defaultHeadImageView release];
    [_headImageView release];
    [_userName release];
    [_latestStatus release];
    [_commentButton release];
    [super dealloc];
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {
    [super setHighlighted:highlighted animated:animated];
    if(highlighted) {
        self.userName.highlighted = YES;
        self.commentButton.highlighted = YES;
    }
    else {
        self.userName.highlighted = NO;
        self.commentButton.highlighted = NO;
    }
}   

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    if(selected) {
        self.userName.highlighted = YES;
        self.commentButton.highlighted = YES;
    }
    else {
        self.userName.highlighted = NO;
        self.commentButton.highlighted = NO;
    }
}

@end
