//
//  SiftResult.m
//  FundPrj
//
//  Created by leesea on 13-11-21.
//  Copyright (c) 2013年 leesea. All rights reserved.
//

#import "SiftResult.h"
#import "SiftData.h"

@implementation SiftResult

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
					SiftData * objData = [[SiftData alloc]init];
					objData.code = [[dic objectForKey:@"code"]intValue];
					objData.name = [dic objectForKey:@"name"];
					objData.date = [dic objectForKey:@"date"];
					objData.net_value = [[dic objectForKey:@"net_value"]intValue];
					objData.limits = [[dic objectForKey:@"limits"]intValue];
					objData.rr_this_year = [[dic objectForKey:@"rr_this_year"]intValue];
					objData.invest_type = [dic objectForKey:@"invest_type"];
					objData.pur_status = [[dic objectForKey:@"pur_status"]intValue];
					objData.redeem_status = [[dic objectForKey:@"redeem_status"]intValue];
					objData.grade = [[dic objectForKey:@"grade"]intValue];
                    
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

