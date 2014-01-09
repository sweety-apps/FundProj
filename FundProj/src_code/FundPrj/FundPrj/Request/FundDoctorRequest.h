//
//  FundDoctorRequest.h
//  FundPrj
//
//  Created by leesea on 13-12-3.
//  Copyright (c) 2013年 leesea. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FPHttpRequest.h"

@class FundDoctorResult;
@class FundDoctorData;

@interface FundDoctorRequest : FPHttpRequest

@property (strong, nonatomic) FundDoctorResult * result;

- (id)initWithUrl:(NSString *)url;
- (BOOL)isRequestSuccess;
- (FundDoctorData *)getData;


@end
