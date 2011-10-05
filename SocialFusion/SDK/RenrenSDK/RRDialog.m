#import "RRDialog.h"
#import "Renren.h"

static CGFloat kRenrenBlue[4] = {0.42578125, 0.515625, 0.703125, 1.0};
static CGFloat kBorderGray[4] = {0.3, 0.3, 0.3, 0.8};
static CGFloat kBorderBlack[4] = {0.3, 0.3, 0.3, 1};
static CGFloat kBorderBlue[4] = {0.23, 0.35, 0.6, 1.0};
static CGFloat kTransitionDuration = 0.3;
static CGFloat kPadding = 10;
static CGFloat kBorderWidth = 10;
static NSString* kWidgetURL=@"http://widget.renren.com/callback.html";
static NSString* kWidgetDialogURL=@"//widget.renren.com/dialog";

///////////////////////////////////////////////////////////////////////////////////////////////////

static BOOL RRIsDeviceIPad() {
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 30200
    
//if ([[UIDevice currentDevice]==uiinterface)
  if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
    return YES;
  }
#endif
  return NO;
}

///////////////////////////////////////////////////////////////////////////////////////////////////

@implementation RRDialog

@synthesize delegate = _delegate,
            params   = _params;

///////////////////////////////////////////////////////////////////////////////////////////////////
// private

- (void)addRoundedRectToPath:(CGContextRef)context rect:(CGRect)rect radius:(float)radius {
  CGContextBeginPath(context);
  CGContextSaveGState(context);

  if (radius == 0) {
    CGContextTranslateCTM(context, CGRectGetMinX(rect), CGRectGetMinY(rect));
    CGContextAddRect(context, rect);
  } else {
    rect = CGRectOffset(CGRectInset(rect, 0.5, 0.5), 0.5, 0.5);
    CGContextTranslateCTM(context, CGRectGetMinX(rect)-0.5, CGRectGetMinY(rect)-0.5);
    CGContextScaleCTM(context, radius, radius);
    float fw = CGRectGetWidth(rect) / radius;
    float fh = CGRectGetHeight(rect) / radius;

    CGContextMoveToPoint(context, fw, fh/2);
    CGContextAddArcToPoint(context, fw, fh, fw/2, fh, 1);
    CGContextAddArcToPoint(context, 0, fh, 0, fh/2, 1);
    CGContextAddArcToPoint(context, 0, 0, fw/2, 0, 1);
    CGContextAddArcToPoint(context, fw, 0, fw, fh/2, 1);
  }

  CGContextClosePath(context);
  CGContextRestoreGState(context);
}

- (void)drawRect:(CGRect)rect fill:(const CGFloat*)fillColors radius:(CGFloat)radius {
  CGContextRef context = UIGraphicsGetCurrentContext();
  CGColorSpaceRef space = CGColorSpaceCreateDeviceRGB();

  if (fillColors) {
    CGContextSaveGState(context);
    CGContextSetFillColor(context, fillColors);
    if (radius) {
      [self addRoundedRectToPath:context rect:rect radius:radius];
      CGContextFillPath(context);
    } else {
      CGContextFillRect(context, rect);
    }
    CGContextRestoreGState(context);
  }

  CGColorSpaceRelease(space);
}

- (void)strokeLines:(CGRect)rect stroke:(const CGFloat*)strokeColor {
  CGContextRef context = UIGraphicsGetCurrentContext();
  CGColorSpaceRef space = CGColorSpaceCreateDeviceRGB();

  CGContextSaveGState(context);
  CGContextSetStrokeColorSpace(context, space);
  CGContextSetStrokeColor(context, strokeColor);
  CGContextSetLineWidth(context, 1.0);

  {
    CGPoint points[] = {{rect.origin.x+0.5, rect.origin.y-0.5},
      {rect.origin.x+rect.size.width, rect.origin.y-0.5}};
    CGContextStrokeLineSegments(context, points, 2);
  }
  {
    CGPoint points[] = {{rect.origin.x+0.5, rect.origin.y+rect.size.height-0.5},
      {rect.origin.x+rect.size.width-0.5, rect.origin.y+rect.size.height-0.5}};
    CGContextStrokeLineSegments(context, points, 2);
  }
  {
    CGPoint points[] = {{rect.origin.x+rect.size.width-0.5, rect.origin.y},
      {rect.origin.x+rect.size.width-0.5, rect.origin.y+rect.size.height}};
    CGContextStrokeLineSegments(context, points, 2);
  }
  {
    CGPoint points[] = {{rect.origin.x+0.5, rect.origin.y},
      {rect.origin.x+0.5, rect.origin.y+rect.size.height}};
    CGContextStrokeLineSegments(context, points, 2);
  }

  CGContextRestoreGState(context);

  CGColorSpaceRelease(space);
}

