//
//  ItemPhotoController.m
//  FundPrj
//
//  Created by leesea on 13-10-22.
//  Copyright (c) 2013年 leesea. All rights reserved.
//

#import "ItemPhotoController.h"
#import "VariableOrderDownloader.h"
#import "URLCache.h"
#import "FPImageView.h"


// UI元素位置
#define IMAGE_OUTER_WIDTH   220
#define IMAGE_WIDTH         200
#define IMAGE_HEIGHT        300
#define IMAGE_RECT          CGRectMake(10, 0, IMAGE_WIDTH, IMAGE_HEIGHT)
#define SHADOW_WIDTH        50
#define VIEW_RECT           CGRectMake(0, 0, 320, IMAGE_HEIGHT)
#define LEFT_SHADOW_RECT    CGRectMake(0, 0, SHADOW_WIDTH, IMAGE_HEIGHT)
#define RIGHT_SHADOW_RECT   CGRectMake(290, 0, SHADOW_WIDTH, IMAGE_HEIGHT)

// 常量数据定义
#define OUT_BASE_TAG        100
#define IMAGE_TAG           1000
#define MASK_BLACK_TAG      2000
#define MASK_WHITE_TAG      3000

#define MAX_SCROLL_DISTANCE 50


@interface ItemPhotoController ()

- (void)buildScrollView;
- (void)loadImageFinished:(NSData *)data userInfo:(id)info;

- (NSInteger)getIndexWithOffset:(CGPoint)offset;

- (void)setShowAtIndex:(NSInteger)index animated:(BOOL)animated;

- (UIImageView *)getImgViewAtIndex:(NSInteger)index;

- (void)exchangeShowingIndex:(NSInteger)showingIndex
                     toAlpha:(CGFloat)showingAlpha
                   nextIndex:(NSInteger)nextIndex
                    animated:(BOOL)animated;

- (void)setImgViewAlphaAtIndex:(NSInteger)index toAlpha:(CGFloat)alpha;

@end

@implementation ItemPhotoController


- (id)initWithImageUrls:(NSArray *)imageUrls
{
    if (self = [super init])
    {
        // 转换成适合大图展示的图片url
        NSMutableArray * specifyResolutionImgUrls = [[NSMutableArray alloc] initWithCapacity:imageUrls.count];
        for (NSString * url in imageUrls)
        {
            [specifyResolutionImgUrls addObject:url];
        }
        _imageUrls = specifyResolutionImgUrls;
        
//        _needLoop = (_imageUrls.count > 2); // 超过两张图片则可以循环滑动
        _needLoop = NO;
        _showingImageIndex = 0;
    }
    
    return self;
}

- (void)dealloc
{
    _imageUrls = nil;
    _varDownloader = nil;
    
    _scrollView = nil;
}

- (void)loadView
{
    self.view = [[UIView alloc] initWithFrame:VIEW_RECT];
    self.view.backgroundColor = [UIColor clearColor];
    
    _scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    _scrollView.backgroundColor = [UIColor colorWithHexValue:0xc2c1be];
    _scrollView.pagingEnabled = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.delegate = self;
    _scrollView.bounces = NO;
    [self buildScrollView];
    [self.view addSubview:_scrollView];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    
    _scrollView = nil;
}

- (UIImageView *)getImgViewAtIndex:(NSInteger)index
{
    UIView * outView = [_scrollView viewWithTag:OUT_BASE_TAG+index];
    UIImageView * imgView = (UIImageView *)[outView viewWithTag:IMAGE_TAG];
    
    return imgView;
}

- (void)setFakeImage:(NSInteger)index image:(UIImage *)image
{
    if (!_needLoop ||
        (index < 0 && index >= (NSInteger)_imageUrls.count))
    {
        return;
    }
    
    NSInteger fakeIndex = 0;
    
    if (index == 0) {
        fakeIndex = _imageUrls.count;
    } else if (index == _imageUrls.count-1) {
        fakeIndex = -1;
    }
    
    if (fakeIndex != 0)
    {
        UIImageView * fakeImgView = [self getImgViewAtIndex:fakeIndex];
        fakeImgView.image = image;
    }
}

