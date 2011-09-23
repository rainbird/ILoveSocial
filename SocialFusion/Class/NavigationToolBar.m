//
//  SFNavigationBar.m
//  SocialFusion
//
//  Created by Blue Bitch on 11-9-23.
//  Copyright 2011年 TJU. All rights reserved.
//

#import "NavigationToolBar.h"

@implementation NavigationToolBar

- (void)drawRect:(CGRect)rect 
{
    UIImage *image = [UIImage imageNamed: @"bottomGradient.png"];
    [image drawInRect:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
}

+ (UINavigationController*)SFNavigationController
{
    UINavigationController *nav = [[[NSBundle mainBundle] loadNibNamed:@"SFNavigationController" owner:self options:nil] objectAtIndex:0];
    nav.toolbar.frame = CGRectMake(0, 405, 320, 55);
    return nav;
}

@end
