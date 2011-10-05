#import "Renren.h"
#import "Request.h"
#import <CommonCrypto/CommonDigest.h>

static NSString* kAuthBaseURL = @"http://graph.renren.com/oauth/authorize";
static NSString* kDialogBaseURL = @"http://widget.renren.com/dialog/";
static NSString* kRestserverBaseURL = @"http://api.renren.com/restserver.do";
static NSString* kRRSessionKeyURL=@"http://graph.renren.com/renren_api/session_key";
static NSString* kRRSuccessURL=@"http://widget.renren.com/callback.html";
static NSString* kSDKversion=@"1.0";

///////////////////////////////////////////////////////////////////////////////////////////////////

@implementation Renren

@synthesize accessToken = _accessToken,
         expirationDate = _expirationDate,
        sessionDelegate = _sessionDelegate,
        secret=_secret,
        sessionKey=_sessionKey;;
        

///////////////////////////////////////////////////////////////////////////////////////////////////
// private

/**
 * Initialize the Renren object with application key.
 */
- (id)initWithAppKeyAndId:(NSString *)app_key andAppId:(NSString *)app_id {
  self = [super init];
  if (self) {
    [_appKey release];
    [_appId release];
    _appId = [app_id copy];
    _appKey = [app_key copy]; 
  }
  return self;
}

/**
 * Override NSObject : free the space
 */
- (void)dealloc {
    [super dealloc];
    [_accessToken release];
    [_expirationDate release];
    [_request release];
    [_loginDialog release];
    [_rrDialog release];
    [_appId release];
    [_appKey release];
    [_secret release];
    [_permissions release];
    [_sessionKey release];	
}

 
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
 * A private function for opening the authorization dialog.
 * User-Agent Flow
 */
- (void)authorizeWithRRAppAuth:(BOOL)tryRRAppAuth
                    safariAuth:(BOOL)trySafariAuth {
    NSMutableDictionary* params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                 _appKey, @"client_id",
                                 @"token", @"response_type",
                                 kRRSuccessURL, @"redirect_uri",
                                 @"touch", @"display",
                                 nil];
    if (_permissions != nil) {
      NSString* scope = [_permissions componentsJoinedByString:@","];
     [params setValue:scope forKey:@"scope"];
    }
	
	[_rrDialog release];
	_rrDialog = [[RRDialog alloc] initWithURL:kAuthBaseURL params:params delegate:self];
	[_rrDialog show];
}


/**
 * 
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


///////////////////////////////////////////////////////////////////////////////////////////////////
//public


/*
 * 用户oauth2登录请求认证授权
 */

- (void)authorize:(NSArray *)permissions
         delegate:(id<RRSessionDelegate>)delegate {
  NSLog(@"人人网 OAuth2.0 请求认证授权⋯⋯");
  [_permissions release];
  _permissions = permissions;
  _sessionDelegate = delegate;
  if (![self isSessionValid]) {
	 [self authorizeWithRRAppAuth:YES safariAuth:YES]; 
  }
}

/**
 * 退出用户登录
 *
 * @param delegate
 *          
 */
 
