//
//  DisplayViewController.h
//  SocialFusion
//
//  Created by Blue Bitch on 11-10-25.
//  Copyright 2011年 TJU. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FriendProfileViewController.h"
#import "MainPageViewController.h"

typedef enum {
    DisplayViewTypeSelf,
    DisplayViewTypeWeibo,
    DisplayViewTypeRenren,
} DisplayViewType;

@interface DisplayViewController : CoreDataViewController<MainPageViewControllerDelegate> {
    NSMutableArray *_viewControllers;
    NSMutableDictionary *_viewControllerMap;
    DisplayViewType _type;
}

@property (retain, nonatomic) NSMutableArray *viewControllers;

- (id)initWithType:(DisplayViewType)type;

@end
