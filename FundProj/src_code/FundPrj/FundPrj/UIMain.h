//
//  UIMain.h
//  FundPrj
//
//  Created by leesea on 13-10-22.
//  Copyright (c) 2013年 leesea. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Reachability.h"
#import "NetworkManager.h"

@class CMTabBarController;
@class HomeViewController;
@class FPNavigationController;

@interface UIMain : NSObject
<UITabBarControllerDelegate,
FPNetworkChangeDelegate,
UIGestureRecognizerDelegate>
{

}

/**
 * 各个界面元素
 */
@property (strong, nonatomic) UIWindow * window; // 主窗口
@property (strong, nonatomic) CMTabBarController * mainTabCtrl; // TabBar
@property (nonatomic, copy) NSString * loginToken;
@property (nonatomic, copy) NSString * userName;
@property (assign, nonatomic) BOOL isLogin;


#pragma mark - Functions

- (NSString *)getUserID;
- (BOOL)isLogin;

// 显示主窗口
- (void)showMainWindow;

- (NSInteger)networkState;

- (NSString *)md5EncParam:(NSMutableArray *)array;
- (NSString *)md5EncParamRegister:(NSMutableArray *)array;

@end
