//
//  SiftRequest.h
//  FundPrj
//
//  Created by leesea on 13-11-21.
//  Copyright (c) 2013年 leesea. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FPHttpRequest.h"

@class SiftResult;

@interface SiftRequest : FPHttpRequest

@property (strong, nonatomic) SiftResult * result;

- (id)initWithUrl:(NSString *)url;
- (BOOL)isRequestSuccess;
- (NSMutableArray *)getDataArray;

@end