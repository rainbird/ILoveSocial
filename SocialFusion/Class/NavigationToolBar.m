//
//  SFNavigationBar.m
//  SocialFusion
//
//  Created by Blue Bitch on 11-9-23.
//  Copyright 2011年 TJU. All rights reserved.
//

#import "NavigationToolBar.h"

@implementation NavigationToolBar
@synthesize respondView = _respondView;

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

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    /* Use the event.type, subview to decide what actions to perform */
    // Optionally nominate a default event recipient if your view is not completely covered by subviews
    //NSLog(@"x:%f, y:%f", point.x, point.y);
    if(point.x < 60 || point.y < 0)
        return [super hitTest:point withEvent:event];
    else 
       return _respondView;
}

@end
