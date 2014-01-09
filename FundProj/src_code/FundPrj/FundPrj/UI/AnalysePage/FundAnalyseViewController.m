//
//  FundAnalyseViewController.m
//  FundPrj
//
//  Created by leesea on 13-11-11.
//  Copyright (c) 2013年 leesea. All rights reserved.
//

#import "FundAnalyseViewController.h"
#import "FundNotMoneyData.h"
#import "FundMoneyData.h"
#import "FundRankNotMoneyData.h"
#import "FundRankMoneyData.h"
#import "FundQuoteRequest.h"
#import "FundQuoteData.h"
#import "FMDatabase.h"
#import "FMDatabaseQueue.h"
#import "FundQuoteHistoryRequest.h"
#import "FundQuoteHistoryData.h"
#import "FundDetailInfoRequst.h"
#import "FundDetailInfoData.h"
#import "FundManagerInfoRequest.h"
#import "FundManagerInfoData.h"
#import "NTChartView.h"
#import "PCPieChart.h"
#import "FundDoctorRequest.h"
#import "FundDoctorData.h"


#define DB_NAME    @"FundDB.sqlite"
#define NAME      @"name"
#define CODE       @"code"
#define PY   @"py"

typedef enum _FundType {
	MoneyType = 0,
    NotMoneyType = 1
} FundType;

@interface FundAnalyseViewController ()
{
    UIView * bodyView;
    
    UIButton * doctorBtn;
    UIButton * infoBtn;
    UIButton * riskBtn;
    UIButton * managerBtn;
    UIImageView * btnBgImgView;
    
    UIView * doctorView;
    UIView * infoView;
    UIView * riskView;
    UIView * managerView;
    
    NSString *db_path;
    
    FMDatabase *dbBase;
    NSInteger fundCode;
    FundType type;
    
    FundDoctorRequest * doctorRequest;
    FundDoctorData * doctorData;
}

@end

@implementation FundAnalyseViewController

- (id)initWithFundCode:(NSInteger)code
{
    self = [super init];
    if (self) {
        // Custom initialization
        fundCode = code;
        
        type = MoneyType;
        
        db_path = [PATH_OF_DOCUMENT stringByAppendingPathComponent:DB_NAME];
        dbBase = [FMDatabase databaseWithPath:db_path];
    }
    return self;
}

- (void)backBtnPress:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)refreshBtnPress:(id)sender
{
}

- (void)bondBtnPress:(id)sender
{
    
}

- (void)followBtnPress:(id)sender
{
    
}

- (void)buildHeaderView
{
    UIImage *syncBgImg = [UIImage imageNamed:@"detail_04"];
    UIView * headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 1024, 86)];
    headerView.backgroundColor = [[UIColor alloc] initWithPatternImage:syncBgImg];
    [self.view addSubview:headerView];
    UIButton * backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(0, 0, 63, 86);
    [backBtn setBackgroundImage:[UIImage imageNamed:@"detail_02"] forState:UIControlStateNormal];
    [backBtn setBackgroundImage:[UIImage imageNamed:@"detail_02"] forState:UIControlStateHighlighted];
    [backBtn addTarget:self action:@selector(backBtnPress:) forControlEvents:UIControlEventTouchUpInside];
    [headerView addSubview:backBtn];
    UIButton * refrashBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    refrashBtn.frame = CGRectMake(1024-63, 0, 63, 86);
    [refrashBtn setBackgroundImage:[UIImage imageNamed:@"detail_06"] forState:UIControlStateNormal];
    [refrashBtn setBackgroundImage:[UIImage imageNamed:@"detail_06"] forState:UIControlStateHighlighted];
    [refrashBtn addTarget:self action:@selector(refreshBtnPress:) forControlEvents:UIControlEventTouchUpInside];
    [headerView addSubview:refrashBtn];
    UIImageView * line = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"detail_08"]];
    line.frame = CGRectMake(63+286, (86-68)/2, 3, 68);
    [headerView addSubview:line];
    UILabel * nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(63+13, 12, 286-13-17, 30)];
    [nameLabel setTextAlignment:NSTextAlignmentCenter];
    [nameLabel setTextColor:[UIColor whiteColor]];
    [nameLabel setFont:[UIFont systemFontOfSize:30]];
    [nameLabel setBackgroundColor:[UIColor clearColor]];
    [headerView addSubview:nameLabel];
    UILabel * codeLabel = [[UILabel alloc] initWithFrame:CGRectMake(63+13, 12*2+30, 64, 18)];
    [codeLabel setTextAlignment:NSTextAlignmentCenter];
    [codeLabel setTextColor:[UIColor whiteColor]];
    [codeLabel setFont:[UIFont systemFontOfSize:18]];
    [codeLabel setBackgroundColor:[UIColor clearColor]];
    codeLabel.text = [NSString stringWithFormat:@"%d", fundCode ];
    [headerView addSubview:codeLabel];
    UIButton * bondBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    bondBtn.frame = CGRectMake(158, 50, 85, 23);
    bondBtn.backgroundColor = [UIColor colorWithHexValue:0xdce3e9];
    UILabel * label = bondBtn.titleLabel;
    label.font = [UIFont boldSystemFontOfSize:12];
    [bondBtn setTintColor:[UIColor whiteColor]];
    //    [bondBtn setBackgroundImage:[UIImage imageNamed:@"detail_11"] forState:UIControlStateNormal];
    //    [bondBtn setBackgroundImage:[UIImage imageNamed:@"detail_11"] forState:UIControlStateHighlighted];
    [bondBtn addTarget:self action:@selector(bondBtnPress:) forControlEvents:UIControlEventTouchUpInside];
    [headerView addSubview:bondBtn];
    UIButton * followBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    followBtn.frame = CGRectMake(255, 50, 63, 23);
    [followBtn setBackgroundImage:[UIImage imageNamed:@"detail_14"] forState:UIControlStateNormal];
    [followBtn setBackgroundImage:[UIImage imageNamed:@"detail_14"] forState:UIControlStateHighlighted];
    [followBtn addTarget:self action:@selector(followBtnPress:) forControlEvents:UIControlEventTouchUpInside];
    [headerView addSubview:followBtn];
    
    UILabel * label11 = [[UILabel alloc] initWithFrame:CGRectMake(63+286+17, 20, 60, 14)];
    [label11 setTextAlignment:NSTextAlignmentLeft];
    [label11 setTextColor:[UIColor whiteColor]];
    [label11 setFont:[UIFont systemFontOfSize:14]];
    [label11 setBackgroundColor:[UIColor clearColor]];
    [headerView addSubview:label11];
    UILabel * label12 = [[UILabel alloc] initWithFrame:CGRectMake(63+286+17+10+60, 15, 100, 24)];
    [label12 setTextAlignment:NSTextAlignmentLeft];
    [label12 setTextColor:[UIColor redColor]];
    [label12 setFont:[UIFont systemFontOfSize:24]];
    [label12 setBackgroundColor:[UIColor clearColor]];
    [headerView addSubview:label12];
    UILabel * label13 = [[UILabel alloc] initWithFrame:CGRectMake(63+286+17*2+60+100, 20, 100, 14)];
    [label13 setTextAlignment:NSTextAlignmentLeft];
    [label13 setTextColor:[UIColor whiteColor]];
    [label13 setFont:[UIFont systemFontOfSize:14]];
    [label13 setBackgroundColor:[UIColor clearColor]];
    [headerView addSubview:label13];
    UILabel * label14 = [[UILabel alloc] initWithFrame:CGRectMake(63+286+17*2+60+100+100, 15, 60, 24)];
    [label14 setTextAlignment:NSTextAlignmentLeft];
    [label14 setTextColor:[UIColor redColor]];
    [label14 setFont:[UIFont systemFontOfSize:24]];
    [label14 setBackgroundColor:[UIColor clearColor]];
    [headerView addSubview:label14];
    UILabel * label15 = [[UILabel alloc] initWithFrame:CGRectMake(63+286+17*3+60+100+100+60, 20, 40, 14)];
    [label15 setTextAlignment:NSTextAlignmentLeft];
    [label15 setTextColor:[UIColor whiteColor]];
    [label15 setFont:[UIFont systemFontOfSize:14]];
    [label15 setBackgroundColor:[UIColor clearColor]];
    label15.text = @"增长";
    [headerView addSubview:label15];
    UILabel * label16 = [[UILabel alloc] initWithFrame:CGRectMake(63+286+17*3+60+100+100+60+40, 15, 100, 24)];
    [label16 setTextAlignment:NSTextAlignmentLeft];
    [label16 setTextColor:[UIColor greenColor]];
    [label16 setFont:[UIFont systemFontOfSize:24]];
    [label16 setBackgroundColor:[UIColor clearColor]];
    [headerView addSubview:label16];
    UILabel * label17 = [[UILabel alloc] initWithFrame:CGRectMake(63+286+17*3+60+100+100+60+40+100, 15, 100, 24)];
    [label17 setTextAlignment:NSTextAlignmentLeft];
    [label17 setTextColor:[UIColor greenColor]];
    [label17 setFont:[UIFont systemFontOfSize:24]];
    [label17 setBackgroundColor:[UIColor clearColor]];
    [headerView addSubview:label17];
    
    UILabel * label21 = [[UILabel alloc] initWithFrame:CGRectMake(63+286+17, 52, 60, 14)];
    [label21 setTextAlignment:NSTextAlignmentLeft];
    [label21 setTextColor:[UIColor whiteColor]];
    [label21 setFont:[UIFont systemFontOfSize:14]];
    [label21 setBackgroundColor:[UIColor clearColor]];
    label21.text = @"净值日期";
    [headerView addSubview:label21];
    UILabel * label22 = [[UILabel alloc] initWithFrame:CGRectMake(63+286+17+10+60, 52, 100, 14)];
    [label22 setTextAlignment:NSTextAlignmentLeft];
    [label22 setTextColor:[UIColor whiteColor]];
    [label22 setFont:[UIFont systemFontOfSize:14]];
    [label22 setBackgroundColor:[UIColor clearColor]];
    [headerView addSubview:label22];
    UILabel * label23 = [[UILabel alloc] initWithFrame:CGRectMake(63+286+17*2+60+100, 52, 100, 14)];
    [label23 setTextAlignment:NSTextAlignmentLeft];
    [label23 setTextColor:[UIColor whiteColor]];
    [label23 setFont:[UIFont systemFontOfSize:14]];
    [label23 setBackgroundColor:[UIColor clearColor]];
    label23.text = @"基金评级";
    [headerView addSubview:label23];
    UILabel * label24 = [[UILabel alloc] initWithFrame:CGRectMake(63+286+17*2+60+100+100, 52, 60, 14)];
    [label24 setTextAlignment:NSTextAlignmentLeft];
    [label24 setTextColor:[UIColor whiteColor]];
    [label24 setFont:[UIFont systemFontOfSize:14]];
    [label24 setBackgroundColor:[UIColor clearColor]];
    [headerView addSubview:label24];
    UILabel * label25 = [[UILabel alloc] initWithFrame:CGRectMake(63+286+17*3+60+100+100+60, 52, 70, 14)];
    [label25 setTextAlignment:NSTextAlignmentLeft];
    [label25 setTextColor:[UIColor whiteColor]];
    [label25 setFont:[UIFont systemFontOfSize:14]];
    [label25 setBackgroundColor:[UIColor clearColor]];
    label25.text = @"申购状态";
    [headerView addSubview:label25];
    UILabel * label26 = [[UILabel alloc] initWithFrame:CGRectMake(63+286+17*3+60+100+100+60+70, 52, 40, 14)];
    [label26 setTextAlignment:NSTextAlignmentLeft];
    [label26 setTextColor:[UIColor redColor]];
    [label26 setFont:[UIFont systemFontOfSize:14]];
    [label26 setBackgroundColor:[UIColor clearColor]];
    [headerView addSubview:label26];
    UILabel * label27 = [[UILabel alloc] initWithFrame:CGRectMake(63+286+17*4+60+100+100+60+70+40, 52, 60, 14)];
    [label27 setTextAlignment:NSTextAlignmentLeft];
    [label27 setTextColor:[UIColor greenColor]];
    [label27 setFont:[UIFont systemFontOfSize:14]];
    [label27 setBackgroundColor:[UIColor clearColor]];
    label27.text = @"赎回状态";
    [headerView addSubview:label27];
    UILabel * label28 = [[UILabel alloc] initWithFrame:CGRectMake(63+286+17*4+60+100+100+60+70+40+70, 52, 100, 14)];
    [label28 setTextAlignment:NSTextAlignmentLeft];
    [label28 setTextColor:[UIColor redColor]];
    [label28 setFont:[UIFont systemFontOfSize:14]];
    [label28 setBackgroundColor:[UIColor clearColor]];
    [headerView addSubview:label28];
    
    
    if ([dbBase open]) {
        NSString *sqlMoneyQuery = [NSString stringWithFormat:@"SELECT * FROM FUNDMONEY WHERE %@ = '%d'", @"code", fundCode ];
        FMResultSet * rs = [dbBase executeQuery:sqlMoneyQuery];
        while ([rs next]) {
            
            type = MoneyType;
            
            nameLabel.text = [rs stringForColumn:@"name"];
            
            NSString * str = [rs stringForColumn:@"type"];
            if ([str isEqualToString:@"A"]) {
                [bondBtn setTitle:@"股票型" forState:UIControlStateNormal];
            }
            if ([str isEqualToString:@"B"]) {
                [bondBtn setTitle:@"普通债券型" forState:UIControlStateNormal];
            }
            if ([str isEqualToString:@"C"]) {
                [bondBtn setTitle:@"激进债券" forState:UIControlStateNormal];
            }
            if ([str isEqualToString:@"D"]) {
                [bondBtn setTitle:@"纯债基金" forState:UIControlStateNormal];
            }
            if ([str isEqualToString:@"E"]) {
                [bondBtn setTitle:@"普通混合型" forState:UIControlStateNormal];
            }
            if ([str isEqualToString:@"F"]) {
                [bondBtn setTitle:@"保守混合型" forState:UIControlStateNormal];
            }
            if ([str isEqualToString:@"G"]) {
                [bondBtn setTitle:@"激进混合型" forState:UIControlStateNormal];
            }
            if ([str isEqualToString:@"H"]) {
                [bondBtn setTitle:@"货币型" forState:UIControlStateNormal];
            }
            if ([str isEqualToString:@"I"]) {
                [bondBtn setTitle:@"短债基金" forState:UIControlStateNormal];
            }
            if ([str isEqualToString:@"J"]) {
                [bondBtn setTitle:@"FOF" forState:UIControlStateNormal];
            }
            if ([str isEqualToString:@"K"]) {
                [bondBtn setTitle:@"保本基金" forState:UIControlStateNormal];
            }
            if ([str isEqualToString:@"L"]) {
                [bondBtn setTitle:@"普通型指数基金" forState:UIControlStateNormal];
            }
            if ([str isEqualToString:@"M"]) {
                [bondBtn setTitle:@"增强型指数基金" forState:UIControlStateNormal];
            }
            if ([str isEqualToString:@"N"]) {
                [bondBtn setTitle:@"分级基金" forState:UIControlStateNormal];
            }
            if ([str isEqualToString:@"O"]) {
                [bondBtn setTitle:@"其它" forState:UIControlStateNormal];
            }
            
            label11.text = @"万分收益";
            int intValue = [rs intForColumn:@"pay_price"];
            label12.text = [[NSString alloc]initWithFormat:@"%d", intValue];
            label13.text = @"7日年化收益率";
            intValue = [rs intForColumn:@"seven_areturn"];
            label14.text = [[NSString alloc]initWithFormat:@"%d", intValue];
            
            //            intValue = sqlite3_column_int(statement, 10);
            //            label16.text = [[NSString alloc]initWithFormat:@"%d", intValue];
            //            intValue = sqlite3_column_int(statement, 11);
            //            label17.text = [[NSString alloc]initWithFormat:@"%d", intValue];
            label16.text = @"--";
            label17.text = @"--";
            
            label22.text = [rs stringForColumn:@"date"];
            //            strValue = (char*)sqlite3_column_text(statement, 13);
            //            label24.text = [[NSString alloc]initWithUTF8String:strValue];
            label24.text = @"--";
            
            intValue = [rs intForColumn:@"pur_status"];
            if (intValue == 1) {
                label26.text = @"是";
            }
            else {
                label26.text = @"否";
            }
            intValue = [rs intForColumn:@"redeem_status"];
            if (intValue == 1) {
                label28.text = @"是";
            }
            else {
                label28.text = @"否";
            }
            
        }
        
        
        NSString *sqlNotMoneyQuery = [NSString stringWithFormat:@"SELECT * FROM FUNDNOTMONEY WHERE %@ = '%d'", @"code", fundCode ];
        FMResultSet * rs1 = [dbBase executeQuery:sqlNotMoneyQuery];
        while ([rs1 next]) {
            
            type = NotMoneyType;
            
            nameLabel.text = [rs1 stringForColumn:@"name"];
            
            NSString * str = [rs1 stringForColumn:@"type"];
            if ([str isEqualToString:@"A"]) {
                [bondBtn setTitle:@"股票型" forState:UIControlStateNormal];
            }
            if ([str isEqualToString:@"B"]) {
                [bondBtn setTitle:@"普通债券型" forState:UIControlStateNormal];
            }
            if ([str isEqualToString:@"C"]) {
                [bondBtn setTitle:@"激进债券" forState:UIControlStateNormal];
            }
            if ([str isEqualToString:@"D"]) {
                [bondBtn setTitle:@"纯债基金" forState:UIControlStateNormal];
            }
            if ([str isEqualToString:@"E"]) {
                [bondBtn setTitle:@"普通混合型" forState:UIControlStateNormal];
            }
            if ([str isEqualToString:@"F"]) {
                [bondBtn setTitle:@"保守混合型" forState:UIControlStateNormal];
            }
            if ([str isEqualToString:@"G"]) {
                [bondBtn setTitle:@"激进混合型" forState:UIControlStateNormal];
            }
            if ([str isEqualToString:@"H"]) {
                [bondBtn setTitle:@"货币型" forState:UIControlStateNormal];
            }
            if ([str isEqualToString:@"I"]) {
                [bondBtn setTitle:@"短债基金" forState:UIControlStateNormal];
            }
            if ([str isEqualToString:@"J"]) {
                [bondBtn setTitle:@"FOF" forState:UIControlStateNormal];
            }
            if ([str isEqualToString:@"K"]) {
                [bondBtn setTitle:@"保本基金" forState:UIControlStateNormal];
            }
            if ([str isEqualToString:@"L"]) {
                [bondBtn setTitle:@"普通型指数基金" forState:UIControlStateNormal];
            }
            if ([str isEqualToString:@"M"]) {
                [bondBtn setTitle:@"增强型指数基金" forState:UIControlStateNormal];
            }
            if ([str isEqualToString:@"N"]) {
                [bondBtn setTitle:@"分级基金" forState:UIControlStateNormal];
            }
            if ([str isEqualToString:@"O"]) {
                [bondBtn setTitle:@"其它" forState:UIControlStateNormal];
            }
            
            label11.text = @"最新净值";
            int intValue = [rs1 intForColumn:@"net_value"];
            label12.text = [[NSString alloc]initWithFormat:@"%d", intValue];
            label13.text = @"累计净值";
            intValue = [rs1 intForColumn:@"account_value"];
            label14.text = [[NSString alloc]initWithFormat:@"%d", intValue];
            
            intValue = [rs1 intForColumn:@"limits"];
            label16.text = [[NSString alloc]initWithFormat:@"%d", intValue];
            intValue = [rs1 intForColumn:@"updown"];
            label17.text = [[NSString alloc]initWithFormat:@"%d", intValue];
            
            label22.text = [rs1 stringForColumn:@"date"];
            intValue = [rs1 intForColumn:@"grade"];
            label24.text = [[NSString alloc]initWithFormat:@"%d", intValue];
            
            intValue = [rs1 intForColumn:@"pur_status"];
            if (intValue == 1) {
                label26.text = @"是";
            }
            else {
                label26.text = @"否";
            }
            intValue = [rs1 intForColumn:@"redeem_status"];
            if (intValue == 1) {
                label28.text = @"是";
            }
            else {
                label28.text = @"否";
            }
        }
        
        
        [dbBase close];
    }
}

