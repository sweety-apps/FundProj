//
//  FundQuoteRequest.h
//  FundPrj
//
//  Created by leesea on 13-11-26.
//  Copyright (c) 2013年 leesea. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FPHttpRequest.h"

@class FundQuoteResult;

@interface FundQuoteRequest : FPHttpRequest

@property (strong, nonatomic) FundQuoteResult * result;

- (id)initWithUrl:(NSString *)url;
- (BOOL)isRequestSuccess;
- (NSMutableArray *)getDataArray;

@end
