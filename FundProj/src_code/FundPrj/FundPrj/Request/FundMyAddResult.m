//
//  FundMyAddResult.m
//  FundPrj
//
//  Created by Lee Justin on 14-1-6.
//  Copyright (c) 2014年 leesea. All rights reserved.
//

#import "FundMyAddResult.h"

@implementation FundMyAddResult

@synthesize retcode;
@synthesize msg;

- (id)initWithJSONObject:(NSDictionary *)jsonObject
{
    self = [super init];
    
    @try {
		if (self)
		{
			retcode = [[jsonObject objectForKey:@"retcode"] intValue];
			msg = [jsonObject objectForKey:@"msg"];
        }
	}
    @catch (NSException *exception) {
        //
    }
    @finally {
    }
    
    return self;
}

@end
