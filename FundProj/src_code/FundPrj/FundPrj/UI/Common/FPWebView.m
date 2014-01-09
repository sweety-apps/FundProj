//
// FPWebView.m
//  FundPrj
//
//  Created by leesea on 13-10-22.
//  Copyright (c) 2013年 leesea. All rights reserved.
//
// FPWebview是一个在UIWebview基础上封装的模块
//  基本包含了FPWebView的所有属性和方法，并且在此基础上加入了更加丰富的方法，委托实现等

#import "FPWebView.h"
#import <QuartzCore/QuartzCore.h>


@interface FPWebView()
{
    BOOL isFirstLoad;
    NSTimer *timer;
}

@end

@implementation FPWebView
@synthesize delegate,webview,scrollView,loadingURL,progressState,progress,isLoading;

static NSString *onloadScript;


- (id)initWithFrame:(CGRect)frame
{
    if(self = [super initWithFrame:frame])
    {
        onloadScript = [NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"onload" ofType:@"txt"] encoding:NSUTF8StringEncoding error:nil];
        self.webview = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        [self addSubview:webview];
        self.webview.delegate = self;
        
    }
    return self;
}


#pragma mark -
#pragma mark Extension Method

//获取当前网页截图
- (UIImage *)capture
{
    CGSize webViewSize = self.webview.frame.size;
    CGColorSpaceRef colorSpaceRef = CGColorSpaceCreateDeviceRGB(); 
    CGContextRef ctx = CGBitmapContextCreate(nil, webViewSize.width, webViewSize.height, 8, 4*(int)webViewSize.width, colorSpaceRef, kCGImageAlphaPremultipliedLast);
    CGContextTranslateCTM(ctx, 0.0, webViewSize.height);
    CGContextScaleCTM(ctx, 1.0, -1.0);
    
    [(CALayer*)self.webview.layer renderInContext:ctx];
    
    CGImageRef cgImage = CGBitmapContextCreateImage(ctx);
    UIImage *image = [UIImage imageWithCGImage:cgImage];
    CGImageRelease(cgImage);
    CGContextRelease(ctx);  
    
    return image;
}

//获取当前网页IOCN的地址
- (NSURL *)iconURL
{
    //get icon url from meta tag.
    NSString *iconurl = [self.webview stringByEvaluatingJavaScriptFromString:@"document.querySelector('link[rel*=shortcut]')?document.querySelector('link[rel*=shortcut]').href:''"];
    //default icon url is the favicon.icon file in root path
    if ([iconurl isEqualToString:@""]) {
        NSURL *url = [[self.webview request]URL];
        iconurl = [NSString stringWithFormat:@"%@://%@/%@",url.scheme,url.host,@"favicon.ico"];
    }

    return [NSURL URLWithString:iconurl];
}

//获取当前网页标题
- (NSString *)title
{
    return [self.webview stringByEvaluatingJavaScriptFromString:@"document.title"];
}

- (FPWebViewReadyState)readyState
{
    NSString *_readyState = [self stringByEvaluatingJavaScriptFromString:@"document.readyState"];
    if ([_readyState isEqualToString:@"uninitialized"]) {
        return FPWebViewReadyStateUninitialized;
    }
    if ([_readyState isEqualToString:@"loading"]) {
        return FPWebViewReadyStateLoading;
    }
    if ([_readyState isEqualToString:@"interactive"]) {
        return FPWebViewReadyStateInteractive;
    }
    if ([_readyState isEqualToString:@"complete"]) {
        return FPWebViewReadyStateComplete;
    }
    return FPWebViewReadyStateLoading;
}

#pragma mark -
#pragma mark UIWebview Method

- (void)goForward
{
    isFirstLoad = YES;
    [self.webview goForward];
}

- (void)goBack
{
    isFirstLoad = YES;
    [self.webview goBack];
}

- (void)reload
{
    [self.webview reload];
}

- (void)stopLoading
{
    [self.webview stopLoading];
}

