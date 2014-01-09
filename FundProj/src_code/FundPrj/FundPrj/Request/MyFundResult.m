//
//  MyFundResult.m
//  FundPrj
//
//  Created by leesea on 13-12-2.
//  Copyright (c) 2013年 leesea. All rights reserved.
//

#import "MyFundResult.h"
#import "MyFundData.h"

@implementation MyFundResult

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
					MyFundData * objData = [[MyFundData alloc]init];
					objData.close = [[dic objectForKey:@"close"]intValue];
					objData.limits = [[dic objectForKey:@"limits"]intValue];
					objData.updown = [[dic objectForKey:@"updown"]intValue];
					objData.join_value = [[dic objectForKey:@"join_value"]intValue];
					objData.rr = [[dic objectForKey:@"rr"]intValue];
					objData.symbol = [dic objectForKey:@"symbol"];
					objData.name = [dic objectForKey:@"name"];
					objData.join_time = [dic objectForKey:@"join_time"];
					objData.rr_time = [dic objectForKey:@"rr_time"];
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