- (BOOL)shouldRotateToOrientation:(UIDeviceOrientation)orientation {
  if (orientation == _orientation) {
    return NO;
  } else {
    return orientation == UIDeviceOrientationLandscapeLeft
      || orientation == UIDeviceOrientationLandscapeRight
      || orientation == UIDeviceOrientationPortrait
      || orientation == UIDeviceOrientationPortraitUpsideDown;
  }
}

- (CGAffineTransform)transformForOrientation {
  UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
  if (orientation == UIInterfaceOrientationLandscapeLeft) {
    return CGAffineTransformMakeRotation(M_PI*1.5);
  } else if (orientation == UIInterfaceOrientationLandscapeRight) {
    return CGAffineTransformMakeRotation(M_PI/2);
  } else if (orientation == UIInterfaceOrientationPortraitUpsideDown) {
    return CGAffineTransformMakeRotation(-M_PI);
  } else {
    return CGAffineTransformIdentity;
  }
}

- (void)sizeToFitOrientation:(BOOL)transform {
  if (transform) {
    self.transform = CGAffineTransformIdentity;
  }

  CGRect frame = [UIScreen mainScreen].applicationFrame;
  CGPoint center = CGPointMake(
    frame.origin.x + ceil(frame.size.width/2),
    frame.origin.y + ceil(frame.size.height/2));

  CGFloat scale_factor = 1.0f;
  if (RRIsDeviceIPad()) {
    // On the iPad the dialog's dimensions should only be 60% of the screen's
    scale_factor = 0.6f;
  }

  CGFloat width = floor(scale_factor * frame.size.width) - kPadding * 2;
  CGFloat height = floor(scale_factor * frame.size.height) - kPadding * 2;

  _orientation = [UIApplication sharedApplication].statusBarOrientation;
  if (UIInterfaceOrientationIsLandscape(_orientation)) {
    self.frame = CGRectMake(kPadding, kPadding, height, width);
  } else {
    self.frame = CGRectMake(kPadding, kPadding, width, height);
  }
  self.center = center;

  if (transform) {
    self.transform = [self transformForOrientation];
  }
}

- (void)updateWebOrientation {
  UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
  if (UIInterfaceOrientationIsLandscape(orientation)) {
    [_webView stringByEvaluatingJavaScriptFromString:
      @"document.body.setAttribute('orientation', 90);"];
  } else {
    [_webView stringByEvaluatingJavaScriptFromString:
      @"document.body.removeAttribute('orientation');"];
  }
}

- (void)bounce1AnimationStopped {
  [UIView beginAnimations:nil context:nil];
  [UIView setAnimationDuration:kTransitionDuration/2];
  [UIView setAnimationDelegate:self];
  [UIView setAnimationDidStopSelector:@selector(bounce2AnimationStopped)];
  self.transform = CGAffineTransformScale([self transformForOrientation], 0.9, 0.9);
  [UIView commitAnimations];
}

- (void)bounce2AnimationStopped {
  [UIView beginAnimations:nil context:nil];
  [UIView setAnimationDuration:kTransitionDuration/2];
  self.transform = [self transformForOrientation];
  [UIView commitAnimations];
}

- (NSURL*)generateURL:(NSString*)baseURL params:(NSDictionary*)params {
  if (params) {
    NSMutableArray* pairs = [NSMutableArray array];
    for (NSString* key in params.keyEnumerator) {
      NSString* value = [params objectForKey:key];
      NSString* escaped_value = (NSString *)CFURLCreateStringByAddingPercentEscapes(
                                  NULL, /* allocator */
                                  (CFStringRef)value,
                                  NULL, /* charactersToLeaveUnescaped */
                                  (CFStringRef)@"!*'();:@&=+$,/?%#[]",
                                  kCFStringEncodingUTF8);

      [pairs addObject:[NSString stringWithFormat:@"%@=%@", key, escaped_value]];
      [escaped_value release];
    }

    NSString* query = [pairs componentsJoinedByString:@"&"];
    NSString* url = [NSString stringWithFormat:@"%@?%@", baseURL, query];
    return [NSURL URLWithString:url];
  } else {
    return [NSURL URLWithString:baseURL];
  }
}