- (void)bodyHeaderBtnPress:(id)sender
{
    UIButton * btnClick = (UIButton *)sender;
    if (btnClick == doctorBtn) {
        btnBgImgView.frame = CGRectMake(0, 0, 129, 44);
        [doctorBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [doctorBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        [infoBtn setTitleColor:[UIColor colorWithHexValue:0x415c7a] forState:UIControlStateNormal];
        [infoBtn setTitleColor:[UIColor colorWithHexValue:0x415c7a] forState:UIControlStateSelected];
        [riskBtn setTitleColor:[UIColor colorWithHexValue:0x415c7a] forState:UIControlStateNormal];
        [riskBtn setTitleColor:[UIColor colorWithHexValue:0x415c7a] forState:UIControlStateSelected];
        [managerBtn setTitleColor:[UIColor colorWithHexValue:0x415c7a] forState:UIControlStateNormal];
        [managerBtn setTitleColor:[UIColor colorWithHexValue:0x415c7a] forState:UIControlStateSelected];
        [bodyView bringSubviewToFront:doctorView];
    }
    else if (btnClick == infoBtn) {
        btnBgImgView.frame = CGRectMake(129, 0, 129, 44);
        [doctorBtn setTitleColor:[UIColor colorWithHexValue:0x415c7a] forState:UIControlStateNormal];
        [doctorBtn setTitleColor:[UIColor colorWithHexValue:0x415c7a] forState:UIControlStateSelected];
        [infoBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [infoBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        [riskBtn setTitleColor:[UIColor colorWithHexValue:0x415c7a] forState:UIControlStateNormal];
        [riskBtn setTitleColor:[UIColor colorWithHexValue:0x415c7a] forState:UIControlStateSelected];
        [managerBtn setTitleColor:[UIColor colorWithHexValue:0x415c7a] forState:UIControlStateNormal];
        [managerBtn setTitleColor:[UIColor colorWithHexValue:0x415c7a] forState:UIControlStateSelected];
        [bodyView bringSubviewToFront:infoView];
    }
    else if (btnClick == riskBtn) {
        btnBgImgView.frame = CGRectMake(129*2, 0, 129, 44);
        [doctorBtn setTitleColor:[UIColor colorWithHexValue:0x415c7a] forState:UIControlStateNormal];
        [doctorBtn setTitleColor:[UIColor colorWithHexValue:0x415c7a] forState:UIControlStateSelected];
        [infoBtn setTitleColor:[UIColor colorWithHexValue:0x415c7a] forState:UIControlStateNormal];
        [infoBtn setTitleColor:[UIColor colorWithHexValue:0x415c7a] forState:UIControlStateSelected];
        [riskBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [riskBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        [managerBtn setTitleColor:[UIColor colorWithHexValue:0x415c7a] forState:UIControlStateNormal];
        [managerBtn setTitleColor:[UIColor colorWithHexValue:0x415c7a] forState:UIControlStateSelected];
        [bodyView bringSubviewToFront:riskView];
    }
    else if (btnClick == managerBtn) {
        btnBgImgView.frame = CGRectMake(129*3, 0, 129, 44);
        [doctorBtn setTitleColor:[UIColor colorWithHexValue:0x415c7a] forState:UIControlStateNormal];
        [doctorBtn setTitleColor:[UIColor colorWithHexValue:0x415c7a] forState:UIControlStateSelected];
        [infoBtn setTitleColor:[UIColor colorWithHexValue:0x415c7a] forState:UIControlStateNormal];
        [infoBtn setTitleColor:[UIColor colorWithHexValue:0x415c7a] forState:UIControlStateSelected];
        [riskBtn setTitleColor:[UIColor colorWithHexValue:0x415c7a] forState:UIControlStateNormal];
        [riskBtn setTitleColor:[UIColor colorWithHexValue:0x415c7a] forState:UIControlStateSelected];
        [managerBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [managerBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        [bodyView bringSubviewToFront:managerView];
    }
}

- (void)doctorRefreshBtnPress:(id)sender
{
    
}

- (UIView *)buildDoctorTableCell:(NSString *)str1 str2:(NSString *)str2 str3:(NSString *)str3
{
    UIView * cell = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 948, 44)];
    cell.backgroundColor = [UIColor clearColor];
    UILabel * _tableCellLabel11 = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, 150, 44)];
    [_tableCellLabel11 setTextAlignment:NSTextAlignmentLeft];
    [_tableCellLabel11 setTextColor:[UIColor blackColor]];
    [_tableCellLabel11 setFont:[UIFont systemFontOfSize:14]];
    [_tableCellLabel11 setBackgroundColor:[UIColor clearColor]];
    _tableCellLabel11.text = str1;
    [cell addSubview:_tableCellLabel11];
    UILabel * _tableCellLabel12 = [[UILabel alloc] initWithFrame:CGRectMake(144, 0, 150, 44)];
    [_tableCellLabel12 setTextAlignment:NSTextAlignmentLeft];
    [_tableCellLabel12 setTextColor:[UIColor colorWithHexValue:0x7a7a7a]];
    [_tableCellLabel12 setFont:[UIFont systemFontOfSize:14]];
    [_tableCellLabel12 setBackgroundColor:[UIColor clearColor]];
    _tableCellLabel12.text = str2;
    [cell addSubview:_tableCellLabel12];
    UILabel * _tableCellLabel13 = [[UILabel alloc] initWithFrame:CGRectMake(300, 0, 948-300-20, 44)];
    [_tableCellLabel13 setTextAlignment:NSTextAlignmentLeft];
    [_tableCellLabel13 setTextColor:[UIColor colorWithHexValue:0x7a7a7a]];
    [_tableCellLabel13 setFont:[UIFont systemFontOfSize:14]];
    [_tableCellLabel13 setBackgroundColor:[UIColor clearColor]];
    _tableCellLabel13.text = str3;
    [cell addSubview:_tableCellLabel13];
    return cell;
}

- (void)buildDoctorView
{
    doctorView = [[UIView alloc]initWithFrame:CGRectMake(18, 20+36, 984-18*2, 577-20)];
    doctorView.backgroundColor = [UIColor whiteColor];
    [bodyView addSubview:doctorView];
    
    UIView * chartView = [[UIView alloc]initWithFrame:CGRectMake(17, 0, 279, 194)];
    chartView.backgroundColor = [UIColor lightGrayColor];
    [doctorView addSubview:chartView];
    
    UILabel * _riskLabel = [[UILabel alloc] initWithFrame:CGRectMake(440, 26, 30, 14)];
    [_riskLabel setTextAlignment:NSTextAlignmentLeft];
    [_riskLabel setTextColor:[UIColor blackColor]];
    [_riskLabel setFont:[UIFont systemFontOfSize:14]];
    [_riskLabel setBackgroundColor:[UIColor clearColor]];
    _riskLabel.text = @"风险";
    [doctorView addSubview:_riskLabel];
    UILabel * _timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(776, 12, 80, 14)];
    [_timeLabel setTextAlignment:NSTextAlignmentLeft];
    [_timeLabel setTextColor:[UIColor blackColor]];
    [_timeLabel setFont:[UIFont systemFontOfSize:14]];
    [_timeLabel setBackgroundColor:[UIColor clearColor]];
    _timeLabel.text = @"截止2013/4";
    [doctorView addSubview:_timeLabel];
    UIButton * refreshBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    refreshBtn.frame = CGRectMake(858, 2, 90, 26);
    refreshBtn.backgroundColor = [UIColor colorWithHexValue:0x1abd9b];
    [refreshBtn setTitle:@"查看最新数据" forState:UIControlStateNormal];
    [refreshBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    UILabel * label = refreshBtn.titleLabel;
    label.font = [UIFont boldSystemFontOfSize:14];
    [refreshBtn addTarget:self action:@selector(doctorRefreshBtnPress:) forControlEvents:UIControlEventTouchUpInside];
    [doctorView addSubview:refreshBtn];
    UIView * imgView = [[UIView alloc]initWithFrame:CGRectMake(404, 42, 509, 32)];
    imgView.backgroundColor = [UIColor lightGrayColor];
    [doctorView addSubview:imgView];
    UILabel * _label1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 102, 32)];
    [_label1 setTextAlignment:NSTextAlignmentCenter];
    [_label1 setTextColor:[UIColor whiteColor]];
    [_label1 setFont:[UIFont systemFontOfSize:14]];
    [_label1 setBackgroundColor:[UIColor clearColor]];
    _label1.text = @"低";
    [imgView addSubview:_label1];
    UILabel * _label2 = [[UILabel alloc] initWithFrame:CGRectMake(102, 0, 102, 32)];
    [_label2 setTextAlignment:NSTextAlignmentCenter];
    [_label2 setTextColor:[UIColor whiteColor]];
    [_label2 setFont:[UIFont systemFontOfSize:14]];
    [_label2 setBackgroundColor:[UIColor clearColor]];
    _label2.text = @"偏低";
    [imgView addSubview:_label2];
    UILabel * _label3 = [[UILabel alloc] initWithFrame:CGRectMake(102*2, 0, 102, 32)];
    [_label3 setTextAlignment:NSTextAlignmentCenter];
    [_label3 setTextColor:[UIColor whiteColor]];
    [_label3 setFont:[UIFont systemFontOfSize:14]];
    [_label3 setBackgroundColor:[UIColor clearColor]];
    _label3.text = @"中";
    [imgView addSubview:_label3];
    UILabel * _label4 = [[UILabel alloc] initWithFrame:CGRectMake(102*3, 0, 102, 32)];
    [_label4 setTextAlignment:NSTextAlignmentCenter];
    [_label4 setTextColor:[UIColor whiteColor]];
    [_label4 setFont:[UIFont systemFontOfSize:14]];
    [_label4 setBackgroundColor:[UIColor clearColor]];
    _label4.text = @"偏高";
    [imgView addSubview:_label4];
    UILabel * _label5 = [[UILabel alloc] initWithFrame:CGRectMake(102*4, 0, 102, 32)];
    [_label5 setTextAlignment:NSTextAlignmentCenter];
    [_label5 setTextColor:[UIColor whiteColor]];
    [_label5 setFont:[UIFont systemFontOfSize:14]];
    [_label5 setBackgroundColor:[UIColor clearColor]];
    _label5.text = @"高";
    [imgView addSubview:_label5];
    UILabel * _repayLabel = [[UILabel alloc] initWithFrame:CGRectMake(440+102*3, 84, 30, 14)];
    [_repayLabel setTextAlignment:NSTextAlignmentLeft];
    [_repayLabel setTextColor:[UIColor blackColor]];
    [_repayLabel setFont:[UIFont systemFontOfSize:14]];
    [_repayLabel setBackgroundColor:[UIColor clearColor]];
    _repayLabel.text = @"回报";
    [doctorView addSubview:_repayLabel];
    UILabel * _commentLabel = [[UILabel alloc] initWithFrame:CGRectMake(392, 104, 80, 16)];
    [_commentLabel setTextAlignment:NSTextAlignmentLeft];
    [_commentLabel setTextColor:[UIColor colorWithHexValue:0xc32421]];
    [_commentLabel setFont:[UIFont systemFontOfSize:16]];
    [_commentLabel setBackgroundColor:[UIColor clearColor]];
    _commentLabel.text = @"综合评述";
    [doctorView addSubview:_commentLabel];
    UILabel * _commentDetailLabel = [[UILabel alloc] initWithFrame:CGRectMake(392, 128, 530, 66)];
    [_commentDetailLabel setTextAlignment:NSTextAlignmentLeft];
    [_commentDetailLabel setTextColor:[UIColor blackColor]];
    [_commentDetailLabel setFont:[UIFont systemFontOfSize:16]];
    [_commentDetailLabel setBackgroundColor:[UIColor clearColor]];
    _commentDetailLabel.numberOfLines = 0;
    _commentDetailLabel.text = @"从历史数据来看，目前大盘蓝筹股具备做多优势。一方面，大盘估值水平便宜。本轮调整上证指数的最低点为2132点，蓝筹股对应的市盈率为11倍，低于2008年1664点时的13.5倍；另一方面，市场活跃度有所提升。";
    [doctorView addSubview:_commentDetailLabel];
    
    UIView * tableView = [[UIView alloc]initWithFrame:CGRectMake(0, 208, 948, 324)];
    [doctorView addSubview:tableView];
    UIImageView * tableHeaderView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"risk1_03"]];
    tableHeaderView.frame = CGRectMake(0, 0, 948, 34);
    [tableView addSubview:tableHeaderView];
    UIScrollView * scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 34, 948, 324-34)];
    scrollView.backgroundColor = [UIColor clearColor];
    [tableView addSubview:scrollView];
    UIView * cell1 = [self buildDoctorTableCell:@"基金经理" str2:@"一般" str3:@"童汀自上任华夏成长基金经理以来，最近一年的回报率为99%，与同期基准指数相比居中"];
    cell1.frame = CGRectMake(0, 0, 948, 44);
    [scrollView addSubview:cell1];
    UIView * cell2 = [self buildDoctorTableCell:@"历史回报" str2:@"一般" str3:@"与同类型基金相比，该基金历史回报率居中"];
    cell2.frame = CGRectMake(0, 45, 948, 44);
    [scrollView addSubview:cell2];
    UIView * cell3 = [self buildDoctorTableCell:@"超额收益" str2:@"较好" str3:@"最近三年，于同类型基金相比，该基金的超额收益高"];
    cell3.frame = CGRectMake(0, 45*2, 948, 44);
    [scrollView addSubview:cell3];
    UIView * cell4 = [self buildDoctorTableCell:@"风险评测" str2:@"较低" str3:@"最近三年，与同类型基金相比，该基金的波动幅度高，系统风险居中，下行风险偏低"];
    cell4.frame = CGRectMake(0, 45*3, 948, 44);
    [scrollView addSubview:cell4];
    UIView * cell5 = [self buildDoctorTableCell:@"分红能力" str2:@"较高" str3:@"最近三年，该基金累计分红3次，与同类型基金相比，分红比重偏高"];
    cell5.frame = CGRectMake(0, 45*4, 948, 44);
    [scrollView addSubview:cell5];
    UIView * cell6 = [self buildDoctorTableCell:@"成本费用" str2:@"较高" str3:@"与同类型基金平均水平比较，费用负担偏高"];
    cell6.frame = CGRectMake(0, 45*5, 948, 44);
    [scrollView addSubview:cell6];
    UIView * cell7 = [self buildDoctorTableCell:@"投资风格" str2:@"中盘成长性股票" str3:@"股票型基金，主要投资中盘成长性股票，债券投资较为保守"];
    cell7.frame = CGRectMake(0, 45*6, 948, 44);
    [scrollView addSubview:cell7];
    UIView * line1 = [[UIView alloc]initWithFrame:CGRectMake(0, 45, 948, 1)];
    line1.backgroundColor = [UIColor colorWithHexValue:0xf4f8fc];
    [scrollView addSubview:line1];
    UIView * line2 = [[UIView alloc]initWithFrame:CGRectMake(0, 45*2, 948, 1)];
    line2.backgroundColor = [UIColor colorWithHexValue:0xf4f8fc];
    [scrollView addSubview:line2];
    UIView * line3 = [[UIView alloc]initWithFrame:CGRectMake(0, 45*3, 948, 1)];
    line3.backgroundColor = [UIColor colorWithHexValue:0xf4f8fc];
    [scrollView addSubview:line3];
    UIView * line4 = [[UIView alloc]initWithFrame:CGRectMake(0, 45*4, 948, 1)];
    line4.backgroundColor = [UIColor colorWithHexValue:0xf4f8fc];
    [scrollView addSubview:line4];
    UIView * line5 = [[UIView alloc]initWithFrame:CGRectMake(0, 45*5, 948, 1)];
    line5.backgroundColor = [UIColor colorWithHexValue:0xf4f8fc];
    [scrollView addSubview:line5];
    UIView * line6 = [[UIView alloc]initWithFrame:CGRectMake(0, 45*6, 948, 1)];
    line6.backgroundColor = [UIColor colorWithHexValue:0xf4f8fc];
    [scrollView addSubview:line6];
    [scrollView setContentSize:CGSizeMake(948, 45*7-1)];
    
}

