//
//  FundRepayData.h
//  FundPrj
//
//  Created by leesea on 13-11-18.
//  Copyright (c) 2013年 leesea. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FundRepayData : NSObject

@property (nonatomic, assign) NSInteger code;
@property (nonatomic, copy) NSString * name;
@property (nonatomic, copy) NSString * py;
@property (nonatomic, copy) NSString * date;
@property (nonatomic, assign) NSInteger net_value;
@property (nonatomic, assign) NSInteger account_value;
@property (nonatomic, assign) NSInteger limits;
@property (nonatomic, assign) NSInteger updown;
@property (nonatomic, copy) NSString * invest_type;
@property (nonatomic, copy) NSString * pur_status;
@property (nonatomic, copy) NSString * redeem_status;
@property (nonatomic, assign) NSInteger rr_this_year;
@property (nonatomic, assign) NSInteger grade;

@end