- (void)addObservers {
  [[NSNotificationCenter defaultCenter] addObserver:self
    selector:@selector(deviceOrientationDidChange:)
    name:@"UIDeviceOrientationDidChangeNotification" object:nil];
  [[NSNotificationCenter defaultCenter] addObserver:self
    selector:@selector(keyboardWillShow:) name:@"UIKeyboardWillShowNotification" object:nil];
  [[NSNotificationCenter defaultCenter] addObserver:self
    selector:@selector(keyboardWillHide:) name:@"UIKeyboardWillHideNotification" object:nil];
}

- (void)removeObservers {
  [[NSNotificationCenter defaultCenter] removeObserver:self
    name:@"UIDeviceOrientationDidChangeNotification" object:nil];
  [[NSNotificationCenter defaultCenter] removeObserver:self
    name:@"UIKeyboardWillShowNotification" object:nil];
  [[NSNotificationCenter defaultCenter] removeObserver:self
    name:@"UIKeyboardWillHideNotification" object:nil];
}

- (void)postDismissCleanup {
  [self removeObservers];
  [self removeFromSuperview];
  [_modalBackgroundView removeFromSuperview];
}

- (void)dismiss:(BOOL)animated {
  [self dialogWillDisappear];

  [_loadingURL release];
  _loadingURL = nil;

  if (animated) {
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:kTransitionDuration];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(postDismissCleanup)];
    self.alpha = 0;
    [UIView commitAnimations];
  } else {
    [self postDismissCleanup];
  }
}

- (void)cancel {
  [self dialogDidCancel:nil];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
// NSObject

- (id)init {
  if (self = [super initWithFrame:CGRectZero]) {
      
      
      //_webView.scalesPageToFit=YES;
      //[[[_webView subviews] lastObject] setScale:5];
      //  [[[_webView subviews] lastObject] setZoomScale:5];
    _delegate = nil;
    _loadingURL = nil;
    _orientation = UIDeviceOrientationUnknown;
    _showingKeyboard = NO;

    self.backgroundColor = [UIColor clearColor];
    self.autoresizesSubviews = YES;
    self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.contentMode = UIViewContentModeRedraw;
  
    _webView = [[UIWebView alloc] initWithFrame:CGRectMake(kPadding, kPadding, 480, 480)];
    _webView.delegate = self;
    _webView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self addSubview:_webView];

    _spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:
      UIActivityIndicatorViewStyleWhiteLarge];
    _spinner.autoresizingMask =
      UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin
      | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
    [self addSubview:_spinner];
    _modalBackgroundView = [[UIView alloc] init];
  }
  return self;
}

