//
//  FPPhotoViewController.m
//  FundPrj
//
//  Created by leesea on 13-10-22.
//  Copyright (c) 2013年 leesea. All rights reserved.
//
#import "FPPhotoViewController.h"
#import "VariableOrderDownloader.h"
#import "FPTipsManager.h"
#import "FPImageView.h"
#import "URLCache.h"


#define kAnimationDuration      0.3
#define kExtZoomScale           1.5 // 在图片原始尺寸的基础上还能放大的倍数

#define kBaseSubScrollTag       100
#define kImageViewTag           5000


@interface FPPhotoViewController ()

- (void)buildScrollView;

- (void)loadImageFinished:(NSData *)data userInfo:(id)info;

- (void)backItemPressed:(id)sender;
- (void)saveItemPressed:(id)sender;
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo;

- (void)showControlBar:(BOOL)show animated:(BOOL)animated;

- (void)setImage:(UIImage *)image forImgView:(FPImageView *)imgView;

- (void)setShowIndex:(NSUInteger)index;

- (void)handleScrollEnd;

- (void)updateControlBar;

@end


@implementation FPPhotoViewController


- (id)initWithImageUrls:(NSArray *)imageUrls defaultIndex:(NSUInteger)defaultIndex
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
        
        if (defaultIndex < _imageUrls.count)
        {
            _defaultIndex = defaultIndex;
        }
        
//        self.wantsFullScreenLayout = YES;
//        self.wantsFullScreenLayout = NO;
    }
    
    return self;
}

- (void)presentByParent:(UIViewController *)parentController
{
    UINavigationController * navCtrl = [[FPNavigationController alloc] initWithRootViewController:self];
    
//    UILabel * titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 160, 44)];
//    [titleLabel setBackgroundColor:[UIColor clearColor]];
//    [titleLabel setFont:[UIFont systemFontOfSize:18]];
//    [titleLabel setTextAlignment:UITextAlignmentCenter];
//    [titleLabel setTextColor:[UIColor whiteColor]];
//    self.navigationItem.titleView = titleLabel;
    
    [parentController presentModalViewController:navCtrl animated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // 基本属性配置
    self.navigationItem.leftBarButtonItem =
    [FPNavigationBar createBarButtonFromImg:[UIImage imageNamed:@"backBtn.png"]
                                       imgDown:[UIImage imageNamed:@"backBtnHover.png"]
                                        target:self
                                        action:@selector(backItemPressed:)];
    
    self.navigationItem.rightBarButtonItem =
    [FPNavigationBar createBarButtonForMe:@"保存"
                                     iconNor:@"保存按钮"
                                    iconDown:@"保存按钮hover"
                                      target:self
                                      action:@selector(saveItemPressed:)];
    
    self.view.backgroundColor = [UIColor blackColor];
    self.navigationController.navigationBar.barStyle = UIBarStyleBlackTranslucent;
    self.navigationController.navigationBar.tintColor = nil;
    
    // UI元素
    _innerView = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    _innerView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_innerView];
    
    _scrollView = [[UIScrollView alloc] initWithFrame:_innerView.bounds];
    _scrollView.backgroundColor = [UIColor clearColor];
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.pagingEnabled = YES;
    _scrollView.delegate = self;
    [_innerView addSubview:_scrollView];
    
    [self buildScrollView];
    [self setShowIndex:_defaultIndex];
    
    // 设置从默认显示图片的索引处开始下载图片
    _varDownloader.nextTaskIndex = _firstDownloaderIndex;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    
    _scrollView = nil;
    _innerView = nil;
}

- (void)dealloc
{
    _innerView = nil;
    _scrollView = nil;
    
    _varDownloader = nil;
    _imageUrls = nil;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    _originalStatusBarStyle = [UIApplication sharedApplication].statusBarStyle;
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackTranslucent animated:NO];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [[UIApplication sharedApplication] setStatusBarStyle:_originalStatusBarStyle animated:NO];
}

- (void)showControlBar:(BOOL)show animated:(BOOL)animated
{
	if ([[UIApplication sharedApplication] respondsToSelector:@selector(setStatusBarHidden:withAnimation:)])
    {
		[[UIApplication sharedApplication] setStatusBarHidden:!show
                                                withAnimation:(animated
                                                               ? UIStatusBarAnimationFade
                                                               : UIStatusBarAnimationNone)];
    }
    
    if (animated)
    {
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:kAnimationDuration];
    }
    
    self.navigationController.navigationBar.alpha = show ? 1 : 0;
    
    if (animated)
    {
        [UIView commitAnimations];
    }
}

