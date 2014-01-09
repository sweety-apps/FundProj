//
//  MyFundData.h
//  FundPrj
//
//  Created by leesea on 13-12-2.
//  Copyright (c) 2013年 leesea. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyFundData : NSObject

@property (nonatomic, copy) NSString * symbol;
@property (nonatomic, copy) NSString * name;
@property (nonatomic, copy) NSString * join_time;
@property (nonatomic, copy) NSString * rr_time;
@property (nonatomic, assign) NSInteger close;
@property (nonatomic, assign) NSInteger limits;
@property (nonatomic, assign) NSInteger updown;
@property (nonatomic, assign) NSInteger join_value;
@property (nonatomic, assign) NSInteger rr;

@end
