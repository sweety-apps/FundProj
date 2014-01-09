//
//  FundDetailPercentResult.m
//  FundPrj
//
//  Created by leesea on 13-12-2.
//  Copyright (c) 2013年 leesea. All rights reserved.
//

#import "FundDetailPercentResult.h"
#import "FundDetailPercentData.h"

@implementation FundDetailPercentResult

@synthesize retcode;
@synthesize retnum;
@synthesize msg;
@synthesize objData;

- (id)initWithJSONObject:(NSDictionary *)jsonObject
{
    self = [super init];
    
    @try {
		if (self)
		{
			retcode = [[jsonObject objectForKey:@"retcode"] intValue];
			retnum = [[jsonObject objectForKey:@"retnum"] intValue];
			msg = [jsonObject objectForKey:@"msg"];
            objData = [[FundDetailPercentData alloc]init];
			objData.name = [jsonObject objectForKey:@"name"];
			objData.code = [[jsonObject objectForKey:@"code"]intValue];
			if ([jsonObject objectForKey:@"asset"])
			{
				NSDictionary * dic = [jsonObject objectForKey:@"asset"];
                objData.stock_ratio = [[dic objectForKey:@"stock_ratio"]floatValue];
                objData.bond_ratio = [[dic objectForKey:@"bond_ratio"]floatValue];
                objData.warrant_ratio = [[dic objectForKey:@"warrant_ratio"]floatValue];
                objData.money_ratio = [[dic objectForKey:@"money_ratio"]floatValue];
                objData.other_ratio = [[dic objectForKey:@"other_ratio"]floatValue];
			}
			if ([jsonObject objectForKey:@"industry"])
			{
				NSDictionary * dic = [jsonObject objectForKey:@"industry"];
                objData.A = [[dic objectForKey:@"A"]floatValue];
                objData.B = [[dic objectForKey:@"B"]floatValue];
                objData.C = [[dic objectForKey:@"C"]floatValue];
                objData.D = [[dic objectForKey:@"D"]floatValue];
                objData.E = [[dic objectForKey:@"E"]floatValue];
                objData.F = [[dic objectForKey:@"F"]floatValue];
                objData.G = [[dic objectForKey:@"G"]floatValue];
                objData.H = [[dic objectForKey:@"H"]floatValue];
                objData.I = [[dic objectForKey:@"I"]floatValue];
                objData.J = [[dic objectForKey:@"J"]floatValue];
                objData.K = [[dic objectForKey:@"K"]floatValue];
                objData.L = [[dic objectForKey:@"L"]floatValue];
                objData.M = [[dic objectForKey:@"M"]floatValue];
                objData.N = [[dic objectForKey:@"N"]floatValue];
                objData.O = [[dic objectForKey:@"O"]floatValue];
                objData.P = [[dic objectForKey:@"P"]floatValue];
                objData.Q = [[dic objectForKey:@"Q"]floatValue];
                objData.R = [[dic objectForKey:@"R"]floatValue];
                objData.S = [[dic objectForKey:@"S"]floatValue];
			}
		}
	}
    @catch (NSException *exception) {
        if (objData == nil)
        {
			objData = [[FundDetailPercentData alloc]init];
        }
        else
        {
        }
    }
    @finally {
    }
    
    return self;
}

@end

