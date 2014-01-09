//
//  ImgDownloaderIndexManager.m
//  FundPrj
//
//  Created by leesea on 13-10-22.
//  Copyright (c) 2013年 leesea. All rights reserved.
//

#import "ImgDownloaderIndexManager.h"

@interface ImgDownloaderIndexManager()
{
    NSMutableArray * offsetArray;
}

@end

@implementation ImgDownloaderIndexManager

- (id)initWithCapability:(NSInteger)capability
{
    self = [super init];
    if (self) {
        // Custom initialization
        NSInteger cap = capability;
        if (cap < 10) {
            cap = 10;
        }
        
        offsetArray = [[NSMutableArray alloc]initWithCapacity:cap];
        for (int i = 0; i < cap; ++i) {
            [offsetArray insertObject:0 atIndex:i];
        }
    }
    return self;
}

- (void)setOffsetAtIndex:(NSInteger)index offset:(NSInteger)offset
{
    [offsetArray insertObject:[NSNumber numberWithInt:offset] atIndex:index];
}

- (void)dealloc
{
    offsetArray = nil;
}

- (NSInteger)getImgIndexInDownloader:(NSInteger)sectionIdx index:(NSInteger)index
{
	NSInteger result = 0;
    for (int i = 0; i < sectionIdx; ++i) {
        result += [[offsetArray objectAtIndex:i]intValue];
    }
    result += [[offsetArray objectAtIndex:sectionIdx]intValue];
	return result;
}

- (NSInteger)getSectionIndexFromDownloaderIndex:(NSInteger)index
{
	NSInteger result = 0;
    for (int i = 0; i < offsetArray.count; ++i) {
        result += [[offsetArray objectAtIndex:i]intValue];
        if (result >= index) {
            return i;
        }
    }
    return -1;
}

- (NSInteger)getIndexFromDownloadIndex:(NSInteger)index
{
	NSInteger result = 0;
    for (int i = 0; i < offsetArray.count; ++i) {
        result += [[offsetArray objectAtIndex:i]intValue];
        if (result >= index) {
            result -= [[offsetArray objectAtIndex:i]intValue];
            return index - result;
        }
    }
    return -1;
}

@end
