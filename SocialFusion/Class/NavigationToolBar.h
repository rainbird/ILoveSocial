//
//  SFNavigationBar.h
//  SocialFusion
//
//  Created by Blue Bitch on 11-9-23.
//  Copyright 2011年 TJU. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NavigationToolBar : UIToolbar {
    UIView *_respondView;
}

@property (nonatomic, assign) UIView *respondView;

+ (UINavigationController*)SFNavigationController;

@end
