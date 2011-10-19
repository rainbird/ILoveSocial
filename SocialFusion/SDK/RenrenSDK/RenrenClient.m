//
//  RenrenClient.m
//  SocialFusion
//
//  Created by Blue Bitch on 11-9-9.
//  Copyright 2011年 TJU. All rights reserved.
//

#import "RenrenClient.h"
#import <CommonCrypto/CommonDigest.h>

static NSString* kAuthBaseURL = @"http://graph.renren.com/oauth/authorize";
//static NSString* kDialogBaseURL = @"http://widget.renren.com/dialog/";
static NSString* kRestserverBaseURL = @"http://api.renren.com/restserver.do";
static NSString* kRRSessionKeyURL=@"http://graph.renren.com/renren_api/session_key";
static NSString* kRRSuccessURL=@"http://widget.renren.com/callback.html";
static NSString* kSDKversion=@"1.0";

static NSString* const AppKey = @"02f195588a7645db8f1862d989020d88";
static NSString* const AppID = @"150399";

//static NSString* UserID = nil;

@interface RenrenClient(Private)
- (void)authorizeWithRRAppAuth:(BOOL)tryRRAppAuth safariAuth:(BOOL)trySafariAuth permissions:(NSArray *)pm;
- (void)reportCompletion;
+ (void)delUserSessionInfo;
@end

@implementation RenrenClient

@synthesize accessToken = _accessToken,
            expirationDate = _expirationDate,
            secret = _secret,
            sessionKey = _sessionKey,
            responseJSONObject = _responseJSONObject,
            hasError = _hasError;

- (id)init
{
    self = [super init];
    if (self) {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];	
        self.accessToken = [defaults objectForKey:@"access_Token"];
        self.expirationDate = [defaults objectForKey:@"expiration_Date"];
        self.sessionKey = [defaults objectForKey:@"session_Key"];
        self.secret = [defaults objectForKey:@"secret_Key"];
    }
    
    return self;
}

- (void)dealloc {
    //NSLog(@"RenrenClient dealloc");
    [_sessionKey release];
    [_secret release];
    [_accessToken release];
 //  [self.responseJSONObject release];
   //[_responseJSONObject release];
    [_expirationDate release];
    [_rrDialog release];
    [_request release];
    [_responseJSONObject release];
    [super dealloc];
}

- (void)setCompletionBlock:(void (^)(RenrenClient* client))completionBlock {
    [_completionBlock autorelease];
    _completionBlock = [completionBlock copy];
}

- (RRCompletionBlock)completionBlock {
    return _completionBlock;
}

// 类方法 判断是否已经授权
+ (BOOL)authorized
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *accessToken = [defaults objectForKey:@"access_Token"];
    NSDate *expirationDate = [defaults objectForKey:@"expiration_Date"];
    NSString *sessionKey = [defaults objectForKey:@"session_Key"];
    //NSString *secret = [defaults objectForKey:@"secret_Key"];
    return (accessToken != nil && expirationDate != nil && sessionKey != nil
			&& NSOrderedDescending == [expirationDate compare:[NSDate date]]);
}

+ (id)client {
    //autorelease intentially ommited here
    return [[RenrenClient alloc] init];
}

+ (void)signout {
    [RenrenClient delUserSessionInfo];
}

// please modify your permissions here
- (void)authorize {
    NSArray *permissions = [[NSArray arrayWithObjects:@"read_user_feed photo_upload publish_feed status_update operate_like read_user_status read_user_status",nil] retain];
    
    NSLog(@"人人网 OAuth2.0 请求认证授权");
    if (![RenrenClient authorized]) {
        [self authorizeWithRRAppAuth:YES safariAuth:YES permissions:permissions]; 
    }
}

/**
 * A private function for opening the authorization dialog.
 * User-Agent Flow
 */
- (void)authorizeWithRRAppAuth:(BOOL)tryRRAppAuth safariAuth:(BOOL)trySafariAuth permissions:(NSArray *)pm {
    NSMutableDictionary* params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                   AppKey, @"client_id",
                                   @"token", @"response_type",
                                   kRRSuccessURL, @"redirect_uri",
                                   @"touch", @"display",
                                   nil];
    if (pm != nil) {
        NSString* scope = [pm componentsJoinedByString:@","];
        [params setValue:scope forKey:@"scope"];
    }

	[_rrDialog release];
	_rrDialog = [[RRDialog alloc] initWithURL:kAuthBaseURL params:params delegate:self];
	[_rrDialog show];
}

