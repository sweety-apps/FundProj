//
//  FundQuoteHistoryData.h
//  FundPrj
//
//  Created by leesea on 13-12-1.
//  Copyright (c) 2013年 leesea. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FundQuoteHistoryData : NSObject

@property (nonatomic, copy) NSString * net_value;
@property (nonatomic, copy) NSString * limits;
@property (nonatomic, copy) NSString * updown_price;
@property (nonatomic, copy) NSString * pay_price;
@property (nonatomic, copy) NSString * pay_rate;
@property (nonatomic, copy) NSString * seven_areturn;
@property (nonatomic, copy) NSString * growth_10;

@property (nonatomic, copy) NSString * date;

@end