- (UIView *)buildInfoTableCell:(NSString *)str1 str2:(NSString *)str2
{
    UIView * cell = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 470, 29)];
    cell.backgroundColor = [UIColor clearColor];
    UILabel * _tableCellLabel11 = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 120, 29)];
    [_tableCellLabel11 setTextAlignment:NSTextAlignmentRight];
    [_tableCellLabel11 setTextColor:[UIColor colorWithHexValue:0x7d7d7d]];
    [_tableCellLabel11 setFont:[UIFont systemFontOfSize:14]];
    [_tableCellLabel11 setBackgroundColor:[UIColor clearColor]];
    _tableCellLabel11.text = str1;
    [cell addSubview:_tableCellLabel11];
    UILabel * _tableCellLabel12 = [[UILabel alloc] initWithFrame:CGRectMake(160, 0, 300, 29)];
    [_tableCellLabel12 setTextAlignment:NSTextAlignmentLeft];
    [_tableCellLabel12 setTextColor:[UIColor colorWithHexValue:0x7a7a7a]];
    [_tableCellLabel12 setFont:[UIFont systemFontOfSize:14]];
    [_tableCellLabel12 setBackgroundColor:[UIColor clearColor]];
    _tableCellLabel12.text = str2;
    [cell addSubview:_tableCellLabel12];
    return cell;
}