+ (NSString *)getSecretKeyByToken:(NSString *) token{
	NSMutableDictionary* params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
								   token, @"oauth_token",
								   nil];
	NSString *getKeyUrl = [Request serializeURL:kRRSessionKeyURL params:params];
    id result = [Request getRequestSessionKeyWithParams:getKeyUrl];
	if ([result isKindOfClass:[NSDictionary class]]) {
		NSString *secretkey=[[result objectForKey:@"renren_token"] objectForKey:@"session_secret"];
		return secretkey;
	}
	return nil;
}


+ (NSString *)getSessionKeyByToken:(NSString *) token{
	NSMutableDictionary* params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
								   token, @"oauth_token",
								   nil];
	NSString *getKeyUrl = [Request serializeURL:kRRSessionKeyURL params:params];
    id result = [Request getRequestSessionKeyWithParams:getKeyUrl];
	if ([result isKindOfClass:[NSDictionary class]]) {
		NSString* sessionkey=[[result objectForKey:@"renren_token"] objectForKey:@"session_key"];
		return sessionkey;
	}
	return nil;
}

/**
 * 保存用户用oauth登录后的信息
 */
- (void)createUserSessionInfo{
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];	
    if (self.accessToken) {
        [defaults setObject:self.accessToken forKey:@"access_Token"];
    }
	if (self.expirationDate) {
		[defaults setObject:self.expirationDate forKey:@"expiration_Date"];
	}	
    if (self.sessionKey) {
        [defaults setObject:self.sessionKey forKey:@"session_Key"];
        [defaults setObject:self.secret forKey:@"secret_Key"];
    }
    [defaults synchronize];	
}

/**
 * 删除本地保存的用户 oauth信息 
 */
+ (void)delUserSessionInfo {
	NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    [defaults removeObjectForKey:@"access_Token"];
	[defaults removeObjectForKey:@"secret_Key"];
	[defaults removeObjectForKey:@"session_Key"];
	[defaults removeObjectForKey:@"expiration_Date"];
	NSHTTPCookieStorage* cookies = [NSHTTPCookieStorage sharedHTTPCookieStorage];
	NSArray* graphCookies = [cookies cookiesForURL:
                             [NSURL URLWithString:@"http://graph.renren.com"]];
	
	for (NSHTTPCookie* cookie in graphCookies) {
		[cookies deleteCookie:cookie];
	}
	NSArray* widgetCookies = [cookies cookiesForURL:
                              [NSURL URLWithString:@"http://widget.renren.com"]];
	
	for (NSHTTPCookie* cookie in widgetCookies) {
		[cookies deleteCookie:cookie];
	}
	[defaults synchronize];
}

#pragma mark RRDialog Delegate
/*
 * 登录成功
 */

- (void)rrDialogLogin:(NSString *)token expirationDate:(NSDate *)expirationDate {
    NSLog(@"renren dialog did login");
    self.accessToken = token;
    self.expirationDate = expirationDate;
    self.secret = [RenrenClient getSecretKeyByToken:token];
    self.sessionKey = [RenrenClient getSessionKeyByToken:token];	
    //用户信息保存到本地
    [self createUserSessionInfo];
    [self reportCompletion];
    
}

- (void)rrDialogNotLogin:(BOOL)cancelled {
    NSLog(@"renren dialog did not login");
	/*if ([self.sessionDelegate respondsToSelector:@selector(rrDidNotLogin:)]) {
		[_sessionDelegate rrDidNotLogin:cancelled];
	}*/
    _hasError = YES;
    [self reportCompletion];
}

#pragma mark request
- (Request*)openUrl:(NSString *)url
             params:(NSMutableDictionary *)params
         httpMethod:(NSString *)httpMethod
           delegate:(id<RequestDelegate>)delegate {
    
    [_request release];
    _request = [[Request getRequestWithParams:params
                                   httpMethod:httpMethod
                                     delegate:delegate
                                   requestURL:url] retain];
    [_request connect];
    return _request;
}

/**
 * 解析 url 参数的function
 */
