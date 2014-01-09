//
//  LoginResult.m
//  FundPrj
//
//  Created by leesea on 13-10-22.
//  Copyright (c) 2013年 leesea. All rights reserved.
//

#import "LoginResult.h"

@implementation LoginResult

@synthesize retcode;
@synthesize access_token;
@synthesize msg;

- (id)initWithJSONObject:(NSDictionary *)jsonObject
{
    self = [super init];
	
	retcode = 1;
    
    @try {
		if (self)
		{
			self.retcode = [[jsonObject objectForKey:@"retcode"] intValue];
			self.access_token = [jsonObject objectForKey:@"access_token"];
            self.msg = [jsonObject objectForKey:@"msg"];
		}
	}
    @catch (NSException *exception) {
        if (retcode != 0)
        {
			self.access_token = @"";
        }
    }
    @finally {
    }
    
    return self;
}

@end