- (void)buildScrollView
{
    if (_varDownloader == nil)
    {
        _varDownloader = [[VariableOrderDownloader alloc] initWithCapacity:_imageUrls.count];
        _varDownloader.delegate = self;
        _varDownloader.itemFinishedSelector = @selector(loadImageFinished:userInfo:);
        _varDownloader.downloadCache = [FPURLCache permanenceCache];
    }
    [_varDownloader removeAllTasks];
    
    CGFloat xoffset = SHADOW_WIDTH;
    
    for (NSInteger i = 0; i < (NSInteger)_imageUrls.count; ++i)
    {
        UIView * outView = [[UIView alloc] initWithFrame:CGRectMake(xoffset, 0, IMAGE_OUTER_WIDTH, IMAGE_HEIGHT)];
        outView.backgroundColor = [UIColor clearColor];
        outView.tag = OUT_BASE_TAG + i;
        
        FPImageView * imgView = [[FPImageView alloc] initWithFrame:IMAGE_RECT];
        imgView.backgroundColor = [UIColor whiteColor];
        imgView.style = FPImageViewStyleCenter;
        imgView.tag = IMAGE_TAG;
        [outView addSubview:imgView];   // 先放图

        imgView.image = [UIImage imageNamed:@"列表详情加载.jpg"]; // 默认图片
        [_scrollView addSubview:outView];
        
        // 下载图片
        if (i >= 0 && i < (NSInteger)_imageUrls.count)
        {
            UIImage * image = [[FPURLCache sharedCache] imageWithUrl:[_imageUrls objectAtIndex:i]];
            if (image)
            {
                imgView.image = image;
            }
            else
            {
                [_varDownloader addTask:[NSURL URLWithStringAddingPercentEscapes:[_imageUrls objectAtIndex:i]]];
                [_varDownloader startTaskAtIndex:_varDownloader.count-1
                                        userInfo:[NSNumber numberWithInteger:i]];
            }
        }
        
        xoffset += IMAGE_OUTER_WIDTH;
    }
    
    xoffset += SHADOW_WIDTH;
    
    // 设置虚假图片
    for (NSInteger i = 0; i < (NSInteger)_imageUrls.count; ++i)
    {
        UIImage * image = [[FPURLCache sharedCache] imageWithUrl:[_imageUrls objectAtIndex:i]];
        if (image) {
            [self setFakeImage:i image:image];
        }
    }
    
    [_scrollView setContentSize:CGSizeMake(xoffset, _scrollView.bounds.size.height)];
    
    // 显示第一张图片
    [self setShowAtIndex:0 animated:NO];
}

- (void)loadImageFinished:(NSData *)data userInfo:(id)info
{
    NSInteger index = [(NSNumber *)info integerValue];
    
    if (index >= 0 && index < (NSInteger)_imageUrls.count)
    {
        UIImageView * imgView = [self getImgViewAtIndex:index];
        
        imgView.image = [[FPURLCache sharedCache] imageWithUrl:[_imageUrls objectAtIndex:index]];
        
        [self setFakeImage:index image:imgView.image];
    }
}

- (void)exchangeShowingIndex:(NSInteger)showingIndex
                     toAlpha:(CGFloat)showingAlpha
                   nextIndex:(NSInteger)nextIndex
                    animated:(BOOL)animated
{
    if (animated)
    {
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.3];
    }
    
    [self setImgViewAlphaAtIndex:showingIndex toAlpha:showingAlpha];
    [self setImgViewAlphaAtIndex:nextIndex toAlpha:1.0-showingAlpha];
    
    if (animated)
    {
        [UIView commitAnimations];
    }
    
    // 对fake对应的原始image设置同样的alpha
    NSInteger originalIndex = -1;
    if (_needLoop)
    {
        if (nextIndex == -1) {
            originalIndex = _imageUrls.count - 1;
        } else if (nextIndex == _imageUrls.count) {
            originalIndex = 0;
        }
    }
    
    if (originalIndex != -1) {
        [self setImgViewAlphaAtIndex:originalIndex toAlpha:1.0-showingAlpha];
    }
}

