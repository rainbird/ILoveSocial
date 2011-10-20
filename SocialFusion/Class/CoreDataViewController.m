//
//  CoreDataViewController.m
//  PushBox
//
//  Created by Xie Hasky on 11-7-24.
//  Copyright 2011年 同济大学. All rights reserved.
//

#import "CoreDataViewController.h"
#import "RenrenUser.h"
#import "WeiboUser.h"

@implementation CoreDataViewController

@synthesize managedObjectContext = _managedObjectContext;
@synthesize currentRenrenUser = _currentRenrenUser;
@synthesize currentWeiboUser = _currentWeiboUser;

- (void)dealloc
{
    [_managedObjectContext release];
    [_currentRenrenUser release];
    [_currentWeibosUser release];
    [super dealloc];
}

- (void)setCurrentRenrenUser:(RenrenUser *)renrenUser
{
    if (_currentRenrenUser != renrenUser) {
        [_currentRenrenUser release];
        _currentRenrenUser = [renrenUser retain];
        if (!self.managedObjectContext) {
            self.managedObjectContext = renrenUser.managedObjectContext;
        }
    }
}

- (void)setCurrentWeiboUser:(WeiboUser *)weiboUser
{
    if (_currentWeiboUser != weiboUser) {
        [_currentWeiboUser release];
        _currentWeiboUser = [weiboUser retain];
        if (!self.managedObjectContext) {
            self.managedObjectContext = weiboUser.managedObjectContext;
        }
    }
}

@end
