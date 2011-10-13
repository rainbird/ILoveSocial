//
//  NewFeedStatusWithRepostcell.m
//  SocialFusion
//
//  Created by He Ruoyun on 11-10-13.
//  Copyright 2011年 TJU. All rights reserved.
//

#import "NewFeedStatusWithRepostcell.h"


@implementation NewFeedStatusWithRepostcell


@synthesize repostUserName = _repostUserName;
@synthesize repostAreaButton = _repostAreaButton;
@synthesize repostAreaButtonCursor = _repostAreaButtonCursor;

@synthesize repostStatus = _repostStatus;


- (void)dealloc
{
    [super dealloc];
    [_repostUserName release];
    [_repostAreaButton release];
    [_repostStatus release];
}



#pragma mark - View lifecycle




- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
