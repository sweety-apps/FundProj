//
//  PersonalInfoRequest.h
//  FundPrj
//
//  Created by leesea on 13-12-2.
//  Copyright (c) 2013年 leesea. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FPHttpRequest.h"

@class PersonalInfoResult;
@class PersonalInfoData;

@interface PersonalInfoRequest : FPHttpRequest

@property (strong, nonatomic) PersonalInfoResult * result;

- (id)initWithUrl:(NSString *)url;
- (BOOL)isRequestSuccess;
- (PersonalInfoData *)getData;

@end
