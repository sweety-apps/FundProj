//
//  FPPhotoViewController.h
//  FundPrj
//
//  Created by leesea on 13-10-22.
//  Copyright (c) 2013年 leesea. All rights reserved.
//

#import <UIKit/UIKit.h>

@class VariableOrderDownloader;

@interface FPPhotoViewController : UIViewController <UIScrollViewDelegate>
{
    // UI元素
    UIView * _innerView;
    UIScrollView * _scrollView;
    
    // 数据
    VariableOrderDownloader * _varDownloader;
    NSArray * _imageUrls;
    UIStatusBarStyle _originalStatusBarStyle;
    NSUInteger _currentIndex;
    
    NSUInteger _defaultIndex;
    NSUInteger _firstDownloaderIndex;
}

- (id)initWithImageUrls:(NSArray *)imageUrls defaultIndex:(NSUInteger)defaultIndex;

- (void)presentByParent:(UIViewController *)parentController;


@end
