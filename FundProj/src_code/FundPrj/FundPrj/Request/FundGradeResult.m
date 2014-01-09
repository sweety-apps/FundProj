//
//  FundGradeResult.m
//  FundPrj
//
//  Created by leesea on 13-12-9.
//  Copyright (c) 2013年 leesea. All rights reserved.
//

#import "FundGradeResult.h"
#import "FundGradeData.h"

@implementation FundGradeResult

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
				NSDictionary * dic = jsonObject;
                objData = [[FundGradeData alloc]init];
                objData.code = [[dic objectForKey:@"code"]floatValue];
                objData.name = [dic objectForKey:@"name"];
                if ([dic objectForKey:@"items"])
                {
                    NSMutableArray * array = [dic objectForKey:@"items"];
                    NSDictionary * dict = [array objectAtIndex:0];
                    objData.date = [dict objectForKey:@"date"];
                    objData.grade = [[dict objectForKey:@"grade"]intValue];
                    objData.risk_ss_rank = [[dict objectForKey:@"risk_ss_rank"]intValue];
                    objData.profit_rank = [[dict objectForKey:@"profit_rank"]intValue];
                    objData.net_value = [[dict objectForKey:@"net_value"]floatValue];
                    objData.rr_one_month = [[dict objectForKey:@"rr_one_month"]floatValue];
                }
			}
		}
	}
    @catch (NSException *exception) {
        if (objData == nil)
        {
			objData = [[FundGradeData alloc]init];
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

