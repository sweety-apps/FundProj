//
// FPNavigationBar.h
//  FundPrj
//
//  Created by leesea on 13-10-22.
//  Copyright (c) 2013年 leesea. All rights reserved.
//

#import "FPNavigationController.h"
#import "NSStringEX.h"


NSString * const FPNavigationPoppedNotification = @"FPNavigationPoppedNotification";

#pragma mark - FPNavigationBar
@implementation FPNavigationBar

@synthesize backgroundImage = _backgroundImage;


+ (void)adjustBarItemWidth:(UIBarButtonItem*)item
{
    UIButton* btn = (UIButton*)item.customView;
    NSString* title = btn.titleLabel.text;
    
    CGSize titleSize = [title sizeWithFont:[UIFont systemFontOfSize:18]];
    
    CGFloat fIconWidth = 0;
    if (btn.imageView.image)
    {
        fIconWidth = 31-16;
    }
    
    CGFloat fBtnWidth = fIconWidth 
        + titleSize.width 
        + (btn.imageView.image?20:((150/titleSize.width)*8/2));
    
    if (fBtnWidth > 150)
    {
        fBtnWidth = 150;
        
        btn.titleLabel.numberOfLines = 1;
        btn.titleLabel.adjustsFontSizeToFitWidth = YES;
        if (btn.imageView.image)
        {
            [btn setImageEdgeInsets:UIEdgeInsetsMake(8, 12, 8, fBtnWidth-12-fIconWidth)];
            [btn setTitleEdgeInsets:UIEdgeInsetsMake(0, -5, 0, 3)];
        }
        else
        {
            [btn setTitleEdgeInsets:UIEdgeInsetsMake(0, 8, 0, 8)];
        }
    }
    else
    {
        btn.titleLabel.numberOfLines = 1;
        if (btn.imageView.image)
        {
            [btn setImageEdgeInsets:UIEdgeInsetsMake(8, 8, 8, titleSize.width+12)];
            [btn setTitleEdgeInsets:UIEdgeInsetsMake(0, -6, 0, 6)];
        }
    }
    
    CGRect rect = btn.frame;
    rect.size.width = fBtnWidth;
    btn.frame = rect;
}

