//
//  FundCompanyResult.m
//  FundPrj
//
//  Created by leesea on 13-11-25.
//  Copyright (c) 2013年 leesea. All rights reserved.
//

#import "FundCompanyResult.h"
#import "FundCompanyData.h"

@implementation FundCompanyResult

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
					FundCompanyData * objData = [[FundCompanyData alloc]init];
					objData.corp_id = [[dic objectForKey:@"corp_id"]intValue];
					objData.corp_name = [dic objectForKey:@"corp_name"];
                    
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

