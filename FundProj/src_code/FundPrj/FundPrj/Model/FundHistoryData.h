//
//  FundHistoryData.h
//  FundPrj
//
//  Created by leesea on 13-12-18.
//  Copyright (c) 2013年 leesea. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FundHistoryData : NSObject

@property (nonatomic, assign) NSInteger code;
@property (nonatomic, copy) NSString * name;
@property (nonatomic, copy) NSString * date;
@property (nonatomic, copy) NSString * net_value;
@property (nonatomic, copy) NSString * limits;
@property (nonatomic, copy) NSString * rr_one_month;
@property (nonatomic, copy) NSString * rr_three_month;
@property (nonatomic, copy) NSString * rr_six_month;
@property (nonatomic, copy) NSString * rr_one_year;
@property (nonatomic, copy) NSString * rr_two_year;
@property (nonatomic, copy) NSString * rr_three_year;
@property (nonatomic, copy) NSString * rr_five_year;
@property (nonatomic, copy) NSString * rr_this_year;

@end
