//
//  AsynImageLoader.m
//  FundPrj
//
//  Created by leesea on 13-10-22.
//  Copyright (c) 2013年 leesea. All rights reserved.
//
#import "AsynImageLoader.h"
#import "ASIHTTPRequest.h"
#import "URLCache.h"

#pragma clang diagnostic ignored "-Warc-performSelector-leaks"

@interface AsynImageLoader ()

- (void)startLoad;

- (void)imgRequestFinished:(ASIHTTPRequest *)request;
- (void)imgRequestFailed:(ASIHTTPRequest *)request;

@end


@implementation AsynImageLoader

@synthesize imageURL = _imageURL;
@synthesize image = _image;
@synthesize delegate = _delegate, finishedSelector = _finishedSelector;

@synthesize downloadCache = _downloadCache;

- (id)initWithURL:(NSString *)url
{
    if (self = [super init])
    {
        _imageURL = [NSURL URLWithStringAddingPercentEscapes:url];
        [self startLoad];
    }
    
    return self;
}

- (void)startLoad
{
    _request = [ASIHTTPRequest requestWithURL:self.imageURL];
    _request.downloadCache = self.downloadCache? self.downloadCache: [FPURLCache lastmodifyCache];
    _request.cacheStoragePolicy = ASICachePermanentlyCacheStoragePolicy;
    _request.delegate = self;
    _request.didFinishSelector = @selector(imgRequestFinished:);
    _request.didFailSelector = @selector(imgRequestFailed:);
    
    [_request startAsynchronous];
}

- (void)imgRequestFinished:(ASIHTTPRequest *)request
{
    self.image = [UIImage imageWithData:request.responseData];
    
    if (self.finishedSelector && [self.delegate respondsToSelector:self.finishedSelector])
    {
        [self.delegate performSelector:self.finishedSelector];
    }
}

- (void)imgRequestFailed:(ASIHTTPRequest *)request
{
    NSLog(@"download image failed(%@), image:(%@)", request.error, request.originalURL);
}

- (void)dealloc
{
    [_request clearDelegatesAndCancel];
    _request = nil;
}

@end
