//
//  FundCompanyRequest.h
//  FundPrj
//
//  Created by leesea on 13-11-25.
//  Copyright (c) 2013年 leesea. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FPHttpRequest.h"

@class FundCompanyResult;

@interface FundCompanyRequest : FPHttpRequest

@property (strong, nonatomic) FundCompanyResult * result;

- (id)initWithUrl:(NSString *)url;
- (BOOL)isRequestSuccess;
- (NSMutableArray *)getDataArray;

@end
