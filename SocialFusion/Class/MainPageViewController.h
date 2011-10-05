//
//  MainPageViewController.h
//  SocialFusion
//
//  Created by Blue Bitch on 11-9-7.
//  Copyright 2011年 TJU. All rights reserved.
//

#import "LabelViewController.h"
#import "CoreDataViewController.h"

@interface MainPageViewController : CoreDataViewController<LableViewControllerDelegate> {
    BOOL _firstLoad;
}

@property (nonatomic, retain) LabelViewController *lableViewController;
@property (nonatomic, retain) NSMutableArray *viewControllers;

@end