+ (UIBarButtonItem *)createBarButtonForMe:(NSString*)title 
                                  iconNor:(NSString*)iconNor
                                 iconDown:(NSString*)iconDown
                                   target:(id)target 
                                   action:(SEL)selector
{
    if (title == nil || [title isEqualToString:@""]) 
    {
        return nil;
    }
    
    UIButton* btn = [[UIButton alloc] initWithFrame:CGRectZero];
    [btn setTitle:title forState:UIControlStateNormal];
    
    UIImage * imgBtnNormal, * imgBtnDown;
    
    if (iconNor) {
        imgBtnNormal = [UIImage imageNamed:iconNor];
    }
    
    
    if (iconDown) {
        imgBtnDown = [UIImage imageNamed:iconDown];
    }
    
    CGRect frame = CGRectZero;
    frame.size = imgBtnNormal.size;
    btn.frame = frame;
    [btn setBackgroundImage:imgBtnNormal forState:UIControlStateNormal];
    [btn setBackgroundImage:imgBtnDown forState:UIControlStateHighlighted];
    
    CGSize  titleSize = [title sizeWithFont:btn.titleLabel.font];//如果title宽度超过width处理一下
    if(titleSize.width > frame.size.width)
    {
        frame.size.width = titleSize.width;
        btn.frame = frame;
    }
    
    [btn addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
    
    [btn setTitleColor:[UIColor colorWithHexValue:0xffffff] forState:UIControlStateNormal];
    [btn.titleLabel setFont:[UIFont systemFontOfSize:16]];
//    [btn.titleLabel setShadowColor:[UIColor colorWithHexValue:0x770000]];
//    [btn.titleLabel setShadowOffset:CGSizeMake(-0.5, -0.866)];
    
    UIBarButtonItem* item = [[UIBarButtonItem alloc] initWithCustomView:btn];
    
    //[self adjustBarItemWidth:item];
    
    return item;
}

+ (UIBarButtonItem *)createBarButton:(NSString*)title
                                  iconNor:(NSString*)iconNor
                                 iconDown:(NSString*)iconDown
                                   target:(id)target
                                   action:(SEL)selector
{
    if (title == nil || [title isEqualToString:@""])
    {
        return nil;
    }
    
    UIButton* btn = [[UIButton alloc] initWithFrame:CGRectZero];
    [btn setTitle:title forState:UIControlStateNormal];
    
    UIImage * imgBtnNormal, * imgBtnDown;
    
    if (iconNor) {
        imgBtnNormal = [UIImage imageNamed:iconNor];
    }
    
    
    if (iconDown) {
        imgBtnDown = [UIImage imageNamed:iconDown];
    }
    
    CGRect frame = CGRectZero;
    frame.size = imgBtnNormal.size;
    btn.frame = frame;
    [btn setImage:imgBtnNormal forState:UIControlStateNormal];
    if (iconDown) {
        [btn setImage:imgBtnDown forState:UIControlStateHighlighted];
    }    
    CGSize  titleSize = [title sizeWithFont:btn.titleLabel.font];//如果title宽度超过width处理一下
    if(titleSize.width + imgBtnNormal.size.width > frame.size.width)
    {
        frame.size.width = titleSize.width + imgBtnNormal.size.width;
        btn.frame = frame;
    }
    
    [btn addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
    
    [btn setTitleColor:[UIColor colorWithHexValue:0xffffff] forState:UIControlStateNormal];
    [btn.titleLabel setFont:[UIFont systemFontOfSize:16]];
    //    [btn.titleLabel setShadowColor:[UIColor colorWithHexValue:0x770000]];
    //    [btn.titleLabel setShadowOffset:CGSizeMake(-0.5, -0.866)];
    [btn setTitleEdgeInsets:UIEdgeInsetsMake(0, -imgBtnNormal.size.width/2, 0.0, 0.0)];
    [btn setImageEdgeInsets:UIEdgeInsetsMake(0.0, -btn.titleLabel.bounds.size.width/2, 0.0, 0.0)];
    
    UIBarButtonItem* item = [[UIBarButtonItem alloc] initWithCustomView:btn];
    
    //[self adjustBarItemWidth:item];
    
    return item;
}


+ (UIBarButtonItem *)createBarButtonFromImg:(UIImage *)imgNor 
									imgDown:(UIImage *)imgDown
									 target:(id)target 
									 action:(SEL)selector     // 创建一个图片按钮
{
    if (imgNor == nil) 
    {
        return nil;
    }
    
    UIButton* btn = [[UIButton alloc] initWithFrame:CGRectZero];
    
    CGRect frame = CGRectZero;
    frame.size = imgNor.size;
    btn.frame = frame;
    [btn setBackgroundImage:imgNor forState:UIControlStateNormal];
    if (imgDown) {
		[btn setBackgroundImage:imgDown forState:UIControlStateHighlighted];
    }
    
    [btn addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem* item = [[UIBarButtonItem alloc] initWithCustomView:btn];
    
    return item;
}


- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        //        self.backgroundColor = [UIColor redColor];
        UIImage *syncBgImg = [UIImage imageNamed:@"home01_02"];
        self.backgroundColor = [[UIColor alloc] initWithPatternImage:syncBgImg];
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
//    if (self.backgroundImage)
//    {
//        CGContextRef context = UIGraphicsGetCurrentContext();
//        CGContextTranslateCTM(context, 0, self.bounds.size.height);
//        CGContextScaleCTM(context, 1.0f, -1.0f);
//        CGContextDrawImage(context, rect, self.backgroundImage.CGImage);
//        
//        return;
//    }
//    self.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"navBg.png"]];
    
//    [super drawRect:rect];
}

@end


#pragma mark - FPNavigationController
@implementation FPNavigationController

// 将自定义的 FPNavigationBar 置于最底层，并且将原本的bar的背景层移除掉
// 或者使用IB, 指定 FPNavigationController 的 navigationBar的class为FPNavigationBar
- (void)replaceNavigationBar
{
    FPNavigationBar * subNavBar = [[FPNavigationBar alloc]
                                   initWithFrame:CGRectMake(0, 0, 1024, 44)];
    
    for (int i = 0; i < self.navigationBar.subviews.count; ++i)
    {
        UIView * subView = [self.navigationBar.subviews objectAtIndex:i];
        
        if (CGRectEqualToRect(subView.bounds, self.navigationBar.bounds))
        {
            [subView removeFromSuperview];
        }
    }
    
    [self.navigationBar addSubview:subNavBar];
    [self.navigationBar sendSubviewToBack:subNavBar];
}

- (id)initWithRootViewController:(UIViewController *)rootViewController
{
    if (self = [super initWithRootViewController:rootViewController])
    {
        [self replaceNavigationBar];
        
		UIView * titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 624, 26)];
		titleView.backgroundColor = [UIColor clearColor];
        rootViewController.navigationItem.titleView = titleView;
    }
    return self;
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if (self.topViewController != nil && self.topViewController != viewController)
    {
		UIView * titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 624, 26)];
		titleView.backgroundColor = [UIColor clearColor];
        viewController.navigationItem.titleView = titleView;
    }
    
    [super pushViewController:viewController animated:animated];
    
    // 创建默认的返回按钮
    if (viewController.navigationItem.leftBarButtonItem == nil && self.viewControllers.count > 1)
    {
        
//        UIBarButtonItem * backBarButtonItem =
//        [FPNavigationBar createBarButton:@"返回"
//                                      iconNor:@"img_13"
//                                      iconDown:nil
//                                       target:self
//                                       action:@selector(defaultActionBack:)];
        UIButton* btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 51, 32)];

        [btn setBackgroundImage:[UIImage imageNamed:@"xq_br_03"] forState:UIControlStateNormal];
        //    [btn setImage:[UIImage imageNamed:@"ic_feedback_titlebar"] forState:UIControlStateHighlighted];

        [btn setTitle:@"返回" forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        UILabel * label = [btn titleLabel];
        label.textColor = [UIColor whiteColor];
        label.textAlignment = UITextAlignmentCenter;
        [label setFont:[UIFont systemFontOfSize:16]];

        [btn addTarget:self action:@selector(defaultActionBack:) forControlEvents:UIControlEventTouchUpInside];

        UIBarButtonItem * backBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];


        
        viewController.navigationItem.leftBarButtonItem = backBarButtonItem;
    }
    
    [self replaceNavigationBar];
}

