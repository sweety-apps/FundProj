//
//  FundGradeData.h
//  FundPrj
//
//  Created by leesea on 13-12-9.
//  Copyright (c) 2013年 leesea. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FundGradeData : NSObject

@property (nonatomic, assign) NSInteger code;
@property (nonatomic, assign) NSInteger grade;
@property (nonatomic, assign) NSInteger risk_ss_rank;
@property (nonatomic, assign) NSInteger profit_rank;
@property (nonatomic, copy) NSString * name;
@property (nonatomic, copy) NSString * date;
@property (nonatomic, assign) float net_value;
@property (nonatomic, assign) float rr_one_month;

@end
