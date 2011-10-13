//
//  FriendHeadTabelViewCell.m
//  SocialFusion
//
//  Created by Blue Bitch on 11-10-4.
//  Copyright 2011年 TJU. All rights reserved.
//

#import "FriendHeadTableViewCell.h"

@implementation FriendHeadTableViewCell
@synthesize headGridArray = _headGridArray;

- (void)awakeFromNib
{
    _headGridArray = [[NSMutableArray alloc] initWithCapacity:3];
    for(int i = 0; i < 3; i++) {
        FriendHeadGridViewController *grid = [[[FriendHeadGridViewController alloc] init] autorelease];
        [_headGridArray addObject:grid];
        grid.view.frame = CGRectMake(110 * i, 0, 100, 140);
        [self addSubview:grid.view];
    }
}

- (void)dealloc {
    
    NSLog(@"head deallooc");
    [_headGridArray release];
    [super dealloc];
}


@end
