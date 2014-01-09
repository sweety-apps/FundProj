//
//  RegisterResult.h
//  FundPrj
//
//  Created by leesea on 13-11-18.
//  Copyright (c) 2013年 leesea. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface RegisterResult : NSObject

@property (assign, nonatomic) NSInteger retcode;

- (id)initWithJSONObject:(NSDictionary *)jsonObject;

@end