- (UIView *)buildInfoTableCell1:(NSString *)str1 str2:(NSString *)str2
{
    UIView * cell = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 467, 29)];
    cell.backgroundColor = [UIColor clearColor];
    UILabel * _tableCellLabel11 = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 120, 29)];
    [_tableCellLabel11 setTextAlignment:NSTextAlignmentRight];
    [_tableCellLabel11 setTextColor:[UIColor colorWithHexValue:0x7d7d7d]];
    [_tableCellLabel11 setFont:[UIFont systemFontOfSize:14]];
    [_tableCellLabel11 setBackgroundColor:[UIColor clearColor]];
    _tableCellLabel11.text = str1;
    [cell addSubview:_tableCellLabel11];
    UILabel * _tableCellLabel12 = [[UILabel alloc] initWithFrame:CGRectMake(160, 0, 80, 29)];
    [_tableCellLabel12 setTextAlignment:NSTextAlignmentLeft];
    [_tableCellLabel12 setTextColor:[UIColor colorWithHexValue:0x7a7a7a]];
    [_tableCellLabel12 setFont:[UIFont systemFontOfSize:14]];
    [_tableCellLabel12 setBackgroundColor:[UIColor clearColor]];
    _tableCellLabel12.text = str2;
    [cell addSubview:_tableCellLabel12];
    return cell;
}


- (void)buildInfoView
{
    infoView = [[UIView alloc]initWithFrame:CGRectMake(18, 20+36, 984-18*2, 577-20)];
    infoView.backgroundColor = [UIColor whiteColor];
    [bodyView addSubview:infoView];
    
    UIView * styleView = [[UIView alloc]initWithFrame:CGRectMake(2, 0, 944, 34+210)];
    UIImageView * styleHeaderView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"risk1_03"]];
    styleHeaderView.frame = CGRectMake(0, 0, 948, 34);
    [styleView addSubview:styleHeaderView];
    UILabel * _styleTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, 200, 34)];
    [_styleTitleLabel setTextAlignment:NSTextAlignmentLeft];
    [_styleTitleLabel setTextColor:[UIColor whiteColor]];
    [_styleTitleLabel setFont:[UIFont systemFontOfSize:16]];
    [_styleTitleLabel setBackgroundColor:[UIColor clearColor]];
    _styleTitleLabel.text = @"i财富点评";
    [styleHeaderView addSubview:_styleTitleLabel];
    UIView * cell1 = [self buildInfoTableCell:@"股票仓位" str2:@"高"];
    cell1.frame = CGRectMake(0, 34, 470, 29);
    [styleView addSubview:cell1];
    UIView * cell2 = [self buildInfoTableCell:@"股票集中度" str2:@"一般"];
    cell2.frame = CGRectMake(0, 34+30, 470, 29);
    [styleView addSubview:cell2];
    UIView * cell3 = [self buildInfoTableCell:@"行业集中度" str2:@"高"];
    cell3.frame = CGRectMake(0, 34+30*2, 470, 29);
    [styleView addSubview:cell3];
    UIView * cell4 = [self buildInfoTableCell:@"债券仓位" str2:@"低"];
    cell4.frame = CGRectMake(0, 34+30*3, 470, 29);
    [styleView addSubview:cell4];
    UIView * cell5 = [self buildInfoTableCell:@"债券集中度" str2:@"高"];
    cell5.frame = CGRectMake(0, 34+30*4, 470, 29);
    [styleView addSubview:cell5];
    UIView * cell6 = [self buildInfoTableCell:@"债券品种集中度" str2:@"高"];
    cell6.frame = CGRectMake(0, 34+30*5, 470, 29);
    [styleView addSubview:cell6];
    UIView * cell7 = [self buildInfoTableCell:@"总评" str2:@"激进混合型"];
    cell7.frame = CGRectMake(0, 34+30*6, 470, 29);
    [styleView addSubview:cell7];
    UIView * line1 = [[UIView alloc]initWithFrame:CGRectMake(0, 34+30, 470, 1)];
    line1.backgroundColor = [UIColor colorWithHexValue:0xe6e8ed];
    [styleView addSubview:line1];
    UIView * line2 = [[UIView alloc]initWithFrame:CGRectMake(0, 34+30*2, 470, 1)];
    line2.backgroundColor = [UIColor colorWithHexValue:0xe6e8ed];
    [styleView addSubview:line2];
    UIView * line3 = [[UIView alloc]initWithFrame:CGRectMake(0, 34+30*3, 470, 1)];
    line3.backgroundColor = [UIColor colorWithHexValue:0xe6e8ed];
    [styleView addSubview:line3];
    UIView * line4 = [[UIView alloc]initWithFrame:CGRectMake(0, 34+30*4, 470, 1)];
    line4.backgroundColor = [UIColor colorWithHexValue:0xe6e8ed];
    [styleView addSubview:line4];
    UIView * line5 = [[UIView alloc]initWithFrame:CGRectMake(0, 34+30*5, 470, 1)];
    line5.backgroundColor = [UIColor colorWithHexValue:0xe6e8ed];
    [styleView addSubview:line5];
    UIView * line6 = [[UIView alloc]initWithFrame:CGRectMake(0, 34+30*6, 470, 1)];
    line6.backgroundColor = [UIColor colorWithHexValue:0xe6e8ed];
    [styleView addSubview:line6];
    UIView * line7 = [[UIView alloc]initWithFrame:CGRectMake(0, 34+30*7, 470, 1)];
    line7.backgroundColor = [UIColor colorWithHexValue:0xe6e8ed];
    [styleView addSubview:line7];
    UIView * hLine1 = [[UIView alloc]initWithFrame:CGRectMake(0, 34, 1, 210)];
    hLine1.backgroundColor = [UIColor colorWithHexValue:0xe6e8ed];
    [styleView addSubview:hLine1];
    UIView * hLine2 = [[UIView alloc]initWithFrame:CGRectMake(139, 34, 1, 210)];
    hLine2.backgroundColor = [UIColor colorWithHexValue:0xe6e8ed];
    [styleView addSubview:hLine2];
    UIView * hLine3 = [[UIView alloc]initWithFrame:CGRectMake(469, 34, 1, 210)];
    hLine3.backgroundColor = [UIColor colorWithHexValue:0xe6e8ed];
    [styleView addSubview:hLine3];
    
    UILabel * _styleShareBoxLabel = [[UILabel alloc] initWithFrame:CGRectMake(470+40, 34, 156, 30)];
    [_styleShareBoxLabel setTextAlignment:NSTextAlignmentLeft];
    [_styleShareBoxLabel setTextColor:[UIColor colorWithHexValue:0xecac65]];
    [_styleShareBoxLabel setFont:[UIFont systemFontOfSize:14]];
    [_styleShareBoxLabel setBackgroundColor:[UIColor clearColor]];
    _styleShareBoxLabel.text = @"股票投资风格箱";
    [styleView addSubview:_styleShareBoxLabel];
    UIView * styleChartView = [[UIView alloc]initWithFrame:CGRectMake(470+40, 34+40, 112, 94)];
    styleChartView.backgroundColor = [UIColor lightGrayColor];
    [styleView addSubview:styleChartView];
    UILabel * _styleShareLabel = [[UILabel alloc] initWithFrame:CGRectMake(470+40, 34+40+94, 156, 30)];
    [_styleShareLabel setTextAlignment:NSTextAlignmentLeft];
    [_styleShareLabel setTextColor:[UIColor colorWithHexValue:0x333333]];
    [_styleShareLabel setFont:[UIFont systemFontOfSize:14]];
    [_styleShareLabel setBackgroundColor:[UIColor clearColor]];
    _styleShareLabel.text = @"价值型 平衡性 成长型";
    [styleView addSubview:_styleShareLabel];
    UILabel * _styleShareLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(470+40+112, 34+40, 44, 30)];
    [_styleShareLabel1 setTextAlignment:NSTextAlignmentCenter];
    [_styleShareLabel1 setTextColor:[UIColor colorWithHexValue:0x333333]];
    [_styleShareLabel1 setFont:[UIFont systemFontOfSize:14]];
    [_styleShareLabel1 setBackgroundColor:[UIColor clearColor]];
    _styleShareLabel1.text = @"大盘";
    [styleView addSubview:_styleShareLabel1];
    UILabel * _styleShareLabel2 = [[UILabel alloc] initWithFrame:CGRectMake(470+40+112, 34+40+30, 44, 30)];
    [_styleShareLabel2 setTextAlignment:NSTextAlignmentCenter];
    [_styleShareLabel2 setTextColor:[UIColor colorWithHexValue:0x333333]];
    [_styleShareLabel2 setFont:[UIFont systemFontOfSize:14]];
    [_styleShareLabel2 setBackgroundColor:[UIColor clearColor]];
    _styleShareLabel2.text = @"中盘";
    [styleView addSubview:_styleShareLabel2];
    UILabel * _styleShareLabel3 = [[UILabel alloc] initWithFrame:CGRectMake(470+40+112, 34+40+30*2, 44, 30)];
    [_styleShareLabel3 setTextAlignment:NSTextAlignmentCenter];
    [_styleShareLabel3 setTextColor:[UIColor colorWithHexValue:0x333333]];
    [_styleShareLabel3 setFont:[UIFont systemFontOfSize:14]];
    [_styleShareLabel3 setBackgroundColor:[UIColor clearColor]];
    _styleShareLabel3.text = @"小盘";
    [styleView addSubview:_styleShareLabel3];
    
    UILabel * _styleBondBoxLabel = [[UILabel alloc] initWithFrame:CGRectMake(470+40+156+54, 34, 156, 30)];
    [_styleBondBoxLabel setTextAlignment:NSTextAlignmentLeft];
    [_styleBondBoxLabel setTextColor:[UIColor colorWithHexValue:0xecac65]];
    [_styleBondBoxLabel setFont:[UIFont systemFontOfSize:14]];
    [_styleBondBoxLabel setBackgroundColor:[UIColor clearColor]];
    _styleBondBoxLabel.text = @"债券投资风格箱";
    [styleView addSubview:_styleBondBoxLabel];
    UIView * styleBondChartView = [[UIView alloc]initWithFrame:CGRectMake(470+40+156+54, 34+40, 112, 32)];
    styleBondChartView.backgroundColor = [UIColor lightGrayColor];
    [styleView addSubview:styleBondChartView];
    UILabel * _styleBondLabel = [[UILabel alloc] initWithFrame:CGRectMake(470+40+156+54, 34+40+32, 156, 30)];
    [_styleBondLabel setTextAlignment:NSTextAlignmentLeft];
    [_styleBondLabel setTextColor:[UIColor colorWithHexValue:0x333333]];
    [_styleBondLabel setFont:[UIFont systemFontOfSize:14]];
    [_styleBondLabel setBackgroundColor:[UIColor clearColor]];
    _styleBondLabel.text = @"保守型 平衡型 激进型";
    [styleView addSubview:_styleBondLabel];
    
    UILabel * _styleLabel = [[UILabel alloc] initWithFrame:CGRectMake(470+40+10, 34+40+94+30, 156, 30)];
    [_styleLabel setTextAlignment:NSTextAlignmentLeft];
    [_styleLabel setTextColor:[UIColor colorWithHexValue:0x333333]];
    [_styleLabel setFont:[UIFont systemFontOfSize:14]];
    [_styleLabel setBackgroundColor:[UIColor clearColor]];
    _styleLabel.text = @"风格：平衡";
    [styleView addSubview:_styleLabel];
    UILabel * _styleSizeLabel = [[UILabel alloc] initWithFrame:CGRectMake(470+40+10, 34+40+94+30*2, 156, 30)];
    [_styleSizeLabel setTextAlignment:NSTextAlignmentLeft];
    [_styleSizeLabel setTextColor:[UIColor colorWithHexValue:0x333333]];
    [_styleSizeLabel setFont:[UIFont systemFontOfSize:14]];
    [_styleSizeLabel setBackgroundColor:[UIColor clearColor]];
    _styleSizeLabel.text = @"规模：小盘";
    [styleView addSubview:_styleSizeLabel];
    
    UILabel * _styleLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(470+40+156+54, 34+40+94+30, 156, 60)];
    [_styleLabel1 setTextAlignment:NSTextAlignmentLeft];
    [_styleLabel1 setTextColor:[UIColor colorWithHexValue:0x333333]];
    [_styleLabel1 setFont:[UIFont systemFontOfSize:14]];
    [_styleLabel1 setBackgroundColor:[UIColor clearColor]];
    _styleLabel1.text = @"风格：激进";
    [styleView addSubview:_styleLabel1];
    
    
    UIView * costView = [[UIView alloc]initWithFrame:CGRectMake(2, 34+210+20, 467, 154)];
    UIImageView * costHeaderView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"risk1_07"]];
    costHeaderView.frame = CGRectMake(0, 0, 467, 34);
    [costView addSubview:costHeaderView];
    UILabel * _costTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, 200, 34)];
    [_costTitleLabel setTextAlignment:NSTextAlignmentLeft];
    [_costTitleLabel setTextColor:[UIColor whiteColor]];
    [_costTitleLabel setFont:[UIFont systemFontOfSize:16]];
    [_costTitleLabel setBackgroundColor:[UIColor clearColor]];
    _costTitleLabel.text = @"成本费用";
    [costHeaderView addSubview:_costTitleLabel];
    UIView * cell11 = [self buildInfoTableCell:@"管理费" str2:@"1.5%"];
    cell11.frame = CGRectMake(0, 34, 470, 29);
    [costView addSubview:cell11];
    UIView * cell12 = [self buildInfoTableCell:@"托管费" str2:@"0.25%"];
    cell12.frame = CGRectMake(0, 34+30, 470, 29);
    [costView addSubview:cell12];
    UIView * cell13 = [self buildInfoTableCell:@"交易费" str2:@"1.2%"];
    cell13.frame = CGRectMake(0, 34+30*2, 470, 29);
    [costView addSubview:cell13];
    UIView * cell14 = [self buildInfoTableCell:@"评价" str2:@"偏高"];
    cell14.frame = CGRectMake(0, 34+30*3, 470, 29);
    [costView addSubview:cell14];
    UIView * line11 = [[UIView alloc]initWithFrame:CGRectMake(0, 34+30, 467, 1)];
    line11.backgroundColor = [UIColor colorWithHexValue:0xe6e8ed];
    [costView addSubview:line11];
    UIView * line12 = [[UIView alloc]initWithFrame:CGRectMake(0, 34+30*2, 467, 1)];
    line12.backgroundColor = [UIColor colorWithHexValue:0xe6e8ed];
    [costView addSubview:line12];
    UIView * line13 = [[UIView alloc]initWithFrame:CGRectMake(0, 34+30*3, 467, 1)];
    line13.backgroundColor = [UIColor colorWithHexValue:0xe6e8ed];
    [costView addSubview:line13];
    UIView * line14 = [[UIView alloc]initWithFrame:CGRectMake(0, 34+30*4, 467, 1)];
    line14.backgroundColor = [UIColor colorWithHexValue:0xe6e8ed];
    [costView addSubview:line14];
    UIView * hLine11 = [[UIView alloc]initWithFrame:CGRectMake(0, 34, 1, 120)];
    hLine11.backgroundColor = [UIColor colorWithHexValue:0xe6e8ed];
    [costView addSubview:hLine11];
    UIView * hLine12 = [[UIView alloc]initWithFrame:CGRectMake(139, 34, 1, 120)];
    hLine12.backgroundColor = [UIColor colorWithHexValue:0xe6e8ed];
    [costView addSubview:hLine12];
    UIView * hLine13 = [[UIView alloc]initWithFrame:CGRectMake(466, 34, 1, 120)];
    hLine13.backgroundColor = [UIColor colorWithHexValue:0xe6e8ed];
    [costView addSubview:hLine13];
    
    
    UIView * companyView = [[UIView alloc]initWithFrame:CGRectMake(2+467+10, 34+210+20, 467, 154)];
    UIImageView * companyHeaderView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"risk1_07"]];
    companyHeaderView.frame = CGRectMake(0, 0, 467, 34);
    [companyView addSubview:companyHeaderView];
    UILabel * _companyTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, 200, 34)];
    [_companyTitleLabel setTextAlignment:NSTextAlignmentLeft];
    [_companyTitleLabel setTextColor:[UIColor whiteColor]];
    [_companyTitleLabel setFont:[UIFont systemFontOfSize:16]];
    [_companyTitleLabel setBackgroundColor:[UIColor clearColor]];
    _companyTitleLabel.text = @"公司实力";
    [costHeaderView addSubview:_companyTitleLabel];
    UIView * cell21 = [self buildInfoTableCell:@"公司名称" str2:@"华夏基金管理有限公司"];
    cell21.frame = CGRectMake(0, 34, 470, 29);
    [companyView addSubview:cell21];
    UIView * cell22 = [self buildInfoTableCell:@"成立年份" str2:@"1998年"];
    cell22.frame = CGRectMake(0, 34+30, 470, 29);
    [companyView addSubview:cell22];
    UIView * cell23 = [self buildInfoTableCell:@"管理基金数量" str2:@"122"];
    cell23.frame = CGRectMake(0, 34+30*2, 470, 29);
    [companyView addSubview:cell23];
    UIView * cell24 = [self buildInfoTableCell:@"管理基金规模" str2:@"2530亿"];
    cell24.frame = CGRectMake(0, 34+30*3, 470, 29);
    [companyView addSubview:cell24];
    UIView * line21 = [[UIView alloc]initWithFrame:CGRectMake(0, 34+30, 120+180, 1)];
    line21.backgroundColor = [UIColor colorWithHexValue:0xe6e8ed];
    [companyView addSubview:line21];
    UIView * line22 = [[UIView alloc]initWithFrame:CGRectMake(0, 34+30*2, 120+180, 1)];
    line22.backgroundColor = [UIColor colorWithHexValue:0xe6e8ed];
    [companyView addSubview:line22];
    UIView * line23 = [[UIView alloc]initWithFrame:CGRectMake(0, 34+30*3, 120+180, 1)];
    line23.backgroundColor = [UIColor colorWithHexValue:0xe6e8ed];
    [companyView addSubview:line23];
    UIView * line24 = [[UIView alloc]initWithFrame:CGRectMake(0, 34+30*4, 467, 1)];
    line24.backgroundColor = [UIColor colorWithHexValue:0xe6e8ed];
    [companyView addSubview:line24];
    UIView * hLine21 = [[UIView alloc]initWithFrame:CGRectMake(0, 34, 1, 120)];
    hLine21.backgroundColor = [UIColor colorWithHexValue:0xe6e8ed];
    [companyView addSubview:hLine21];
    UIView * hLine22 = [[UIView alloc]initWithFrame:CGRectMake(139, 34, 1, 120)];
    hLine22.backgroundColor = [UIColor colorWithHexValue:0xe6e8ed];
    [companyView addSubview:hLine22];
    UIView * hLine23 = [[UIView alloc]initWithFrame:CGRectMake(120+179, 34, 1, 120)];
    hLine23.backgroundColor = [UIColor colorWithHexValue:0xe6e8ed];
    [companyView addSubview:hLine23];
    UIView * hLine24 = [[UIView alloc]initWithFrame:CGRectMake(466, 34, 1, 120)];
    hLine24.backgroundColor = [UIColor colorWithHexValue:0xe6e8ed];
    [companyView addSubview:hLine24];
    
    [infoView addSubview:styleView];
    [infoView addSubview:costView];
    [infoView addSubview:companyView];
}

