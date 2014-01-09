//
//  ManagerRankResult.m
//  FundPrj
//
//  Created by leesea on 13-11-18.
//  Copyright (c) 2013年 leesea. All rights reserved.
//

#import "ManagerRankResult.h"
#import "ManagerRankData.h"

@implementation ManagerRankResult

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
					ManagerRankData * objData = [[ManagerRankData alloc]init];
					objData.code = [[dic objectForKey:@"code"]intValue];
					objData.name = [dic objectForKey:@"name"];
					objData.take_date = [dic objectForKey:@"take_date"];
					objData.leave_date = [dic objectForKey:@"leave_date"];
					objData.rr_one_year = [[dic objectForKey:@"rr_one_year"]intValue];
					objData.rr_one_year_rank = [[dic objectForKey:@"rr_one_year_rank"]intValue];
					objData.rr_one_year_eval = [dic objectForKey:@"rr_one_year_eval"];
					objData.ann_rr_tenure = [[dic objectForKey:@"ann_rr_tenure"]floatValue];
					objData.ann_rr_tenure_index = [[dic objectForKey:@"ann_rr_tenure_index"]floatValue];
					objData.rr_sdate = [[dic objectForKey:@"rr_sdate"]intValue];
					
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

