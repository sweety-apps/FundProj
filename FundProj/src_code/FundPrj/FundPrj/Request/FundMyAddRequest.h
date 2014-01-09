//
//  FundMyAddRequest.h
//  FundPrj
//
//  Created by Lee Justin on 14-1-6.
//  Copyright (c) 2014年 leesea. All rights reserved.
//

#import "FPHttpRequest.h"
#import "FundMyAddResult.h"

@interface FundMyAddRequest : FPHttpRequest

@property (strong, nonatomic) FundMyAddResult * result;

- (id)initWithUrl:(NSString *)url;
- (BOOL)isRequestSuccess;

@end