- (NSDictionary*)parseURLParams:(NSString *)query {
	NSArray *pairs = [query componentsSeparatedByString:@"&"];
	NSMutableDictionary *params = [[[NSMutableDictionary alloc] init] autorelease];
	for (NSString *pair in pairs) {
		NSArray *kv = [pair componentsSeparatedByString:@"="];
		NSString *val =[[kv objectAtIndex:1] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
		[params setObject:val forKey:[kv objectAtIndex:0]];
	}
    return params;
}

- (NSString*)md5HexDigest:(NSString*)input {
	const char* str = [input UTF8String];
	unsigned char result[CC_MD5_DIGEST_LENGTH];
	CC_MD5(str, strlen(str), result);
	
	return [NSString stringWithFormat:
			@"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
			result[0], result[1], result[2], result[3], result[4], result[5], result[6], result[7],
			result[8], result[9], result[10], result[11], result[12], result[13], result[14], result[15]
			];
}

- (NSString*)generateSig:(NSMutableDictionary*)_params {
	NSMutableString* joined = [NSMutableString string]; 
	NSArray* keys = [_params.allKeys sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];
	for (id obj in [keys objectEnumerator]) {
		id value = [_params valueForKey:obj];
		if ([value isKindOfClass:[NSString class]]) {
			[joined appendString:obj];
			[joined appendString:@"="];
			[joined appendString:value];
		}
	}
	[joined appendString:self.secret];
	return [self md5HexDigest:joined];
}

- (NSString*)generateCallId {
	return [NSString stringWithFormat:@"%.0f", [[NSDate date] timeIntervalSince1970]];
}


- (Request*)requestWithParams:(NSMutableDictionary *)params
                  andDelegate:(id <RequestDelegate>)delegate {
    
    if ([params objectForKey:@"method"] == nil) {
        NSLog(@"API Method must be specified");
        return nil;
    }
	if ([RenrenClient authorized]) {
		[params setObject:self.sessionKey forKey:@"session_key"];
    } else {
		[RenrenClient delUserSessionInfo];
		NSLog(@"session not valid");
		return nil;
	}
	
	[params setObject:[self generateCallId] forKey:@"call_id"];//增加键与值
	[params setObject:AppKey forKey:@"api_key"];	
	[params setObject:kSDKversion forKey:@"v"];
	[params setObject:@"json" forKey:@"format"];
	[params setObject:@"1" forKey:@"xn_ss"];
	
	NSString *sig=[self generateSig:params];
	[params setObject:sig forKey:@"sig"];
    
    return [self openUrl:kRestserverBaseURL
				  params:params
			  httpMethod:@"POST"
				delegate:delegate];	
}

//回调
- (void)reportCompletion
{
    /*if (_preCompletionBlock) {
        _preCompletionBlock(self);
    }*/
    //NSLog(@"block retain count:%d", [_completionBlock retainCount]);
    if (_completionBlock) {
        _completionBlock(self);
    }
}

#pragma mark Request Delegate
- (void)request:(Request *)request didLoad:(id)result {
	//NSLog(@"数据请求成功 解析数据");
	self.responseJSONObject = result;
    [self reportCompletion];
    [self autorelease];
    
}

- (void)request:(Request *)request didFailWithError:(NSError *)error {
	//NSLog(@"error localizedDescription=======================%@",[error localizedDescription]);
	NSLog(@"%@",[error localizedDescription]);
    _hasError = YES;
    [self reportCompletion];
    [self autorelease];
};

//请求好友列表
- (void)getFriendsProfile {
    NSMutableDictionary *params=[NSMutableDictionary dictionaryWithObjectsAndKeys:
								 @"friends.getFriends",@"method",
								 nil];
	[self requestWithParams:params andDelegate:self];
}

//请求用户信息
- (void)getUserInfo {
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
								 @"users.getInfo",@"method",
                                 @"uid,name,sex,birthday,email_hash,tinyurl,headurl,mainurl,hometown_location,work_history,university_history",@"fields",
								 nil];
    [self requestWithParams:params andDelegate:self];
}

//请求最近的一条状态
- (void)getLatestStatus:(NSString *)userID {
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
								 @"status.get", @"method",
                                 userID, @"owner_id",
								 nil];
	[self requestWithParams:params andDelegate:self];
}

- (void)getNewFeed:(int)pageNumber
{
    
    NSString* tempString=[[NSString alloc] initWithFormat:@"%d",pageNumber];
    NSMutableDictionary *params=[NSMutableDictionary dictionaryWithObjectsAndKeys:
                                 @"feed.get",@"method",
                                 @"10,20,21,30,32,33,34,50,51",@"type",
                                 tempString,@"page",
                                 @"30",@"count",
                                 nil];
    [tempString release];
	[self requestWithParams:params andDelegate:self];
}


-(void)getComments:(NSString*)userID status_ID:(NSString*)status pageNumber:(int)pageNumber
{
    
    NSString* tempString=[[NSString alloc] initWithFormat:@"%d",pageNumber];
    NSMutableDictionary *params=[NSMutableDictionary dictionaryWithObjectsAndKeys:
                                 @"status.getComment",@"method",
                                 status,@"status_id",
                                 userID,@"owner_id",
                                 tempString,@"page",
                                 @"1",@"order",
                                 nil];
    [tempString release];
	[self requestWithParams:params andDelegate:self];
}


@end