- (void)buildScrollView
{
    if (nil == _varDownloader)
    {
        _varDownloader = [[VariableOrderDownloader alloc] initWithCapacity:_imageUrls.count];
        _varDownloader.delegate = self;
        _varDownloader.itemFinishedSelector = @selector(loadImageFinished:userInfo:);
        _varDownloader.maxConcurrentTaskCount = 1;
        _varDownloader.useMemoryCache = YES;
        _varDownloader.downloadCache = [FPURLCache permanenceCache];
    }
    [_varDownloader removeAllTasks];
    
    CGRect frame;
    CGFloat xoffset = 0;
    
    for (int i = 0; i < _imageUrls.count; ++i)
    {
        UIScrollView * scroll = [[UIScrollView alloc] initWithFrame:_scrollView.bounds];
        scroll.backgroundColor = [UIColor clearColor];
        scroll.showsVerticalScrollIndicator = NO;
        scroll.showsHorizontalScrollIndicator = NO;
        scroll.delegate = self;
        scroll.tag = kBaseSubScrollTag + i;
        frame = scroll.frame;
        frame.origin.x = xoffset;
        scroll.frame = frame;
        
        // 单击
        UITapGestureRecognizer * singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                     action:@selector(scrollSingleTapped:)];
        singleTap.numberOfTapsRequired = 1;
        [scroll addGestureRecognizer:singleTap];
        
        // 双击
        UITapGestureRecognizer * doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                     action:@selector(scrollDoubleTapped:)];
        doubleTap.numberOfTapsRequired = 2;
        [scroll addGestureRecognizer:doubleTap];
        [singleTap requireGestureRecognizerToFail:doubleTap];
        
        FPImageView * imgView = [[FPImageView alloc] initWithFrame:scroll.bounds];
        imgView.backgroundColor = [UIColor blackColor];
        imgView.style = FPImageViewStyleCenter;
        imgView.tag = kImageViewTag;
        
        [scroll addSubview:imgView];
        [_scrollView addSubview:scroll];
        
        // 从缓存取图片
        UIImage * image = [[FPURLCache sharedCache] imageWithUrl:[_imageUrls objectAtIndex:i]];
        if (image)
        {
            [self setImage:image forImgView:imgView];
        }
        else
        {
            // 下载图片
            [_varDownloader addTask:[NSURL URLWithStringAddingPercentEscapes:[_imageUrls objectAtIndex:i]]];
            [_varDownloader startTaskAtIndex:_varDownloader.count-1 userInfo:imgView];
            
            // 记录优先下载的index
            if (i == _defaultIndex)
            {
                _firstDownloaderIndex = _varDownloader.count-1;
            }
        }
        
        xoffset += _scrollView.bounds.size.width;
    }
    
    [_scrollView setContentSize:CGSizeMake(xoffset, _scrollView.bounds.size.height)];
}

- (void)setImage:(UIImage *)image forImgView:(FPImageView *)imgView
{
    if (!image || !imgView) {
        return;
    }
    
    imgView.image = image;
    
    // 设置最大放大比例
    UIScrollView * scroll = (UIScrollView *)imgView.superview;
    if (scroll)
    {
        scroll.maximumZoomScale = image.size.width / imgView.imageDrawRect.size.width;
        scroll.maximumZoomScale *= kExtZoomScale;
    }
}

- (void)loadImageFinished:(NSData *)data userInfo:(id)info
{
    FPImageView * imgView = info;
    
    NSInteger urlIndex = ((UIScrollView *)imgView.superview).tag - kBaseSubScrollTag;
    UIImage * image;
    
    if (urlIndex >= 0 && urlIndex < _imageUrls.count) {
        image = [[FPURLCache sharedCache] imageWithUrl:[_imageUrls objectAtIndex:urlIndex]];
    } else {
        image = [UIImage imageWithData:data];
    }
    
    [self setImage:image forImgView:imgView];
}

- (void)backItemPressed:(id)sender
{
    [self.navigationController dismissModalViewControllerAnimated:YES];
}

- (void)saveItemPressed:(id)sender
{
    NSArray * subViews = _scrollView.subviews;
    if (_currentIndex < subViews.count)
    {
        UIScrollView * scroll = [subViews objectAtIndex:_currentIndex];
        FPImageView * imgView = (FPImageView *)[scroll viewWithTag:kImageViewTag];
        if (imgView.image)
        {
            UIImageWriteToSavedPhotosAlbum(imgView.image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
        }
    }
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    if (!error) {
        [[FPTipsManager sharedManager] postSuccess:FPString(@"保存成功！")];
    } else {
        [[FPTipsManager sharedManager] postError:FPString(@"保存失败！")];
    }
}

- (void)setShowIndex:(NSUInteger)index
{
    if (index >= _imageUrls.count) {
        return;
    }
    
    CGFloat xoffset = index * _scrollView.bounds.size.width;
    [_scrollView setContentOffset:CGPointMake(xoffset, 0) animated:NO];
    
    [self handleScrollEnd];
}

- (void)updateControlBar
{
    self.navigationItem.title = [NSString stringWithFormat:@"%d / %d", _currentIndex+1, _imageUrls.count];
}


#pragma mark - UIScrollViewDelegate

- (void)scrollSingleTapped:(id)sender
{
    BOOL barShowing = (self.navigationController.navigationBar.alpha == 1);
    [self showControlBar:!barShowing animated:YES];
}

- (void)scrollDoubleTapped:(id)sender
{
    NSArray * subViews = _scrollView.subviews;
    if (_currentIndex < subViews.count)
    {
        UIScrollView * scroll = [subViews objectAtIndex:_currentIndex];
        
        if (fabsf(scroll.zoomScale-1.0) < 0.001)
        {
            [scroll setZoomScale:scroll.maximumZoomScale animated:YES];
        }
        else
        {
            [scroll setZoomScale:1.0 animated:YES];
        }
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    BOOL barShowing = (self.navigationController.navigationBar.alpha == 1);
    if (barShowing)
    {
        [self showControlBar:!barShowing animated:YES];
    }
}

- (void)handleScrollEnd
{
    _currentIndex = _scrollView.contentOffset.x / _scrollView.bounds.size.width;
    
    [self updateControlBar];
    
    // 重置图片到初始状态
    for (UIScrollView * scroll in _scrollView.subviews)
    {
        if ([scroll isKindOfClass:[UIScrollView class]])
        {
            scroll.zoomScale = 1.0;
        }
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (scrollView == _scrollView && !decelerate)
    {
        [self handleScrollEnd];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (scrollView == _scrollView)
    {
        [self handleScrollEnd];
    }
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return [scrollView.subviews objectAtIndex:0];
}


@end
