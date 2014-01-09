//
//  ImgDownloaderIndexManager.h
//  FundPrj
//
//  Created by leesea on 13-10-22.
//  Copyright (c) 2013年 leesea. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ImgDownloaderIndexManager : NSObject

- (id)initWithCapability:(NSInteger)capability;

- (void)setOffsetAtIndex:(NSInteger)index offset:(NSInteger)offset;

- (NSInteger)getImgIndexInDownloader:(NSInteger)sectionIdx index:(NSInteger)index;

- (NSInteger)getSectionIndexFromDownloaderIndex:(NSInteger)index;

- (NSInteger)getIndexFromDownloadIndex:(NSInteger)index;

@end
