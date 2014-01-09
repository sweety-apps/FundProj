//
//  FundHistoryRequest.h
//  FundPrj
//
//  Created by leesea on 13-12-18.
//  Copyright (c) 2013年 leesea. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FPHttpRequest.h"

@class FundHistoryResult;
@class FundHistoryData;

@interface FundHistoryRequest : FPHttpRequest

@property (strong, nonatomic) FundHistoryResult * result;

- (id)initWithUrl:(NSString *)url;
- (BOOL)isRequestSuccess;
- (NSInteger)getCode;
- (NSMutableArray *)getDataArray;

@end