- (void)logout:(id<RRSessionDelegate>)delegate {
  _sessionDelegate = delegate;
  NSMutableDictionary * params = [[NSMutableDictionary alloc] init];
  [params release];
  [_accessToken release];
  _accessToken = nil;
  [_expirationDate release];
  _expirationDate = nil;
  [_secret release];
  _secret=nil;
  [_sessionKey release];
  _sessionKey=nil;
  [self delUserSessionInfo];
  if ([self.sessionDelegate respondsToSelector:@selector(rrDidLogout)]) {
    [_sessionDelegate rrDidLogout];
  }
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
	if ([self isSessionValid]) {
		[params setObject:self.sessionKey forKey:@"session_key"];
     }else {
		//[self delUserSessionInfo];
		NSLog(@"session not valid");
		return nil;
	}
	
	[params setObject:[self generateCallId] forKey:@"call_id"];//增加键与值
	[params setObject:_appKey forKey:@"api_key"];	
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


-(BOOL)isSessionValid{
	NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
	if (defaults) {
		self.accessToken = [defaults objectForKey:@"access_Token"];
		self.expirationDate = [defaults objectForKey:@"expiration_Date"];
		self.sessionKey = [defaults objectForKey:@"session_Key"];
		self.secret = [defaults objectForKey:@"secret_Key"];
	}
    return (self.accessToken != nil && self.expirationDate != nil&& self.sessionKey!=nil
			&& NSOrderedDescending == [self.expirationDate compare:[NSDate date]]);
}

/**
 * 保存用户用oauth登录后的信息
 */
-(void)createUserSessionInfo{
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
-(void)delUserSessionInfo{
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


- (void)dialog:(NSString *)action
     andParams:(NSMutableDictionary *)params
     andDelegate:(id <RRDialogDelegate>)delegate {
	NSString *dialogURL = [kDialogBaseURL stringByAppendingString:action];
	[params setObject:_appId forKey:@"app_id"];
	[params setObject:@"touch" forKey:@"display"];
	
	if ([params objectForKey:@"redirect_uri"] == nil) {
		[params setObject:kRRSuccessURL forKey:@"redirect_uri"];
    }
 
	if ([self isSessionValid]) {
			[params setValue:[self.accessToken stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]
					  forKey:@"access_token"];
	 }
	
	
	[_rrDialog release];
	_rrDialog = [[RRDialog alloc] initWithURL:dialogURL params:params delegate:delegate];
	[_rrDialog show];
}


/**
 * 用accesstoken 获取调用api 时用到的参数session_secret
 */

-(NSString *)getSecretKeyByToken:(NSString *) token{
	NSMutableDictionary* params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
								   token, @"oauth_token",
								   nil];
	NSString *getKeyUrl = [Request serializeURL:kRRSessionKeyURL params:params];
    id result = [Request getRequestSessionKeyWithParams:getKeyUrl];
	if ([result isKindOfClass:[NSDictionary class]]) {
		NSString* secretkey=[[result objectForKey:@"renren_token"] objectForKey:@"session_secret"];
		return secretkey;
	}
	[result release];
	[getKeyUrl release];
	[params release];
	return nil;
}


-(NSString *)getSessionKeyByToken:(NSString *) token{
	NSMutableDictionary* params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
								   token, @"oauth_token",
								   nil];
	NSString *getKeyUrl = [Request serializeURL:kRRSessionKeyURL params:params];
    id result = [Request getRequestSessionKeyWithParams:getKeyUrl];
	if ([result isKindOfClass:[NSDictionary class]]) {
		NSString* sessionkey=[[result objectForKey:@"renren_token"] objectForKey:@"session_key"];
		return sessionkey;
	}
	[result release];
	[getKeyUrl release];
	[params release];
	return nil;
}

/*
 * 登录成功
 */
 
- (void)rrDialogLogin:(NSString *)token expirationDate:(NSDate *)expirationDate {
  self.accessToken = token;
  self.expirationDate = expirationDate;
  self.secret=[self getSecretKeyByToken:token];
  self.sessionKey=[self getSessionKeyByToken:token];	
  //用户信息保存到本地
  [self createUserSessionInfo];	
  if ([self.sessionDelegate respondsToSelector:@selector(rrDidLogin)]) {  
    [_sessionDelegate rrDidLogin];
  }

}

- (void)rrDialogNotLogin:(BOOL)cancelled {
	if ([self.sessionDelegate respondsToSelector:@selector(rrDidNotLogin:)]) {
		[_sessionDelegate rrDidNotLogin:cancelled];
	}
}

/**
 * Handle the auth.ExpireSession api call failure
 */
- (void)request:(Request*)request didFailWithError:(NSError*)error{
    NSLog(@"Failed to expire the session");
}

@end
