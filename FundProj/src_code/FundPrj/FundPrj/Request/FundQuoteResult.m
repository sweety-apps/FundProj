//
//  FundQuoteResult.m
//  FundPrj
//
//  Created by leesea on 13-11-26.
//  Copyright (c) 2013年 leesea. All rights reserved.
//

#import "FundQuoteResult.h"
#import "FundQuoteData.h"

@implementation FundQuoteResult

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
					FundQuoteData * objData = [[FundQuoteData alloc]init];
					objData.code = [[dic objectForKey:@"code"]intValue];
					objData.net_value = [[dic objectForKey:@"net_value"]intValue];
					objData.limits = [[dic objectForKey:@"limits"]intValue];
					objData.updown_price = [[dic objectForKey:@"updown_price"]intValue];
					objData.pay_price = [[dic objectForKey:@"pay_price"]intValue];
					objData.pay_rate = [[dic objectForKey:@"pay_rate"]intValue];
					objData.seven_areturn = [[dic objectForKey:@"seven_areturn"]intValue];
					objData.rr_one_month = [[dic objectForKey:@"rr_one_month"]intValue];
					objData.rr_three_month = [[dic objectForKey:@"rr_three_month"]intValue];
					objData.rr_six_month = [[dic objectForKey:@"rr_six_month"]intValue];
					objData.rr_one_year = [[dic objectForKey:@"rr_one_year"]intValue];
					objData.rr_this_year = [[dic objectForKey:@"rr_this_year"]intValue];
					objData.name = [dic objectForKey:@"name"];
					objData.date = [dic objectForKey:@"date"];
                    
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