- (UIView *)buildRiskTableCell:(NSString *)str1 str2:(NSString *)str2 str3:(NSString *)str3 str4:(NSString *)str4
                          str5:(NSString *)str5 str6:(NSString *)str6 str7:(NSString *)str7
{
    UIView * cell = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 657, 29)];
    cell.backgroundColor = [UIColor clearColor];
    UILabel * _tableCellLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(5, 0, 90, 29)];
    [_tableCellLabel1 setTextAlignment:NSTextAlignmentLeft];
    [_tableCellLabel1 setTextColor:[UIColor colorWithHexValue:0x7d7d7d]];
    [_tableCellLabel1 setFont:[UIFont systemFontOfSize:14]];
    [_tableCellLabel1 setBackgroundColor:[UIColor clearColor]];
    _tableCellLabel1.text = str1;
    [cell addSubview:_tableCellLabel1];
    UILabel * _tableCellLabel2 = [[UILabel alloc] initWithFrame:CGRectMake(5+100, 0, 80, 29)];
    [_tableCellLabel2 setTextAlignment:NSTextAlignmentCenter];
    [_tableCellLabel2 setTextColor:[UIColor colorWithHexValue:0x7a7a7a]];
    [_tableCellLabel2 setFont:[UIFont systemFontOfSize:14]];
    [_tableCellLabel2 setBackgroundColor:[UIColor clearColor]];
    _tableCellLabel2.text = str2;
    [cell addSubview:_tableCellLabel2];
    UILabel * _tableCellLabel3 = [[UILabel alloc] initWithFrame:CGRectMake(5+190, 0, 80, 29)];
    [_tableCellLabel3 setTextAlignment:NSTextAlignmentCenter];
    [_tableCellLabel3 setTextColor:[UIColor colorWithHexValue:0x7a7a7a]];
    [_tableCellLabel3 setFont:[UIFont systemFontOfSize:14]];
    [_tableCellLabel3 setBackgroundColor:[UIColor clearColor]];
    _tableCellLabel3.text = str3;
    _tableCellLabel3.numberOfLines = 0;
    [cell addSubview:_tableCellLabel3];
    UILabel * _tableCellLabel4 = [[UILabel alloc] initWithFrame:CGRectMake(5+280, 0, 80, 29)];
    [_tableCellLabel4 setTextAlignment:NSTextAlignmentCenter];
    [_tableCellLabel4 setTextColor:[UIColor colorWithHexValue:0x7a7a7a]];
    [_tableCellLabel4 setFont:[UIFont systemFontOfSize:14]];
    [_tableCellLabel4 setBackgroundColor:[UIColor clearColor]];
    _tableCellLabel4.text = str4;
    _tableCellLabel4.numberOfLines = 0;
    [cell addSubview:_tableCellLabel4];
    UILabel * _tableCellLabel5 = [[UILabel alloc] initWithFrame:CGRectMake(5+370, 0, 80, 29)];
    [_tableCellLabel5 setTextAlignment:NSTextAlignmentCenter];
    [_tableCellLabel5 setTextColor:[UIColor colorWithHexValue:0x7a7a7a]];
    [_tableCellLabel5 setFont:[UIFont systemFontOfSize:14]];
    [_tableCellLabel5 setBackgroundColor:[UIColor clearColor]];
    _tableCellLabel5.text = str5;
    [cell addSubview:_tableCellLabel5];
    UILabel * _tableCellLabel6 = [[UILabel alloc] initWithFrame:CGRectMake(5+460, 0, 80, 29)];
    [_tableCellLabel6 setTextAlignment:NSTextAlignmentCenter];
    [_tableCellLabel6 setTextColor:[UIColor colorWithHexValue:0x7a7a7a]];
    [_tableCellLabel6 setFont:[UIFont systemFontOfSize:14]];
    [_tableCellLabel6 setBackgroundColor:[UIColor clearColor]];
    _tableCellLabel6.text = str6;
    [cell addSubview:_tableCellLabel6];
    UILabel * _tableCellLabel7 = [[UILabel alloc] initWithFrame:CGRectMake(5+550, 0, 80, 29)];
    [_tableCellLabel7 setTextAlignment:NSTextAlignmentCenter];
    [_tableCellLabel7 setTextColor:[UIColor colorWithHexValue:0x7a7a7a]];
    [_tableCellLabel7 setFont:[UIFont systemFontOfSize:14]];
    [_tableCellLabel7 setBackgroundColor:[UIColor clearColor]];
    _tableCellLabel7.text = str7;
    [cell addSubview:_tableCellLabel7];
    return cell;
}