- (void)loadRequest:(NSURLRequest *)request;
{
    if ([self.delegate respondsToSelector:@selector(webView:loadRequest:)]) {
        [self.delegate webView:self loadRequest:request];
    }
    isFirstLoad = YES;
    [self.webview loadRequest:request];
}

- (NSString *)stringByEvaluatingJavaScriptFromString:(NSString *)script
{
    return [self.webview stringByEvaluatingJavaScriptFromString:script];
}

- (BOOL)canGoBack
{
    return self.webview.canGoBack;
}

- (BOOL)canGoForward
{
    return self.webview.canGoForward;
}

- (BOOL)isLoading
{
    return self.webview.isLoading;
}

- (NSURLRequest *)request
{
    return self.webview.request;
}

- (UIScrollView *)scrollView
{
    return self.webview.scrollView;
}

- (void) setProgressState:(FPWebViewProgressState)aProgressState
{
    if (aProgressState <= progressState && aProgressState!= FPWebViewProgressStateInited) return;
    switch (aProgressState) {
        case FPWebViewProgressStateInited:
            self.progress = 0;
            break;
        case FPWebViewProgressStateRequested:
            self.progress = 0.2;
            if ([self.delegate respondsToSelector:@selector(webViewWillStartLoad:)]) [self.delegate webViewWillStartLoad:self];
            break;
        case FPWebViewProgressStateGetResponse:
            self.progress = 0.4;
            if ([self.delegate respondsToSelector:@selector(webViewStartLoad:)]) [self.delegate webViewStartLoad:self];
            break;
        case FPWebViewProgressStateHTMLLoaded:
            self.progress = 0.6;
            if ([self.delegate respondsToSelector:@selector(webViewDOMLoaded:)]) [self.delegate webViewDOMLoaded:self];
            break;
        case FPWebViewProgressStateLoadingResource:
            break;
        case FPWebViewProgressStateFinish:
            self.progress = 1.0;
            if ([self.delegate respondsToSelector:@selector(webViewLoaded:)]) [self.delegate webViewLoaded:self];
            break;
        default:
            break;
    } 
    progressState = aProgressState;
}

