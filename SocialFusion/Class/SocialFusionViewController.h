//
//  SocialFusionViewController.h
//  SocialFusion
//
//  Created by He Ruoyun on 11-8-8.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SocialFusionViewController : UIViewController<UIAlertViewDelegate>

@property(nonatomic, retain) NSManagedObjectContext *managedObjectContext;
@property(nonatomic, retain) UIAlertView *hasLoggedInAlertView;
@property(nonatomic, retain) IBOutlet UILabel *weiboStatusLabel;
@property(nonatomic, retain) IBOutlet UILabel *renrenStatusLabel;

- (IBAction)renrenLogIn:(id)sender;
- (IBAction)weiboLogIn:(id)sender;
- (IBAction)gotoMain:(id)sender;

@end
