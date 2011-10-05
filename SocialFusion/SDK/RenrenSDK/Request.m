#import "Request.h"
#import "JSON.h"

///////////////////////////////////////////////////////////////////////////////////////////////////
// global

//static NSString* kUserAgent = @"RenrenConnect";
static NSString* kStringBoundary = @"3i2ndDfv2rTHiSisAbouNdArYfORhtTPEefj3";
static const int kGeneralErrorCode = 10000;

static const NSTimeInterval kTimeoutInterval = 60.0;

///////////////////////////////////////////////////////////////////////////////////////////////////

@implementation Request

@synthesize delegate = _delegate,
            url = _url,
            httpMethod = _httpMethod,
            params = _params,
            connection = _connection,
            responseText = _responseText;

//////////////////////////////////////////////////////////////////////////////////////////////////
// class public

+ (Request *)getRequestWithParams:(NSMutableDictionary *) params
                         httpMethod:(NSString *) httpMethod
                           delegate:(id<RequestDelegate>) delegate
                         requestURL:(NSString *) url {
  Request* request = [[[Request alloc] init] autorelease];
  request.delegate = delegate;
  request.url =url;
  request.httpMethod = httpMethod;
  request.params = params;
  request.connection = nil;
  request.responseText = nil;
  return request;
}



///////////////////////////////////////////////////////////////////////////////////////////////////
// private

+ (NSString *)serializeURL:(NSString *)baseUrl
                   params:(NSDictionary *)params {
  return [self serializeURL:baseUrl params:params httpMethod:@"GET"];
}

/**
 * Generate get URL
 */
+ (NSString*)serializeURL:(NSString *)baseUrl
                   params:(NSDictionary *)params
               httpMethod:(NSString *)httpMethod {

  NSURL* parsedURL = [NSURL URLWithString:baseUrl];
  NSString* queryPrefix = parsedURL.query ? @"&" : @"?";

  NSMutableArray* pairs = [NSMutableArray array];
  for (NSString* key in [params keyEnumerator]) {
    if (([[params valueForKey:key] isKindOfClass:[UIImage class]])
        ||([[params valueForKey:key] isKindOfClass:[NSData class]])) {
      if ([httpMethod isEqualToString:@"GET"]) {
        NSLog(@"can not use GET to upload a file");
      }
      continue;
    }

    NSString* escaped_value = (NSString *)CFURLCreateStringByAddingPercentEscapes(
                                NULL, /* allocator */
                                (CFStringRef)[params objectForKey:key],
                                NULL, /* charactersToLeaveUnescaped */
                                (CFStringRef)@"!*'();:@&=+$,/?%#[]",
                                kCFStringEncodingUTF8);

    [pairs addObject:[NSString stringWithFormat:@"%@=%@", key, escaped_value]];
    [escaped_value release];
  }
  NSString* query = [pairs componentsJoinedByString:@"&"];

  return [NSString stringWithFormat:@"%@%@%@", baseUrl, queryPrefix, query];
}
 


+ (id)getRequestSessionKeyWithParams:(NSString *) url {  
	NSURL* sessionKeyURL = [NSURL URLWithString:url];
	NSData *data=[NSData dataWithContentsOfURL:sessionKeyURL];
	NSString* responseString = [[[NSString alloc] initWithData:data
													  encoding:NSUTF8StringEncoding]
								autorelease];
	SBJSON *jsonParser = [[SBJSON new] autorelease];
	id result = [jsonParser objectWithString:responseString];
	return result;
}




/**
 * Body append for POST method
 */
- (void)utfAppendBody:(NSMutableData *)body data:(NSString *)data {
  [body appendData:[data dataUsingEncoding:NSUTF8StringEncoding]];
}