- (void)setImgTitle:(UIViewController *)viewController imgTitle:(UIImageView *)imgTitle
{
    UIView * view = (UIView *)viewController.navigationItem.titleView;
	[view addSubview:imgTitle];
}

- (UIViewController *)popViewControllerAnimated:(BOOL)animated
{
    UIViewController * poppedViewController = [super popViewControllerAnimated:animated];
    
    [[NSNotificationCenter defaultCenter]
     postNotificationName:FPNavigationPoppedNotification object:poppedViewController];
    
    [self replaceNavigationBar];
    
    CGRect frame = self.navigationItem.titleView.frame;
    
    super.navigationItem.titleView.frame = CGRectMake(0, 0, 624, 26);
    
    frame = super.navigationItem.titleView.frame;
    
    return poppedViewController;
}

- (void)defaultActionBack:(id)sender
{
    [self popViewControllerAnimated:YES];
}

@end


@implementation UINavigationItem (FP)

- (void)setTitle:(NSString *)title
{
    UIView * view = (UIView *)self.titleView;
    for (UIView * v in view.subviews) {
        if ([v isKindOfClass:[UILabel class]]) {
            [v removeFromSuperview];
        }
    }
	// 标题栏
	UILabel * titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 624, 26)];
	[titleLabel setBackgroundColor:[UIColor clearColor]];
	[titleLabel setFont:[UIFont systemFontOfSize:26]];
	[titleLabel setTextAlignment:NSTextAlignmentCenter];
    [titleLabel setTextColor:[UIColor whiteColor]];
	[titleLabel setLineBreakMode:NSLineBreakByWordWrapping | NSLineBreakByTruncatingTail];
    [titleLabel setText:title];
	[view addSubview:titleLabel];
}

@end
