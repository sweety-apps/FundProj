//
//  FundRankMoneyRequest.h
//  FundPrj
//
//  Created by leesea on 13-11-19.
//  Copyright (c) 2013年 leesea. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FPHttpRequest.h"

@class FundRankMoneyResult;

@interface FundRankMoneyRequest : FPHttpRequest

@property (strong, nonatomic) FundRankMoneyResult * result;

- (id)initWithUrl:(NSString *)url;
- (BOOL)isRequestSuccess;
- (NSMutableArray *)getDataArray;

@end
