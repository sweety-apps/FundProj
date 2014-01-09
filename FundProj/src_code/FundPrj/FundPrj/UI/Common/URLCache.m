//
// FPURLCache.m
//  FundPrj
//
//  Created by leesea on 13-10-22.
//  Copyright (c) 2013年 leesea. All rights reserved.
//

#import "URLCache.h"
#import "UIDeviceEX.h"
#import "NSStringEX.h"
#import "ASIHTTPRequest.h"


// 常量数据定义
#define MAX_DEFAULT_MEMORY_CAPACITY_MB     (50) // 最大默认缓存50M

// 图片缓存目录
#define IMAGE_CACHE_DIR             @"ImageCaches"
#define IMAGE_CACHE_OWNED_DIR       @"Owned"


////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////


@implementation FPURLCache

@synthesize memoryCapacity = _memoryCapacity;

static FPURLCache * sharedCache = nil;


#pragma mark - Class methods

+ (ASIDownloadCache *)permanenceCache
{
    static ASIDownloadCache * permanenceCache = nil;
    
    if (permanenceCache == nil)
    {
        permanenceCache = [[ASIDownloadCache alloc] init];
        
        NSArray * paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString * documentDirectory = [paths objectAtIndex:0];
        
        [permanenceCache setStoragePath:[documentDirectory stringByAppendingPathComponent:IMAGE_CACHE_DIR]];
        [permanenceCache setDefaultCachePolicy:ASIOnlyLoadIfNotCachedCachePolicy];
    }
    
    return permanenceCache;
}

+ (ASIDownloadCache *)lastmodifyCache
{
    static ASIDownloadCache * lastmodifyCache = nil;
    
    if (lastmodifyCache == nil)
    {
        lastmodifyCache = [[ASIDownloadCache alloc] init];
        
        NSArray * paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString * documentDirectory = [paths objectAtIndex:0];
        
        [lastmodifyCache setStoragePath:[documentDirectory stringByAppendingPathComponent:IMAGE_CACHE_DIR]];
        [lastmodifyCache setDefaultCachePolicy:ASIAskServerIfModifiedCachePolicy];
    }
    
    return lastmodifyCache;
}

+ (id)allocWithZone:(NSZone *)zone
{
	@synchronized(self)
	{
		if (nil == sharedCache)
		{
			sharedCache = [super allocWithZone:zone];
			return sharedCache;
		}
	}
	
	return nil; // external invoke, reject.
}

- (void)initSelf
{
    _urlCacheMap = [[NSMutableDictionary alloc] init];
    _urlArray = [[NSMutableArray alloc] init];
    
    // 设置缓存大小：可用内存的1/5，最大不超过50M
    double availableMemoryMB = [[UIDevice currentDevice] availableMemory];
    availableMemoryMB /= 5.0;
    NSUInteger capacity = MIN(MAX_DEFAULT_MEMORY_CAPACITY_MB, (NSUInteger)availableMemoryMB);
    self.memoryCapacity = capacity*1024*1024;
}


////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////


+ (id)sharedCache
{
	@synchronized(self)
	{
        if (!sharedCache)
        {
            sharedCache = [[self alloc] init];
            [sharedCache initSelf];
        }
    }
    
    return sharedCache;
}

- (void)dealloc
{
    _urlCacheMap = nil;
    _urlArray = nil;
}


////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////


- (id)dataWithUrl:(NSString *)urlString
{
    return [self dataWithUrl:urlString addMemoryCache:YES];
}

- (UIImage *)imageWithUrl:(NSString *)urlString
{
    return [self imageWithUrl:urlString addMemoryCache:YES];
}

- (id)dataWithUrl:(NSString *)urlString addMemoryCache:(BOOL)addMemoryCache
{
    return [self dataWithUrl:urlString addMemoryCache:addMemoryCache useDiskCache:YES];
}

- (UIImage *)imageWithUrl:(NSString *)urlString addMemoryCache:(BOOL)addMemoryCache
{
    return [self imageWithUrl:urlString addMemoryCache:addMemoryCache useDiskCache:YES];
}

