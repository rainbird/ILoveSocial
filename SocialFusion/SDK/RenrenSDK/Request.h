#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol RequestDelegate;


@interface Request : NSObject {
  id<RequestDelegate> _delegate;
  NSString*             _url;
  NSString*             _httpMethod;
  NSMutableDictionary*  _params;
  NSURLConnection*      _connection;
  NSMutableData*        _responseText;
}


@property(nonatomic,assign) id<RequestDelegate> delegate;

@property(nonatomic,copy) NSString* url;

@property(nonatomic,copy) NSString* httpMethod;

@property(nonatomic,retain) NSMutableDictionary* params;

@property(nonatomic,assign) NSURLConnection*  connection;

@property(nonatomic,assign) NSMutableData* responseText;

+ (NSString*)serializeURL:(NSString *)baseUrl
                   params:(NSDictionary *)params;

+ (NSString*)serializeURL:(NSString *)baseUrl
                   params:(NSDictionary *)params
               httpMethod:(NSString *)httpMethod;

+ (id)getRequestSessionKeyWithParams:(NSString *) url;   	              	

+ (Request*)getRequestWithParams:(NSMutableDictionary *) params
                        httpMethod:(NSString *) httpMethod
                          delegate:(id<RequestDelegate>)delegate
					  requestURL:(NSString *) url;

- (NSString*)encodeString:(NSString*)actionString urlEncode:(NSStringEncoding)enc;

-(BOOL)isKindOfUIImage;

- (BOOL) loading;

- (void) connect;

@end

////////////////////////////////////////////////////////////////////////////////

/*
 *delegate
 */
@protocol RequestDelegate <NSObject>

@optional

/**
 * 请求发送给服务器之前调用。
 */
- (void)requestLoading:(Request *)request;

/**
 * 服务器回应后准备再次发送数据时调用。
 */
- (void)request:(Request *)request didReceiveResponse:(NSURLResponse *)response;

/**
 * 错误使请求无法成功时调用。
 */
- (void)request:(Request *)request didFailWithError:(NSError *)error;

/**
 * 当收到回应回应并解析为对象后应用。
 *
 * 结果对应可以是dictionary，array，string，number，依赖于API返回的数据。
 */
- (void)request:(Request *)request didLoad:(id)result;

/**
 * 请求取消的时候调用。
 */
- (void)request:(Request *)request didLoadRawResponse:(NSData *)data;

@end

