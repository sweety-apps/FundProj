//
//  FPHttpRequest.h
//  FundPrj
//
//  Created by leesea on 13-10-22.
//  Copyright (c) 2013年 leesea. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "ASIHTTPRequestDelegate.h"


@class ASIFormDataRequest;


@interface FPHttpRequest : NSObject{
    
    ASIHTTPRequest          *_httpRequest;
    
    id                _responseJSON;
    NSString                    *_responseString;
    
    SEL                         _requestDidFinishSelector;
    SEL                         _requestDidFailedSelector;
    
    id                          _delegate;
    
    NSURL * requestUrl;
}


@property (retain, nonatomic) id responseJSON;

@property (retain, nonatomic) NSString *responseString;

@property (assign, nonatomic) SEL requestDidFinishSelector;

@property (assign, nonatomic) SEL requestDidFailedSelector;

@property (retain, nonatomic) id delegate;

@property (retain, nonatomic) NSURL * requestUrl;


- (id) initWithUrl:(NSString *)url;

- (void) sendRequest;

- (void) sendRequestWithMethod:(NSString*)method;

- (void) cancel;

- (void)customizeRequest:(ASIHTTPRequest *)request;

- (void) reset;
- (void)requestFinished:(ASIHTTPRequest *)request;

- (void)requestFailed:(ASIHTTPRequest *)request;

- (void)setPostValueAndKey:(NSString *)value key:(NSString *)key;

@end
