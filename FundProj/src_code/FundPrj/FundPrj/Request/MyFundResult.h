//
//  MyFundResult.h
//  FundPrj
//
//  Created by leesea on 13-12-2.
//  Copyright (c) 2013年 leesea. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyFundResult : NSObject


@property (assign, nonatomic) NSInteger retcode;
@property (assign, nonatomic) NSInteger retnum;
@property (copy, nonatomic) NSString * msg;
@property (strong, nonatomic) NSMutableArray * itemList;

- (id)initWithJSONObject:(NSDictionary *)jsonObject;

@end