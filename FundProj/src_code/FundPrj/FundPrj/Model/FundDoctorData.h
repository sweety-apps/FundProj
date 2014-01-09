//
//  FundDoctorData.h
//  FundPrj
//
//  Created by leesea on 13-12-3.
//  Copyright (c) 2013年 leesea. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FundDoctorData : NSObject

@property (nonatomic, assign) NSInteger code;
@property (nonatomic, copy) NSString * name;
@property (nonatomic, copy) NSString * date;
@property (nonatomic, copy) NSString * company_info_name;
@property (nonatomic, copy) NSString * company_info_est_date;
@property (nonatomic, assign) NSInteger company_info_amount;
@property (nonatomic, assign) NSInteger company_info_size;
@property (nonatomic, copy) NSString * company_info_profit_status;
@property (nonatomic, copy) NSString * invest_style_stock_style;
@property (nonatomic, copy) NSString * invest_style_bond_style;
@property (nonatomic, copy) NSString * invest_style_grade;
@property (nonatomic, copy) NSString * invest_style_eval;
@property (nonatomic, copy) NSString * historys_rank;
@property (nonatomic, assign) float bonus_info_year;
@property (nonatomic, assign) float bonus_info_times;
@property (nonatomic, assign) float bonus_info_pay;
@property (nonatomic, assign) float bonus_info_net_ratio;
@property (nonatomic, assign) float bonus_info_grade;
@property (nonatomic, assign) float historys_year;
@property (nonatomic, assign) float historys_rate_return;
@property (nonatomic, assign) float historys_index_return;
@property (nonatomic, copy) NSString * judgement_stock_ability;
@property (nonatomic, copy) NSString * judgement_stock_ability_rank;
@property (nonatomic, copy) NSString * judgement_time_ability;
@property (nonatomic, copy) NSString * judgement_time_ability_rank;
@property (nonatomic, copy) NSString * profit_jensen_three_year;
@property (nonatomic, copy) NSString * profit_jensen_three_year_rank;
@property (nonatomic, copy) NSString * profit_sharpe_three_year;
@property (nonatomic, copy) NSString * profit_sharpe_three_year_rank;
@property (nonatomic, copy) NSString * profit_treynor_three_year;
@property (nonatomic, copy) NSString * profit_treynor_three_year_rank;
@property (nonatomic, copy) NSString * profit_profit_rank;
@property (nonatomic, copy) NSString * risk_beta_three_year;
@property (nonatomic, copy) NSString * risk_beta_three_year_rank;
@property (nonatomic, copy) NSString * risk_downside_three_year;
@property (nonatomic, copy) NSString * risk_downside_three_year_rank;
@property (nonatomic, copy) NSString * risk_sd_three_year;
@property (nonatomic, copy) NSString * risk_sd_three_year_rank;
@property (nonatomic, copy) NSString * risk_risk_ss_rank;


@end
