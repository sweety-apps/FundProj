//
//  FundHistoryResult.h
//  FundPrj
//
//  Created by leesea on 13-12-18.
//  Copyright (c) 2013年 leesea. All rights reserved.
//

#import <Foundation/Foundation.h>

@class FundHistoryData;

@interface FundHistoryResult : NSObject


@property (assign, nonatomic) NSInteger retcode;
@property (assign, nonatomic) NSInteger retnum;
@property (copy, nonatomic) NSString * msg;
@property (assign, nonatomic) NSInteger code;
@property (copy, nonatomic) NSString * name;
@property (strong, nonatomic) NSMutableArray * itemList;

- (id)initWithJSONObject:(NSDictionary *)jsonObject;

@end
