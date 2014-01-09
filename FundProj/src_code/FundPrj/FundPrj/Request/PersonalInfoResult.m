//
//  PersonalInfoResult.m
//  FundPrj
//
//  Created by leesea on 13-12-2.
//  Copyright (c) 2013年 leesea. All rights reserved.
//

#import "PersonalInfoResult.h"
#import "PersonalInfoData.h"

@implementation PersonalInfoResult

@synthesize retcode;
@synthesize retnum;
@synthesize msg;
@synthesize objData;

- (id)initWithJSONObject:(NSDictionary *)jsonObject
{
    self = [super init];
    
    @try {
		if (self)
		{
			retcode = [[jsonObject objectForKey:@"retcode"] intValue];
			retnum = [[jsonObject objectForKey:@"retnum"] intValue];
			msg = [jsonObject objectForKey:@"msg"];
            objData = [[PersonalInfoData alloc]init];
            objData.username = [jsonObject objectForKey:@"username"];
            objData.gender = [jsonObject objectForKey:@"gender"];
            objData.email = [jsonObject objectForKey:@"email"];
            objData.address = [jsonObject objectForKey:@"address"];
            objData.birthday = [jsonObject objectForKey:@"birthday"];
            objData.mobile = [[jsonObject objectForKey:@"mobile"]longLongValue];
            objData.cash = [[jsonObject objectForKey:@"cash"]intValue];
            objData.money = [[jsonObject objectForKey:@"money"]intValue];
		}
	}
    @catch (NSException *exception) {
        if (objData == nil)
        {
			objData = [[PersonalInfoData alloc]init];
        }
        else
        {
        }
    }
    @finally {
    }
    
    return self;
}

@end

