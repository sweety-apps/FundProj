//
//  ItemPhotoController.h
//  FundPrj
//
//  Created by leesea on 13-10-22.
//  Copyright (c) 2013年 leesea. All rights reserved.
//

#import <UIKit/UIKit.h>

@class VariableOrderDownloader;

@interface ItemPhotoController : UIViewController <UIScrollViewDelegate>
{
    // 数据
    NSArray * _imageUrls; // <NSString *>
    
    BOOL _needLoop;
    VariableOrderDownloader * _varDownloader;
    CGFloat _touchBeginXoffset;
    NSInteger _showingImageIndex;
    
    // UI元素
    UIScrollView * _scrollView;
}

- (id)initWithImageUrls:(NSArray *)imageUrls;

- (NSInteger)getShowIndex;

@end
