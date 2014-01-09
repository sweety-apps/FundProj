//
//  PersonalInfoData.h
//  FundPrj
//
//  Created by leesea on 13-12-2.
//  Copyright (c) 2013年 leesea. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PersonalInfoData : NSObject

@property (nonatomic, copy) NSString * username;
@property (nonatomic, copy) NSString * gender;
@property (nonatomic, copy) NSString * email;
@property (nonatomic, copy) NSString * address;
@property (nonatomic, copy) NSString * birthday;
@property (nonatomic, assign) long long mobile;
@property (nonatomic, assign) NSInteger cash;
@property (nonatomic, assign) NSInteger money;

@end
