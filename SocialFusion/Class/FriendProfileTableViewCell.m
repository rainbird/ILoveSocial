//
//  FreindProfileTabelViewCell.m
//  SocialFusion
//
//  Created by Blue Bitch on 11-8-29.
//  Copyright 2011年 TJU. All rights reserved.
//

#import "FriendProfileTableViewCell.h"
#import <QuartzCore/QuartzCore.h>


@implementation FriendProfileTableViewCell
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
    NSLog(@"Friend Profile Cell Dealloc");
    [_defaultHeadImageView release];
    [_headImageView release];
    [_userName release];
    [_latestStatus release];
    [_commentButton release];
    [super dealloc];
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {
    [super setHighlighted:highlighted animated:animated];
    //NSLog(@"highlight:%d", highlighted);
    if(highlighted == NO && self.selected == YES)
        return;
    self.userName.highlighted = highlighted;
    self.commentButton.highlighted = highlighted;
}   

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    //NSLog(@"selected:%d", selected);
    self.userName.highlighted = selected;
    self.commentButton.highlighted = selected;
}

@end