- (void)buildRiskView
{
    riskView = [[UIView alloc]initWithFrame:CGRectMake(18, 20+36, 984-18*2, 577-20)];
    riskView.backgroundColor = [UIColor whiteColor];
    [bodyView addSubview:riskView];
    
    UIView * chartView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 640, 164)];
    chartView.backgroundColor = [UIColor lightGrayColor];
    [riskView addSubview:chartView];
    
    UIView * historyView = [[UIView alloc]initWithFrame:CGRectMake(0, 164+20, 657, 34+30*3)];
    [riskView addSubview:historyView];
    UIImageView * historyHeaderView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"risk1_07"]];
    historyHeaderView.frame = CGRectMake(0, 0, 657, 34);
    [historyView addSubview:historyHeaderView];
    UILabel * _historyTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, 200, 34)];
    [_historyTitleLabel setTextAlignment:NSTextAlignmentLeft];
    [_historyTitleLabel setTextColor:[UIColor whiteColor]];
    [_historyTitleLabel setFont:[UIFont systemFontOfSize:18]];
    [_historyTitleLabel setBackgroundColor:[UIColor clearColor]];
    _historyTitleLabel.text = @"历史业绩";
    [historyHeaderView addSubview:_historyTitleLabel];
    UILabel * _historyTitleLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(657-20-200, 0, 200, 34)];
    [_historyTitleLabel1 setTextAlignment:NSTextAlignmentRight];
    [_historyTitleLabel1 setTextColor:[UIColor whiteColor]];
    [_historyTitleLabel1 setFont:[UIFont systemFontOfSize:14]];
    [_historyTitleLabel1 setBackgroundColor:[UIColor clearColor]];
    _historyTitleLabel1.text = @"2013-01-04";
    [historyHeaderView addSubview:_historyTitleLabel1];
    UIView * cell1 = [self buildRiskTableCell:@"" str2:@"今年以来" str3:@"2012" str4:@"2011" str5:@"2010" str6:@"2009" str7:@"2008"];
    cell1.frame = CGRectMake(0, 34, 657, 29);
    [historyView addSubview:cell1];
    UIView * cell2 = [self buildRiskTableCell:@"总回报" str2:@"36.94" str3:@"25.87" str4:@"12.03" str5:@"--" str6:@"--" str7:@"--"];
    cell2.frame = CGRectMake(0, 34+30, 657, 29);
    [historyView addSubview:cell2];
    UIView * cell3 = [self buildRiskTableCell:@"+/-基准指数" str2:@"28.40" str3:@"10.11" str4:@"0.35" str5:@"--" str6:@"--" str7:@"--"];
    cell3.frame = CGRectMake(0, 34+30*2, 657, 29);
    [historyView addSubview:cell3];
    UIView * line11 = [[UIView alloc]initWithFrame:CGRectMake(0, 34+30, 657, 1)];
    line11.backgroundColor = [UIColor colorWithHexValue:0xe6e8ed];
    [historyView addSubview:line11];
    UIView * line12 = [[UIView alloc]initWithFrame:CGRectMake(0, 34+30*2, 657, 1)];
    line12.backgroundColor = [UIColor colorWithHexValue:0xe6e8ed];
    [historyView addSubview:line12];
    UIView * line13 = [[UIView alloc]initWithFrame:CGRectMake(0, 34+30*3, 657, 1)];
    line13.backgroundColor = [UIColor colorWithHexValue:0xe6e8ed];
    [historyView addSubview:line13];
    
    UIView * sharingView = [[UIView alloc]initWithFrame:CGRectMake(0, 164+20*2+124, 657, 34+30*5)];
    [riskView addSubview:sharingView];
    UIImageView * sharingHeaderView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"risk1_07"]];
    sharingHeaderView.frame = CGRectMake(0, 0, 657, 34);
    [sharingView addSubview:sharingHeaderView];
    UILabel * _sharingTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, 200, 34)];
    [_sharingTitleLabel setTextAlignment:NSTextAlignmentLeft];
    [_sharingTitleLabel setTextColor:[UIColor whiteColor]];
    [_sharingTitleLabel setFont:[UIFont systemFontOfSize:18]];
    [_sharingTitleLabel setBackgroundColor:[UIColor clearColor]];
    _sharingTitleLabel.text = @"分红能力";
    [sharingView addSubview:_sharingTitleLabel];
    UILabel * _sharingTitleLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(657-20-200, 0, 200, 34)];
    [_sharingTitleLabel1 setTextAlignment:NSTextAlignmentRight];
    [_sharingTitleLabel1 setTextColor:[UIColor whiteColor]];
    [_sharingTitleLabel1 setFont:[UIFont systemFontOfSize:14]];
    [_sharingTitleLabel1 setBackgroundColor:[UIColor clearColor]];
    _sharingTitleLabel1.text = @"2013-01-04";
    [sharingView addSubview:_sharingTitleLabel1];
    UIView * cell11 = [self buildRiskTableCell:@"分红年份" str2:@"分红次数" str3:@"年度累计分红" str4:@"占总资产净值的比重" str5:@"评价" str6:@"" str7:@""];
    cell11.frame = CGRectMake(0, 34, 657, 29);
    [sharingView addSubview:cell11];
    UIView * cell12 = [self buildRiskTableCell:@"2012" str2:@"1" str3:@"0.5" str4:@"1.03" str5:@"--" str6:@"" str7:@""];
    cell12.frame = CGRectMake(0, 34+30, 657, 29);
    [sharingView addSubview:cell12];
    UIView * cell13 = [self buildRiskTableCell:@"2011" str2:@"0" str3:@"1" str4:@"--" str5:@"偏低" str6:@"" str7:@""];
    cell13.frame = CGRectMake(0, 34+30*2, 657, 29);
    [sharingView addSubview:cell13];
    UIView * cell14 = [self buildRiskTableCell:@"2009" str2:@"1" str3:@"1" str4:@"--" str5:@"偏低" str6:@"" str7:@""];
    cell14.frame = CGRectMake(0, 34+30*3, 657, 29);
    [sharingView addSubview:cell14];
    UIView * cell15 = [self buildRiskTableCell:@"总计" str2:@"2" str3:@"2.5" str4:@"1.03" str5:@"偏低" str6:@"" str7:@""];
    cell15.frame = CGRectMake(0, 34+30*4, 657, 29);
    [sharingView addSubview:cell15];
    UIView * line21 = [[UIView alloc]initWithFrame:CGRectMake(0, 34+30, 657, 1)];
    line21.backgroundColor = [UIColor colorWithHexValue:0xe6e8ed];
    [sharingView addSubview:line21];
    UIView * line22 = [[UIView alloc]initWithFrame:CGRectMake(0, 34+30*2, 657, 1)];
    line22.backgroundColor = [UIColor colorWithHexValue:0xe6e8ed];
    [sharingView addSubview:line12];
    UIView * line23 = [[UIView alloc]initWithFrame:CGRectMake(0, 34+30*3, 657, 1)];
    line23.backgroundColor = [UIColor colorWithHexValue:0xe6e8ed];
    [sharingView addSubview:line23];
    UIView * line24 = [[UIView alloc]initWithFrame:CGRectMake(0, 34+30*4, 657, 1)];
    line24.backgroundColor = [UIColor colorWithHexValue:0xe6e8ed];
    [sharingView addSubview:line24];
    UIView * line25 = [[UIView alloc]initWithFrame:CGRectMake(0, 34+30*5, 657, 1)];
    line25.backgroundColor = [UIColor colorWithHexValue:0xe6e8ed];
    [sharingView addSubview:line25];
    
    UIView * right1View = [[UIView alloc]initWithFrame:CGRectMake(657+10, 0, 280, 36+30*4)];
    right1View.backgroundColor = [UIColor colorWithHexValue:0xf7fcfd];
    [riskView addSubview:right1View];
    UIImageView * right1HeaderView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"risk_05"]];
    right1HeaderView.frame = CGRectMake(0, 0, 280, 36);
    [right1View addSubview:right1HeaderView];
    UILabel * _right1TitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(120+5, 0, 80, 30)];
    [_right1TitleLabel setTextAlignment:NSTextAlignmentLeft];
    [_right1TitleLabel setTextColor:[UIColor colorWithHexValue:0x6bb3dc]];
    [_right1TitleLabel setFont:[UIFont systemFontOfSize:14]];
    [_right1TitleLabel setBackgroundColor:[UIColor clearColor]];
    _right1TitleLabel.text = @"最近三年";
    [right1HeaderView addSubview:_right1TitleLabel];
    UILabel * _right1TitleLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(210+5, 0, 40, 30)];
    [_right1TitleLabel1 setTextAlignment:NSTextAlignmentLeft];
    [_right1TitleLabel1 setTextColor:[UIColor colorWithHexValue:0x6bb3dc]];
    [_right1TitleLabel1 setFont:[UIFont systemFontOfSize:14]];
    [_right1TitleLabel1 setBackgroundColor:[UIColor clearColor]];
    _right1TitleLabel1.text = @"评价";
    [right1HeaderView addSubview:_right1TitleLabel1];
    UIView * cell21 = [self buildRiskTableCell:@"夏普比率" str2:@"--" str3:@"--" str4:@"" str5:@"" str6:@"" str7:@""];
    cell21.frame = CGRectMake(0, 34, 280, 29);
    [right1View addSubview:cell21];
    UIView * cell22 = [self buildRiskTableCell:@"特雷诺指数" str2:@"--" str3:@"--" str4:@"" str5:@"" str6:@"" str7:@""];
    cell22.frame = CGRectMake(0, 34+30, 280, 29);
    [right1View addSubview:cell22];
    UIView * cell23 = [self buildRiskTableCell:@"杰森指数" str2:@"--" str3:@"--" str4:@"" str5:@"" str6:@"" str7:@""];
    cell23.frame = CGRectMake(0, 34+30*2, 280, 29);
    [right1View addSubview:cell23];
    UIView * cell24 = [self buildRiskTableCell:@"评价" str2:@"--" str3:@"--" str4:@"" str5:@"" str6:@"" str7:@""];
    cell24.frame = CGRectMake(0, 34+30*3, 280, 29);
    [right1View addSubview:cell24];
    UIView * line31 = [[UIView alloc]initWithFrame:CGRectMake(0, 30-1, 280, 1)];
    line31.backgroundColor = [UIColor colorWithHexValue:0xe6e8ed];
    [right1View addSubview:line31];
    UIView * line32 = [[UIView alloc]initWithFrame:CGRectMake(0, 30*2-1, 280, 1)];
    line32.backgroundColor = [UIColor colorWithHexValue:0xe6e8ed];
    [right1View addSubview:line32];
    UIView * line33 = [[UIView alloc]initWithFrame:CGRectMake(0, 30*3-1, 280, 1)];
    line33.backgroundColor = [UIColor colorWithHexValue:0xe6e8ed];
    [right1View addSubview:line33];
    UIView * line34 = [[UIView alloc]initWithFrame:CGRectMake(0, 30*4-1, 280, 1)];
    line34.backgroundColor = [UIColor colorWithHexValue:0xe6e8ed];
    [right1View addSubview:line34];
    
    UIView * right2View = [[UIView alloc]initWithFrame:CGRectMake(657+10, 36+30*4+10, 280, 36+30*4)];
    right2View.backgroundColor = [UIColor colorWithHexValue:0xf7fcfd];
    [riskView addSubview:right2View];
    UIImageView * right2HeaderView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"risk_05"]];
    right2HeaderView.frame = CGRectMake(0, 0, 280, 36);
    [right2View addSubview:right2HeaderView];
    UILabel * _right2TitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(120+5, 0, 80, 30)];
    [_right2TitleLabel setTextAlignment:NSTextAlignmentLeft];
    [_right2TitleLabel setTextColor:[UIColor colorWithHexValue:0x6bb3dc]];
    [_right2TitleLabel setFont:[UIFont systemFontOfSize:14]];
    [_right2TitleLabel setBackgroundColor:[UIColor clearColor]];
    _right2TitleLabel.text = @"最近三年";
    [right2HeaderView addSubview:_right2TitleLabel];
    UILabel * _right2TitleLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(210+5, 0, 40, 30)];
    [_right2TitleLabel1 setTextAlignment:NSTextAlignmentLeft];
    [_right2TitleLabel1 setTextColor:[UIColor colorWithHexValue:0x6bb3dc]];
    [_right2TitleLabel1 setFont:[UIFont systemFontOfSize:14]];
    [_right2TitleLabel1 setBackgroundColor:[UIColor clearColor]];
    _right2TitleLabel1.text = @"评价";
    [right2HeaderView addSubview:_right2TitleLabel1];
    UIView * cell31 = [self buildRiskTableCell:@"波动幅度" str2:@"--" str3:@"--" str4:@"" str5:@"" str6:@"" str7:@""];
    cell31.frame = CGRectMake(0, 34, 280, 29);
    [right2View addSubview:cell31];
    UIView * cell32 = [self buildRiskTableCell:@"系统风险" str2:@"--" str3:@"--" str4:@"" str5:@"" str6:@"" str7:@""];
    cell32.frame = CGRectMake(0, 34+30, 280, 29);
    [right2View addSubview:cell32];
    UIView * cell33 = [self buildRiskTableCell:@"下行风险" str2:@"--" str3:@"--" str4:@"" str5:@"" str6:@"" str7:@""];
    cell33.frame = CGRectMake(0, 34+30*2, 280, 29);
    [right2View addSubview:cell33];
    UIView * cell34 = [self buildRiskTableCell:@"评价" str2:@"--" str3:@"--" str4:@"" str5:@"" str6:@"" str7:@""];
    cell34.frame = CGRectMake(0, 34+30*3, 280, 29);
    [right2View addSubview:cell34];
    UIView * line41 = [[UIView alloc]initWithFrame:CGRectMake(0, 30-1, 280, 1)];
    line41.backgroundColor = [UIColor colorWithHexValue:0xe6e8ed];
    [right2View addSubview:line41];
    UIView * line42 = [[UIView alloc]initWithFrame:CGRectMake(0, 30*2-1, 280, 1)];
    line42.backgroundColor = [UIColor colorWithHexValue:0xe6e8ed];
    [right2View addSubview:line42];
    UIView * line43 = [[UIView alloc]initWithFrame:CGRectMake(0, 30*3-1, 280, 1)];
    line43.backgroundColor = [UIColor colorWithHexValue:0xe6e8ed];
    [right2View addSubview:line43];
    UIView * line44 = [[UIView alloc]initWithFrame:CGRectMake(0, 30*4-1, 280, 1)];
    line44.backgroundColor = [UIColor colorWithHexValue:0xe6e8ed];
    [right2View addSubview:line44];
    
    UIView * right3View = [[UIView alloc]initWithFrame:CGRectMake(657+10, (36+30*4+10)*2, 280, 36+30*2)];
    right3View.backgroundColor = [UIColor colorWithHexValue:0xf7fcfd];
    [riskView addSubview:right3View];
    UIImageView * right3HeaderView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"risk_05"]];
    right3HeaderView.frame = CGRectMake(0, 0, 280, 36);
    [right3View addSubview:right3HeaderView];
    UILabel * _right3TitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(120+5, 0, 80, 30)];
    [_right3TitleLabel setTextAlignment:NSTextAlignmentLeft];
    [_right3TitleLabel setTextColor:[UIColor colorWithHexValue:0x6bb3dc]];
    [_right3TitleLabel setFont:[UIFont systemFontOfSize:14]];
    [_right3TitleLabel setBackgroundColor:[UIColor clearColor]];
    _right3TitleLabel.text = @"最近三年";
    [right3HeaderView addSubview:_right3TitleLabel];
    UILabel * _right3TitleLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(210+5, 0, 40, 30)];
    [_right3TitleLabel1 setTextAlignment:NSTextAlignmentLeft];
    [_right3TitleLabel1 setTextColor:[UIColor colorWithHexValue:0x6bb3dc]];
    [_right3TitleLabel1 setFont:[UIFont systemFontOfSize:14]];
    [_right3TitleLabel1 setBackgroundColor:[UIColor clearColor]];
    _right3TitleLabel1.text = @"评价";
    [right3HeaderView addSubview:_right3TitleLabel1];
    UIView * cell41 = [self buildRiskTableCell:@"择股能力" str2:@"--" str3:@"--" str4:@"" str5:@"" str6:@"" str7:@""];
    cell41.frame = CGRectMake(0, 34, 280, 29);
    [right3View addSubview:cell41];
    UIView * cell42 = [self buildRiskTableCell:@"择时能力" str2:@"--" str3:@"--" str4:@"" str5:@"" str6:@"" str7:@""];
    cell42.frame = CGRectMake(0, 34+30, 280, 29);
    [right3View addSubview:cell42];
    UIView * line51 = [[UIView alloc]initWithFrame:CGRectMake(0, 30-1, 280, 1)];
    line51.backgroundColor = [UIColor colorWithHexValue:0xe6e8ed];
    [right3View addSubview:line51];
    UIView * line52 = [[UIView alloc]initWithFrame:CGRectMake(0, 30*2-1, 280, 1)];
    line52.backgroundColor = [UIColor colorWithHexValue:0xe6e8ed];
    [right3View addSubview:line52];
    
}

