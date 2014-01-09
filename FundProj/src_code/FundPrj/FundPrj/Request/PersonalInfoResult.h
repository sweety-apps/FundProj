//
//  PersonalInfoResult.h
//  FundPrj
//
//  Created by leesea on 13-12-2.
//  Copyright (c) 2013年 leesea. All rights reserved.
//

#import <Foundation/Foundation.h>

@class PersonalInfoData;

@interface PersonalInfoResult : NSObject


@property (assign, nonatomic) NSInteger retcode;
@property (assign, nonatomic) NSInteger retnum;
@property (copy, nonatomic) NSString * msg;
@property (strong, nonatomic) PersonalInfoData * objData;

- (id)initWithJSONObject:(NSDictionary *)jsonObject;

@end