- (void)setImgViewAlphaAtIndex:(NSInteger)index toAlpha:(CGFloat)alpha
{
    UIView * outView = [_scrollView viewWithTag:OUT_BASE_TAG+index];
    
    UIView * mask = [outView viewWithTag:MASK_WHITE_TAG];
    mask.alpha = alpha;
    mask = [outView viewWithTag:MASK_BLACK_TAG];
    mask.alpha = 1.0-alpha;
}

- (void)setShowAtIndex:(NSInteger)index animated:(BOOL)animated
{
    if (index < 0 || index >= (NSInteger)_imageUrls.count) {
        return;
    }
    
    CGFloat xoffset = index*IMAGE_OUTER_WIDTH;
    
    [_scrollView setContentOffset:CGPointMake(xoffset, 0) animated:animated];
    
    BOOL alphaAnimated = (_showingImageIndex != index);
    
    // 动画效果
    [self exchangeShowingIndex:_showingImageIndex
                       toAlpha:0
                     nextIndex:index
                      animated:animated? alphaAnimated: NO];
    
    _showingImageIndex = index;
    
    // 将所有非显示的image设为黑色遮罩
    for (NSInteger i = -1; i < (NSInteger)_imageUrls.count+1; ++i)
    {
        if (i != _showingImageIndex)
        {
            [self setImgViewAlphaAtIndex:i toAlpha:0];
        }
    }
}

- (NSInteger)getShowIndex
{
    return [self getIndexWithOffset:_scrollView.contentOffset];
}

- (NSInteger)getIndexWithOffset:(CGPoint)offset
{
    CGFloat xoffset = offset.x;
    xoffset -= SHADOW_WIDTH;
    
    NSInteger index = (xoffset+IMAGE_OUTER_WIDTH-1) / IMAGE_OUTER_WIDTH;
//    index -= 1;
    
    index = MAX(-1, index);
    index = MIN(index, (NSInteger)_imageUrls.count);
    
    return index;
}

- (BOOL)isFakeIndexByOffset:(CGPoint)offset
{
    NSInteger index = [self getIndexWithOffset:offset];
    return (index == -1 || index == (NSInteger)_imageUrls.count);
}


#pragma mark - UIScrollViewDelegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    _touchBeginXoffset = scrollView.contentOffset.x;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat xdistance = scrollView.contentOffset.x - _touchBeginXoffset;
    NSInteger nextIndex;
    
    if (xdistance > 0) {
        nextIndex = _showingImageIndex + 1;
    } else {
        nextIndex = _showingImageIndex - 1;
    }
    
    CGFloat alpha = 1.0 - (fabsf(xdistance)/IMAGE_OUTER_WIDTH);
    if (alpha < 0) {
        alpha = 0;
    }
    
    [self exchangeShowingIndex:_showingImageIndex
                       toAlpha:alpha
                     nextIndex:nextIndex
                      animated:NO];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    scrollView.userInteractionEnabled = NO; // 滑动过程中禁止scrollview交互
    
    NSInteger xdistance = (NSInteger)scrollView.contentOffset.x - _touchBeginXoffset;
    
    if (ABS(xdistance) < MAX_SCROLL_DISTANCE)
    {
        if (xdistance == 0) {
            scrollView.userInteractionEnabled = YES;
        }
        [scrollView setContentOffset:CGPointMake(_touchBeginXoffset, 0) animated:YES];
        return;
    }
    
    xdistance = xdistance > 0? IMAGE_OUTER_WIDTH: -IMAGE_OUTER_WIDTH;
    
    if (!_needLoop &&
        [self isFakeIndexByOffset:CGPointMake(_touchBeginXoffset+xdistance, 0)])
    {
        [scrollView setContentOffset:CGPointMake(_touchBeginXoffset, 0) animated:YES];
        return;
    }
    
    [scrollView setContentOffset:CGPointMake(_touchBeginXoffset+xdistance, 0) animated:YES];
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    scrollView.userInteractionEnabled = YES; // 恢复scrollview的交互功能
    
    NSInteger index = [self getShowIndex];
    
    if (_needLoop)
    {
        if (index == -1)
        {
            index = _imageUrls.count - 1;
        }
        else if (index == _imageUrls.count)
        {
            index = 0;
        }
    }
    
    [self setShowAtIndex:index animated:NO];
}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView
{
    [scrollView setContentOffset:scrollView.contentOffset animated:NO];
}

@end