- (void)dealloc {
  _webView.delegate = nil;
  [_webView release];
  [_params release];
  [_serverURL release];
  [_spinner release];
  [_loadingURL release];
  [_modalBackgroundView release];
  [super dealloc];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
// UIView

- (void)drawRect:(CGRect)rect {
  CGRect grayRect = CGRectOffset(rect, -0.5, -0.5);
  [self drawRect:grayRect fill:kBorderGray radius:10];

  CGRect headerRect = CGRectMake(
    ceil(rect.origin.x + kBorderWidth), ceil(rect.origin.y + kBorderWidth),
    rect.size.width - kBorderWidth*2,0);
  [self drawRect:headerRect fill:kRenrenBlue radius:0];
  [self strokeLines:headerRect stroke:kBorderBlue];

  CGRect webRect = CGRectMake(
    ceil(rect.origin.x + kBorderWidth), headerRect.origin.y + headerRect.size.height,
    rect.size.width - kBorderWidth*2, _webView.frame.size.height+1);
  [self strokeLines:webRect stroke:kBorderBlack];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
// UIWebViewDelegate

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request
    navigationType:(UIWebViewNavigationType)navigationType {
	
    NSURL* url = request.URL;
	NSString *errorReason=nil;
	NSString *query = [url fragment];
	if (!query) {
		query = [url query];
	}
	NSDictionary *params = [self parseURLParams:query];
	NSString *accessToken = [params valueForKey:@"access_token"];
	NSString *error_desc = [params valueForKey:@"error_description"];
	errorReason = [params valueForKey:@"error"];
	if (errorReason) {
		[self errormsg:error_desc];
		[self dialogDidCancel:url];
	}
	
	NSString *q = [url absoluteString];
	NSString* isOk=[q hasPrefix:kWidgetURL]?@"yes":@"no";
	if([isOk isEqualToString:@"yes"]&&accessToken) {
		[self dialogDidSucceed:url];
	}

	if (navigationType == UIWebViewNavigationTypeLinkClicked)//点击链接  
	{
			BOOL userDidCancel = (errorReason && [errorReason isEqualToString:@"login_denied"]||[errorReason isEqualToString:@"access_denied"]);
			if(userDidCancel){
			    [self dialogDidCancel:url];
			}else {
				[[UIApplication sharedApplication] openURL:request.URL];
			}
			return NO;
	}
	
	if (navigationType==UIWebViewNavigationTypeFormSubmitted) {//提交表单
		NSString *state=[params valueForKey:@"flag"];
		if (state && [state isEqualToString:@"success"]||accessToken) {
			[self dialogDidSucceed:url];
		}
	}
    return YES;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
  [_spinner stopAnimating];
  _spinner.hidden = YES;
  [self updateWebOrientation];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
  // 102 == WebKitErrorFrameLoadInterruptedByPolicyChange
  if (!([error.domain isEqualToString:@"WebKitErrorDomain"] && error.code == 102)) {
    [self dismissWithError:error animated:YES];
  }
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
		NSString *val =
		[[kv objectAtIndex:1]
		 stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
		[params setObject:val forKey:[kv objectAtIndex:0]];
	}
	return params;
}

-(void) errormsg:(NSString*) errorReason{
	if (errorReason) {
		NSLog(@"%@",errorReason);
	}
}

///////////////////////////////////////////////////////////////////////////////////////////////////
// UIDeviceOrientationDidChangeNotification

- (void)deviceOrientationDidChange:(void*)object {
  UIDeviceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
  if (!_showingKeyboard && [self shouldRotateToOrientation:orientation]) {
    [self updateWebOrientation];

    CGFloat duration = [UIApplication sharedApplication].statusBarOrientationAnimationDuration;
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:duration];
    [self sizeToFitOrientation:YES];
    [UIView commitAnimations];
  }
}

///////////////////////////////////////////////////////////////////////////////////////////////////
// UIKeyboardNotifications

- (void)keyboardWillShow:(NSNotification*)notification {

  _showingKeyboard = YES;

  if (RRIsDeviceIPad()) {
    // On the iPad the screen is large enough that we don't need to
    // resize the dialog to accomodate the keyboard popping up
    return;
  }

  UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
  if (UIInterfaceOrientationIsLandscape(orientation)) {
    _webView.frame = CGRectInset(_webView.frame,
      -(kPadding + kBorderWidth),
      -(kPadding + kBorderWidth));
  }
}

- (void)keyboardWillHide:(NSNotification*)notification {
  _showingKeyboard = NO;

  if (RRIsDeviceIPad()) {
    return;
  }
  UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
  if (UIInterfaceOrientationIsLandscape(orientation)) {
    _webView.frame = CGRectInset(_webView.frame,
      kPadding + kBorderWidth,
      kPadding + kBorderWidth) ;
  }
}

 
- (NSString *) getStringFromUrl: (NSString*) url needle:(NSString *) needle {
  NSString * str = nil;
  NSRange start = [url rangeOfString:needle];
  if (start.location != NSNotFound) {
    NSRange end = [[url substringFromIndex:start.location+start.length] rangeOfString:@"&"];
    NSUInteger offset = start.location+start.length;
    str = end.location == NSNotFound
    ? [url substringFromIndex:offset]
    : [url substringWithRange:NSMakeRange(offset, end.location)];
    str = [str stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
  }

  return str;
}

- (id)initWithURL: (NSString *) serverURL
           params: (NSMutableDictionary *) params
         delegate: (id <RRDialogDelegate>) delegate {

  self = [self init];
  _serverURL = [serverURL retain];
  _params = [params retain];
  _delegate = delegate;

  return self;
}


- (void)load {
  [self loadURL:_serverURL get:_params];
}

- (void)loadURL:(NSString*)url get:(NSDictionary*)getParams {
  [_loadingURL release];
  _loadingURL = [[self generateURL:url params:getParams] retain];	
  NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:_loadingURL];
  [_webView loadRequest:request];
}

- (void)show {
  [self load];
  [self sizeToFitOrientation:NO];
  CGFloat innerWidth = self.frame.size.width - (kBorderWidth+1)*2;
  _webView.frame = CGRectMake(
    kBorderWidth+1,
    kBorderWidth,
    innerWidth,
    self.frame.size.height - (1 + kBorderWidth*2));

  [_spinner sizeToFit];
  [_spinner startAnimating];
  _spinner.center = _webView.center;

  UIWindow* window = [UIApplication sharedApplication].keyWindow;
  if (!window) {
    window = [[UIApplication sharedApplication].windows objectAtIndex:0];
  }

  _modalBackgroundView.frame = window.frame;
  [_modalBackgroundView addSubview:self];
  [window addSubview:_modalBackgroundView];

  [window addSubview:self];

  [self dialogWillAppear];

  self.transform = CGAffineTransformScale([self transformForOrientation], 0.001, 0.001);
  [UIView beginAnimations:nil context:nil];
  [UIView setAnimationDuration:kTransitionDuration/1.5];
  [UIView setAnimationDelegate:self];
  [UIView setAnimationDidStopSelector:@selector(bounce1AnimationStopped)];
  self.transform = CGAffineTransformScale([self transformForOrientation], 1.1, 1.1);
  [UIView commitAnimations];

  [self addObservers];
}

- (void)dismissWithSuccess:(BOOL)success animated:(BOOL)animated {
  if (success) {
    if ([_delegate respondsToSelector:@selector(dialogDidComplete:)]) {
      [_delegate dialogDidComplete:self];
    }
  } else {
    if ([_delegate respondsToSelector:@selector(dialogDidNotComplete:)]) {
      [_delegate dialogDidNotComplete:self];
    }
  }

  [self dismiss:animated];
}

- (void)dismissWithError:(NSError*)error animated:(BOOL)animated {
  if ([_delegate respondsToSelector:@selector(dialog:didFailWithError:)]) {
    [_delegate dialog:self didFailWithError:error];
  }

  [self dismiss:animated];
}

- (void)dialogWillAppear {
}

- (void)dialogWillDisappear {
}

- (void)dialogDidSucceed:(NSURL *)url {
	NSString *q = [url absoluteString];
	NSString* isOk=[url.resourceSpecifier hasPrefix:kWidgetDialogURL]?@"yes":@"no";
	if([isOk isEqualToString:@"no"]) {
	   NSString *token = [self getStringFromUrl:q needle:@"access_token="];
	   NSString *expTime = [self getStringFromUrl:q needle:@"expires_in="];
	   NSDate *expirationDate =nil;
	   if (expTime != nil) {
		  int expVal = [expTime intValue];
		  if (expVal == 0) {
			 expirationDate = [NSDate distantFuture];
		  } else {
			expirationDate = [NSDate dateWithTimeIntervalSinceNow:expVal];
		  } 
	   } 
	   if ((token == (NSString *) [NSNull null]) || (token.length == 0)) {
		  [self dialogDidCancel:url];
		  [self dismissWithSuccess:NO animated:YES];
	   } else {
		if ([_delegate respondsToSelector:@selector(rrDialogLogin:expirationDate:)]) {
			[_delegate rrDialogLogin:token expirationDate:expirationDate];
		}
		[self dismissWithSuccess:YES animated:YES];
	   }
	  }
   NSString *flag = [self getStringFromUrl:q needle:@"flag="];	
   if ([flag isEqualToString:@"success"]) {
	   NSString *query = [url fragment];
	   if (!query) {
		   query = [url query];
	   }
	   NSDictionary *params = [self parseURLParams:query];
	   if ([_delegate respondsToSelector:@selector(widgetDialogCompleteWithDict:)]) {
		   [_delegate widgetDialogCompleteWithDict:params];
	   }
   }
  if ([_delegate respondsToSelector:@selector(dialogCompleteWithUrl:)]) {
    [_delegate dialogCompleteWithUrl:url];
  }
  [self dismissWithSuccess:YES animated:YES];
}

- (void)dialogDidCancel:(NSURL *)url {
  if ([_delegate respondsToSelector:@selector(dialogDidNotCompleteWithUrl:)]) {
    [_delegate dialogDidNotCompleteWithUrl:url];
  }
  [self dismissWithSuccess:NO animated:YES];
}

@end
