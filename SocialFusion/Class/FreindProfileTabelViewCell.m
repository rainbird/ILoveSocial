//
//  FreindProfileTabelViewCell.m
//  SocialFusion
//
//  Created by Blue Bitch on 11-8-29.
//  Copyright 2011年 TJU. All rights reserved.
//

#import "FreindProfileTabelViewCell.h"
#import <QuartzCore/QuartzCore.h>


@implementation FreindProfileTabelViewCell

- (void)layoutSubviews
{   
    [super layoutSubviews];
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    self.textLabel.frame = CGRectMake(70, 6, 210, 18);
    self.textLabel.font = [UIFont systemFontOfSize:16];
    self.textLabel.textColor = [UIColor whiteColor];
    
    self.imageView.frame = CGRectMake(13, 5, 50, 50);
    self.imageView.layer.masksToBounds = YES;
    self.imageView.layer.cornerRadius = 5.0f;
    
    self.detailTextLabel.frame = CGRectMake(70, 24, 210, 35);
    self.detailTextLabel.lineBreakMode = UILineBreakModeTailTruncation;//为防止行内容过多而显示不出来，改内容显示模式为多行
    self.detailTextLabel.numberOfLines = 2;//不控制显示为多少行，若设为2，则只显示为2行
    self.detailTextLabel.font = [UIFont systemFontOfSize:12];
    self.detailTextLabel.textColor = [UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:1];
    
    UIImage *messageButton = [UIImage imageNamed:@"messageButton.png"];
    UIImageView *messageButtonView = [[UIImageView alloc] initWithFrame:CGRectMake(284, 22, 20, 20)];
    messageButtonView.image = messageButton;
    [self.contentView addSubview:messageButtonView];
    
    UIImage *backgroundImage = [UIImage imageNamed:@"friendProfileBackground.png"];
    UIImageView *backgroundImageView = [[UIImageView alloc] initWithImage:backgroundImage];
    self.backgroundView = backgroundImageView;
    
    UIImage *renrenIcon = [UIImage imageNamed:@"renrenicon.png"];
    UIImageView *renreIconView = [[UIImageView alloc] initWithImage:renrenIcon];
    renreIconView.frame = CGRectMake(252, 7, 16, 16);
    [self.contentView addSubview:renreIconView];
    
    UIImage *weiboIcon = [UIImage imageNamed:@"weiboicon.png"];
    UIImageView *weiboIconView = [[UIImageView alloc] initWithImage:weiboIcon];
    weiboIconView.frame = CGRectMake(230, 7, 16, 16);
    [self.contentView addSubview:weiboIconView];
    
//    UIImage *friendImageCover = [UIImage imageNamed:@"friendImageCover.png"];
//    UIImageView *friendImageCoverView = [[UIImageView alloc] initWithFrame:CGRectMake(13, 5, 50, 50)];
//    friendImageCoverView.image = friendImageCover;
//    [self.contentView addSubview:friendImageCoverView];
}

- (void)dealloc {
    [super dealloc];
}

@end
