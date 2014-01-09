//
//  AsynImageLoader.h
//  FundPrj
//
//  Created by leesea on 13-10-22.
//  Copyright (c) 2013年 leesea. All rights reserved.
//
#import <Foundation/Foundation.h>

@class ASIDownloadCache;

@interface AsynImageLoader : NSObject
{
  @private
    ASIHTTPRequest *    _request;
}

@property (nonatomic, strong, readonly) NSURL * imageURL;
@property (nonatomic, strong) UIImage * image;

// 回调
@property (nonatomic, assign) id delegate;
@property (nonatomic, assign) SEL finishedSelector; // ex: downloadFinished;

@property (nonatomic, assign) ASIDownloadCache * downloadCache; // 磁盘缓存方式，从URLCache中取得


// 通过url初始化图片
- (id)initWithURL:(NSString *)url;

@end