- (NSMutableData *)generatePostBody {
	NSMutableData *body = [NSMutableData data];
	NSString *endLine = [NSString stringWithFormat:@"\r\n--%@\r\n", kStringBoundary];
	NSMutableArray *pairs = [NSMutableArray array];
    if ([self isKindOfUIImage]) {
	   [body appendData:[[NSString stringWithFormat:@"--%@\r\n", kStringBoundary]
						 dataUsingEncoding:NSUTF8StringEncoding]];
	   for(NSString *key in [_params keyEnumerator]){
		   if ([key isEqualToString:@"upload"]) {
			   continue;
		   }
		   [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name = \"%@\"\r\n\r\n", key]
							 dataUsingEncoding:NSUTF8StringEncoding]];
		   [body appendData:[[_params valueForKey:key] dataUsingEncoding:NSUTF8StringEncoding]];
		   
		   [body appendData:[endLine dataUsingEncoding:NSUTF8StringEncoding]];
	   }
	   NSData *_dataParam=[_params valueForKey:@"upload"];
	   NSData* imageData = UIImagePNGRepresentation((UIImage*)_dataParam);
	   [body appendData:[[NSString
						  stringWithFormat:@"Content-Disposition: form-data; name=\"upload\";filename=no.jpg"]
						 dataUsingEncoding:NSUTF8StringEncoding]];
	   [body appendData:[endLine dataUsingEncoding:NSUTF8StringEncoding]];
	   [body appendData:[[NSString
						  stringWithString:@"Content-Type:image/jpeg\r\n\r\n"]
						 dataUsingEncoding:NSUTF8StringEncoding]];  
	   [body appendData:imageData];
	   [body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n", kStringBoundary] dataUsingEncoding:NSUTF8StringEncoding]]; 
    }else {
	   for (NSString* key  in [_params keyEnumerator]) {
		   NSString* value = [_params objectForKey:key];
		   NSString* value_str = [self encodeString:value urlEncode:NSUTF8StringEncoding];
		   [pairs addObject:[NSString stringWithFormat:@"%@=%@", key, value_str]];
	   }
	   NSString* params = [pairs componentsJoinedByString:@"&"];
	   [body appendData:[params dataUsingEncoding:NSUTF8StringEncoding]];
   }
   return body;
}

//对value进行URL编码
- (NSString*)encodeString:(NSString*)actionString urlEncode:(NSStringEncoding)enc {
	NSMutableString *escaped = [NSMutableString string];
	[escaped setString:[actionString stringByAddingPercentEscapesUsingEncoding:enc]];
	
	[escaped replaceOccurrencesOfString:@"&" withString:@"%26" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [escaped length])];
	[escaped replaceOccurrencesOfString:@"+" withString:@"%2B" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [escaped length])];
	[escaped replaceOccurrencesOfString:@"," withString:@"%2C" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [escaped length])];
	[escaped replaceOccurrencesOfString:@"/" withString:@"%2F" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [escaped length])];
	[escaped replaceOccurrencesOfString:@":" withString:@"%3A" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [escaped length])];
	[escaped replaceOccurrencesOfString:@";" withString:@"%3B" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [escaped length])];
	[escaped replaceOccurrencesOfString:@"=" withString:@"%3D" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [escaped length])];
	[escaped replaceOccurrencesOfString:@"?" withString:@"%3F" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [escaped length])];
	[escaped replaceOccurrencesOfString:@"@" withString:@"%40" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [escaped length])];
	[escaped replaceOccurrencesOfString:@" " withString:@"+" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [escaped length])];
	[escaped replaceOccurrencesOfString:@"\t" withString:@"%09" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [escaped length])];
	[escaped replaceOccurrencesOfString:@"#" withString:@"%23" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [escaped length])];
	[escaped replaceOccurrencesOfString:@"<" withString:@"%3C" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [escaped length])];
	[escaped replaceOccurrencesOfString:@">" withString:@"%3E" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [escaped length])];
	[escaped replaceOccurrencesOfString:@"\"" withString:@"%22" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [escaped length])];
	[escaped replaceOccurrencesOfString:@"\n" withString:@"%0A" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [escaped length])];
	
	return escaped;
}


/**
 * Formulate the NSError
 */
- (id)formError:(NSInteger)code userInfo:(NSDictionary *) errorData {

   return [NSError errorWithDomain:@"renrenErrDomain" code:code userInfo:errorData];

}

/**
 * 解析返回的data
 */
