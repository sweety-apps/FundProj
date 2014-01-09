//
// FPNavigationBar.h
//  FundPrj
//
//  Created by leesea on 13-10-22.
//  Copyright (c) 2013年 leesea. All rights reserved.
//

/*
 自定义的导航bar和controller，可定制导航bar的背景图
 也可以创建iconButton (icon＋文字组合的按钮)
 */

#import <Foundation/Foundation.h>


extern NSString * const FPNavigationPoppedNotification;


#pragma mark - FPNavigationBar

@interface FPNavigationBar : UINavigationBar

@property(strong, nonatomic) UIImage * backgroundImage;


+ (UIBarButtonItem *)createBarButtonForMe:(NSString*)title 
                                  iconNor:(NSString*)iconNor // 图标可以为nil
                                 iconDown:(NSString*)iconDown
                                   target:(id)target 
                                   action:(SEL)selector;     // 创建一个正方按钮

+ (UIBarButtonItem *)createBarButton:(NSString*)title
                             iconNor:(NSString*)iconNor
                            iconDown:(NSString*)iconDown
                              target:(id)target
                              action:(SEL)selector;


+ (UIBarButtonItem *)createBarButtonFromImg:(UIImage *)imgNor
									imgDown:(UIImage *)imgDown
									 target:(id)target 
									 action:(SEL)selector;     // 创建一个图片按钮

@end


#pragma mark - FPNavigationController

@interface FPNavigationController : UINavigationController

- (void)setImgTitle:(UIViewController *)viewController imgTitle:(UIImageView *)imgTitle;


@end



@interface UINavigationItem (FP)

- (void)setTitle:(NSString *)title;

@end


