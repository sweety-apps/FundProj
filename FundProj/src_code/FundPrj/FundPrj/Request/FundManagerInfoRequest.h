//
//  FundManagerInfoRequest.h
//  FundPrj
//
//  Created by leesea on 13-12-2.
//  Copyright (c) 2013年 leesea. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FPHttpRequest.h"

@class FundManagerInfoResult;
@class FundManagerInfoData;

@interface FundManagerInfoRequest : FPHttpRequest

@property (strong, nonatomic) FundManagerInfoResult * result;

- (id)initWithUrl:(NSString *)url;
- (BOOL)isRequestSuccess;
- (FundManagerInfoData *)getData;

@end
