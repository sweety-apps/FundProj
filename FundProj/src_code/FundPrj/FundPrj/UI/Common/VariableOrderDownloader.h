//
//  VariableOrderDownloader.h
//  FundPrj
//
//  Created by leesea on 13-10-22.
//  Copyright (c) 2013年 leesea. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "URLCache.h"

typedef enum tagDownloaderStatus {
    DownloaderStatusNotStart,
    DownloaderStatusRunning,
    DownloaderStatusPause,
    DownloaderStatusDone
} DownloaderStatus;


@class ASIDownloadCache;


@interface VariableOrderDownloader : NSObject

@property (nonatomic, assign, readonly) DownloaderStatus status;

@property (nonatomic, assign, readonly) NSUInteger count;

@property (nonatomic, assign) NSUInteger nextTaskIndex; // 可以设置从什么地方开始下载
@property (nonatomic, assign) NSUInteger maxConcurrentTaskCount; // 最大同时下载的任务数（添加到ASIHttpRequest队列的任务数，而非真实下载的任务数）
@property (nonatomic, assign, readonly) NSUInteger concurrentTaskCount; // 当前同时下载的任务数

@property (nonatomic, assign) id delegate;
@property (nonatomic, assign) SEL itemFinishedSelector; // ex. finished:(NSData *)responseData userInfo:(id)userInfo;
@property (nonatomic, assign) SEL itemFailedSelector;   // ex. failed:(NSError *)error userInfo:(id)userInfo;

@property (nonatomic, assign, getter = usingMemoryCache) BOOL useMemoryCache;  // 是否使用urlCache，默认NO

@property (nonatomic, assign) ASIDownloadCache * downloadCache; // 磁盘缓存方式，从TMURLCache中取得，默认为nil不使用缓存


// 初始化
- (id)initWithCapacity:(NSUInteger)numItems;

// 添加一个URL下载（放置队尾）
- (void)addTask:(NSURL *)URL;

// 添加一个URL下载（可插队）
- (void)insertTask:(NSURL *)URL atIndex:(NSInteger)index;

// 开始一个下载任务，并将下载调至所传入的index处（如果该任务已经下载完成，该任务不会重新下载）
- (void)startTaskAtIndex:(NSUInteger)index userInfo:(id)userInfo;

// 重新开始一个下载任务，并将下载调至所传入的index处（如果该任务已经下载完成并加入缓存，则去除缓存）
- (void)restartTaskAtIndex:(NSUInteger)index userInfo:(id)userInfo;

// 开始一个下载任务，并将下载调至所传入的index处（如果该任务已经下载完成，该任务不会重新下载，会根据restart确定是否需要重新回调）
- (void)startTaskAtIndex:(NSUInteger)index userInfo:(id)userInfo restart:(BOOL)restart;

// 功能包含startTaskAtIndex:userInfo:restart, 且返回缓存中对应的数据（如果缓存中没有对应的数据，则返回nil；数据可能为NSData，也可能为UIImage，请自行判断）
- (id)startTaskAndReturnCacheDataAtIndex:(NSUInteger)index userInfo:(id)userInfo restart:(BOOL)restart;

// 移除一个下载任务
- (void)removeTaskAtIndex:(NSUInteger)index;

// 移除所有的下载任务
- (void)removeAllTasks;

// 暂停下载（对于已经添加到下载队列的任务，不做暂停处理）
- (void)pauseDownload;

// 继续下载
- (void)continueDownload;


@end
