//
//  VariableOrderDownloader.m
//  FundPrj
//
//  Created by leesea on 13-10-22.
//  Copyright (c) 2013年 leesea. All rights reserved.
//

#import "VariableOrderDownloader.h"
#import "ASIHTTPRequest.h"
#import "URLCache.h"

#pragma clang diagnostic ignored "-Warc-performSelector-leaks"


#define kRequestUserInfo @"RequestUserInfo"

#define kDefaultMaxConcurrentTaskCount 3
#define kDefaultCapacity 10


@interface DownloadTask : NSObject

@property (nonatomic, strong) NSURL * URL;
@property (nonatomic, strong) ASIHTTPRequest * request;
@property (nonatomic, strong) id userInfo;
@property (nonatomic, assign) BOOL canDownload;
@property (nonatomic, assign) BOOL finished;

@end


@implementation DownloadTask

@synthesize URL = _URL;
@synthesize request = _request;
@synthesize userInfo = _userInfo;
@synthesize canDownload = _canDownload;
@synthesize finished = _finished;

@end


@interface VariableOrderDownloader ()
{
    NSMutableArray * _taskArray;
}

- (void)startNextTasks;

- (void)taskRequestFinished:(ASIHTTPRequest *)request;
- (void)taskRequestFailed:(ASIHTTPRequest *)request;

@end


@implementation VariableOrderDownloader

@synthesize status = _status;

@synthesize count = _count;

@synthesize nextTaskIndex = _nextTaskIndex;
@synthesize maxConcurrentTaskCount = _maxConcurrentTaskCount;
@synthesize concurrentTaskCount = _concurrentTaskCount;

@synthesize delegate = _delegate;
@synthesize itemFinishedSelector = _itemFinishedSelector;
@synthesize itemFailedSelector = _itemFailedSelector;

@synthesize useMemoryCache = _useMemoryCache;
@synthesize downloadCache = _downloadCache;

- (id)initWithCapacity:(NSUInteger)numItems
{
    if (self = [super init])
    {
        _taskArray = [[NSMutableArray alloc] initWithCapacity:numItems];
        self.maxConcurrentTaskCount = kDefaultMaxConcurrentTaskCount;
    }
    
    return self;
}

- (id)init
{
    return [self initWithCapacity:kDefaultCapacity];
}

- (void)dealloc
{
    [self removeAllTasks];
    
    self.delegate = nil;
    self.itemFinishedSelector = nil;
    self.itemFailedSelector = nil;
}

- (void)addTask:(NSURL *)URL
{
    DownloadTask * task = [[DownloadTask alloc] init];
    task.URL = URL;
    [_taskArray addObject:task];
}

- (void)insertTask:(NSURL *)URL atIndex:(NSInteger)index
{
    DownloadTask * task = [[DownloadTask alloc] init];
    task.URL = URL;
    
    [_taskArray insertObject:task atIndex:index];
}

- (void)setNextTaskIndex:(NSUInteger)nextTaskIndex
{
    @synchronized(self)
    {
        if (nextTaskIndex >= _taskArray.count)
        {
            _nextTaskIndex = 0;
        }
        else
        {
            _nextTaskIndex = nextTaskIndex;
        }
    }
}

- (void)startTaskAtIndex:(NSUInteger)index userInfo:(id)userInfo
{
    return [self startTaskAtIndex:index userInfo:userInfo restart:NO];
}

- (void)restartTaskAtIndex:(NSUInteger)index userInfo:(id)userInfo
{
    DownloadTask * task = [_taskArray objectAtIndex:index];
	
    // 先删除内存缓存
    if (self.useMemoryCache)
    {
        [[FPURLCache sharedCache]
         removeCacheWithUrl:task.URL.absoluteString];
    }
	
	if (task.request)
	{
        if (!task.request.complete)
        {
            _concurrentTaskCount --;
        }
        
		[task.request clearDelegatesAndCancel];
		task.request = nil;
	}
	task.userInfo = nil;
	task.canDownload = NO;
	task.finished = NO;
	
    return [self startTaskAtIndex:index userInfo:userInfo restart:NO];
}

- (void)startTaskAtIndex:(NSUInteger)index userInfo:(id)userInfo restart:(BOOL)restart
{
    if (index >= _taskArray.count)
    {
        return;
    }
    
    DownloadTask * task = [_taskArray objectAtIndex:index];
    
    task.userInfo = userInfo;
    task.canDownload = YES;
    
    if (restart && task.finished && task.request.complete)
    {
        // 如果是一个已经完成的下载，则异步的方式再调用一次成功的回调（失败的情况不管）
        // 在taskRequestFinished函数中也会做相应的处理
        [task.request performSelectorInBackground:@selector(requestFinished) withObject:nil];
    }
    
    self.nextTaskIndex = index;
    [self startNextTasks];
    
    return;
}

