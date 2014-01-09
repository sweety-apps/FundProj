
//
//  FundNewsResult.m
//  FundPrj
//
//  Created by leesea on 13-11-18.
//  Copyright (c) 2013年 leesea. All rights reserved.
//

#import "FundNewsResult.h"
#import "FundNewsData.h"

@implementation FundNewsResult

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
					FundNewsData * objData = [[FundNewsData alloc]init];
					objData.pubtime = [dic objectForKey:@"pubtime"];
					objData.title = [dic objectForKey:@"title"];
					objData.origin = [dic objectForKey:@"origin"];
					objData.author = [dic objectForKey:@"author"];
					objData.context = [dic objectForKey:@"context"];
					objData.channel = [[dic objectForKey:@"channel"]intValue];
					
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