- (UIView *)buildManagerTableCell:(NSString *)str1 str2:(NSString *)str2
{
    UIView * cell = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 948, 30)];
    cell.backgroundColor = [UIColor clearColor];
    UILabel * _tableCellLabel11 = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 80, 30)];
    [_tableCellLabel11 setTextAlignment:NSTextAlignmentRight];
    [_tableCellLabel11 setTextColor:[UIColor blackColor]];
    [_tableCellLabel11 setFont:[UIFont systemFontOfSize:14]];
    [_tableCellLabel11 setBackgroundColor:[UIColor clearColor]];
    _tableCellLabel11.text = str1;
    [cell addSubview:_tableCellLabel11];
    UILabel * _tableCellLabel12 = [[UILabel alloc] initWithFrame:CGRectMake(110, 0, 820, 30)];
    [_tableCellLabel12 setTextAlignment:NSTextAlignmentLeft];
    [_tableCellLabel12 setTextColor:[UIColor colorWithHexValue:0x7a7a7a]];
    [_tableCellLabel12 setFont:[UIFont systemFontOfSize:14]];
    [_tableCellLabel12 setBackgroundColor:[UIColor clearColor]];
    _tableCellLabel12.text = str2;
    [cell addSubview:_tableCellLabel12];
    return cell;
}

- (UIView *)buildManagerTableCell1:(NSString *)str1 str2:(NSString *)str2 str3:(NSString *)str3 str4:(NSString *)str4
                              str5:(NSString *)str5 str6:(NSString *)str6 str7:(NSString *)str7 lineHeight:(NSInteger)lineHeight
{
    UIView * cell = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 948, lineHeight)];
    cell.backgroundColor = [UIColor clearColor];
    UILabel * _tableCellLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(5, 0, 90, lineHeight)];
    [_tableCellLabel1 setTextAlignment:NSTextAlignmentLeft];
    [_tableCellLabel1 setTextColor:[UIColor colorWithHexValue:0x7d7d7d]];
    [_tableCellLabel1 setFont:[UIFont systemFontOfSize:14]];
    [_tableCellLabel1 setBackgroundColor:[UIColor clearColor]];
    _tableCellLabel1.text = str1;
    [cell addSubview:_tableCellLabel1];
    UILabel * _tableCellLabel2 = [[UILabel alloc] initWithFrame:CGRectMake(5+100, 0, 150, lineHeight)];
    [_tableCellLabel2 setTextAlignment:NSTextAlignmentCenter];
    [_tableCellLabel2 setTextColor:[UIColor colorWithHexValue:0x7a7a7a]];
    [_tableCellLabel2 setFont:[UIFont systemFontOfSize:14]];
    [_tableCellLabel2 setBackgroundColor:[UIColor clearColor]];
    _tableCellLabel2.text = str2;
    [cell addSubview:_tableCellLabel2];
    UILabel * _tableCellLabel3 = [[UILabel alloc] initWithFrame:CGRectMake(5+250, 0, 120, lineHeight)];
    [_tableCellLabel3 setTextAlignment:NSTextAlignmentCenter];
    [_tableCellLabel3 setTextColor:[UIColor colorWithHexValue:0x7a7a7a]];
    [_tableCellLabel3 setFont:[UIFont systemFontOfSize:14]];
    [_tableCellLabel3 setBackgroundColor:[UIColor clearColor]];
    _tableCellLabel3.text = str3;
    _tableCellLabel3.numberOfLines = 0;
    [cell addSubview:_tableCellLabel3];
    UILabel * _tableCellLabel4 = [[UILabel alloc] initWithFrame:CGRectMake(5+370, 0, 120, lineHeight)];
    [_tableCellLabel4 setTextAlignment:NSTextAlignmentCenter];
    [_tableCellLabel4 setTextColor:[UIColor colorWithHexValue:0x7a7a7a]];
    [_tableCellLabel4 setFont:[UIFont systemFontOfSize:14]];
    [_tableCellLabel4 setBackgroundColor:[UIColor clearColor]];
    _tableCellLabel4.text = str4;
    _tableCellLabel4.numberOfLines = 0;
    [cell addSubview:_tableCellLabel4];
    UILabel * _tableCellLabel5 = [[UILabel alloc] initWithFrame:CGRectMake(5+490, 0, 120, lineHeight)];
    [_tableCellLabel5 setTextAlignment:NSTextAlignmentCenter];
    [_tableCellLabel5 setTextColor:[UIColor colorWithHexValue:0x7a7a7a]];
    [_tableCellLabel5 setFont:[UIFont systemFontOfSize:14]];
    [_tableCellLabel5 setBackgroundColor:[UIColor clearColor]];
    _tableCellLabel5.text = str5;
    [cell addSubview:_tableCellLabel5];
    UILabel * _tableCellLabel6 = [[UILabel alloc] initWithFrame:CGRectMake(5+610, 0, 120, lineHeight)];
    [_tableCellLabel6 setTextAlignment:NSTextAlignmentCenter];
    [_tableCellLabel6 setTextColor:[UIColor colorWithHexValue:0x7a7a7a]];
    [_tableCellLabel6 setFont:[UIFont systemFontOfSize:14]];
    [_tableCellLabel6 setBackgroundColor:[UIColor clearColor]];
    _tableCellLabel6.text = str6;
    _tableCellLabel6.numberOfLines = 0;
    [cell addSubview:_tableCellLabel6];
    UILabel * _tableCellLabel7 = [[UILabel alloc] initWithFrame:CGRectMake(5+760, 0, 120, lineHeight)];
    [_tableCellLabel7 setTextAlignment:NSTextAlignmentCenter];
    [_tableCellLabel7 setTextColor:[UIColor colorWithHexValue:0x7a7a7a]];
    [_tableCellLabel7 setFont:[UIFont systemFontOfSize:14]];
    [_tableCellLabel7 setBackgroundColor:[UIColor clearColor]];
    _tableCellLabel7.text = str7;
    _tableCellLabel7.numberOfLines = 0;
    [cell addSubview:_tableCellLabel7];
    return cell;
}


