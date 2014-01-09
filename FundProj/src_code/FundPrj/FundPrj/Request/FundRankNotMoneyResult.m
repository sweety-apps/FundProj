
//
//  FundRankNotMoneyResult.m
//  FundPrj
//
//  Created by leesea on 13-11-19.
//  Copyright (c) 2013年 leesea. All rights reserved.
//

#import "FundRankNotMoneyResult.h"
#import "FundRankNotMoneyData.h"

@implementation FundRankNotMoneyResult

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
					FundRankNotMoneyData * objData = [[FundRankNotMoneyData alloc]init];
					objData.name = [dic objectForKey:@"name"];
					objData.py = [dic objectForKey:@"py"];
					objData.date = [dic objectForKey:@"date"];
					objData.net_value = [dic objectForKey:@"net_value"];
					objData.account_value = [dic objectForKey:@"account_value"];
					objData.rr_one_month = [dic objectForKey:@"rr_one_month"];
					objData.rr_one_month_rank = [dic objectForKey:@"rr_one_month_rank"];
					objData.rr_three_month = [dic objectForKey:@"rr_three_month"];
					objData.rr_three_month_rank = [dic objectForKey:@"rr_three_month_rank"];
					objData.rr_six_month = [dic objectForKey:@"rr_six_month"];
					objData.rr_six_month_rank = [dic objectForKey:@"rr_six_month_rank"];
					objData.rr_this_year = [dic objectForKey:@"rr_this_year"];
					objData.rr_this_year_rank = [dic objectForKey:@"rr_this_year_rank"];
					objData.rr_one_year = [dic objectForKey:@"rr_one_year"];
					objData.rr_one_year_rank = [dic objectForKey:@"rr_one_year_rank"];
					objData.rr_two_year = [dic objectForKey:@"rr_two_year"];
					objData.rr_two_year_rank = [dic objectForKey:@"rr_two_year_rank"];
					objData.rr_three_year = [dic objectForKey:@"rr_three_year"];
					objData.rr_three_year_rank = [dic objectForKey:@"rr_three_year_rank"];
					objData.estb_date = [dic objectForKey:@"estb_date"];
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

