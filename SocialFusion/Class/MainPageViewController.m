//
//  MainPageViewController.m
//  SocialFusion
//
//  Created by Blue Bitch on 11-9-7.
//  Copyright 2011年 TJU. All rights reserved.
//

#import "MainPageViewController.h"

@implementation MainPageViewController

@synthesize university, name, gender, hometown;
@synthesize userInfo;

///////////////////////////////////////////////////////////////////////////////////////////////////
// private

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
// UIViewController

- (void)loadView {
    [super loadView];
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 460)];
    self.view = view;
    
    self.name = [[UILabel alloc] initWithFrame:CGRectMake(20, 20, 100, 30)];
    self.name.text = userInfo.name;
    self.gender = [[UILabel alloc] initWithFrame:CGRectMake(100, 20, 100, 30)];
    self.gender.text = userInfo.gender;
    self.university = [[UILabel alloc] initWithFrame:CGRectMake(20, 80, 300, 100)];
    self.university.text = userInfo.universityHistory;
    self.hometown = [[UILabel alloc] initWithFrame:CGRectMake(20, 200, 300, 100)];
    self.hometown.text = userInfo.hometownLocation;
    
    [self.view addSubview:self.name];
    [self.view addSubview:self.gender];
    [self.view addSubview:self.university];
    [self.view addSubview:self.hometown];
}


- (void)createModel {
    NSLog(@"create model");
}

//- (TTTableViewDragRefreshDelegate *)createDelegate {
//    
//    TTTableViewDragRefreshDelegate *delegate = [[TTTableViewDragRefreshDelegate alloc] initWithController:self];
//    return [delegate autorelease];
//}


- (void)dealloc {
    [super dealloc];
    NSLog(@"main page dealloc");
    self.name = nil;
    self.gender = nil;
    self.university = nil;
    self.hometown = nil;
    self.userInfo = nil;
}

@end