- (void)buildManagerView
{
    managerView = [[UIView alloc]initWithFrame:CGRectMake(18, 20+36, 984-18*2, 577-20)];
    managerView.backgroundColor = [UIColor whiteColor];
    [bodyView addSubview:managerView];
    
    UIView * tableView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 948, 34+30*7)];
    [managerView addSubview:tableView];
    UIImageView * tableHeaderView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"risk1_03"]];
    tableHeaderView.frame = CGRectMake(0, 0, 948, 34);
    [tableView addSubview:tableHeaderView];
    UILabel * _headerTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, 200, 34)];
    [_headerTitleLabel setTextAlignment:NSTextAlignmentLeft];
    [_headerTitleLabel setTextColor:[UIColor colorWithHexValue:0x6bb3dc]];
    [_headerTitleLabel setFont:[UIFont systemFontOfSize:18]];
    [_headerTitleLabel setBackgroundColor:[UIColor clearColor]];
    _headerTitleLabel.text = @"基金经理简介";
    [tableHeaderView addSubview:_headerTitleLabel];

    UIView * cell1 = [self buildManagerTableCell:@"姓名" str2:@"童汀"];
    cell1.frame = CGRectMake(0, 34, 948, 30);
    [tableView addSubview:cell1];
    UIView * cell2 = [self buildManagerTableCell:@"任职日期" str2:@"2011-01-01"];
    cell2.frame = CGRectMake(0, 34+30, 948, 30);
    [tableView addSubview:cell2];
    UIView * cell3 = [self buildManagerTableCell:@"性别" str2:@"男"];
    cell3.frame = CGRectMake(0, 34+30*2, 948, 30);
    [tableView addSubview:cell3];
    UIView * cell4 = [self buildManagerTableCell:@"出生年份" str2:@"--"];
    cell4.frame = CGRectMake(0, 34+30*3, 948, 30);
    [tableView addSubview:cell4];
    UIView * cell5 = [self buildManagerTableCell:@"学历" str2:@"硕士"];
    cell5.frame = CGRectMake(0, 34+30*4, 948, 30);
    [tableView addSubview:cell5];
    UIView * cell6 = [[UIView alloc]initWithFrame:CGRectMake(0, 34+30*5, 948, 60)];
    cell6.backgroundColor = [UIColor clearColor];
    UILabel * _tableCellLabel11 = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 80, 30)];
    [_tableCellLabel11 setTextAlignment:NSTextAlignmentRight];
    [_tableCellLabel11 setTextColor:[UIColor blackColor]];
    [_tableCellLabel11 setFont:[UIFont systemFontOfSize:14]];
    [_tableCellLabel11 setBackgroundColor:[UIColor clearColor]];
    _tableCellLabel11.text = @"简历";
    [cell6 addSubview:_tableCellLabel11];
    UILabel * _tableCellLabel12 = [[UILabel alloc] initWithFrame:CGRectMake(110, 0, 820, 60)];
    [_tableCellLabel12 setTextAlignment:NSTextAlignmentLeft];
    [_tableCellLabel12 setTextColor:[UIColor colorWithHexValue:0x7a7a7a]];
    [_tableCellLabel12 setFont:[UIFont systemFontOfSize:14]];
    [_tableCellLabel12 setBackgroundColor:[UIColor clearColor]];
    _tableCellLabel12.numberOfLines = 0;
    _tableCellLabel12.text = @"北京大学经济学硕士,美国注册金融分析师,2003-2007 年在申银 万国证券研究所从事电信、媒体、旅游等行业研究,2007 年加盟本公司";
    [cell6 addSubview:_tableCellLabel12];
    [tableView addSubview:cell6];
    UIView * line1 = [[UIView alloc]initWithFrame:CGRectMake(0, 34+30, 948, 1)];
    line1.backgroundColor = [UIColor colorWithHexValue:0xf4f8fc];
    [tableView addSubview:line1];
    UIView * line2 = [[UIView alloc]initWithFrame:CGRectMake(0, 34+30*2, 948, 1)];
    line2.backgroundColor = [UIColor colorWithHexValue:0xf4f8fc];
    [tableView addSubview:line2];
    UIView * line3 = [[UIView alloc]initWithFrame:CGRectMake(0, 34+30*3, 948, 1)];
    line3.backgroundColor = [UIColor colorWithHexValue:0xf4f8fc];
    [tableView addSubview:line3];
    UIView * line4 = [[UIView alloc]initWithFrame:CGRectMake(0, 34+30*4, 948, 1)];
    line4.backgroundColor = [UIColor colorWithHexValue:0xf4f8fc];
    [tableView addSubview:line4];
    UIView * line5 = [[UIView alloc]initWithFrame:CGRectMake(0, 34+30*5, 948, 1)];
    line5.backgroundColor = [UIColor colorWithHexValue:0xf4f8fc];
    [tableView addSubview:line5];
    UIView * line6 = [[UIView alloc]initWithFrame:CGRectMake(0, 34+30*7, 948, 1)];
    line6.backgroundColor = [UIColor colorWithHexValue:0xf4f8fc];
    [tableView addSubview:line6];
    UIView * hLine1 = [[UIView alloc]initWithFrame:CGRectMake(0, 34, 1, 210)];
    hLine1.backgroundColor = [UIColor colorWithHexValue:0xe6e8ed];
    [tableView addSubview:hLine1];
    UIView * hLine2 = [[UIView alloc]initWithFrame:CGRectMake(100, 34, 1, 210)];
    hLine2.backgroundColor = [UIColor colorWithHexValue:0xe6e8ed];
    [tableView addSubview:hLine2];
    UIView * hLine3 = [[UIView alloc]initWithFrame:CGRectMake(948, 34, 1, 210)];
    hLine3.backgroundColor = [UIColor colorWithHexValue:0xe6e8ed];
    [tableView addSubview:hLine3];
    
    UIView * tableView1 = [[UIView alloc]initWithFrame:CGRectMake(0, 34+30*7+20, 948, 34+36+34*3)];
    [managerView addSubview:tableView1];
    UIImageView * tableHeaderView1 = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"risk1_03"]];
    tableHeaderView1.frame = CGRectMake(0, 0, 948, 34);
    [tableView1 addSubview:tableHeaderView1];
    UILabel * _headerTitleLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, 200, 34)];
    [_headerTitleLabel1 setTextAlignment:NSTextAlignmentLeft];
    [_headerTitleLabel1 setTextColor:[UIColor colorWithHexValue:0x6bb3dc]];
    [_headerTitleLabel1 setFont:[UIFont systemFontOfSize:18]];
    [_headerTitleLabel1 setBackgroundColor:[UIColor clearColor]];
    _headerTitleLabel1.text = @"管理业绩";
    [tableHeaderView1 addSubview:_headerTitleLabel1];
    
    UIView * cell11 = [self buildManagerTableCell1:@"基金代码" str2:@"基金名称" str3:@"任职日期" str4:@"离职日期" str5:@"任职时间" str6:@"任职期年化回报(%)" str7:@"+/-同期市场年化平均回报(%)" lineHeight:36];
    cell11.frame = CGRectMake(0, 34, 948, 36);
    [tableView1 addSubview:cell11];
    UIView * cell12 = [self buildManagerTableCell1:@"260115" str2:@"景顺长城中小盘" str3:@"2011-03-08" str4:@"--" str5:@"1年201天" str6:@"0.31" str7:@"9.31" lineHeight:36];
    cell12.frame = CGRectMake(0, 34+36, 948, 34);
    [tableView1 addSubview:cell12];
    UIView * cell13 = [self buildManagerTableCell1:@"250031" str2:@"景顺长城内需增长" str3:@"2013-01-01" str4:@"--" str5:@"1年201天" str6:@"0.96" str7:@"12.51" lineHeight:36];
    cell13.frame = CGRectMake(0, 34+36+34, 948, 34);
    [tableView1 addSubview:cell13];
    UIView * cell14 = [self buildManagerTableCell1:@"320085" str2:@"景顺长城内需增长二" str3:@"2012-01-01" str4:@"--" str5:@"1年201天" str6:@"0.19" str7:@"53.11" lineHeight:36];
    cell14.frame = CGRectMake(0, 34+36+34*2, 948, 34);
    [tableView1 addSubview:cell14];
    UIView * line11 = [[UIView alloc]initWithFrame:CGRectMake(0, 34+36, 948, 1)];
    line11.backgroundColor = [UIColor colorWithHexValue:0xf4f8fc];
    [tableView1 addSubview:line11];
    UIView * line12 = [[UIView alloc]initWithFrame:CGRectMake(0, 34*2+36, 948, 1)];
    line12.backgroundColor = [UIColor colorWithHexValue:0xf4f8fc];
    [tableView1 addSubview:line12];
    UIView * line13 = [[UIView alloc]initWithFrame:CGRectMake(0, 34*3+36, 948, 1)];
    line13.backgroundColor = [UIColor colorWithHexValue:0xf4f8fc];
    [tableView1 addSubview:line13];
    UIView * line14 = [[UIView alloc]initWithFrame:CGRectMake(0, 34*4+36, 948, 1)];
    line14.backgroundColor = [UIColor colorWithHexValue:0xf4f8fc];
    [tableView1 addSubview:line14];
}

- (void)buildBody
{
    bodyView = [[UIView alloc]initWithFrame:CGRectMake(20, 86+14, 1024-20*2, 768-20-59-86-14)];
    bodyView.backgroundColor = [UIColor whiteColor];
    
    //UIView设置边框
//    [[bodyView layer] setCornerRadius:15];
//    [[bodyView layer] setBorderWidth:1];
//    [[bodyView layer] setBorderColor:[UIColor colorWithHexValue:0xbbbbbb].CGColor];
    [self.view addSubview:bodyView];
    
    UIView * headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 984, 36)];
    UIImage *syncBgImg = [UIImage imageNamed:@"risk_05"];
    headerView.backgroundColor = [[UIColor alloc] initWithPatternImage:syncBgImg];
    [bodyView addSubview:headerView];
    
    btnBgImgView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"img_09"]];
    btnBgImgView.frame = CGRectMake(0, 0, 129, 44);
    [headerView addSubview:btnBgImgView];
     doctorBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    doctorBtn.frame = CGRectMake(0, 0, 129, 36);
    doctorBtn.backgroundColor = [UIColor clearColor];
    [doctorBtn setTitle:@"i财富基金医生" forState:UIControlStateNormal];
    [doctorBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    UILabel * label = doctorBtn.titleLabel;
    label.font = [UIFont boldSystemFontOfSize:16];
    [doctorBtn addTarget:self action:@selector(bodyHeaderBtnPress:) forControlEvents:UIControlEventTouchUpInside];
    [headerView addSubview:doctorBtn];
    infoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    infoBtn.frame = CGRectMake(129, 0, 129, 36);
    infoBtn.backgroundColor = [UIColor clearColor];
    [infoBtn setTitle:@"基本情况" forState:UIControlStateNormal];
    [infoBtn setTitleColor:[UIColor colorWithHexValue:0x415c7a] forState:UIControlStateNormal];
    UILabel * label1 = infoBtn.titleLabel;
    label1.font = [UIFont boldSystemFontOfSize:16];
    [infoBtn addTarget:self action:@selector(bodyHeaderBtnPress:) forControlEvents:UIControlEventTouchUpInside];
    [headerView addSubview:infoBtn];
    riskBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    riskBtn.frame = CGRectMake(129*2, 0, 129, 36);
    riskBtn.backgroundColor = [UIColor clearColor];
    [riskBtn setTitle:@"风险收益" forState:UIControlStateNormal];
    [riskBtn setTitleColor:[UIColor colorWithHexValue:0x415c7a] forState:UIControlStateNormal];
    UILabel * label2 = riskBtn.titleLabel;
    label2.font = [UIFont boldSystemFontOfSize:16];
    [riskBtn addTarget:self action:@selector(bodyHeaderBtnPress:) forControlEvents:UIControlEventTouchUpInside];
    [headerView addSubview:riskBtn];
    managerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    managerBtn.frame = CGRectMake(129*3, 0, 129, 36);
    managerBtn.backgroundColor = [UIColor clearColor];
    [managerBtn setTitle:@"基金经理" forState:UIControlStateNormal];
    [managerBtn setTitleColor:[UIColor colorWithHexValue:0x415c7a] forState:UIControlStateNormal];
    UILabel * label3 = managerBtn.titleLabel;
    label3.font = [UIFont boldSystemFontOfSize:16];
    [managerBtn addTarget:self action:@selector(bodyHeaderBtnPress:) forControlEvents:UIControlEventTouchUpInside];
    [headerView addSubview:managerBtn];
    
    [self buildDoctorView];
    [self buildInfoView];
    [self buildRiskView];
    [self buildManagerView];
    [bodyView bringSubviewToFront:doctorView];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    //    self.extendedLayoutIncludesOpaqueBars = NO;
    //    self.edgesForExtendedLayout = UIRectEdgeBottom | UIRectEdgeLeft | UIRectEdgeRight;
    self.view.backgroundColor = [UIColor clearColor];
    self.navigationController.navigationBarHidden = YES;
    
//    UIView * statusBarBg = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 1024, 20)];
//    statusBarBg.backgroundColor = [UIColor blackColor];
//    [self.view addSubview:statusBarBg];
    self.view.backgroundColor = [UIColor colorWithHexValue:0xf1f1ee];
    
    [self buildHeaderView];
    [self buildBody];
    [self getfundDoctorRequestData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) getFundDoctorRequestSuccess:(FundDoctorRequest *)request
{
	BOOL isRequestSuccess = [doctorRequest isRequestSuccess];
    if (isRequestSuccess) {
        doctorData = [doctorRequest getData];
    }
    else {
    }
}

- (void) getFundDoctorRequestFailed:(FundDoctorRequest *)request
{
    
}

- (void)getfundDoctorRequestData
{
    NSString * url = [NSString stringWithFormat:@"%@%@", HOST_NAME, DOCTOR];
    NSMutableArray * array = [[NSMutableArray alloc]initWithCapacity:0];
    [array addObject:[NSString stringWithFormat:@"%@=%@", OPENID, OPENID_VALUE]];
    [array addObject:[NSString stringWithFormat:@"%@=%@", TYPE, DATA_FORMAT]];
    if (_UI.isLogin) {
        [array addObject:[NSString stringWithFormat:@"%@=%@", @"user_name", _UI.userName]];
        [array addObject:[NSString stringWithFormat:@"%@=%@", @"access_token", _UI.loginToken]];
    }
    //    [array addObject:[NSString stringWithFormat:@"%@=%@", @"page_no", @"1"]];
    //    [array addObject:[NSString stringWithFormat:@"%@=%@", @"page_size", @"2"]];
    
    [array addObject:[NSString stringWithFormat:@"%@=%d", @"code", fundCode]];
    NSString * md5Result = [_UI md5EncParam:array];
    url = [url stringByAppendingString:md5Result];
    url = [url URLEncodedString];
    doctorRequest = [[FundDoctorRequest alloc]initWithUrl:url];
    
	doctorRequest.delegate = self;
    doctorRequest.requestDidFinishSelector = @selector(getFundDoctorRequestSuccess:);
    doctorRequest.requestDidFailedSelector = @selector(getFundDoctorRequestFailed:);
    
    [doctorRequest sendRequest];
}

@end
