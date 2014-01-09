//
//  FundNotMoneyData.h
//  FundPrj
//
//  Created by leesea on 13-11-19.
//  Copyright (c) 2013年 leesea. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FundNotMoneyData : NSObject

@property (nonatomic, copy) NSString * name;
@property (nonatomic, copy) NSString * py;
@property (nonatomic, copy) NSString * date;
@property (nonatomic, copy) NSString * type;
@property (nonatomic, copy) NSString * invest_type;
@property (nonatomic, copy) NSString * pur_status;
@property (nonatomic, copy) NSString * redeem_status;
@property (nonatomic, assign) NSInteger code;
@property (nonatomic, copy) NSString * net_value;
@property (nonatomic, copy) NSString * account_value;
@property (nonatomic, copy) NSString * limits;
@property (nonatomic, copy) NSString * updown;
@property (nonatomic, copy) NSString * rr_this_year;
@property (nonatomic, copy) NSString * grade;

@end
