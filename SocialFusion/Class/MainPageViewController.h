//
//  MainPageViewController.h
//  SocialFusion
//
//  Created by Blue Bitch on 11-9-7.
//  Copyright 2011年 TJU. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RenrenUser.h"

@interface MainPageViewController : UIViewController

@property(nonatomic, retain) UILabel *name;
@property(nonatomic, retain) UILabel *hometown;
@property(nonatomic, retain) UILabel *university;
@property(nonatomic, retain) UILabel *gender;

@property(nonatomic, retain) RenrenUser *userInfo;


@end
