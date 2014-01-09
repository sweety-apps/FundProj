//
//  RegisterResult.m
//  FundPrj
//
//  Created by leesea on 13-11-18.
//  Copyright (c) 2013年 leesea. All rights reserved.
//

#import "RegisterResult.h"

@implementation RegisterResult

@synthesize retcode;

- (id)initWithJSONObject:(NSDictionary *)jsonObject
{
    self = [super init];
    
    @try {
		if (self)
		{
			self.retcode = [[jsonObject objectForKey:@"retcode"] intValue];
		}
	}
    @catch (NSException *exception) {
    }
    @finally {
    }
    
    return self;
}

@end
