//
// FPURLCache.h
//  FundPrj
//
//  Created by leesea on 13-10-22.
//  Copyright (c) 2013年 leesea. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "ASIHTTPRequest.h"
#import "ASIDownloadCache.h"


@interface FPURLCache : NSObject
{
    NSMutableDictionary *   _urlCacheMap;
    NSMutableArray *        _urlArray;
    NSUInteger              _currentSize;
}

@property (nonatomic, assign) NSUInteger memoryCapacity; // 缓存大小(单位:Byte)

// 返回用于ASIHttpRequest的disk cache
+ (ASIDownloadCache *)permanenceCache;  // 不检查是否有更新
+ (ASIDownloadCache *)lastmodifyCache;  // 检查更新，如果有更新则下载新资源


////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////


// 返回共享实例
+ (id)sharedCache;


////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////


// 从缓存中查找url对应的数据，如果没有缓存，不会去下载
// addMemoryCache:YES
// useDiskCache:YES
- (id)dataWithUrl:(NSString *)urlString;
- (UIImage *)imageWithUrl:(NSString *)urlString;

// useDiskCache:YES
- (id)dataWithUrl:(NSString *)urlString addMemoryCache:(BOOL)addMemoryCache;
- (UIImage *)imageWithUrl:(NSString *)urlString addMemoryCache:(BOOL)addMemoryCache;

- (id)dataWithUrl:(NSString *)urlString addMemoryCache:(BOOL)addMemoryCache useDiskCache:(BOOL)useDiskCache;
- (UIImage *)imageWithUrl:(NSString *)urlString addMemoryCache:(BOOL)addMemoryCache useDiskCache:(BOOL)useDiskCache;


////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////


// 自定义文件名的缓存 |data|只支持NSData和UIImage，如果addMemoryCache为YES，会同时缓存到memory cache
- (BOOL)addCacheWithName:(NSString *)name data:(id)data addMemoryCache:(BOOL)addMemoryCache;

// 通过自定义的文件名查找缓存，返回的数据可能为NSData，也可能为UIImage
- (id)dataWithName:(NSString *)name addMemoryCache:(BOOL)addMemoryCache;

// 通过自定义的文件名查找缓存，返回的数据为UIImage（磁盘上的数据为NSData，取到后将其转换为UIImage）
- (UIImage *)imageWithName:(NSString *)name addMemoryCache:(BOOL)addMemoryCache;


////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

// 从memory cache删除数据
- (void)removeCacheWithUrl:(NSString *)url;

// 添加数据到memory cache队列
- (void)addUrl:(NSString *)url toMemoryCache:(id)data;

// 清除所有cache数据
- (void)clearMemoryCache;

// 清除磁盘缓存（包括自定义文件名的磁盘缓存）
- (void)clearDiskCache;

@end