- (id)startTaskAndReturnCacheDataAtIndex:(NSUInteger)index userInfo:(id)userInfo restart:(BOOL)restart
{
    [self startTaskAtIndex:index userInfo:userInfo restart:restart];

    if (index >= _taskArray.count)
    {
        return nil;
    }
    
    DownloadTask * task = [_taskArray objectAtIndex:index];

    return [[FPURLCache sharedCache]
            dataWithUrl:[task.request.originalURL absoluteString]
            addMemoryCache:self.useMemoryCache
            useDiskCache:NO];
}

- (void)startNextTasks
{
    NSUInteger oldNextTaskIndex = self.nextTaskIndex;
    
    while (self.concurrentTaskCount < self.maxConcurrentTaskCount)
    {
        // 在其他线程调用了暂停下载
        if (_status == DownloaderStatusPause)
        {
            return ;
        }

        DownloadTask * task = [_taskArray objectAtIndex:self.nextTaskIndex];

        // 如果还未标示可下载，或者已经开始下载了，则继续寻找下一个
        // 如果URL为nil则不允许下载
        while (!task.canDownload || task.request || !task.URL)
        {
            self.nextTaskIndex ++; // 超出会在setter中自动归零，从头开始遍历队列
            
            if (self.nextTaskIndex == oldNextTaskIndex)
            {
                // 已经全部添加到下载队列里了
                _status = DownloaderStatusDone;
                return;
            }
            
            task = [_taskArray objectAtIndex:self.nextTaskIndex];
        }
        
        task.request = [ASIHTTPRequest requestWithURL:task.URL]; // 如果URL为nil则不允许下载       
        task.request.downloadCache = self.downloadCache;
        task.request.cacheStoragePolicy = ASICachePermanentlyCacheStoragePolicy;
        task.request.delegate = self;
        task.request.didFinishSelector = @selector(taskRequestFinished:);
        task.request.didFailSelector = @selector(taskRequestFailed:);
        
        task.request.userInfo = [NSDictionary
                                 dictionaryWithObject:task
                                 forKey:kRequestUserInfo];
        
        [task.request startAsynchronous];

        // 参数重新配置
        _concurrentTaskCount ++;
        
        self.nextTaskIndex ++; // 超出会在setter中自动归零，从头开始遍历队列
        
        if (self.nextTaskIndex == oldNextTaskIndex)
        {
            // 已经全部添加到下载队列里了
            _status = DownloaderStatusDone;
            return;
        }
        
        _status = DownloaderStatusRunning;
    }
}

- (void)removeTaskAtIndex:(NSUInteger)index
{
    if (index >= _taskArray.count)
    {
        return ;
    }

    DownloadTask * task = [_taskArray objectAtIndex:index];
    if (task.request)
    {
        if (!task.request.complete)
        {
            _concurrentTaskCount --;
        }
        
        [task.request clearDelegatesAndCancel];
        task.request = nil;
    }
    
    [_taskArray removeObjectAtIndex:index];
    self.nextTaskIndex --;
}

- (void)removeAllTasks
{
    for (NSUInteger i = 0; i < _taskArray.count; ++i)
    {
        DownloadTask * task = [_taskArray objectAtIndex:i];
        if (task.request)
        {
            [task.request clearDelegatesAndCancel];
            task.request = nil;
        }
    }
    
    [_taskArray removeAllObjects];
    self.nextTaskIndex = 0;
    _concurrentTaskCount = 0;
}

- (void)pauseDownload
{
    @synchronized(self)
    {
        if (_status == DownloaderStatusRunning)
        {
            _status = DownloaderStatusPause;
        }
    }
}

- (void)continueDownload
{
    @synchronized(self)
    {
        if (_status == DownloaderStatusRunning ||
            _status == DownloaderStatusDone)
        {
            return;
        }
        
        _status = DownloaderStatusRunning;
        
        if (_taskArray.count == 0)
        {
            return;
        }
        
        [self startNextTasks];
    }    
}

- (void)taskRequestFinished:(ASIHTTPRequest *)request
{
    DownloadTask * task = [request.userInfo objectForKey:kRequestUserInfo];
    
    // 如果不是刚刚完成的任务，不做以下处理
    if (!task.finished)
    {
        _concurrentTaskCount --;
        task.finished = YES;
        
        [self startNextTasks];
    }
    
    // 先添加到内存缓存
    if (self.useMemoryCache)
    {
        [[FPURLCache sharedCache]
         addUrl:[request.originalURL absoluteString]
         toMemoryCache:request.responseData];
    }

    // 再回调
    if (self.itemFinishedSelector && [self.delegate respondsToSelector:self.itemFinishedSelector])
    {
        [self.delegate performSelector:self.itemFinishedSelector
                            withObject:request.responseData
                            withObject:task.userInfo];
    }
}

- (void)taskRequestFailed:(ASIHTTPRequest *)request
{
    DownloadTask * task = [request.userInfo objectForKey:kRequestUserInfo];

    _concurrentTaskCount --;
    [self startNextTasks];

    if (self.itemFailedSelector && [self.delegate respondsToSelector:self.itemFailedSelector])
    {
        [self.delegate performSelector:self.itemFailedSelector
                            withObject:request.error
                            withObject:task.userInfo];
    }
}

- (NSUInteger)count
{
    return _taskArray.count;
}


@end
