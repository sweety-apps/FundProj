//
//  FundManagerInfoResult.m
//  FundPrj
//
//  Created by leesea on 13-12-2.
//  Copyright (c) 2013年 leesea. All rights reserved.
//

#import "FundManagerInfoResult.h"
#import "FundManagerInfoData.h"

@implementation FundManagerInfoResult

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
			if ([jsonObject objectForKey:@"items"])
			{
				NSDictionary * dic = [jsonObject objectForKey:@"items"];
                objData = [[FundManagerInfoData alloc]init];
                objData.code = [[dic objectForKey:@"code"]intValue];
                objData.name = [dic objectForKey:@"name"];
                objData.take_date = [dic objectForKey:@"take_date"];
                objData.leave_date = [dic objectForKey:@"leave_date"];
                objData.birth_date = [dic objectForKey:@"birth_date"];
                objData.education = [dic objectForKey:@"education"];
                objData.resume = [dic objectForKey:@"resume"];
			}
		}
	}
    @catch (NSException *exception) {
        if (objData == nil)
        {
			objData = [[FundManagerInfoData alloc]init];
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

