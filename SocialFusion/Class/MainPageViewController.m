//
//  MainPageViewController.m
//  SocialFusion
//
//  Created by Blue Bitch on 11-9-7.
//  Copyright 2011年 TJU. All rights reserved.
//

#import "MainPageViewController.h"

@implementation MainPageViewController
@synthesize lableViewController = _lableViewController;

///////////////////////////////////////////////////////////////////////////////////////////////////
// UIViewController

- (void)configToolbar {
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backButton setImage:[UIImage imageNamed:@"backButton.png"] forState:UIControlStateNormal];
    [backButton setImage:[UIImage imageNamed:@"backButton-highlight.png"] forState:UIControlStateHighlighted];
    [backButton addTarget:self action:@selector(backButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    backButton.frame = CGRectMake(12, 12, 31, 34);
    UIBarButtonItem *backButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:backButton] autorelease];
    NSMutableArray *toolBarItems = [NSMutableArray array];
    [toolBarItems addObject:backButtonItem];
    self.toolbarItems = nil;
    self.toolbarItems = toolBarItems;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configToolbar];
    self.lableViewController = [[[LabelViewController alloc] init] autorelease];
    [self.view addSubview:self.lableViewController.view];
}

- (void)dealloc {
    NSLog(@"main page dealloc");
    [_lableViewController release];
    [super dealloc];
}

// IBAction
- (IBAction)backButtonPressed:(id)sender {
    UINavigationController *nav = self.navigationController;
    [self.navigationController popViewControllerAnimated:YES];
    [nav.topViewController performSelector:@selector(configToolbar)];
}

@end
