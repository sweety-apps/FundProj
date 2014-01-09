//
//  FundMoneyRequest.h
//  FundPrj
//
//  Created by leesea on 13-11-19.
//  Copyright (c) 2013年 leesea. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FPHttpRequest.h"

@class FundMoneyResult;

@interface FundMoneyRequest : FPHttpRequest

@property (strong, nonatomic) FundMoneyResult * result;

- (id)initWithUrl:(NSString *)url;
- (BOOL)isRequestSuccess;
- (NSMutableArray *)getDataArray;

@end
