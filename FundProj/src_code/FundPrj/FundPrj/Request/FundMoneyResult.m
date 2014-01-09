//
//  FundMoneyResult.m
//  FundPrj
//
//  Created by leesea on 13-11-19.
//  Copyright (c) 2013年 leesea. All rights reserved.
//

#import "FundMoneyResult.h"
#import "FundMoneyData.h"

@implementation FundMoneyResult

@synthesize retcode;
@synthesize retnum;
@synthesize msg;

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
				_itemList = [[NSMutableArray alloc]init];
				NSMutableArray * datas = [jsonObject objectForKey:@"items"];
				for (int index = 0; index < datas.count; ++index)
				{
					NSDictionary * dic = [datas objectAtIndex:index];
					FundMoneyData * objData = [[FundMoneyData alloc]init];
					objData.name = [dic objectForKey:@"name"];
					objData.py = [dic objectForKey:@"py"];
					objData.date = [dic objectForKey:@"date"];
					objData.pay_price = [dic objectForKey:@"pay_price"];
					objData.seven_areturn = [dic objectForKey:@"seven_areturn"];
					objData.type = [dic objectForKey:@"type"];
					objData.invest_type = [dic objectForKey:@"invest_type"];
					objData.pur_status = [dic objectForKey:@"pur_status"];
					objData.redeem_status = [dic objectForKey:@"redeem_status"];
					objData.rr_this_year = [dic objectForKey:@"rr_this_year"];
					objData.code = [[dic objectForKey:@"code"]intValue];
					
					[_itemList addObject:objData];
				}
			}
		}
	}
    @catch (NSException *exception) {
        if (_itemList == nil)
        {
			_itemList = [[NSMutableArray alloc]init];
        }
        else
        {
            [_itemList removeAllObjects];
        }
    }
    @finally {
    }
    
    return self;
}

@end

