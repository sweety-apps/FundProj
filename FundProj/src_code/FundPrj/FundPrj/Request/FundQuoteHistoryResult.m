//
//  FundQuoteHistoryResult.m
//  FundPrj
//
//  Created by leesea on 13-12-1.
//  Copyright (c) 2013年 leesea. All rights reserved.
//

#import "FundQuoteHistoryResult.h"
#import "FundQuoteHistoryData.h"

@implementation FundQuoteHistoryResult

@synthesize retcode;
@synthesize retnum;
@synthesize msg;
@synthesize code;
@synthesize name;

- (id)initWithJSONObject:(NSDictionary *)jsonObject
{
    self = [super init];
    
    @try {
		if (self)
		{
			retcode = [[jsonObject objectForKey:@"retcode"] intValue];
			retnum = [[jsonObject objectForKey:@"retnum"] intValue];
			msg = [jsonObject objectForKey:@"msg"];
			code = [[jsonObject objectForKey:@"code"] intValue];
			name = [jsonObject objectForKey:@"name"];
			if ([jsonObject objectForKey:@"items"])
			{
				_itemList = [[NSMutableArray alloc]init];
				NSMutableArray * datas = [jsonObject objectForKey:@"items"];
				for (int index = 0; index < datas.count; ++index)
				{
					NSDictionary * dic = [datas objectAtIndex:index];
					FundQuoteHistoryData * objData = [[FundQuoteHistoryData alloc]init];
					objData.net_value = [dic objectForKey:@"net_value"];
					objData.limits = [dic objectForKey:@"limits"];
					objData.updown_price = [dic objectForKey:@"updown_price"];
					objData.pay_price = [dic objectForKey:@"pay_price"];
					objData.pay_rate = [dic objectForKey:@"pay_rate"];
					objData.seven_areturn = [dic objectForKey:@"seven_areturn"];
					objData.growth_10 = [dic objectForKey:@"growth_10"];
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

