//
// FPUIKits.h
//  FundPrj
//
//  Created by leesea on 13-10-22.
//  Copyright (c) 2013年 leesea. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 * 此文件用于定义UI中一些通用的方法，比如Alert、Loading等
 */
@interface FPUIKits : NSObject

#define FPString(key) NSLocalizedString(key, @"")

#define NONILString(str) (str? str: @"")
#define ZEROString(str) (str? str: @"0")

// 用于加载数据时弹出的全局进度提示框（有个圈圈的旋转动画）
+ (void)showProcMsgBox:(NSString*)message;
+ (BOOL)isProcMsgBoxShowing;
+ (void)hideProcMsgBox;

// normal alertview
+ (void)messageBox:(NSString*)message 
             title:(NSString*)title 
               tag:(NSInteger)tag
          delegate:(id)delegate 
           buttons:(NSArray*)btnTitleArray;

+ (void)messageBox:(NSString*)message 
             title:(NSString*)title 
               tag:(NSInteger)tag
          delegate:(id)delegate;

+ (void)messageBox:(NSString*)message;

+ (void)messageBox:(NSString*)message 
             title:(NSString*)title;

+ (void)killCurrentMessageBox;

// width position offset
+ (void)messageBox:(NSString*)message 
             title:(NSString*)title 
               tag:(NSInteger)tag
          delegate:(id)delegate 
           buttons:(NSArray*)btnTitleArray 
            offset:(CGPoint)offset;

+ (void)messageBox:(NSString*)message 
             title:(NSString*)title 
               tag:(NSInteger)tag
          delegate:(id)delegate 
            offset:(CGPoint)offset;

+ (void)messageBox:(NSString*)message 
            offset:(CGPoint)offset;

+ (void)messageBox:(NSString*)message 
             title:(NSString*)title 
            offset:(CGPoint)offset;

// modal message box
+ (NSUInteger)modalMessageBox:(NSString*)message 
                        title:(NSString*)title 
                      button1:(NSString*)button1 
                      button2:(NSString*)button2;



@end
