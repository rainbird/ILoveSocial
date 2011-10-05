#import "RRDialog.h"
#import "Request.h"

@protocol RRSessionDelegate;

@interface Renren: NSObject<RRDialogDelegate>{
  NSString* _accessToken;
  NSString* _secret;
  NSString* _sessionKey;
  NSDate* _expirationDate;
  NSString* _createTime;
  id<RRSessionDelegate> _sessionDelegate;
  Request* _request;
  RRDialog* _loginDialog;
  RRDialog* _rrDialog;
  NSString* _appId;
  NSString* _appKey;
  NSArray* _permissions;
}

@property(nonatomic, copy) NSString* accessToken;
@property(nonatomic,copy) NSString* secret;
@property(nonatomic, copy) NSString* sessionKey;
@property(nonatomic, copy) NSDate* expirationDate;

@property(nonatomic, assign) id<RRSessionDelegate> sessionDelegate;

- (id)initWithAppKeyAndId:(NSString *)app_key andAppId:(NSString *)app_id;

- (void)authorize:(NSArray *)permissions
         delegate:(id<RRSessionDelegate>)delegate;

- (void)logout:(id<RRSessionDelegate>)delegate;

- (Request*)requestWithParams:(NSMutableDictionary *)params
                    andDelegate:(id <RequestDelegate>)delegate;

- (void)dialog:(NSString *)action
     andParams:(NSMutableDictionary *)params
   andDelegate:(id <RRDialogDelegate>)delegate;

/**
 * 判断当前的用户登录后生命周期是否有效
 */
-(BOOL)isSessionValid;

/**
 * 删除当前用户登录状态
 */
-(void)delUserSessionInfo;

@end

 
@protocol RRSessionDelegate <NSObject>

@optional
/**
 * 用户的登录成功后，第三方开发者实现这个方法
 */
- (void)rrDidLogin;

/**
 * 用户退出后调用 第三方开发者实现这个方法
 */
- (void)rrDidLogout;

/**
 *
 */
- (void)rrDidNotLogin:(BOOL)cancelled;

@end
