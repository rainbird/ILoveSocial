//
//  SocialFusionViewController.m
//  SocialFusion
//
//  Created by He Ruoyun on 11-8-8.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "SocialFusionViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "FriendListViewController.h"
#import "FriendHeadViewController.h"
#import "RenrenUser+Addition.h"
#import "WeiboUser+Addition.h"
#import "WeiboClient.h"
#import "RenrenClient.h"

#import "NewFeedListController.h"

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
@synthesize logoutClient = _logoutClient;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        NSLog(@"init social fusion view controller using nib file %@", nibNameOrNil);
    }
    return self;
}


- (void)dealloc
{
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

- (void)configToolbar {
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backButton setImage:[UIImage imageNamed:@"backButton.png"] forState:UIControlStateNormal];
    [backButton setImage:[UIImage imageNamed:@"backButton-highlight.png"] forState:UIControlStateHighlighted];
    backButton.frame = CGRectMake(12, 12, 31, 34);
    UIBarButtonItem *backButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:backButton] autorelease];
    NSMutableArray *toolBarItems = [NSMutableArray array];
    [toolBarItems addObject:backButtonItem];
    self.toolbarItems = toolBarItems;
}

#pragma mark - View lifecycle
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];    
    [self configToolbar];    
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
	if ([RenrenClient authorized]) {
        NSString *renrenID = [ud objectForKey:@"renren_ID"];
        self.currentRenrenUser = [RenrenUser userWithID:renrenID inManagedObjectContext:self.managedObjectContext];
        if(self.currentRenrenUser == nil) {
            [self rrDidLogin];
        }
        else {
            [_renrenStatusLabel setText:[ud stringForKey:@"renren_Name"]];
        }
	} else {
		[_renrenStatusLabel setText:NSLocalizedString(@"ID_LogIn_All", nil)];
	}
    
	if ([WeiboClient authorized]) {
        
        
        NSString *weiboID = [ud objectForKey:@"weibo_ID"];
        self.currentWeiboUser = [WeiboUser userWithID:weiboID inManagedObjectContext:self.managedObjectContext];
        if(self.currentWeiboUser == nil) {
            [self wbDidLogin];
        }
        else {
            // [self wbDidLogin];
            
            [_weiboStatusLabel setText:[ud stringForKey:@"weibo_Name"]];
        }
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

    
    if(![RenrenClient authorized] && ![WeiboClient authorized])
        return;
   // FriendListViewController *vc = [[FriendListViewController alloc] initWithType:RelationshipViewTypeWeiboFollowers];
    FriendListViewController *vc = [[FriendListViewController alloc] initWithType:RelationshipViewTypeRenrenFriends];
    //FriendHeadViewController *vc = [[FriendHeadViewController alloc] initWithType:RelationshipViewTypeWeiboFriends];
    vc.currentRenrenUser = self.currentRenrenUser;
    vc.currentWeiboUser  = self.currentWeiboUser;
    [self.navigationController pushViewController:vc animated:YES];
    [vc release];
     
  
    return;
    
    
    
    NewFeedListController *vc2 = [[NewFeedListController alloc] init];
    //vc.currentRenrenUser = self.currentRenrenUser;
    
    vc.toolbarItems=self.toolbarItems;
    [self.navigationController pushViewController:vc2 animated:YES];
    [vc release];

     
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
    /*  WeiboClient *weibo = [WeiboClient client];
        [weibo setCompletionBlock:^(WeiboClient *client) {
            [self wbDidLogin];
        }];
       
        [weibo authWithUsername:@"wzc345@gmail.com" password:@"5656496" autosave:YES];
    */
        
        WeiboClient *weibo = [WeiboClient client];
       // [weibo setDelegate:self];
        //[weibo oAuth:@selector(wbDidLogin) withFailedSelector:@selector(wbDidLogin)];
        [weibo authorize:nil delegate:self];

        
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

- (void)wbDidNotLogin:(BOOL)cancelled
{
    
}

-(void)finished
{

    self.currentWeiboUser = [WeiboUser insertUser:nil inManagedObjectContext:self.managedObjectContext];
    [self.managedObjectContext processPendingChanges];
}
- (void)wbDidLogin {
    NSLog(@"weibo did login");
    // get user info
    WeiboClient *weibo = [WeiboClient client];
    [weibo setCompletionBlock:^(WeiboClient *client) {
        if (!weibo.hasError) {
            NSLog(@"weibo did get user info");
            NSDictionary *dict = client.responseJSONObject;
            NSLog(@"weibo user info:%@", dict);
            NSString *weiboName = [NSString stringWithFormat:@"%@",[dict objectForKey:@"screen_name"]];
            NSString *weiboID = [NSString stringWithFormat:@"%@",[dict objectForKey:@"id"]];
            NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
            [ud setValue:weiboName forKey:@"weibo_Name"];
            [ud setValue:weiboID forKey:@"weibo_ID"];
            [ud synchronize];
            [_weiboStatusLabel setText:weiboName];

            
            self.currentWeiboUser = [WeiboUser insertUser:dict inManagedObjectContext:self.managedObjectContext];
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
            self.currentRenrenUser = [RenrenUser insertUser:dict inManagedObjectContext:self.managedObjectContext];
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
