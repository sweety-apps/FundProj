//
//  RegisterRequest.h
//  FundPrj
//
//  Created by leesea on 13-11-18.
//  Copyright (c) 2013年 leesea. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FPHttpRequest.h"

@class RegisterResult;

@interface RegisterRequest : FPHttpRequest

@property (strong, nonatomic) RegisterResult * data;

- (id)initWithUrl:(NSString *)url;
- (BOOL)isRegisterSuccess;

@end
