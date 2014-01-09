//
//  FundQuoteHistoryRequest.h
//  FundPrj
//
//  Created by leesea on 13-12-1.
//  Copyright (c) 2013年 leesea. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FPHttpRequest.h"

@class FundQuoteHistoryResult;

@interface FundQuoteHistoryRequest : FPHttpRequest

@property (strong, nonatomic) FundQuoteHistoryResult * result;

- (id)initWithUrl:(NSString *)url;
- (BOOL)isRequestSuccess;
- (NSMutableArray *)getDataArray;
- (NSInteger)getFundID;

@end
