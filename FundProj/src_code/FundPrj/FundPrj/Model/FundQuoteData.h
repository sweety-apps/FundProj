//
//  FundQuoteData.h
//  FundPrj
//
//  Created by leesea on 13-11-26.
//  Copyright (c) 2013年 leesea. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FundQuoteData : NSObject

@property (nonatomic, assign) NSInteger code;
@property (nonatomic, assign) NSInteger net_value;
@property (nonatomic, assign) NSInteger limits;
@property (nonatomic, assign) NSInteger updown_price;
@property (nonatomic, assign) NSInteger pay_price;
@property (nonatomic, assign) NSInteger pay_rate;
@property (nonatomic, assign) NSInteger seven_areturn;
@property (nonatomic, assign) NSInteger rr_one_month;
@property (nonatomic, assign) NSInteger rr_three_month;
@property (nonatomic, assign) NSInteger rr_six_month;
@property (nonatomic, assign) NSInteger rr_one_year;
@property (nonatomic, assign) NSInteger rr_this_year;
@property (nonatomic, copy) NSString * name;
@property (nonatomic, copy) NSString * date;

@end
