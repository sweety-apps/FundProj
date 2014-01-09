//
//  ManagerRankData.h
//  FundPrj
//
//  Created by leesea on 13-11-18.
//  Copyright (c) 2013年 leesea. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ManagerRankData : NSObject

@property (nonatomic, assign) NSInteger code;
@property (nonatomic, copy) NSString * name;
@property (nonatomic, copy) NSString * take_date;
@property (nonatomic, copy) NSString * leave_date;
@property (nonatomic, assign) NSInteger rr_one_year;
@property (nonatomic, assign) NSInteger rr_one_year_rank;
@property (nonatomic, copy) NSString * rr_one_year_eval;
@property (nonatomic, assign) float ann_rr_tenure;
@property (nonatomic, assign) float ann_rr_tenure_index;
@property (nonatomic, assign) NSInteger rr_sdate;


@end