- (id)dataWithUrl:(NSString *)urlString addMemoryCache:(BOOL)addMemoryCache useDiskCache:(BOOL)useDiskCache
{
    if (![urlString isKindOfClass:[NSString class]] || !urlString.length) {
        return nil;
    }
    
    BOOL isDisk = NO;
    
    // 优先使用memory cache
    id returnData = [_urlCacheMap objectForKey:urlString];
    
    // 使用disk cache
    if (!returnData && useDiskCache)
    {
        // 先检查永久缓存
        returnData = [[FPURLCache permanenceCache]
                      cachedResponseDataForURL:[NSURL URLWithStringAddingPercentEscapes:urlString]];
        
        if (!returnData)
        {
            // 再检查lastmodify缓存
            returnData = [[FPURLCache lastmodifyCache]
                          cachedResponseDataForURL:[NSURL URLWithStringAddingPercentEscapes:urlString]];
        }
        
        isDisk = YES;
    }
    
    if (returnData && isDisk && addMemoryCache) {
        [self addUrl:urlString toMemoryCache:returnData];
    }
    
    return returnData;
}

- (UIImage *)imageWithUrl:(NSString *)urlString addMemoryCache:(BOOL)addMemoryCache useDiskCache:(BOOL)useDiskCache
{
    if (![urlString isKindOfClass:[NSString class]] || !urlString.length) {
        return nil;
    }
    
    id cacheData = [self dataWithUrl:urlString addMemoryCache:addMemoryCache useDiskCache:useDiskCache];
    
    if ([cacheData isKindOfClass:[UIImage class]])
    {
        return cacheData;
    }
    else if ([cacheData isKindOfClass:[NSData class]])
    {
        UIImage * image = [UIImage imageWithData:cacheData];
        
        // 如果缓存的是NSData，则将其转换为UIImage然后替换到memory cache中
        if (addMemoryCache)
        {
            [self addUrl:urlString toMemoryCache:image];
        }
        
        return image;
    }
    
    return nil;
}


////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////


- (NSUInteger)getMemorySizeWithData:(id)data
{
    if ([data isKindOfClass:[NSData class]])
    {
        return [(NSData *)data length];
    }
    else if ([data isKindOfClass:[UIImage class]])
    {
        UIImage * image = data;
        CGSize imageSize = image.size;
        CGFloat scale = 1.0;
        if ([image respondsToSelector:@selector(scale)]) {
            scale = image.scale;
        }
        
        return ((imageSize.width*scale) * (imageSize.height*scale) * 4.0);
    }
    
    return 0;
}

- (void)removeCacheWithUrl:(NSString *)url
{
	[[FPURLCache permanenceCache] removeCachedDataForURL:[NSURL URLWithStringAddingPercentEscapes:url]];
    id existData = [_urlCacheMap objectForKey:url];
    if (existData)
    {
        NSUInteger len = [self getMemorySizeWithData:existData];
        [_urlCacheMap removeObjectForKey:url];
        _currentSize -= len;
    }
}

- (void)addUrl:(NSString *)url toMemoryCache:(id)data
{
    if (![url isKindOfClass:[NSString class]] ||
        !url.length ||
        (![data isKindOfClass:[NSData class]] && ![data isKindOfClass:[UIImage class]]))
    {
        return;
    }
    
    NSUInteger dataLength = [self getMemorySizeWithData:data];
    
    id existData = [_urlCacheMap objectForKey:url];
    if (existData)
    {
        if ([existData isKindOfClass:[UIImage class]]) {
            return; // 如果已经是UIImage，就不要重新替换了
        }
        
        NSUInteger len = [self getMemorySizeWithData:existData];
        [_urlCacheMap removeObjectForKey:url];
        _currentSize -= len;
    }
    
    if (dataLength > self.memoryCapacity) {
        return;
    }
    
    while (dataLength + _currentSize > self.memoryCapacity)
    {
        NSString * lastObjectUrl = [_urlArray lastObject];
        if ([lastObjectUrl isKindOfClass:[NSString class]])
        {
            id urlData = [_urlCacheMap objectForKey:lastObjectUrl];
            [_urlCacheMap removeObjectForKey:lastObjectUrl];
            [_urlArray removeLastObject];

            _currentSize -= [self getMemorySizeWithData:urlData];
        }
    }
    
    [_urlArray insertObject:url atIndex:0];
    [_urlCacheMap setObject:data forKey:url];
    _currentSize += dataLength;
}


////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////


