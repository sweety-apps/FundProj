//
//  FundNewsRequest.h
//  FundPrj
//
//  Created by leesea on 13-11-18.
//  Copyright (c) 2013年 leesea. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FPHttpRequest.h"

@class FundNewsResult;

@interface FundNewsRequest : FPHttpRequest

@property (strong, nonatomic) FundNewsResult * result;

- (id)initWithUrl:(NSString *)url;
- (BOOL)isRequestSuccess;
- (NSMutableArray *)getDataArray;

@end
