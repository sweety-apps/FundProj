//
//  LoginRequest.h
//  FundPrj
//
//  Created by leesea on 13-10-22.
//  Copyright (c) 2013年 leesea. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FPHttpRequest.h"

@class LoginResult;

@interface LoginRequest : FPHttpRequest

@property (strong, nonatomic) LoginResult * data;

- (id)initWithUrl:(NSString *)url;
- (BOOL)isLoginSuccess;
- (NSString *)getAccess_token;
- (NSString *)getMsg;

@end
