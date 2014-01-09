//
//  FundNotMoneyRequest.h
//  FundPrj
//
//  Created by leesea on 13-11-19.
//  Copyright (c) 2013年 leesea. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FPHttpRequest.h"

@class FundNotMoneyResult;

@interface FundNotMoneyRequest : FPHttpRequest

@property (strong, nonatomic) FundNotMoneyResult * result;

- (id)initWithUrl:(NSString *)url;
- (BOOL)isRequestSuccess;
- (NSMutableArray *)getDataArray;

@end