- (void) setProgress:(float)aProgress
{
    if (aProgress == 0 || aProgress > progress) {
        progress = aProgress;
        if ([self.delegate respondsToSelector:@selector(webView:updateProgress:)]){
            [self.delegate webView:self updateProgress:progress];
        }
    }
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    switch (navigationType) {
        case UIWebViewNavigationTypeBackForward:
            NSLog(@"UIWebViewNavigationTypeBackForward");//前进后退
            break;
        case UIWebViewNavigationTypeLinkClicked:
            NSLog(@"UIWebViewNavigationTypeLinkClicked");//点击链接
            break;
        case UIWebViewNavigationTypeReload:
            NSLog(@"UIWebViewNavigationTypeReload");//刷新页面
            break;
        case UIWebViewNavigationTypeFormSubmitted:
        case UIWebViewNavigationTypeFormResubmitted:
            NSLog(@"UIWebViewNavigationTypeReload");//提交表格
            break;
        case UIWebViewNavigationTypeOther:
            NSLog(@"UIWebViewjuNavigationTypeOther");//loadRequest/页面本身的加载/js导致的跳转/...
            break;
        default:
            break;
    }

    //截取加载检查模块的回调，调用各自的回调以及进度更新
    if ([request.URL.absoluteString hasPrefix:@"checkload"]) 
    {
        if ([loadingURL isEqualToString:self.webview.request.URL.absoluteString]) {
            NSLog(@"%@",request.URL.absoluteString);
            if ([request.URL.absoluteString isEqualToString:@"checkload://DOMContentLoaded"]) {
                self.progressState = FPWebViewProgressStateHTMLLoaded;
            }
            else if ([request.URL.absoluteString isEqualToString:@"checkload://startload"]) {
                self.progressState = FPWebViewProgressStateGetResponse;
            }
            else if ([request.URL.absoluteString isEqualToString:@"checkload://load"]) {
                self.progressState = FPWebViewProgressStateFinish;
            }
            else if([request.URL.absoluteString hasPrefix:@"checkload://progress:"]){
                float aProgress = [[request.URL.absoluteString substringFromIndex:21] floatValue]*0.4f+0.6f;
                self.progressState = FPWebViewProgressStateLoadingResource;
                self.progress = aProgress;
            }
        }
        return  NO;
    }
    
    //如果不等于 UIWebViewNavigationTypeOther，基本可以确认该链接是加载新页面；但loadRequest被会排除
    //还好，FPWebView的loadRequest是我们自己实现的，所有在loadRequest方法里面加入了isFirstLoad标记是识别这种情况
    if (((navigationType != UIWebViewNavigationTypeOther) &&
         (navigationType != UIWebViewNavigationTypeBackForward)) || isFirstLoad) 
    {
        if (![request.URL.absoluteString isEqualToString:@"about:blank"]) {
            loadingURL = request.URL.absoluteString;
            NSLog(@"[FPWebView] begin load URL:%@",loadingURL);
            
            self.progressState = FPWebViewProgressStateInited;
            self.progressState = FPWebViewProgressStateRequested;
            isFirstLoad = NO;
        }
    }

    //最后调用自定义的委托
    if (self.delegate && [self.delegate respondsToSelector:@selector(webView:shouldStartLoadWithRequest:navigationType:)])
    {
        return [self.delegate webView:self shouldStartLoadWithRequest:request navigationType:navigationType];
    }else{
        
        return YES;
    }
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    if(self.delegate && [self.delegate respondsToSelector:@selector(webViewDidStartLoad:)])
    {
        [[self delegate]webViewDidStartLoad:self];
    }
    //初次加载注入 加载检查模块 脚本
    NSLog(@"start: %@",[webView stringByEvaluatingJavaScriptFromString:@"document.readyState"]);
    
    NSString *checkOnloadScript = [NSString stringWithFormat:onloadScript,self.loadingURL,self.request.URL.absoluteString];
    NSString *injectResult = [webView stringByEvaluatingJavaScriptFromString:checkOnloadScript];
    
    NSLog(@"[FPWebView] Inject Result: %@",injectResult);
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    NSLog(@"finish: %@",[webView stringByEvaluatingJavaScriptFromString:@"document.readyState"]);

    NSString *checkOnloadScript = [NSString stringWithFormat:onloadScript,self.loadingURL,self.request.URL.absoluteString];
    NSString *injectResult = [webView stringByEvaluatingJavaScriptFromString:checkOnloadScript];
    
    NSLog(@"[FPWebView] Inject Result: %@",injectResult);
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(webViewDidFinishLoad:)]) 
    {
        [[self delegate]webViewDidFinishLoad:self];
    }

    [self timeoutCheck];
}

- (void) timeoutCheck
{
    NSLog(@"[FPWebView] %@",@"Timeout check.");
    NSLog(@"[FPWebView] readyState:%d",self.readyState);
    NSLog(@"[FPWebView] isloading:%@",self.isLoading?@"YES":@"NO");
    
    if (timer && [timer isValid]) {
        [timer invalidate];
    }
    timer = nil;
    
    if (![self superview]) return;//如果已经被移除了就不用检查了
    
    if (self.readyState == FPWebViewReadyStateInteractive || !self.isLoading) {
        self.progressState = FPWebViewProgressStateHTMLLoaded;
    }
    
    if (self.readyState == FPWebViewReadyStateComplete) {
        self.progressState = FPWebViewProgressStateFinish;
    }else {
        timer = [NSTimer scheduledTimerWithTimeInterval:1.0f 
                                                 target:self 
                                               selector:@selector(timeoutCheck) 
                                               userInfo:nil 
                                                repeats:NO];
    }

}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    if(self.delegate && [self.delegate respondsToSelector:@selector(webView:didFailLoadWithError:)])
    {
        [[self delegate]webView:self didFailLoadWithError:error];
    }
}

@end
