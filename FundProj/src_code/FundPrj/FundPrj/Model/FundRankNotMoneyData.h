//
//  FundRankNotMoneyData.h
//  FundPrj
//
//  Created by leesea on 13-11-19.
//  Copyright (c) 2013年 leesea. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FundRankNotMoneyData : NSObject

@property (nonatomic, copy) NSString * py;
@property (nonatomic, copy) NSString * name;
@property (nonatomic, copy) NSString * date;
@property (nonatomic, copy) NSString * account_value;
@property (nonatomic, copy) NSString * net_value;
@property (nonatomic, copy) NSString * rr_one_month;
@property (nonatomic, copy) NSString * rr_one_month_rank;
@property (nonatomic, copy) NSString * rr_three_month;
@property (nonatomic, copy) NSString * rr_three_month_rank;
@property (nonatomic, copy) NSString * rr_six_month;
@property (nonatomic, copy) NSString * rr_six_month_rank;
@property (nonatomic, copy) NSString * rr_this_year;
@property (nonatomic, copy) NSString * rr_this_year_rank;
@property (nonatomic, copy) NSString * rr_one_year;
@property (nonatomic, copy) NSString * rr_one_year_rank;
@property (nonatomic, copy) NSString * rr_two_year;
@property (nonatomic, copy) NSString * rr_two_year_rank;
@property (nonatomic, copy) NSString * rr_three_year;
@property (nonatomic, copy) NSString * rr_three_year_rank;
@property (nonatomic, copy) NSString * estb_date;
@property (nonatomic, assign) NSInteger code;

@end
