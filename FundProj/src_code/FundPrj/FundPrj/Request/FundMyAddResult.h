//
//  FundMyAddResult.h
//  FundPrj
//
//  Created by Lee Justin on 14-1-6.
//  Copyright (c) 2014年 leesea. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FundMyAddResult : NSObject

@property (assign, nonatomic) NSInteger retcode;
@property (copy, nonatomic) NSString * msg;

- (id)initWithJSONObject:(NSDictionary *)jsonObject;

@end
