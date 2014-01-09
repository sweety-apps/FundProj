//
//  FundDetailInfoResult.h
//  FundPrj
//
//  Created by leesea on 13-12-2.
//  Copyright (c) 2013年 leesea. All rights reserved.
//

#import <Foundation/Foundation.h>

@class FundDetailInfoData;

@interface FundDetailInfoResult : NSObject


@property (assign, nonatomic) NSInteger retcode;
@property (assign, nonatomic) NSInteger retnum;
@property (copy, nonatomic) NSString * msg;
@property (strong, nonatomic) FundDetailInfoData * objData;

- (id)initWithJSONObject:(NSDictionary *)jsonObject;

@end