- (id)parseJsonResponse:(NSData *)data error:(NSError **)error {

  NSString* responseString = [[[NSString alloc] initWithData:data
                                                    encoding:NSUTF8StringEncoding]
                              autorelease];
  SBJSON *jsonParser = [[SBJSON new] autorelease];
  if ([responseString isEqualToString:@"true"]) {
    return [NSDictionary dictionaryWithObject:@"true" forKey:@"result"];
  } else if ([responseString isEqualToString:@"false"]) {
    if (error != nil) {
      *error = [self formError:kGeneralErrorCode
                      userInfo:[NSDictionary
                                dictionaryWithObject:@"This operation can not be completed"
                                forKey:@"error_msg"]];
    }
    return nil;
  }


  id result = [jsonParser objectWithString:responseString];

  if (![result isKindOfClass:[NSArray class]]) {
    if ([result objectForKey:@"error"] != nil) {
      if (error != nil) {
        *error = [self formError:kGeneralErrorCode
                        userInfo:result];
      }
      return nil;
    }

    if ([result objectForKey:@"error_code"] != nil) {
      if (error != nil) {
        *error = [self formError:[[result objectForKey:@"error_code"] intValue] userInfo:result];
      }
      return nil;
    }

    if ([result objectForKey:@"error_msg"] != nil) {
      if (error != nil) {
        *error = [self formError:kGeneralErrorCode userInfo:result];
      }
    }

    if ([result objectForKey:@"error_reason"] != nil) {
      if (error != nil) {
        *error = [self formError:kGeneralErrorCode userInfo:result];
      }
    }
  }

  return result;

}



/*
 * private helper function: call the delegate function when the request
 *                          fails with error
 */
- (void)failWithError:(NSError *)error {
  if ([_delegate respondsToSelector:@selector(request:didFailWithError:)]) {
    [_delegate request:self didFailWithError:error];
  }
}

/*
 * private helper function: handle the response data
 */
- (void)handleResponseData:(NSData *)data {
  if ([_delegate respondsToSelector:
      @selector(request:didLoadRawResponse:)]) {
    [_delegate request:self didLoadRawResponse:data];
  }

  if ([_delegate respondsToSelector:@selector(request:didLoad:)] ||
      [_delegate respondsToSelector:
          @selector(request:didFailWithError:)]) {
    NSError* error = nil;  
    id result = [self parseJsonResponse:data error:&error];
    if (error) {
      [self failWithError:error];
    } else if ([_delegate respondsToSelector:
        @selector(request:didLoad:)]) {
      [_delegate request:self didLoad:(result == nil ? data : result)];
    }

  }

}



//////////////////////////////////////////////////////////////////////////////////////////////////
// public
 
- (BOOL)loading {
  return !!_connection;
}


- (void)connect {

  if ([_delegate respondsToSelector:@selector(requestLoading:)]) {
    [_delegate requestLoading:self];
  }
	
  NSMutableURLRequest* urlRequest =
    [NSMutableURLRequest requestWithURL:[NSURL URLWithString:self.url]
                            cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
                        timeoutInterval:kTimeoutInterval];

	[urlRequest setHTTPMethod:self.httpMethod];
	if ([self isKindOfUIImage]) {
		NSString* contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", kStringBoundary];
		[urlRequest setValue:contentType forHTTPHeaderField:@"Content-Type"];
	}
	[urlRequest setHTTPBody:[self generatePostBody]];
	/*
	NSString* responseString = [[[NSString alloc] initWithData:[self generatePostBody]
													  encoding:NSUTF8StringEncoding]
								autorelease];
    NSLog(@"======：%@",responseString);
	*/
	
  _connection = [[NSURLConnection alloc] initWithRequest:urlRequest delegate:self];
}
		 
-(BOOL)isKindOfUIImage{
  NSString *iskind=nil;	
  for (NSString *key in [_params keyEnumerator]) {
	   if ([key isEqualToString:@"upload"]) {
		  iskind=key;
		  break;
	  }
	}
	return iskind!=nil;	
}


/**
 * Free internal structure
 */
- (void)dealloc {
  [_connection cancel];
  [_connection release];
  [_responseText release];
  [_url release];
  [_httpMethod release];
  [_params release];
  [super dealloc];
}

//////////////////////////////////////////////////////////////////////////////////////////////////
// NSURLConnectionDelegate

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
  _responseText = [[NSMutableData alloc] init];
  NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)response;
	
  if ([_delegate respondsToSelector:
      @selector(request:didReceiveResponse:)]) {
    [_delegate request:self didReceiveResponse:httpResponse];
  }
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
  [_responseText appendData:data];
}

- (NSCachedURLResponse *)connection:(NSURLConnection *)connection
    willCacheResponse:(NSCachedURLResponse*)cachedResponse {
  return nil;
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
  [self handleResponseData:_responseText];

  [_responseText release];
  _responseText = nil;
  [_connection release];
  _connection = nil;
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
  [self failWithError:error];

  [_responseText release];
  _responseText = nil;
  [_connection release];
  _connection = nil;
}

@end
