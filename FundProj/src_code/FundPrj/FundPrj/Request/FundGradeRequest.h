//
//  FundGradeRequest.h
//  FundPrj
//
//  Created by leesea on 13-12-9.
//  Copyright (c) 2013年 leesea. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FPHttpRequest.h"

@class FundGradeResult;
@class FundGradeData;

@interface FundGradeRequest : FPHttpRequest

@property (strong, nonatomic) FundGradeResult * result;

- (id)initWithUrl:(NSString *)url;
- (BOOL)isRequestSuccess;
- (FundGradeData *)getData;

@end
