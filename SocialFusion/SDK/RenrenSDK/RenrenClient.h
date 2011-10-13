//
//  RenrenClient.h
//  SocialFusion
//
//  Created by Blue Bitch on 11-9-9.
//  Copyright 2011年 TJU. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RRDialog.h"
#import "Request.h"

@class RenrenClient;
typedef void (^RRCompletionBlock)(RenrenClient *client);

@interface RenrenClient : NSObject<RRDialogDelegate, RequestDelegate> {
    RRDialog *_rrDialog;
    Request* _request;
    RRCompletionBlock _completionBlock;
}

@property(nonatomic, copy) NSString *accessToken;
@property(nonatomic,copy) NSString *secret;
@property(nonatomic, copy) NSString *sessionKey;
@property(nonatomic, retain) NSDate *expirationDate;

@property (nonatomic, assign, readonly) BOOL hasError;
// NSDictionary or NSArray
@property (nonatomic, retain) id responseJSONObject;

- (void)setCompletionBlock:(void (^)(RenrenClient* client))completionBlock;
- (RRCompletionBlock)completionBlock;

+ (id)client;
// return true if user already logged in
+ (BOOL)authorized;
// authorize with renren dialog
- (void)authorize;
// logout
+ (void)signout;

- (void)getUserInfo;
- (void)getLatestStatus:(NSString *)userID;
- (void)getFriendsProfile;
- (void)getNewFeed:(int)pageNumber;
@end
