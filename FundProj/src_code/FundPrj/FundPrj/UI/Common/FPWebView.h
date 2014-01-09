//
// FPWebView.h
//  FundPrj
//
//  Created by leesea on 13-10-22.
//  Copyright (c) 2013年 leesea. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol FPWebViewDelegate;

typedef enum {
    FPWebViewReadyStateUninitialized,
    FPWebViewReadyStateLoading,
    FPWebViewReadyStateInteractive,
    FPWebViewReadyStateComplete
} FPWebViewReadyState;

typedef enum {
    FPWebViewProgressStateInited,
    FPWebViewProgressStateRequested,
    FPWebViewProgressStateGetResponse,
    FPWebViewProgressStateHTMLLoaded,
    FPWebViewProgressStateLoadingResource,
    FPWebViewProgressStateFinish
} FPWebViewProgressState;

@interface FPWebView : UIView<UIWebViewDelegate>

#pragma -
#pragma UIWebview原有的方法和属性
- (void)reload;
- (void)stopLoading;
- (void)goBack;
- (void)goForward;
- (void)loadRequest:(NSURLRequest *)request;
- (NSString *)stringByEvaluatingJavaScriptFromString:(NSString *)script;

@property(nonatomic,readonly) NSURLRequest *request;
@property(nonatomic,readonly) BOOL canGoBack;
@property(nonatomic,readonly) BOOL canGoForward;
@property(nonatomic,readonly) BOOL isLoading;
@property(nonatomic,readonly) UIScrollView *scrollView;
@property(nonatomic,assign) id<FPWebViewDelegate> delegate;
@property(nonatomic,strong) UIWebView *webview;
@property(nonatomic,readonly) NSString *loadingURL;
@property(nonatomic,readonly) FPWebViewReadyState readyState;
@property(nonatomic,readonly) FPWebViewProgressState progressState;
@property(nonatomic) float progress;


#pragma -
#pragma Extension
- (UIImage *)capture;
- (NSURL *)iconURL;
- (NSString *)title;


@end


@protocol FPWebViewDelegate <NSObject>

@optional
#pragma - Extension Delegate
- (void)webView:(FPWebView *)webView loadRequest:(NSURLRequest *)request;//调用loadRequest的时候触发
- (void)webView:(FPWebView *)webView updateProgress:(float)progress;//进度更新
- (void)webViewWillStartLoad:(FPWebView *)webView;//将要开始加载，请求还没有发出去
- (void)webViewStartLoad:(FPWebView *)webView;//请求发出去，并且已经建立新的页面环境
- (void)webViewLoaded:(FPWebView *)webView;//网页完全加载完成，包括脚本，样式表，图片所有资源
- (void)webViewDOMLoaded:(FPWebView *)webView;//网页HTML文件加载完成的时候触发，里面引用的各类资源不一定已经加载完

#pragma - Original Delegate
//Original delegate, basically identical with the UIWebviewDelegate
- (BOOL)webView:(FPWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType;
- (void)webViewDidStartLoad:(FPWebView *)webView;
- (void)webViewDidFinishLoad:(FPWebView *)webView;
- (void)webView:(FPWebView *)webView didFailLoadWithError:(NSError *)error;

@end