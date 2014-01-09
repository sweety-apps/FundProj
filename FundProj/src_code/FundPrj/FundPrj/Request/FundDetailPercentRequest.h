//
//  FundDetailPercentRequest.h
//  FundPrj
//
//  Created by leesea on 13-12-2.
//  Copyright (c) 2013年 leesea. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FPHttpRequest.h"

@class FundDetailPercentResult;
@class FundDetailPercentData;

@interface FundDetailPercentRequest : FPHttpRequest

@property (strong, nonatomic) FundDetailPercentResult * result;

- (id)initWithUrl:(NSString *)url;
- (BOOL)isRequestSuccess;
- (FundDetailPercentData *)getData;

@end
