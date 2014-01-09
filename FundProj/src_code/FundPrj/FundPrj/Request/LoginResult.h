//
//  LoginResult.h
//  FundPrj
//
//  Created by leesea on 13-10-22.
//  Copyright (c) 2013年 leesea. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LoginResult : NSObject

@property (assign, nonatomic) NSInteger retcode;
@property (copy, nonatomic) NSString * access_token;
@property (copy, nonatomic) NSString * msg;

- (id)initWithJSONObject:(NSDictionary *)jsonObject;

@end
