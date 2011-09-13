//
//  FriendProfileViewController.h
//  SocialFusion
//
//  Created by Blue Bitch on 11-8-28.
//  Copyright 2011年 TJU. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FriendProfileViewController : UIViewController<UITableViewDelegate, UITableViewDataSource> {
    NSArray *_friendsList;
    UITableView *_tablev;
    NSMutableDictionary *_friendStatus;
}

@property (nonatomic, retain) NSArray *friendsList;
@property (nonatomic, retain) UITableView *tablev;
@property (nonatomic, retain) NSMutableDictionary *friendStatus;

@property(nonatomic, retain) NSManagedObjectContext *managedObjectContext;

+ (FriendProfileViewController *)controllerWithContext:(NSManagedObjectContext *)managedObjectContext;

@end