- (BOOL)createDir:(NSString *)path
{
    BOOL ret = YES;
    
    BOOL exist, isDir;
    exist = [[NSFileManager defaultManager] fileExistsAtPath:path isDirectory:&isDir];
    if (exist && !isDir)
    {
        ret = [[NSFileManager defaultManager] removeItemAtPath:path error:nil];
        ret = [[NSFileManager defaultManager] createDirectoryAtPath:path withIntermediateDirectories:NO attributes:nil error:nil];
    }
    else if (!exist) {
        ret = [[NSFileManager defaultManager] createDirectoryAtPath:path withIntermediateDirectories:NO attributes:nil error:nil];
    }
    
    return ret;
}

- (NSString *)imageCacheOwnedDir
{
    NSArray * paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString * path = [paths objectAtIndex:0];
    
    path = [path stringByAppendingPathComponent:IMAGE_CACHE_DIR];
    path = [path stringByAppendingPathComponent:IMAGE_CACHE_OWNED_DIR];
    
    return path;
}

- (BOOL)addCacheWithName:(NSString *)name data:(id)data addMemoryCache:(BOOL)addMemoryCache
{
    if (!name.length ||
        (![data isKindOfClass:[NSData class]] && ![data isKindOfClass:[UIImage class]]))
    {
        return NO;
    }
    
    BOOL ret = YES;

    NSArray * paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString * path = [paths objectAtIndex:0];
    
    path = [path stringByAppendingPathComponent:IMAGE_CACHE_DIR];
    ret = [self createDir:path];
    
    path = [path stringByAppendingPathComponent:IMAGE_CACHE_OWNED_DIR];
    ret = [self createDir:path];
    
    path = [path stringByAppendingPathComponent:[name md5Value]];
    
    if ([data isKindOfClass:[NSData class]])
    {
        ret = [(NSData *)data writeToFile:path atomically:YES];
    }
    else if ([data isKindOfClass:[UIImage class]])
    {
        NSData * jpegData = UIImageJPEGRepresentation((UIImage *)data, 1.0);
        ret = [jpegData writeToFile:path atomically:YES];
    }
    
    // 是否添加到memory cache
    if (addMemoryCache) {
        [self addUrl:name toMemoryCache:data];
    }
    
    return ret;
}

- (id)dataWithName:(NSString *)name addMemoryCache:(BOOL)addMemoryCache
{
    if (!name.length) {
        return nil;
    }
    
    // 先从memory cache中获取
    id retData = [_urlCacheMap objectForKey:name];
    if (retData) {
        return retData;
    }
    
    NSString * path = [self imageCacheOwnedDir];
    path = [path stringByAppendingPathComponent:[name md5Value]];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:path]) {
        return nil;
    }
    
    retData = [NSData dataWithContentsOfFile:path];
    
    if (retData && addMemoryCache) {
        [self addUrl:name toMemoryCache:retData];
    }
    
    return retData;
}

- (UIImage *)imageWithName:(NSString *)name addMemoryCache:(BOOL)addMemoryCache
{
    id cacheData = [self dataWithName:name addMemoryCache:addMemoryCache];
    
    if ([cacheData isKindOfClass:[UIImage class]])
    {
        return cacheData;
    }
    else if ([cacheData isKindOfClass:[NSData class]])
    {
        UIImage * image = [UIImage imageWithData:cacheData];
        
        // 如果缓存的是NSData，则将其转换为UIImage然后替换到memory cache中
        if (image && addMemoryCache) {
            [self addUrl:name toMemoryCache:image];
        }
        
        return image;
    }
    
    return nil;
}


////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////


- (void)clearMemoryCache
{
    [_urlCacheMap removeAllObjects];
    [_urlArray removeAllObjects];
    _currentSize = 0;
}

- (void)clearDiskCache
{
    // 永久缓存
    [[FPURLCache permanenceCache] clearCachedResponsesForStoragePolicy:ASICachePermanentlyCacheStoragePolicy];

    // lastmodiry缓存
    [[FPURLCache lastmodifyCache] clearCachedResponsesForStoragePolicy:ASICachePermanentlyCacheStoragePolicy];
    
    // 自定义文件名的缓存
    NSString * path = [self imageCacheOwnedDir];
    [[NSFileManager defaultManager] removeItemAtPath:path error:nil];
}


@end
