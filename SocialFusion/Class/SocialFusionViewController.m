//
//  SocialFusionViewController.m
//  SocialFusion
//
//  Created by He Ruoyun on 11-8-8.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "SocialFusionViewController.h"
#import <QuartzCore/QuartzCore.h>

#import "FriendProfileViewController.h"
#import "MainPageViewController.h"

#import "RenrenUser.h"
#import "WeiboUser.h"

#import "WeiboClient.h"
#import "RenrenClient.h"

#define LOGOUT_RENREN NO
#define LOGOUT_WEIBO YES

@interface SocialFusionViewController()

@property(nonatomic, assign) BOOL logoutClient;

- (void)rrDidLogin;
- (void)wbDidLogin;

@end

@implementation SocialFusionViewController
@synthesize weiboStatusLabel = _weiboStatusLabel,
            renrenStatusLabel = _renrenStatusLabel,
            hasLoggedInAlertView = _hasLoggedInAlertView;
@synthesize managedObjectContext = _managedObjectContext;
@synthesize logoutClient = _logoutClient;

- (void)dealloc
{
    [_managedObjectContext release];
    [_weiboStatusLabel release];
    [_renrenStatusLabel release];
    if(self.hasLoggedInAlertView.visible) {
		[self.hasLoggedInAlertView dismissWithClickedButtonIndex:-1 animated:NO];
	}
    [_hasLoggedInAlertView release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];    
        
	if ([RenrenClient authorized]) {
        NSUserDefaults *info = [NSUserDefaults standardUserDefaults];
		[_renrenStatusLabel setText:[info stringForKey:@"renren_Name"]];
	} else {
		[_renrenStatusLabel setText:NSLocalizedString(@"ID_LogIn_All", nil)];
	}
    
	if ([WeiboClient authorized]) {
        NSUserDefaults *info = [NSUserDefaults standardUserDefaults];
		[_weiboStatusLabel setText:[info stringForKey:@"weibo_Name"]];
	} else {
		[_weiboStatusLabel setText:NSLocalizedString(@"ID_LogIn_All", nil)];
	}
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (IBAction)gotoMain:(id)sender
{
    FriendProfileViewController *friendProfileViewController = [FriendProfileViewController controllerWithContext:self.managedObjectContext];
    [self.navigationController pushViewController:friendProfileViewController animated:YES];
    [friendProfileViewController release];
}

- (void)showHasLoggedInAlert:(BOOL)whoCalled {
    self.logoutClient = whoCalled;
    NSString *message;
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    if(whoCalled == LOGOUT_WEIBO)
        message = [ud stringForKey:@"weibo_Name"];
    else if(whoCalled == LOGOUT_RENREN)
        message = [ud stringForKey:@"renren_Name"];
    message = [message stringByAppendingString:NSLocalizedString(@"ID_LogOut_All",nil )];
    if(self.hasLoggedInAlertView && self.hasLoggedInAlertView.visible) {
        self.hasLoggedInAlertView.message = message;
    }
    else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:message delegate:self cancelButtonTitle:NSLocalizedString(@"ID_OK",nil) otherButtonTitles:NSLocalizedString(@"ID_Cancel",nil), nil];
        self.hasLoggedInAlertView = alert;
        [alert show];
        [alert release];
    }
}

- (IBAction)weiboLogIn:(id)sender
{
	if (![WeiboClient authorized]) {
        WeiboClient *weibo = [WeiboClient client];
        [weibo setCompletionBlock:^(WeiboClient *client) {
            [self wbDidLogin];
        }];
        [weibo authWithUsername:@"wzc345@gmail.com" password:@"5656496" autosave:YES];
    }
    else {
        [self showHasLoggedInAlert:LOGOUT_WEIBO];
    }
}

- (IBAction)renrenLogIn:(id)sender
{    
	if (![RenrenClient authorized]) {
        RenrenClient *renren = [RenrenClient client];
        [renren setCompletionBlock:^(RenrenClient *client) {
            [self rrDidLogin];
        }];
        [renren authorize];
	}
    else {
        [self showHasLoggedInAlert:LOGOUT_RENREN];
    }
}

- (void)wbDidLogin {
    NSLog(@"weibo did login");
    // get user info
    WeiboClient *weibo = [WeiboClient client];
    [weibo setCompletionBlock:^(WeiboClient *client) {
        NSLog(@"weibo did get user info");
        if (!weibo.hasError) {
            NSDictionary *dict = client.responseJSONObject;
            NSLog(@"weibo user info:%@", dict);
            NSString *weiboName = [NSString stringWithFormat:@"%@",[dict objectForKey:@"screen_name"]];
            NSString *weiboID = [NSString stringWithFormat:@"%@",[dict objectForKey:@"id"]];
            NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
            [ud setValue:weiboName forKey:@"weibo_Name"];
            [ud setValue:weiboID forKey:@"weibo_ID"];
            [ud synchronize];
            [_weiboStatusLabel setText:weiboName];
            [WeiboUser insertUser:dict inManagedObjectContext:self.managedObjectContext];
            [self.managedObjectContext processPendingChanges];
        }
    }];
    [weibo getUser:[WeiboClient currentUserID]];
}

- (void)rrDidLogin
{
    NSLog(@"renren did login");
    // get user info
    RenrenClient *renren = [RenrenClient client];
    [renren setCompletionBlock:^(RenrenClient *client) {
        NSLog(@"weibo did get user info");
        if (!renren.hasError) {
            NSArray *result = client.responseJSONObject;
            NSDictionary* dict = [result lastObject];
            NSLog(@"renren user info:%@", dict);
            NSString *renrenName = [dict objectForKey:@"name"];
            NSString *renrenID = [dict objectForKey:@"uid"];
            NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
            [ud setValue:renrenName forKey:@"renren_Name"];
            [ud setValue:renrenID forKey:@"renren_ID"];
            [ud synchronize];
            [_renrenStatusLabel setText:renrenName];
            [RenrenUser insertUser:dict inManagedObjectContext:self.managedObjectContext];
            [self.managedObjectContext processPendingChanges];
        };
    }];
	[renren getUserInfo];
}

- (void)wbDidLogout
{
    [_weiboStatusLabel setText:NSLocalizedString(@"ID_LogIn_All", nil)];
}

- (void)rrDidLogout
{
    [_renrenStatusLabel setText:NSLocalizedString(@"ID_LogIn_All", nil)];
}

//alertView登出的delegate
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if(self.logoutClient == LOGOUT_RENREN) {
        if (buttonIndex == 0) {
            [RenrenClient signout];
            [self rrDidLogout];
            
        }
    }
    else if(self.logoutClient == LOGOUT_WEIBO)
    {
        if (buttonIndex == 0) {
            [WeiboClient signout];
            [self wbDidLogout];
        }
    }
    self.hasLoggedInAlertView = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
