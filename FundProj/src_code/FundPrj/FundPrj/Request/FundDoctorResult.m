//
//  FundDoctorResult.m
//  FundPrj
//
//  Created by leesea on 13-12-3.
//  Copyright (c) 2013年 leesea. All rights reserved.
//

#import "FundDoctorResult.h"
#import "FundDoctorData.h"

@implementation FundDoctorResult

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
            objData = [[FundDoctorData alloc]init];
            objData.code = [[jsonObject objectForKey:@"code"]floatValue];
			objData.name = [jsonObject objectForKey:@"name"];
			objData.date = [jsonObject objectForKey:@"date"];
			if ([jsonObject objectForKey:@"basic"])
			{
				NSDictionary * dic = [jsonObject objectForKey:@"basic"];
                if ([dic objectForKey:@"company_info"])
                {
                    NSDictionary * dict = [dic objectForKey:@"company_info"];
                    objData.company_info_name = [dict objectForKey:@"name"];
                    objData.company_info_est_date = [dict objectForKey:@"est_date"];
                    objData.company_info_amount = [[dict objectForKey:@"amount"]floatValue];
                    objData.company_info_size = [[dict objectForKey:@"size"]floatValue];
                    objData.company_info_profit_status = [dict objectForKey:@"profit_status"];
                }
                if ([dic objectForKey:@"invest_style"])
                {
                    NSDictionary * dict = [dic objectForKey:@"invest_style"];
                    objData.invest_style_stock_style = [dict objectForKey:@"stock_style"];
                    objData.invest_style_bond_style = [dict objectForKey:@"bond_style"];
                    objData.invest_style_grade = [dict objectForKey:@"grade"];
                    objData.invest_style_eval = [dict objectForKey:@"eval"];
                }
			}
			if ([jsonObject objectForKey:@"risk_profit"])
			{
				NSDictionary * dic = [jsonObject objectForKey:@"risk_profit"];
                objData.historys_rank = [dic objectForKey:@"historys_rank"];
                if ([dic objectForKey:@"bonus_info"])
                {
                    NSDictionary * dict = [dic objectForKey:@"bonus_info"];
                    objData.bonus_info_year = [[dict objectForKey:@"year"]floatValue];
                    objData.bonus_info_times = [[dict objectForKey:@"times"]floatValue];
                    objData.bonus_info_pay = [[dict objectForKey:@"pay"]floatValue];
                    objData.bonus_info_net_ratio = [[dict objectForKey:@"net_ratio"]floatValue];
                    objData.bonus_info_grade = [[dict objectForKey:@"grade"]floatValue];
                }
                if ([dic objectForKey:@"historys"])
                {
                    NSDictionary * dict = [dic objectForKey:@"historys"];
                    objData.historys_year = [[dict objectForKey:@"year"]floatValue];
                    objData.historys_rate_return = [[dict objectForKey:@"rate_return"]floatValue];
                    objData.historys_index_return = [[dict objectForKey:@"index_return"]floatValue];
                }
                if ([dic objectForKey:@"judgement"])
                {
                    NSDictionary * dict = [dic objectForKey:@"judgement"];
                    objData.judgement_stock_ability = [dict objectForKey:@"stock_ability"];
                    objData.judgement_stock_ability_rank = [dict objectForKey:@"stock_ability_rank"];
                    objData.judgement_time_ability = [dict objectForKey:@"time_ability"];
                    objData.judgement_time_ability_rank = [dict objectForKey:@"time_ability_rank"];
                }
                if ([dic objectForKey:@"profit"])
                {
                    NSDictionary * dict = [dic objectForKey:@"profit"];
                    objData.profit_jensen_three_year = [dict objectForKey:@"jensen_three_year"];
                    objData.profit_jensen_three_year_rank = [dict objectForKey:@"jensen_three_year_rank"];
                    objData.profit_sharpe_three_year = [dict objectForKey:@"sharpe_three_year"];
                    objData.profit_sharpe_three_year_rank = [dict objectForKey:@"sharpe_three_year_rank"];
                    objData.profit_treynor_three_year = [dict objectForKey:@"treynor_three_year"];
                    objData.profit_treynor_three_year_rank = [dict objectForKey:@"treynor_three_year_rank"];
                    objData.profit_profit_rank = [dict objectForKey:@"profit_rank"];
                }
                if ([dic objectForKey:@"risk"])
                {
                    NSDictionary * dict = [dic objectForKey:@"risk"];
                    objData.risk_beta_three_year = [dict objectForKey:@"beta_three_year"];
                    objData.risk_beta_three_year_rank = [dict objectForKey:@"beta_three_year_rank"];
                    objData.risk_downside_three_year = [dict objectForKey:@"downside_three_year"];
                    objData.risk_downside_three_year_rank = [dict objectForKey:@"downside_three_year_rank"];
                    objData.risk_sd_three_year = [dict objectForKey:@"sd_three_year"];
                    objData.risk_sd_three_year_rank = [dict objectForKey:@"sd_three_year_rank"];
                    objData.risk_risk_ss_rank = [dict objectForKey:@"risk_ss_rank"];
                }
			}
		}
	}
    @catch (NSException *exception) {
        if (objData == nil)
        {
			objData = [[FundDoctorData alloc]init];
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

