//
//  SiftData.h
//  FundPrj
//
//  Created by leesea on 13-11-21.
//  Copyright (c) 2013年 leesea. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SiftData : NSObject

@property (nonatomic, assign) NSInteger code;
@property (nonatomic, copy) NSString * name;
@property (nonatomic, copy) NSString * date;
@property (nonatomic, assign) NSInteger net_value;
@property (nonatomic, assign) NSInteger limits;
@property (nonatomic, copy) NSString * invest_type;
@property (nonatomic, assign) NSInteger pur_status;
@property (nonatomic, assign) NSInteger redeem_status;
@property (nonatomic, assign) NSInteger rr_this_year;
@property (nonatomic, assign) NSInteger grade;

@end
