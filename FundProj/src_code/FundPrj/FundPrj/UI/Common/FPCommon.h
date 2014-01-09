//
// FPCommon.h
//  FundPrj
//
//  Created by leesea on 13-10-22.
//  Copyright (c) 2013年 leesea. All rights reserved.
//
/**
 * 此文件被包含在预编译头文件中，不需要额外的import
 */

#ifndef FP_iPhone_FPCommon_h
#define FP_iPhone_FPCommon_h

#import "FPAppDelegate.h"


// Macros
#import "CommonMacros.h"
#import "UIDevice+IdentifierAddition.h"

// UI相关
#import "UIKits.h"
#import "FPNavigationController.h"
#import "FPTipsManager.h"

// Categorys
#import "NSStringEX.h"
#import "UIFontEX.h"
#import "UIViewEX.h"
#import "UIImageEX.h"
#import "UIDeviceEX.h"
#import "NSURLEX.h"

// Cache
#import "URLCache.h"

//RGB
#define RGB(r,g,b) [UIColor colorWithRed:r/255.f green:g/255.f blue:b/255.f alpha:1]


#define _APP		((FPAppDelegate*)[UIApplication sharedApplication].delegate)
#define _UI			_APP.objUIMain
#define _NETWORK    _APP.objNetworkManager

#define PATH_OF_APP_HOME    NSHomeDirectory()
#define PATH_OF_TEMP        NSTemporaryDirectory()
#define PATH_OF_DOCUMENT    [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]

#endif
