//
//  CoreDataViewController.h
//  PushBox
//
//  Created by Xie Hasky on 11-7-24.
//  Copyright 2011年 同济大学. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RenrenUser;
@class WeiboUser;

@interface CoreDataViewController : UIViewController {
    NSManagedObjectContext *_managedObjectContext;
    RenrenUser *_currentRenrenUser;
    WeiboUser *_currentWeibosUser;
    RenrenUser *_renrenUser;
    WeiboUser *_weiboUser;
}

@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain) RenrenUser *currentRenrenUser;
@property (nonatomic, retain) WeiboUser *currentWeiboUser;
@property (retain, nonatomic) RenrenUser *renrenUser;
@property (retain, nonatomic) WeiboUser *weiboUser;

@end
