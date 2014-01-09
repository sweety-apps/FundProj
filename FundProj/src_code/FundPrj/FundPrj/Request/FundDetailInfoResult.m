//
//  FundDetailInfoResult.m
//  FundPrj
//
//  Created by leesea on 13-12-2.
//  Copyright (c) 2013年 leesea. All rights reserved.
//

#import "FundDetailInfoResult.h"
#import "FundDetailInfoData.h"

@implementation FundDetailInfoResult

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
                objData = [[FundDetailInfoData alloc]init];
                objData.code = [[dic objectForKey:@"code"]intValue];
                objData.manage_rate = [[dic objectForKey:@"manage_rate"]intValue];
                objData.pur_rate_max = [[dic objectForKey:@"pur_rate_max"]intValue];
                objData.redeem_rate_max = [[dic objectForKey:@"redeem_rate_max"]intValue];
                objData.custodian_rate = [[dic objectForKey:@"custodian_rate"]intValue];
                objData.sales_service = [[dic objectForKey:@"sales_service"]intValue];
                objData.sub_rate_max = [[dic objectForKey:@"sub_rate_max"]intValue];
                objData.size = [[dic objectForKey:@"size"]intValue];
                objData.name = [dic objectForKey:@"name"];
                objData.type = [dic objectForKey:@"type"];
                objData.invest_type = [dic objectForKey:@"invest_type"];
                objData.corp = [dic objectForKey:@"corp"];
                objData.manager = [dic objectForKey:@"manager"];
                objData.eval = [dic objectForKey:@"eval"];
                objData.goal = [dic objectForKey:@"goal"];
                objData.estb_date = [dic objectForKey:@"estb_date"];
                objData.pub_date = [dic objectForKey:@"pub_date"];
			}
		}
	}
    @catch (NSException *exception) {
        if (objData == nil)
        {
			objData = [[FundDetailInfoData alloc]init];
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

