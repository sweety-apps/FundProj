//
//  FundDetailInfoData.h
//  FundPrj
//
//  Created by leesea on 13-12-2.
//  Copyright (c) 2013年 leesea. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FundDetailInfoData : NSObject

@property (nonatomic, assign) NSInteger code;
@property (nonatomic, assign) NSInteger manage_rate;
@property (nonatomic, assign) NSInteger pur_rate_max;
@property (nonatomic, assign) NSInteger redeem_rate_max;
@property (nonatomic, assign) NSInteger custodian_rate;
@property (nonatomic, assign) NSInteger sales_service;
@property (nonatomic, assign) NSInteger sub_rate_max;
@property (nonatomic, assign) NSInteger size;
@property (nonatomic, copy) NSString * name;
@property (nonatomic, copy) NSString * type;
@property (nonatomic, copy) NSString * invest_type;
@property (nonatomic, copy) NSString * corp;
@property (nonatomic, copy) NSString * manager;
@property (nonatomic, copy) NSString * eval;
@property (nonatomic, copy) NSString * goal;
@property (nonatomic, copy) NSString * estb_date;
@property (nonatomic, copy) NSString * pub_date;

@end
