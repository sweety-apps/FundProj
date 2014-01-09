//
//  UIDeviceEX.h
//  FundPrj
//
//  Created by leesea on 13-10-22.
//  Copyright (c) 2013年 leesea. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIDevice (EX)

// 设备可用内存（单位：MB）
@property(nonatomic, assign, readonly) double availableMemory;
@property(nonatomic,assign,readonly) BOOL isRetinaScreen;

@end
