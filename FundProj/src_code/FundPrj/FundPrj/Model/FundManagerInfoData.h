//
//  FundManagerInfoData.h
//  FundPrj
//
//  Created by leesea on 13-12-2.
//  Copyright (c) 2013年 leesea. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FundManagerInfoData : NSObject

@property (nonatomic, assign) NSInteger code;
@property (nonatomic, copy) NSString * name;
@property (nonatomic, copy) NSString * take_date;
@property (nonatomic, copy) NSString * leave_date;
@property (nonatomic, copy) NSString * birth_date;
@property (nonatomic, copy) NSString * education;
@property (nonatomic, copy) NSString * resume;

@end
