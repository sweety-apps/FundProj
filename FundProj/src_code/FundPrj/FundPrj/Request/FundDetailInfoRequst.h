//
//  FundDetailInfoRequst.h
//  FundPrj
//
//  Created by leesea on 13-12-2.
//  Copyright (c) 2013年 leesea. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FPHttpRequest.h"

@class FundDetailInfoResult;
@class FundDetailInfoData;

@interface FundDetailInfoRequst : FPHttpRequest

@property (strong, nonatomic) FundDetailInfoResult * result;

- (id)initWithUrl:(NSString *)url;
- (BOOL)isRequestSuccess;
- (FundDetailInfoData *)getData;

@end
