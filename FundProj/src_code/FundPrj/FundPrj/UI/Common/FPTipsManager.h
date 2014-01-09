//
// FPTipsManager.h
//  FundPrj
//
//  Created by leesea on 13-10-22.
//  Copyright (c) 2013年 leesea. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "MBProgressHUD.h"

@interface FPTipsManager : NSObject<MBProgressHUDDelegate>

@property (strong,nonatomic) MBProgressHUD  * HUD;
@property (strong,nonatomic) UIWindow * maskWindow;
@property (strong,nonatomic) NSTimer * overTimer;

+ (FPTipsManager *)sharedManager;

- (void)postMessage:(NSString *)message;
- (void)postError:(NSString *)message;
- (void)postSuccess:(NSString *)message;
- (void)postLoading:(NSString *)message;

- (void)cleanUp:(BOOL)animated;

@end
