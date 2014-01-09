//
//  FundHistoryResult.m
//  FundPrj
//
//  Created by leesea on 13-12-18.
//  Copyright (c) 2013年 leesea. All rights reserved.
//

#import "FundHistoryResult.h"
#import "FundHistoryData.h"

@implementation FundHistoryResult

@synthesize retcode;
@synthesize retnum;
@synthesize msg;
@synthesize code;
@synthesize name;
@synthesize itemList;

- (id)initWithJSONObject:(NSDictionary *)jsonObject
{
    self = [super init];
    
    @try {
		if (self)
		{
			retcode = [[jsonObject objectForKey:@"retcode"] intValue];
			retnum = [[jsonObject objectForKey:@"retnum"] intValue];
			msg = [jsonObject objectForKey:@"msg"];
            id codeObj = [jsonObject objectForKey:@"code"];
            if ([codeObj isKindOfClass:[NSString class]])
            {
                NSString * str = [jsonObject objectForKey:@"code"];
                if ([str isEqualToString:@"MSSFI"]) {
                    code = 59000001;
                }
                else if ([str isEqualToString:@"MSBFI"]) {
                    code = 59000003;
                }
                else if ([str isEqualToString:@"MSMFI"]) {
                    code = 59000002;
                }
                else {
                    code = [[jsonObject objectForKey:@"code"]intValue];
                }
            }
            else
            {
                code = [[jsonObject objectForKey:@"code"]intValue];
            }
            
			name = [jsonObject objectForKey:@"name"];
			if ([jsonObject objectForKey:@"items"])
			{
				itemList = [[NSMutableArray alloc]init];
				NSMutableArray * datas = [jsonObject objectForKey:@"items"];
				for (int index = 0; index < datas.count; ++index)
				{
					NSDictionary * dic = [datas objectAtIndex:index];
                    FundHistoryData *objData = [[FundHistoryData alloc]init];
                    objData.date = [dic objectForKey:@"date"];
                    objData.net_value = [dic objectForKey:@"net_value"];
                    objData.limits = [dic objectForKey:@"limits"];
                    objData.rr_one_month = [dic objectForKey:@"rr_one_month"];
                    objData.rr_three_month = [dic objectForKey:@"rr_three_month"];
                    objData.rr_six_month = [dic objectForKey:@"rr_six_month"];
                    objData.rr_one_year = [dic objectForKey:@"rr_one_year"];
                    objData.rr_two_year = [dic objectForKey:@"rr_two_year"];
                    objData.rr_three_year = [dic objectForKey:@"rr_three_year"];
                    objData.rr_five_year = [dic objectForKey:@"rr_five_year"];
                    objData.rr_this_year = [dic objectForKey:@"rr_this_year"];
                    
					[itemList addObject:objData];
				}
			}
		}
	}
    @catch (NSException *exception) {
        if (itemList == nil)
        {
			itemList = [[NSMutableArray alloc]init];
        }
        else
        {
            [itemList removeAllObjects];
        }
    }
    @finally {
    }
    
    return self;
}

@end

