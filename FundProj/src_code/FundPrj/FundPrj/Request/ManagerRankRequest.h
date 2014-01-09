//
//  ManagerRankRequest.h
//  FundPrj
//
//  Created by leesea on 13-11-18.
//  Copyright (c) 2013年 leesea. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FPHttpRequest.h"

@class ManagerRankResult;

@interface ManagerRankRequest : FPHttpRequest

@property (strong, nonatomic) ManagerRankResult * result;

- (id)initWithUrl:(NSString *)url;
- (BOOL)isRequestSuccess;
- (NSMutableArray *)getDataArray;

@end