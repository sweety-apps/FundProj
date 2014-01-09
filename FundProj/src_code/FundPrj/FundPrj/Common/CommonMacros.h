//
//  CommonMacros.h
//  FundPrj
//
//  Created by leesea on 13-10-22.
//  Copyright (c) 2013年 leesea. All rights reserved.
//

#ifndef FP_iPhone_CommonMacros_h
#define FP_iPhone_CommonMacros_h

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
//

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
// 

#define DATA_FORMAT @"json"
#define HOST_NAME @"http://api.icaifu.com/v1/"
#define APP_KEY @"app_key"
#define APP_KEY_VALUE @"6yi5l7ovoozqvvfz62qwfernmzwu1w1"

#define OPENID @"openid"
#define SIGN_TYPE @"sign_type"
#define SIGN @"sign"
#define TYPE @"_type"
#define ACTION @"action"
#define SYMBOL @"symbol"

#define OPENID_VALUE @"fundapp"

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
//	request func name
#define REGISTER_FUNC @"my/register"
#define LOGIN_FUNC @"my/login"
#define HOME_FUND_REPAY @"fund/netvalue/list"
#define HOME_MANAGER_RANK @"fund/manager/list"
#define HOME_FUND_NEWS @"news/list"
#define VALUE_FUND_NOT_MONEY @"fund/netvalue/list"
#define VALUE_FUND_MONEY @"fund/c/netvalue/list"
#define VALUE_FUND_RANK_NOT_MONEY @"fund/list"
#define VALUE_FUND_RANK_MONEY @"fund/c/list"
#define SIFT @"fund/search"
#define SIFT_INTEL @"fund/adv_search"
#define SIFT_FUND_COMPANY @"fund/corp/list"
#define DETAIL_QUOTE @"fund/quote"
#define DETAIL_HISTORY_QUOTE @"fund/quote/history"
#define DETAIL_INFO_QUOTE @"fund/info"
#define DETAIL_MANAGER_INFO_QUOTE @"fund/manager/info"
#define DETAIL_PERCENT_QUOTE @"fund/portfolio"
#define PERSONAL_INFO @"my/info"
#define PERSONAL_MYFUND @"my/select"
#define PERSONAL_MYADD @"my/add"
#define DOCTOR @"fund/doctor"
#define FUND_GRADE @"fund/quote/history"
#define FUND_HISTORY @"fund/indexes/history"


////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
// UI相关

// 开始绘制阴影
#define SHADOW_START_WITH_PARAMS(context, uicolor, width, height, blur)    \
CGContextSaveGState(context);\
CGContextSetShadowWithColor(context, CGSizeMake(width, height), blur, uicolor.CGColor);\

// 结束阴影绘制
#define SHADOW_STOP_WITH_PARAMS(context)     \
CGContextRestoreGState(context);


////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
// 设计模式

// 单例模式
#define FP_SINGLETON_GENERATOR(class_name, shared_func_name)    \
static class_name * s_##class_name = nil;                       \
+ (class_name *)shared_func_name                                \
{                                                               \
    @synchronized(self)                                         \
    {                                                           \
        if (nil == s_##class_name) {                            \
            s_##class_name = [[self alloc] init];               \
        }                                                       \
    }                                                           \
    return s_##class_name;                                      \
}                                                               \
+ (class_name *)allocWithZone:(NSZone *)zone                    \
{                                                               \
    @synchronized(self)                                         \
    {                                                           \
        if (nil == s_##class_name) {                            \
            return [super allocWithZone:zone];                  \
        }                                                       \
    }                                                           \
    return s_##class_name;                                      \
}                                                               \
- (class_name *)copyWithZone:(NSZone *)zone                     \
{                                                               \
    return self;                                                \
}                                                               \

// 配合FP_SINGLETON_GENERATOR 返回静态实例 （用于在init中判断是否有初始化过）
#define FP_SINGLETON_SHARED_INSTANCE(class_name)    s_##class_name


#endif
