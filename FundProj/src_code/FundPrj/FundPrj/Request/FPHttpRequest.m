//
//  FPHttpRequest.m
//  FundPrj
//
//  Created by leesea on 13-10-22.
//  Copyright (c) 2013年 leesea. All rights reserved.
//

#import "FPHttpRequest.h"
#import "SBJson.h"
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"

#define FP_DEFAULT_TIMEOUT     10
#define SINGLE_BACK_SLASH  @"\\"
#define DOUBLE_BACK_SLASH  @"\\\\"

@implementation FPHttpRequest

@synthesize responseJSON = _responseJSON;
@synthesize responseString = _responseString;
@synthesize requestDidFinishSelector = _requestDidFinishSelector;
@synthesize requestDidFailedSelector = _requestDidFailedSelector;
@synthesize delegate = _delegate;
@synthesize requestUrl = _requestUrl;


- (id) initWithUrl:(NSString *)url{
    self = [super init];
    
    if (self) {
		_requestUrl = [NSURL URLWithString:url];// stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
		_httpRequest = [ASIHTTPRequest requestWithURL:_requestUrl];
    }
	
    return self;
}



- (void) dealloc{
    self.responseJSON = nil;
    self.responseString = nil;
    self.requestUrl = nil;
	
    [self cancel];
}

- (void)setPostValueAndKey:(NSString *)value key:(NSString *)key
{
	NSLog(@"%@  %@", value,key);
//	[_httpRequest setPostValue:value forKey:key];
}

#pragma mark - send request


- (void) sendRequest{
    
    [self sendRequestWithMethod:@"GET"];
}

- (void) sendRequestWithMethod:(NSString*)method
{
    
    if (_httpRequest)
	{
		[_httpRequest setRequestMethod:method];
		[_httpRequest setDelegate:self];
        //		[_httpRequest setShouldUseRFC2616RedirectBehaviour:YES];
		[_httpRequest setDidFinishSelector:@selector(requestFinished:)];
		[_httpRequest setDidFailSelector:@selector(requestFailed:)];
		[_httpRequest startAsynchronous];
    }
}


- (void) cancel{
    [_httpRequest clearDelegatesAndCancel];
    _httpRequest = nil;
    self.delegate = nil;
}


- (void)customizeRequest:(ASIHTTPRequest *)request{
    
    [request setTimeOutSeconds:FP_DEFAULT_TIMEOUT];
    
}


- (NSString *) responseString{
    if (!_responseString && _httpRequest) {
		// 强制使用utf-８解码中文
        self.responseString = [[NSString alloc] initWithData:_httpRequest.responseData encoding:NSUTF8StringEncoding];
    }
    
    return _responseString;
}

#pragma mark - response and reset
- (id) responseJSON{
	@try {
		if (!_responseJSON && _httpRequest) {
			NSString *responseString = [self responseString];
			if (responseString){
				//            responseString = [responseString stringByReplacingOccurrencesOfString:SINGLE_BACK_SLASH withString:DOUBLE_BACK_SLASH];
				
				//NSLog(@"Receive data from TMS:\n %@", responseString);
				self.responseJSON = [responseString JSONValue];
			}
		}
		
		return _responseJSON;
	}
	@catch (NSException *exception) {
		return nil;
	}
}


- (void)responseToSelector:(SEL)selector {
    if (_delegate && [_delegate respondsToSelector:selector]) {
        [_delegate performSelectorOnMainThread:selector withObject:self waitUntilDone:[NSThread isMainThread]];
    }
}

- (void) reset{
    self.responseString = nil;
    self.responseJSON = nil;
}


#pragma mark - ASIHttpDelegate

// These are the default delegate methods for request status
// You can use different ones by setting didStartSelector / didFinishSelector / didFailSelector
- (void)requestStarted:(ASIHTTPRequest *)request
{
	return;
}
- (void)request:(ASIHTTPRequest *)request didReceiveResponseHeaders:(NSDictionary *)responseHeaders
{
	NSLog(@"%@",responseHeaders);
	return;
}
- (void)request:(ASIHTTPRequest *)request willRedirectToURL:(NSURL *)newURL
{
	NSLog(@"%@",newURL.description);
	return;
}
- (void)requestFinished:(ASIHTTPRequest *)request{
    if (_requestDidFinishSelector) {
        [self responseToSelector:_requestDidFinishSelector];
    }
    else{
        [self responseToSelector:@selector(tmsRequestSuccess:)];
    }
}


- (void)requestFailed:(ASIHTTPRequest *)request{
    if (_requestDidFinishSelector) {
        [self responseToSelector:_requestDidFailedSelector];
    }
    else{
        [self responseToSelector:@selector(tmsRequestFailed:)];
    }
}
//- (void)requestRedirected:(ASIHTTPRequest *)request;

// When a delegate implements this method, it is expected to process all incoming data itself
// This means that responseData / responseString / downloadDestinationPath etc are ignored
// You can have the request call a different method by setting didReceiveDataSelector
//- (void)request:(ASIHTTPRequest *)request didReceiveData:(NSData *)data;

// If a delegate implements one of these, it will be asked to supply credentials when none are available
// The delegate can then either restart the request ([request retryUsingSuppliedCredentials]) once credentials have been set
// or cancel it ([request cancelAuthentication])
//- (void)authenticationNeededForRequest:(ASIHTTPRequest *)request;
//- (void)proxyAuthenticationNeededForRequest:(ASIHTTPRequest *)request;


- (id)getResultData
{
	return nil;
}

@end


