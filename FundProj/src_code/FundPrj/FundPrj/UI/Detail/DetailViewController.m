//
//  DetailViewController.m
//  FundPrj
//
//  Created by leesea on 13-11-18.
//  Copyright (c) 2013年 leesea. All rights reserved.
//

#import "DetailViewController.h"
#import <sqlite3.h>
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
#import "FundDetailPercentRequest.h"
#import "FundDetailPercentData.h"
#import "PCPieChart.h"
#import "MyFavoriteFundList.h"


#define DB_NAME    @"FundDB.sqlite"
#define NAME      @"name"
#define CODE       @"code"
#define PY   @"py"


typedef enum _FundType {
	MoneyType = 0,
    NotMoneyType = 1
} FundType;


@interface DetailViewController ()
{
    NSInteger fundCode;
    
    UIView * chartView;
    UIView * historyView;
    UIView * bodyView;
    
    UIButton * propertyBtn;
    UIButton * industryBtn;
    UIButton * infoBtn;
    UIButton * managerBtn;
    
    UIView * propertyView;
    UIView * industryView;
    UIView * infoView;
    UIView * managerView;
    
    UIButton * followBtnView;
    
    NSString *db_path;
    
    FMDatabase *dbBase;
    
    FundQuoteRequest * fundQuoteRequest;
    NSMutableArray * fundQuoteDataArray;
    
    FundQuoteHistoryRequest * fundQuoteHistoryRequest;
    NSMutableArray * fundQuoteHistoryDataArray;
    
    FundDetailInfoRequst * fundDetailInfoRequst;
    FundDetailInfoData * fundDetailInfoData;
    
    FundManagerInfoRequest * fundManagerInfoRequest;
    FundManagerInfoData * fundManagerInfoData;
    
    FundDetailPercentRequest * fundDetailPercentRequest;
    FundDetailPercentData * fundDetailPercentData;
    
    
    CPTXYGraph                  *graph;             //画板
    CPTScatterPlot              *dataSourceLinePlot;//线
    NSMutableArray              *dataForPlot1;      //坐标数组
    
    FundType type;
    NSInteger fundHistoryMax;
    NSInteger fundHistoryMin;
    
    NSString * manager;
}

@end

@implementation DetailViewController

- (id)initWithFundCode:(NSInteger)code
{
    self = [super init];
    if (self) {
        // Custom initialization
        fundCode = code;
        
        
        dataForPlot1 = [[NSMutableArray alloc] init];
        
        db_path = [PATH_OF_DOCUMENT stringByAppendingPathComponent:DB_NAME];
        dbBase = [FMDatabase databaseWithPath:db_path];
        
        fundQuoteDataArray = [[NSMutableArray alloc]initWithCapacity:0];
        
        type = MoneyType;
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
    NSString* fundSymbol = [NSString stringWithFormat:@"%06d.cn",fundCode];
    if (![[MyFavoriteFundList sharedInstance] isExisted:fundSymbol])
    {
        [[MyFavoriteFundList sharedInstance] addFundCode:fundSymbol target:self succeedSel:@selector(getAddMyFundRequestSuccess) failedSel:@selector(getAddMyFundRequestFailed)];
        [[FPTipsManager sharedManager] postLoading:@""];
    }
    else
    {
        [[MyFavoriteFundList sharedInstance] removeFundCode:fundSymbol target:self succeedSel:@selector(getRemoveMyFundRequestSuccess) failedSel:@selector(getRemoveMyFundRequestFailed)];
        [[FPTipsManager sharedManager] postLoading:@""];
    }
    
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
    [nameLabel setTextAlignment:NSTextAlignmentLeft];
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
    [bondBtn setTitleColor:[UIColor colorWithHexValue:0x333333] forState:UIControlStateNormal];
//    [bondBtn setBackgroundImage:[UIImage imageNamed:@"detail_11"] forState:UIControlStateNormal];
//    [bondBtn setBackgroundImage:[UIImage imageNamed:@"detail_11"] forState:UIControlStateHighlighted];
    [bondBtn addTarget:self action:@selector(bondBtnPress:) forControlEvents:UIControlEventTouchUpInside];
    [headerView addSubview:bondBtn];
    UIButton * followBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    followBtn.frame = CGRectMake(255, 50, 63, 23);
    followBtnView = followBtn;
    NSString* fundSymbol = [NSString stringWithFormat:@"%06d.CN",fundCode];
    if (![[MyFavoriteFundList sharedInstance] isExisted:fundSymbol])
    {
        [followBtnView setBackgroundImage:[UIImage imageNamed:@"detail_14"] forState:UIControlStateNormal];
    }
    else
    {
        [followBtnView setBackgroundImage:[UIImage imageNamed:@"detail_14_2"] forState:UIControlStateNormal];
    }
    
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
#pragma mark - dataSourceOpt

-(NSUInteger)numberOfRecordsForPlot:(CPTPlot *)plot
{
    return [dataForPlot1 count];
}

-(NSNumber *)numberForPlot:(CPTPlot *)plot field:(NSUInteger)fieldEnum recordIndex:(NSUInteger)index
{
    NSString * key = (fieldEnum == CPTScatterPlotFieldX ? @"x" : @"y");
    NSNumber *num;
    //让视图偏移
	if ( [(NSString *)plot.identifier isEqualToString:@"Green Plot"] ) {
        num = [[dataForPlot1 objectAtIndex:index] valueForKey:key];
        if ( fieldEnum == CPTScatterPlotFieldX ) {
			num = [NSNumber numberWithDouble:[num doubleValue]];
		}
	}
    //添加动画效果
    CABasicAnimation *fadeInAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
	fadeInAnimation.duration = 1.0f;
	fadeInAnimation.removedOnCompletion = NO;
	fadeInAnimation.fillMode = kCAFillModeForwards;
	fadeInAnimation.toValue = [NSNumber numberWithFloat:2.0];
	[dataSourceLinePlot addAnimation:fadeInAnimation forKey:@"animateOpacity"];
    return num;
}

- (void)buildChartView
{
    chartView = [[UIView alloc]initWithFrame:CGRectMake(18, 86+18, 645, 330)];
    [self.view addSubview:chartView];
    
    graph = [[CPTXYGraph alloc] initWithFrame:chartView.bounds];
    
    //给画板添加一个主题
    CPTTheme *theme = [CPTTheme themeNamed:kCPTDarkGradientTheme];
    [graph applyTheme:theme];
    
    //创建主画板视图添加画板
    CPTGraphHostingView *hostingView = [[CPTGraphHostingView alloc] initWithFrame:chartView.bounds];
    hostingView.hostedGraph = graph;
    
	[chartView addSubview:hostingView];
    
    //设置留白
    graph.paddingLeft = 0;
	graph.paddingTop = 0;
	graph.paddingRight = 0;
	graph.paddingBottom = 0;
    
    graph.plotAreaFrame.paddingLeft = 60 ;
    graph.plotAreaFrame.paddingTop = 40.0 ;
    graph.plotAreaFrame.paddingRight = 5.0 ;
    graph.plotAreaFrame.paddingBottom = 40.0 ;
    //设置坐标范围
    CPTXYPlotSpace *plotSpace = (CPTXYPlotSpace *)graph.defaultPlotSpace;
    plotSpace.allowsUserInteraction = NO;
    
    plotSpace.xRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(0.0) length:CPTDecimalFromFloat(60.0)];
    plotSpace.yRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(0) length:CPTDecimalFromFloat(fundHistoryMax+fundHistoryMin/2)];
    
    //设置坐标刻度大小
    CPTXYAxisSet *axisSet = (CPTXYAxisSet *) graph.axisSet ;
    CPTXYAxis *x = axisSet.xAxis ;
    //    x.labelingPolicy = CPTAxisLabelingPolicyNone;
    x. minorTickLineStyle = nil ;
    x.labelingPolicy = CPTAxisLabelingPolicyNone;
    
    NSMutableArray *labelArray=[NSMutableArray arrayWithCapacity:60];
    
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSDateComponents *components = [cal components:( NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit ) fromDate:[[NSDate alloc] init]];
    [components setHour:-[components hour]];
    [components setMinute:-[components minute]];
    [components setSecond:-[components second]];
    NSDate *today = [cal dateByAddingComponents:components toDate:[[NSDate alloc] init] options:0];
    [components setDay:-15];
    NSDate *last15Day  = [cal dateByAddingComponents:components toDate: today options:0];
    [components setDay:-30];
    NSDate *last30Day  = [cal dateByAddingComponents:components toDate: today options:0];
    [components setDay:-45];
    NSDate *this45Day = [cal dateByAddingComponents:components toDate: today options:0];
    [components setDay:-60];
    NSDate *last60Day = [cal dateByAddingComponents:components toDate: today options:0];
    
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy年MM月dd日"];
    
    for ( int  i = 1 ; i<=60 ;i++)
    {
        CPTAxisLabel *newLabel ;
        if(i == 1)
        {
            newLabel=[[CPTAxisLabel alloc] initWithText:[formatter stringFromDate:last60Day] textStyle:x.labelTextStyle];
        }else if (i== 14){
            newLabel=[[CPTAxisLabel alloc] initWithText:[formatter stringFromDate:this45Day] textStyle:x.labelTextStyle];
        }else if (i== 27){
            newLabel=[[CPTAxisLabel alloc] initWithText:[formatter stringFromDate:last30Day] textStyle:x.labelTextStyle];
        }else if (i== 40){
            newLabel=[[CPTAxisLabel alloc] initWithText:[formatter stringFromDate:last15Day] textStyle:x.labelTextStyle];
        }else if (i== 53){
            newLabel=[[CPTAxisLabel alloc] initWithText:[formatter stringFromDate:today] textStyle:x.labelTextStyle];
        }
        else{
            newLabel=[[CPTAxisLabel alloc] initWithText:@"" textStyle:x.labelTextStyle];
        }
        newLabel.tickLocation=[[NSNumber numberWithInt:i] decimalValue];
        newLabel.offset=x.labelOffset+x.majorTickLength;
        [labelArray addObject:newLabel];
    }
    x.axisLabels=[NSSet setWithArray:labelArray];
    
    CPTXYAxis *y = axisSet.yAxis ;
    //y 轴：不显示小刻度线
    y. minorTickLineStyle = nil ;
    // 大刻度线间距： 50 单位
    y. majorIntervalLength = CPTDecimalFromString ( [NSString stringWithFormat:@"%d", fundHistoryMax/4 ] );
    // 坐标原点： 0
    y. orthogonalCoordinateDecimal = CPTDecimalFromString ([NSString stringWithFormat:@"%d", 0]);
    
    //创建绿色区域
    dataSourceLinePlot = [[CPTScatterPlot alloc] init];
    dataSourceLinePlot.identifier = @"Green Plot";
    
    //设置绿色区域边框的样式
    CPTMutableLineStyle *lineStyle = [dataSourceLinePlot.dataLineStyle mutableCopy];
    lineStyle.lineWidth = 1.f;
    lineStyle.lineColor = [CPTColor greenColor];
    dataSourceLinePlot.dataLineStyle = lineStyle;
    //设置透明实现添加动画
    dataSourceLinePlot.opacity = 0.0f;
    
    //设置数据元代理
    dataSourceLinePlot.dataSource = self;
    [graph addPlot:dataSourceLinePlot];
    
    // 创建一个颜色渐变：从 建变色 1 渐变到 无色
    CPTGradient *areaGradient = [ CPTGradient gradientWithBeginningColor :[CPTColor greenColor] endingColor :[CPTColor colorWithComponentRed:0.65 green:0.65 blue:0.16 alpha:0.2]];
    // 渐变角度： -90 度（顺时针旋转）
    areaGradient.angle = -90.0f ;
    // 创建一个颜色填充：以颜色渐变进行填充
    CPTFill *areaGradientFill = [ CPTFill fillWithGradient :areaGradient];
    // 为图形设置渐变区
    dataSourceLinePlot. areaFill = areaGradientFill;
    dataSourceLinePlot. areaBaseValue = CPTDecimalFromString ( @"0.0" );
    dataSourceLinePlot.interpolation = CPTScatterPlotInterpolationLinear ;
    
    //刷新画板
    [graph reloadData];
}

- (UIView *)buildHistoryTableCell:(NSString *)str1 str2:(NSString *)str2 str3:(NSString *)str3 str4:(NSString *)str4
{
    UIView * cell = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 645, 30)];
    cell.backgroundColor = [UIColor clearColor];
    UILabel * _tableCellLabel11 = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 180, 30)];
    [_tableCellLabel11 setTextAlignment:NSTextAlignmentLeft];
    [_tableCellLabel11 setTextColor:[UIColor blackColor]];
    [_tableCellLabel11 setFont:[UIFont systemFontOfSize:14]];
    [_tableCellLabel11 setBackgroundColor:[UIColor clearColor]];
    _tableCellLabel11.text = str1;
    [cell addSubview:_tableCellLabel11];
    UILabel * _tableCellLabel12 = [[UILabel alloc] initWithFrame:CGRectMake(200, 0, 160, 30)];
    [_tableCellLabel12 setTextAlignment:NSTextAlignmentCenter];
    [_tableCellLabel12 setTextColor:[UIColor colorWithHexValue:0x7a7a7a]];
    [_tableCellLabel12 setFont:[UIFont systemFontOfSize:14]];
    [_tableCellLabel12 setBackgroundColor:[UIColor clearColor]];
    _tableCellLabel12.text = str2;
    [cell addSubview:_tableCellLabel12];
    UILabel * _tableCellLabel13 = [[UILabel alloc] initWithFrame:CGRectMake(360, 0, 180, 30)];
    [_tableCellLabel13 setTextAlignment:NSTextAlignmentCenter];
    [_tableCellLabel13 setTextColor:[UIColor colorWithHexValue:0x7a7a7a]];
    [_tableCellLabel13 setFont:[UIFont systemFontOfSize:14]];
    [_tableCellLabel13 setBackgroundColor:[UIColor clearColor]];
    _tableCellLabel13.text = str3;
    [cell addSubview:_tableCellLabel13];
    UILabel * _tableCellLabel14 = [[UILabel alloc] initWithFrame:CGRectMake(540, 0, 90, 30)];
    [_tableCellLabel14 setTextAlignment:NSTextAlignmentRight];
    [_tableCellLabel14 setTextColor:[UIColor colorWithHexValue:0x7a7a7a]];
    [_tableCellLabel14 setFont:[UIFont systemFontOfSize:14]];
    [_tableCellLabel14 setBackgroundColor:[UIColor clearColor]];
    _tableCellLabel14.text = str4;
    [cell addSubview:_tableCellLabel14];
    return cell;
}

- (void)buildHistoryView
{
    historyView = [[UIView alloc]initWithFrame:CGRectMake(18, 86+30+330, 645, 38*2+30*5)];
    historyView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:historyView];
    
    UIView * tableView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 645, 38*2+30*5)];
    [historyView addSubview:tableView];
    UIImageView * tableHeaderView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 645, 38)];
    tableHeaderView.image = [[UIImage imageNamed:@"home01_13"] stretchableImageWithLeftCapWidth:252/2 topCapHeight:34/2];
    [tableView addSubview:tableHeaderView];
    UILabel * _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 625, 38)];
    [_titleLabel setTextAlignment:NSTextAlignmentLeft];
    [_titleLabel setTextColor:[UIColor whiteColor]];
    [_titleLabel setFont:[UIFont systemFontOfSize:20]];
    [_titleLabel setBackgroundColor:[UIColor clearColor]];
    _titleLabel.text = @"历史回报";
    [tableHeaderView addSubview:_titleLabel];
    
    
    
    UIView * cell = [self buildHistoryTableCell:@"" str2:@"总回报" str3:@"+/-基准指数" str4:@"排名"];
    cell.frame = CGRectMake(0, 38+4, 645, 30);
    [tableView addSubview:cell];
    if ([dbBase open]) {
        if(type == MoneyType)
        {
            
            
            NSString *sqlRankMoneyQuery = [NSString stringWithFormat:@"SELECT * FROM FUNDRANKMONEY WHERE %@ = '%d'", @"code", fundCode ];
            FMResultSet * rs2 = [dbBase executeQuery:sqlRankMoneyQuery];
            while ([rs2 next]) {
                UIView * cell1 = [self buildHistoryTableCell:@"一个月回报" str2:[NSString stringWithFormat:@"%d", [rs2 intForColumn:@"rr_one_month"]] str3:@"1.50" str4:[NSString stringWithFormat:@"%d", [rs2 intForColumn:@"rr_one_month_rank"]]];
                cell1.frame = CGRectMake(0, 38*2, 645, 30);
                [tableView addSubview:cell1];
                UIView * cell2 = [self buildHistoryTableCell:@"六个月回报" str2:[NSString stringWithFormat:@"%d", [rs2 intForColumn:@"rr_six_month"]] str3:@"1.50" str4:[NSString stringWithFormat:@"%d", [rs2 intForColumn:@"rr_six_month_rank"]]];
                cell2.frame = CGRectMake(0, 38*2+30, 645, 30);
                [tableView addSubview:cell2];
                UIView * cell3 = [self buildHistoryTableCell:@"一年回报" str2:[NSString stringWithFormat:@"%d", [rs2 intForColumn:@"rr_one_year"]] str3:@"1.50" str4:[NSString stringWithFormat:@"%d", [rs2 intForColumn:@"rr_one_year_rank"]]];
                cell3.frame = CGRectMake(0, 38*2+30*2, 645, 30);
                [tableView addSubview:cell3];
                UIView * cell4 = [self buildHistoryTableCell:@"二年回报" str2:[NSString stringWithFormat:@"%d", [rs2 intForColumn:@"rr_two_year"]] str3:@"1.50" str4:[NSString stringWithFormat:@"%d", [rs2 intForColumn:@"rr_two_year_rank"]]];
                cell4.frame = CGRectMake(0, 38*2+30*3, 645, 30);
                [tableView addSubview:cell4];
                UIView * cell5 = [self buildHistoryTableCell:@"三年回报" str2:[NSString stringWithFormat:@"%d", [rs2 intForColumn:@"rr_three_year"]] str3:@"1.50" str4:[NSString stringWithFormat:@"%d", [rs2 intForColumn:@"rr_three_year_rank"]]];
                cell5.frame = CGRectMake(0, 38*2+30*4, 645, 30);
                [tableView addSubview:cell5];
            }
        }
        else if(type == NotMoneyType)
        {


            NSString *sqlRankNotMoneyQuery = [NSString stringWithFormat:@"SELECT * FROM FUNDRANKNOTMONEY WHERE %@ = '%d'", @"code", fundCode ];
            FMResultSet * rs3 = [dbBase executeQuery:sqlRankNotMoneyQuery];
            while ([rs3 next]) {
                UIView * cell1 = [self buildHistoryTableCell:@"一个月回报" str2:[NSString stringWithFormat:@"%d", [rs3 intForColumn:@"rr_one_month"]] str3:@"1.50" str4:[NSString stringWithFormat:@"%d", [rs3 intForColumn:@"rr_one_month_rank"]]];
                cell1.frame = CGRectMake(0, 38*2, 645, 30);
                [tableView addSubview:cell1];
                UIView * cell2 = [self buildHistoryTableCell:@"六个月回报" str2:[NSString stringWithFormat:@"%d", [rs3 intForColumn:@"rr_six_month"]] str3:@"1.50" str4:[NSString stringWithFormat:@"%d", [rs3 intForColumn:@"rr_six_month_rank"]]];
                cell2.frame = CGRectMake(0, 38*2+30, 645, 30);
                [tableView addSubview:cell2];
                UIView * cell3 = [self buildHistoryTableCell:@"一年回报" str2:[NSString stringWithFormat:@"%d", [rs3 intForColumn:@"rr_one_year"]] str3:@"1.50" str4:[NSString stringWithFormat:@"%d", [rs3 intForColumn:@"rr_one_year_rank"]]];
                cell3.frame = CGRectMake(0, 38*2+30*2, 645, 30);
                [tableView addSubview:cell3];
                UIView * cell4 = [self buildHistoryTableCell:@"二年回报" str2:[NSString stringWithFormat:@"%d", [rs3 intForColumn:@"rr_two_year"]] str3:@"1.50" str4:[NSString stringWithFormat:@"%d", [rs3 intForColumn:@"rr_two_year_rank"]]];
                cell4.frame = CGRectMake(0, 38*2+30*3, 645, 30);
                [tableView addSubview:cell4];
                UIView * cell5 = [self buildHistoryTableCell:@"三年回报" str2:[NSString stringWithFormat:@"%d", [rs3 intForColumn:@"rr_three_year"]] str3:@"1.50" str4:[NSString stringWithFormat:@"%d", [rs3 intForColumn:@"rr_three_year_rank"]]];
                cell5.frame = CGRectMake(0, 38*2+30*4, 645, 30);
                [tableView addSubview:cell5];
            }
        }
        
        
        [dbBase close];
    }
    UIView * line1 = [[UIView alloc]initWithFrame:CGRectMake(0, 38*2, 948, 1)];
    line1.backgroundColor = [UIColor colorWithHexValue:0xf4f8fc];
    [tableView addSubview:line1];
    UIView * line2 = [[UIView alloc]initWithFrame:CGRectMake(0, 38*2+30, 948, 1)];
    line2.backgroundColor = [UIColor colorWithHexValue:0xf4f8fc];
    [tableView addSubview:line2];
    UIView * line3 = [[UIView alloc]initWithFrame:CGRectMake(0, 38*2+30*2, 948, 1)];
    line3.backgroundColor = [UIColor colorWithHexValue:0xf4f8fc];
    [tableView addSubview:line3];
    UIView * line4 = [[UIView alloc]initWithFrame:CGRectMake(0, 38*2+30*3, 948, 1)];
    line4.backgroundColor = [UIColor colorWithHexValue:0xf4f8fc];
    [tableView addSubview:line4];
    UIView * line5 = [[UIView alloc]initWithFrame:CGRectMake(0, 38*2+30*4, 948, 1)];
    line5.backgroundColor = [UIColor colorWithHexValue:0xf4f8fc];
    [tableView addSubview:line5];
}

- (void)bodyHeaderBtnPress:(id)sender
{
    UIButton * btnClick = (UIButton *)sender;
    if (btnClick == propertyBtn) {
        [propertyBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [propertyBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        [industryBtn setTitleColor:[UIColor colorWithHexValue:0x415c7a] forState:UIControlStateNormal];
        [industryBtn setTitleColor:[UIColor colorWithHexValue:0x415c7a] forState:UIControlStateSelected];
        [infoBtn setTitleColor:[UIColor colorWithHexValue:0x415c7a] forState:UIControlStateNormal];
        [infoBtn setTitleColor:[UIColor colorWithHexValue:0x415c7a] forState:UIControlStateSelected];
        [managerBtn setTitleColor:[UIColor colorWithHexValue:0x415c7a] forState:UIControlStateNormal];
        [managerBtn setTitleColor:[UIColor colorWithHexValue:0x415c7a] forState:UIControlStateSelected];
        [bodyView bringSubviewToFront:propertyView];
        [propertyBtn setBackgroundColor:[UIColor colorWithHexValue:0x1ba7dd]];
        [industryBtn setBackgroundColor:[UIColor clearColor]];
        [infoBtn setBackgroundColor:[UIColor clearColor]];
        [managerBtn setBackgroundColor:[UIColor clearColor]];
    }
    else if (btnClick == industryBtn) {
        [propertyBtn setTitleColor:[UIColor colorWithHexValue:0x415c7a] forState:UIControlStateNormal];
        [propertyBtn setTitleColor:[UIColor colorWithHexValue:0x415c7a] forState:UIControlStateSelected];
        [industryBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [industryBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        [infoBtn setTitleColor:[UIColor colorWithHexValue:0x415c7a] forState:UIControlStateNormal];
        [infoBtn setTitleColor:[UIColor colorWithHexValue:0x415c7a] forState:UIControlStateSelected];
        [managerBtn setTitleColor:[UIColor colorWithHexValue:0x415c7a] forState:UIControlStateNormal];
        [managerBtn setTitleColor:[UIColor colorWithHexValue:0x415c7a] forState:UIControlStateSelected];
        [bodyView bringSubviewToFront:industryView];
        [propertyBtn setBackgroundColor:[UIColor clearColor]];
        [industryBtn setBackgroundColor:[UIColor colorWithHexValue:0x1ba7dd]];
        [infoBtn setBackgroundColor:[UIColor clearColor]];
        [managerBtn setBackgroundColor:[UIColor clearColor]];
    }
    else if (btnClick == infoBtn) {
        [propertyBtn setTitleColor:[UIColor colorWithHexValue:0x415c7a] forState:UIControlStateNormal];
        [propertyBtn setTitleColor:[UIColor colorWithHexValue:0x415c7a] forState:UIControlStateSelected];
        [industryBtn setTitleColor:[UIColor colorWithHexValue:0x415c7a] forState:UIControlStateNormal];
        [industryBtn setTitleColor:[UIColor colorWithHexValue:0x415c7a] forState:UIControlStateSelected];
        [infoBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [infoBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        [managerBtn setTitleColor:[UIColor colorWithHexValue:0x415c7a] forState:UIControlStateNormal];
        [managerBtn setTitleColor:[UIColor colorWithHexValue:0x415c7a] forState:UIControlStateSelected];
        [bodyView bringSubviewToFront:infoView];
        [propertyBtn setBackgroundColor:[UIColor clearColor]];
        [industryBtn setBackgroundColor:[UIColor clearColor]];
        [infoBtn setBackgroundColor:[UIColor colorWithHexValue:0x1ba7dd]];
        [managerBtn setBackgroundColor:[UIColor clearColor]];
    }
    else if (btnClick == managerBtn) {
        [propertyBtn setTitleColor:[UIColor colorWithHexValue:0x415c7a] forState:UIControlStateNormal];
        [propertyBtn setTitleColor:[UIColor colorWithHexValue:0x415c7a] forState:UIControlStateSelected];
        [industryBtn setTitleColor:[UIColor colorWithHexValue:0x415c7a] forState:UIControlStateNormal];
        [industryBtn setTitleColor:[UIColor colorWithHexValue:0x415c7a] forState:UIControlStateSelected];
        [infoBtn setTitleColor:[UIColor colorWithHexValue:0x415c7a] forState:UIControlStateNormal];
        [infoBtn setTitleColor:[UIColor colorWithHexValue:0x415c7a] forState:UIControlStateSelected];
        [managerBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [managerBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        [bodyView bringSubviewToFront:managerView];
        [propertyBtn setBackgroundColor:[UIColor clearColor]];
        [industryBtn setBackgroundColor:[UIColor clearColor]];
        [infoBtn setBackgroundColor:[UIColor clearColor]];
        [managerBtn setBackgroundColor:[UIColor colorWithHexValue:0x1ba7dd]];
    }
}

- (void)buildBody
{
    bodyView = [[UIView alloc]initWithFrame:CGRectMake(18+645+18, 86+18, 328, 570)];
    bodyView.backgroundColor = [UIColor whiteColor];
    
    //UIView设置边框
    //    [[bodyView layer] setCornerRadius:15];
    //    [[bodyView layer] setBorderWidth:1];
    //    [[bodyView layer] setBorderColor:[UIColor colorWithHexValue:0xbbbbbb].CGColor];
    [self.view addSubview:bodyView];
    
    UIView * headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 328, 36)];
    UIImage *syncBgImg = [UIImage imageNamed:@"risk_05"];
    headerView.backgroundColor = [[UIColor alloc] initWithPatternImage:syncBgImg];
    [bodyView addSubview:headerView];
    
    propertyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    propertyBtn.frame = CGRectMake(0, 0, 82, 36);
    [propertyBtn setBackgroundColor:[UIColor colorWithHexValue:0x1ba7dd]];
    [propertyBtn setTitle:@"资产配置" forState:UIControlStateNormal];
    [propertyBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    UILabel * label = propertyBtn.titleLabel;
    label.font = [UIFont boldSystemFontOfSize:16];
    [propertyBtn addTarget:self action:@selector(bodyHeaderBtnPress:) forControlEvents:UIControlEventTouchUpInside];
    [headerView addSubview:propertyBtn];
    
    industryBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    industryBtn.frame = CGRectMake(82*3, 0, 82, 36);
    industryBtn.backgroundColor = [UIColor clearColor];
    [industryBtn setTitle:@"行业配置" forState:UIControlStateNormal];
    [industryBtn setTitleColor:[UIColor colorWithHexValue:0x415c7a] forState:UIControlStateNormal];
    UILabel * label2 = industryBtn.titleLabel;
    label2.font = [UIFont boldSystemFontOfSize:16];
    [industryBtn addTarget:self action:@selector(bodyHeaderBtnPress:) forControlEvents:UIControlEventTouchUpInside];
    [headerView addSubview:industryBtn];
    if (type == MoneyType) {
        industryBtn.hidden = YES;
    }
    
    infoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    infoBtn.frame = CGRectMake(82, 0, 82, 36);
    infoBtn.backgroundColor = [UIColor clearColor];
    [infoBtn setTitle:@"基本信息" forState:UIControlStateNormal];
    [infoBtn setTitleColor:[UIColor colorWithHexValue:0x415c7a] forState:UIControlStateNormal];
    UILabel * label1 = infoBtn.titleLabel;
    label1.font = [UIFont boldSystemFontOfSize:16];
    [infoBtn addTarget:self action:@selector(bodyHeaderBtnPress:) forControlEvents:UIControlEventTouchUpInside];
    [headerView addSubview:infoBtn];
    
    managerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    managerBtn.frame = CGRectMake(82*2, 0, 82, 36);
    managerBtn.backgroundColor = [UIColor clearColor];
    [managerBtn setTitle:@"基金经理" forState:UIControlStateNormal];
    [managerBtn setTitleColor:[UIColor colorWithHexValue:0x415c7a] forState:UIControlStateNormal];
    UILabel * label3 = managerBtn.titleLabel;
    label3.font = [UIFont boldSystemFontOfSize:16];
    [managerBtn addTarget:self action:@selector(bodyHeaderBtnPress:) forControlEvents:UIControlEventTouchUpInside];
    [headerView addSubview:managerBtn];
    
//    [self buildpropertyView];
//    [self buildindustryView];
    [self buildInfoView];
//    [self buildManagerView];
    [bodyView bringSubviewToFront:propertyView];
}

- (void)buildpropertyView
{
    propertyView = [[UIView alloc]initWithFrame:CGRectMake(10, 36+10, 308, 550-36)];
    propertyView.backgroundColor = [UIColor whiteColor];
    [bodyView addSubview:propertyView];
    
    PCPieChart *pieChart = [[PCPieChart alloc] initWithFrame:CGRectMake(0, 0, 308, 550-36)];
    [pieChart setShowArrow:NO];
    [pieChart setSameColorLabel:YES];
    [pieChart setAutoresizingMask:UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleBottomMargin];
    [pieChart setDiameter:308*3/4];
    [self.view addSubview:pieChart];
    
    pieChart.titleFont = [UIFont fontWithName:@"HelveticaNeue-Bold" size:20];
    pieChart.percentageFont = [UIFont fontWithName:@"HelveticaNeue-Bold" size:20];
    
    int i = 0;
    NSArray * colorArray = PCColorArray;
    NSMutableArray *components = [NSMutableArray array];
    PCPieComponent *component = [PCPieComponent pieComponentWithTitle:@"股票市值占基金资产比例（%）" value:fundDetailPercentData.stock_ratio];
    [component setColour:[colorArray objectAtIndex:i++]];
    [components addObject:component];
    component = [PCPieComponent pieComponentWithTitle:@"债券市值占基金资产比例（%）" value:fundDetailPercentData.bond_ratio];
    [component setColour:[colorArray objectAtIndex:i++]];
    [components addObject:component];
    component = [PCPieComponent pieComponentWithTitle:@"权证市值占基金资产比例（%）" value:fundDetailPercentData.warrant_ratio];
    [component setColour:[colorArray objectAtIndex:i++]];
    [components addObject:component];
    component = [PCPieComponent pieComponentWithTitle:@"权证市值占基金资产比例（%）" value:fundDetailPercentData.money_ratio];
    [component setColour:[colorArray objectAtIndex:i++]];
    [components addObject:component];
    component = [PCPieComponent pieComponentWithTitle:@"其他资产占基金资产比例（%）" value:fundDetailPercentData.other_ratio];
    [component setColour:[colorArray objectAtIndex:i++]];
    [components addObject:component];
        
    [pieChart setComponents:components];
    [propertyView addSubview:pieChart];
    [bodyView bringSubviewToFront:propertyView];
}

- (void)buildindustryView
{
    industryView = [[UIView alloc]initWithFrame:CGRectMake(10, 36+10, 308, 550-36)];
    industryView.backgroundColor = [UIColor whiteColor];
    [bodyView addSubview:industryView];
    
    PCPieChart *pieChart = [[PCPieChart alloc] initWithFrame:CGRectMake(0, 0, 308, 550-36)];
    [pieChart setShowArrow:NO];
    [pieChart setSameColorLabel:YES];
    [pieChart setAutoresizingMask:UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleBottomMargin];
    [pieChart setDiameter:308/2];
    [self.view addSubview:pieChart];
    
    pieChart.titleFont = [UIFont fontWithName:@"HelveticaNeue-Bold" size:20];
    pieChart.percentageFont = [UIFont fontWithName:@"HelveticaNeue-Bold" size:20];
    
    int i = 0;
    NSArray * colorArray = PCColorArray;
    NSMutableArray *components = [NSMutableArray array];
    
    PCPieComponent *component = [PCPieComponent pieComponentWithTitle:@"农、林、牧、渔业" value:fundDetailPercentData.A];
    [component setColour:[colorArray objectAtIndex:i++]];
    if (fundDetailPercentData.A != 0) {
        [components addObject:component];
    }
    component = [PCPieComponent pieComponentWithTitle:@"采矿业" value:fundDetailPercentData.B];
    [component setColour:[colorArray objectAtIndex:i++]];
    if (fundDetailPercentData.B != 0) {
        [components addObject:component];
    }
    component = [PCPieComponent pieComponentWithTitle:@"制造业" value:fundDetailPercentData.C];
    [component setColour:[colorArray objectAtIndex:i++]];
    if (fundDetailPercentData.C != 0) {
        [components addObject:component];
    }
    component = [PCPieComponent pieComponentWithTitle:@"电力、热力、燃气及水生产和供应业" value:fundDetailPercentData.D];
    [component setColour:[colorArray objectAtIndex:i++]];
    if (fundDetailPercentData.D != 0) {
        [components addObject:component];
    }
    component = [PCPieComponent pieComponentWithTitle:@"建筑业" value:fundDetailPercentData.E];
    [component setColour:[colorArray objectAtIndex:i++]];
    if (fundDetailPercentData.E != 0) {
        [components addObject:component];
    }
    component = [PCPieComponent pieComponentWithTitle:@"批发和零售业" value:fundDetailPercentData.F];
    [component setColour:[colorArray objectAtIndex:i++]];
    if (fundDetailPercentData.F != 0) {
        [components addObject:component];
    }
    component = [PCPieComponent pieComponentWithTitle:@"交通运输、仓储和邮政业" value:fundDetailPercentData.G];
    [component setColour:[colorArray objectAtIndex:i++]];
    if (fundDetailPercentData.G != 0) {
        [components addObject:component];
    }
    component = [PCPieComponent pieComponentWithTitle:@"住宿和餐饮业" value:fundDetailPercentData.H];
    [component setColour:[colorArray objectAtIndex:i++]];
    if (fundDetailPercentData.H != 0) {
        [components addObject:component];
    }
    component = [PCPieComponent pieComponentWithTitle:@"信息传输、软件和信息技术服务业" value:fundDetailPercentData.I];
    [component setColour:[colorArray objectAtIndex:i++]];
    if (fundDetailPercentData.I != 0) {
        [components addObject:component];
    }
    component = [PCPieComponent pieComponentWithTitle:@"金融业" value:fundDetailPercentData.J];
    [component setColour:[colorArray objectAtIndex:i++]];
    if (fundDetailPercentData.J != 0) {
        [components addObject:component];
    }
    component = [PCPieComponent pieComponentWithTitle:@"房地产业" value:fundDetailPercentData.K];
    [component setColour:[colorArray objectAtIndex:i++]];
    if (fundDetailPercentData.K != 0) {
        [components addObject:component];
    }
    component = [PCPieComponent pieComponentWithTitle:@"租赁和商务服务业" value:fundDetailPercentData.L];
    [component setColour:[colorArray objectAtIndex:i++]];
    if (fundDetailPercentData.L != 0) {
        [components addObject:component];
    }
    component = [PCPieComponent pieComponentWithTitle:@"科学研究和技术服务业" value:fundDetailPercentData.M];
    [component setColour:[colorArray objectAtIndex:i++]];
    if (fundDetailPercentData.M != 0) {
        [components addObject:component];
    }
    component = [PCPieComponent pieComponentWithTitle:@"水利、环境和公共设施管理业" value:fundDetailPercentData.N];
    [component setColour:[colorArray objectAtIndex:i++]];
    if (fundDetailPercentData.N != 0) {
        [components addObject:component];
    }
    component = [PCPieComponent pieComponentWithTitle:@"居民服务、修理和其他服务业" value:fundDetailPercentData.O];
    [component setColour:[colorArray objectAtIndex:i++]];
    if (fundDetailPercentData.O != 0) {
        [components addObject:component];
    }
    component = [PCPieComponent pieComponentWithTitle:@"教育" value:fundDetailPercentData.P];
    [component setColour:[colorArray objectAtIndex:i++]];
    if (fundDetailPercentData.P != 0) {
        [components addObject:component];
    }
    component = [PCPieComponent pieComponentWithTitle:@"卫生和社会工作" value:fundDetailPercentData.Q];
    [component setColour:[colorArray objectAtIndex:i++]];
    if (fundDetailPercentData.Q != 0) {
        [components addObject:component];
    }
    component = [PCPieComponent pieComponentWithTitle:@"文化、体育和娱乐业" value:fundDetailPercentData.R];
    [component setColour:[colorArray objectAtIndex:i++]];
    if (fundDetailPercentData.R != 0) {
        [components addObject:component];
    }
    component = [PCPieComponent pieComponentWithTitle:@"综合" value:fundDetailPercentData.S];
    [component setColour:[colorArray objectAtIndex:i++]];
    if (fundDetailPercentData.S != 0) {
        [components addObject:component];
    }
    
    [pieChart setComponents:components];
    [industryView addSubview:pieChart];
    [bodyView bringSubviewToFront:propertyView];
}

- (void)buildInfoView
{
    infoView = [[UIView alloc]initWithFrame:CGRectMake(10, 36+10, 308, 550-36)];
    infoView.backgroundColor = [UIColor whiteColor];
    [bodyView addSubview:infoView];
    
    UILabel * _dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 308, 14)];
    [_dateLabel setTextAlignment:NSTextAlignmentLeft];
    [_dateLabel setTextColor:[UIColor colorWithHexValue:0xf17c05]];
    [_dateLabel setFont:[UIFont systemFontOfSize:14]];
    [_dateLabel setBackgroundColor:[UIColor clearColor]];
    _dateLabel.text = @"成立日期：";
    [infoView addSubview:_dateLabel];
    UILabel * _dateValueLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, 308, 14)];
    [_dateValueLabel setTextAlignment:NSTextAlignmentLeft];
    [_dateValueLabel setTextColor:[UIColor colorWithHexValue:0x7a7a7a]];
    [_dateValueLabel setFont:[UIFont systemFontOfSize:14]];
    [_dateValueLabel setBackgroundColor:[UIColor clearColor]];
    _dateValueLabel.tag = 1;
    [infoView addSubview:_dateValueLabel];
    
    UILabel * _investmentLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 50, 308, 14)];
    [_investmentLabel setTextAlignment:NSTextAlignmentLeft];
    [_investmentLabel setTextColor:[UIColor colorWithHexValue:0xf17c05]];
    [_investmentLabel setFont:[UIFont systemFontOfSize:14]];
    [_investmentLabel setBackgroundColor:[UIColor clearColor]];
    _investmentLabel.text = @"投资类型：";
    [infoView addSubview:_investmentLabel];
    UILabel * _investValuementLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 70, 308, 14)];
    [_investValuementLabel setTextAlignment:NSTextAlignmentLeft];
    [_investValuementLabel setTextColor:[UIColor colorWithHexValue:0x7a7a7a]];
    [_investValuementLabel setFont:[UIFont systemFontOfSize:14]];
    [_investValuementLabel setBackgroundColor:[UIColor clearColor]];
    _investValuementLabel.tag = 2;
    [infoView addSubview:_investValuementLabel];
    
    UILabel * _fundLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 100, 308, 14)];
    [_fundLabel setTextAlignment:NSTextAlignmentLeft];
    [_fundLabel setTextColor:[UIColor colorWithHexValue:0xf17c05]];
    [_fundLabel setFont:[UIFont systemFontOfSize:14]];
    [_fundLabel setBackgroundColor:[UIColor clearColor]];
    _fundLabel.text = @"基金类型：";
    [infoView addSubview:_fundLabel];
    UILabel * _fundValueLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 120, 308, 14)];
    [_fundValueLabel setTextAlignment:NSTextAlignmentLeft];
    [_fundValueLabel setTextColor:[UIColor colorWithHexValue:0x7a7a7a]];
    [_fundValueLabel setFont:[UIFont systemFontOfSize:14]];
    [_fundValueLabel setBackgroundColor:[UIColor clearColor]];
    _fundValueLabel.tag = 3;
    [infoView addSubview:_fundValueLabel];
    
    UILabel * _companyLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 150, 308, 14)];
    [_companyLabel setTextAlignment:NSTextAlignmentLeft];
    [_companyLabel setTextColor:[UIColor colorWithHexValue:0xf17c05]];
    [_companyLabel setFont:[UIFont systemFontOfSize:14]];
    [_companyLabel setBackgroundColor:[UIColor clearColor]];
    _companyLabel.text = @"基金管理人：";
    [infoView addSubview:_companyLabel];
    UILabel * _companyValueLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 170, 308, 14)];
    [_companyValueLabel setTextAlignment:NSTextAlignmentLeft];
    [_companyValueLabel setTextColor:[UIColor colorWithHexValue:0x7a7a7a]];
    [_companyValueLabel setFont:[UIFont systemFontOfSize:14]];
    [_companyValueLabel setBackgroundColor:[UIColor clearColor]];
    _companyValueLabel.tag = 4;
    [infoView addSubview:_companyValueLabel];
    
    UILabel * _percentLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 200, 308, 14)];
    [_percentLabel setTextAlignment:NSTextAlignmentLeft];
    [_percentLabel setTextColor:[UIColor colorWithHexValue:0xf17c05]];
    [_percentLabel setFont:[UIFont systemFontOfSize:14]];
    [_percentLabel setBackgroundColor:[UIColor clearColor]];
    _percentLabel.text = @"费率：";
    [infoView addSubview:_percentLabel];
    UILabel * _percentLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 220, 120, 14)];
    [_percentLabel1 setTextAlignment:NSTextAlignmentLeft];
    [_percentLabel1 setTextColor:[UIColor colorWithHexValue:0x7a7a7a]];
    [_percentLabel1 setFont:[UIFont systemFontOfSize:14]];
    [_percentLabel1 setBackgroundColor:[UIColor clearColor]];
    _percentLabel1.text = @"最高认购费率";
    [infoView addSubview:_percentLabel1];
    UILabel * _percentValueLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(150, 220, 150, 14)];
    [_percentValueLabel1 setTextAlignment:NSTextAlignmentLeft];
    [_percentValueLabel1 setTextColor:[UIColor colorWithHexValue:0x7a7a7a]];
    [_percentValueLabel1 setFont:[UIFont systemFontOfSize:14]];
    [_percentValueLabel1 setBackgroundColor:[UIColor clearColor]];
    _percentValueLabel1.tag = 5;
    [infoView addSubview:_percentValueLabel1];
    UILabel * _percentLabel2 = [[UILabel alloc] initWithFrame:CGRectMake(0, 240, 120, 14)];
    [_percentLabel2 setTextAlignment:NSTextAlignmentLeft];
    [_percentLabel2 setTextColor:[UIColor colorWithHexValue:0x7a7a7a]];
    [_percentLabel2 setFont:[UIFont systemFontOfSize:14]];
    [_percentLabel2 setBackgroundColor:[UIColor clearColor]];
    _percentLabel2.text = @"最高赎回费率";
    [infoView addSubview:_percentLabel2];
    UILabel * _percentValueLabel2 = [[UILabel alloc] initWithFrame:CGRectMake(150, 240, 150, 14)];
    [_percentValueLabel2 setTextAlignment:NSTextAlignmentLeft];
    [_percentValueLabel2 setTextColor:[UIColor colorWithHexValue:0x7a7a7a]];
    [_percentValueLabel2 setFont:[UIFont systemFontOfSize:14]];
    [_percentValueLabel2 setBackgroundColor:[UIColor clearColor]];
    _percentValueLabel2.tag = 6;
    [infoView addSubview:_percentValueLabel2];
    UILabel * _percentLabel3 = [[UILabel alloc] initWithFrame:CGRectMake(0, 260, 120, 14)];
    [_percentLabel3 setTextAlignment:NSTextAlignmentLeft];
    [_percentLabel3 setTextColor:[UIColor colorWithHexValue:0x7a7a7a]];
    [_percentLabel3 setFont:[UIFont systemFontOfSize:14]];
    [_percentLabel3 setBackgroundColor:[UIColor clearColor]];
    _percentLabel3.text = @"管理费";
    [infoView addSubview:_percentLabel3];
    UILabel * _percentValueLabel3 = [[UILabel alloc] initWithFrame:CGRectMake(150, 260, 150, 14)];
    [_percentValueLabel3 setTextAlignment:NSTextAlignmentLeft];
    [_percentValueLabel3 setTextColor:[UIColor colorWithHexValue:0x7a7a7a]];
    [_percentValueLabel3 setFont:[UIFont systemFontOfSize:14]];
    [_percentValueLabel3 setBackgroundColor:[UIColor clearColor]];
    _percentValueLabel3.tag = 7;
    [infoView addSubview:_percentValueLabel3];
    UILabel * _percentLabel4 = [[UILabel alloc] initWithFrame:CGRectMake(0, 280, 120, 14)];
    [_percentLabel4 setTextAlignment:NSTextAlignmentLeft];
    [_percentLabel4 setTextColor:[UIColor colorWithHexValue:0x7a7a7a]];
    [_percentLabel4 setFont:[UIFont systemFontOfSize:14]];
    [_percentLabel4 setBackgroundColor:[UIColor clearColor]];
    _percentLabel4.text = @"托管费";
    [infoView addSubview:_percentLabel4];
    UILabel * _percentValueLabel4 = [[UILabel alloc] initWithFrame:CGRectMake(150, 280, 150, 14)];
    [_percentValueLabel4 setTextAlignment:NSTextAlignmentLeft];
    [_percentValueLabel4 setTextColor:[UIColor colorWithHexValue:0x7a7a7a]];
    [_percentValueLabel4 setFont:[UIFont systemFontOfSize:14]];
    [_percentValueLabel4 setBackgroundColor:[UIColor clearColor]];
    _percentValueLabel4.tag = 8;
    [infoView addSubview:_percentValueLabel4];
    UILabel * _percentLabel5 = [[UILabel alloc] initWithFrame:CGRectMake(0, 300, 120, 14)];
    [_percentLabel5 setTextAlignment:NSTextAlignmentLeft];
    [_percentLabel5 setTextColor:[UIColor colorWithHexValue:0x7a7a7a]];
    [_percentLabel5 setFont:[UIFont systemFontOfSize:14]];
    [_percentLabel5 setBackgroundColor:[UIColor clearColor]];
    _percentLabel5.text = @"销售服务费";
    [infoView addSubview:_percentLabel5];
    UILabel * _percentValueLabel5 = [[UILabel alloc] initWithFrame:CGRectMake(150, 300, 150, 14)];
    [_percentValueLabel5 setTextAlignment:NSTextAlignmentLeft];
    [_percentValueLabel5 setTextColor:[UIColor colorWithHexValue:0x7a7a7a]];
    [_percentValueLabel5 setFont:[UIFont systemFontOfSize:14]];
    [_percentValueLabel5 setBackgroundColor:[UIColor clearColor]];
    _percentValueLabel5.tag = 9;
    [infoView addSubview:_percentValueLabel5];
    
    UILabel * _managerLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 330, 308, 14)];
    [_managerLabel setTextAlignment:NSTextAlignmentLeft];
    [_managerLabel setTextColor:[UIColor colorWithHexValue:0xf17c05]];
    [_managerLabel setFont:[UIFont systemFontOfSize:14]];
    [_managerLabel setBackgroundColor:[UIColor clearColor]];
    _managerLabel.text = @"基金经理：";
    [infoView addSubview:_managerLabel];
    UILabel * _managerValueLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 350, 60, 14)];
    [_managerValueLabel setTextAlignment:NSTextAlignmentLeft];
    [_managerValueLabel setTextColor:[UIColor colorWithHexValue:0x7a7a7a]];
    [_managerValueLabel setFont:[UIFont systemFontOfSize:14]];
    [_managerValueLabel setBackgroundColor:[UIColor clearColor]];
    _managerValueLabel.tag = 10;
    [infoView addSubview:_managerValueLabel];
    UILabel * _managerValueLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(70, 350, 80, 14)];
    [_managerValueLabel1 setTextAlignment:NSTextAlignmentLeft];
    [_managerValueLabel1 setTextColor:[UIColor colorWithHexValue:0x7a7a7a]];
    [_managerValueLabel1 setFont:[UIFont systemFontOfSize:14]];
    [_managerValueLabel1 setBackgroundColor:[UIColor clearColor]];
    _managerValueLabel1.tag = 11;
    [infoView addSubview:_managerValueLabel1];
    UILabel * _managerValueLabel2 = [[UILabel alloc] initWithFrame:CGRectMake(160, 350, 180, 14)];
    [_managerValueLabel2 setTextAlignment:NSTextAlignmentLeft];
    [_managerValueLabel2 setTextColor:[UIColor colorWithHexValue:0x7a7a7a]];
    [_managerValueLabel2 setFont:[UIFont systemFontOfSize:14]];
    [_managerValueLabel2 setBackgroundColor:[UIColor clearColor]];
    _managerValueLabel2.tag = 12;
    [infoView addSubview:_managerValueLabel2];
    
    UILabel * _directLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 400, 308, 14)];
    [_directLabel setTextAlignment:NSTextAlignmentLeft];
    [_directLabel setTextColor:[UIColor colorWithHexValue:0xf17c05]];
    [_directLabel setFont:[UIFont systemFontOfSize:14]];
    [_directLabel setBackgroundColor:[UIColor clearColor]];
    _directLabel.text = @"基金投资范围：";
    [infoView addSubview:_directLabel];
    UILabel * _directValueLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 420, 308, 60)];
    [_directValueLabel setTextAlignment:NSTextAlignmentLeft];
    [_directValueLabel setTextColor:[UIColor colorWithHexValue:0x7a7a7a]];
    [_directValueLabel setFont:[UIFont systemFontOfSize:14]];
    [_directValueLabel setBackgroundColor:[UIColor clearColor]];
    _directValueLabel.numberOfLines = 0;
    _directValueLabel.tag = 13;
    [infoView addSubview:_directValueLabel];
}

- (void)buildManagerView
{
    managerView = [[UIView alloc]initWithFrame:CGRectMake(10, 36+10, 308, 550-36)];
    managerView.backgroundColor = [UIColor whiteColor];
    [bodyView addSubview:managerView];
    
    UILabel * _managerValueLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, 60, 14)];
    [_managerValueLabel setTextAlignment:NSTextAlignmentLeft];
    [_managerValueLabel setTextColor:[UIColor colorWithHexValue:0xf17c05]];
    [_managerValueLabel setFont:[UIFont systemFontOfSize:14]];
    [_managerValueLabel setBackgroundColor:[UIColor clearColor]];
    _managerValueLabel.text = fundManagerInfoData.name;
    [managerView addSubview:_managerValueLabel];
    UILabel * _managerValueLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(70, 10, 80, 14)];
    [_managerValueLabel1 setTextAlignment:NSTextAlignmentLeft];
    [_managerValueLabel1 setTextColor:[UIColor colorWithHexValue:0xf17c05]];
    [_managerValueLabel1 setFont:[UIFont systemFontOfSize:14]];
    [_managerValueLabel1 setBackgroundColor:[UIColor clearColor]];
    _managerValueLabel1.text = fundManagerInfoData.take_date;
    [managerView addSubview:_managerValueLabel1];
    UILabel * _managerValueLabel2 = [[UILabel alloc] initWithFrame:CGRectMake(0, 50, 280, 60)];
    [_managerValueLabel2 setTextAlignment:NSTextAlignmentLeft];
    [_managerValueLabel2 setTextColor:[UIColor colorWithHexValue:0x7a7a7a]];
    [_managerValueLabel2 setFont:[UIFont systemFontOfSize:14]];
    [_managerValueLabel2 setBackgroundColor:[UIColor clearColor]];
    _managerValueLabel2.numberOfLines = 0;
    _managerValueLabel2.text = fundManagerInfoData.resume;
    [managerView addSubview:_managerValueLabel2];
    
    
    NSString * ann_rr_tenure = nil;
    NSString * ann_rr_tenure_index = nil;
    if ([dbBase open]) {
        NSString *sqlManagerRankQuery = [NSString stringWithFormat:@"SELECT * FROM FUNDMANAGERRANK WHERE code = '%d' AND name = '%@'", fundCode, fundManagerInfoData.name];
        FMResultSet * rs = [dbBase executeQuery:sqlManagerRankQuery];
        while ([rs next]) {
            ann_rr_tenure = [rs stringForColumn:@"ann_rr_tenure"];
            ann_rr_tenure_index = [rs stringForColumn:@"ann_rr_tenure_index"];
        }
        [dbBase close];
    }
    
    NTChartView * repayView = [[NTChartView alloc]initWithFrame:CGRectMake(20, 140, 280, 300)];
    [managerView addSubview:repayView];
	
	NSArray *g1 = [NSArray arrayWithObjects:
                   [NSNumber numberWithFloat:[ann_rr_tenure floatValue]*100],nil];
    
    NSArray *g2 = [NSArray arrayWithObjects:
                   [NSNumber numberWithFloat:[ann_rr_tenure_index floatValue]*100],nil];
    
    NSArray *g = [NSArray arrayWithObjects:g1, g2, nil];
    
    NSArray *gt = [NSArray arrayWithObjects:@"基金回报",@"市场平均", nil];
    NSArray *xL = [NSArray arrayWithObjects:@"", nil];
    NSArray *ct = [NSArray arrayWithObjects:@"", @"", nil];
    
	repayView.groupData = g;
    repayView.groupTitle = gt;
    repayView.xAxisLabel = xL;
    repayView.chartTitle = ct;
	
    repayView.backgroundColor = [UIColor clearColor];
	
    repayView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    
    UILabel * _timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 450, 280, 14)];
    [_timeLabel setTextAlignment:NSTextAlignmentCenter];
    [_timeLabel setTextColor:[UIColor colorWithHexValue:0xf17c05]];
    [_timeLabel setFont:[UIFont systemFontOfSize:14]];
    [_timeLabel setBackgroundColor:[UIColor clearColor]];
    _timeLabel.text = @"-任职以来-";
    [managerView addSubview:_timeLabel];
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
    [self buildHistoryView];
    [self buildBody];
    [self getFundQuoteHistoryData];
    [self getFundDetailInfoData];
    [self getFundDetailPercentData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) getFundQuoteRequestSuccess:(FundQuoteRequest *)request
{
//	BOOL isRequestSuccess = [fundQuoteRequest isRequestSuccess];
//    if (isRequestSuccess) {
//        fundQuoteDataArray = [fundQuoteRequest getDataArray];
//        FundQuoteData * data = 
//    }
//    else {
//    }
}

- (void) getFundQuoteRequestFailed:(FundQuoteRequest *)request
{
    
}

- (void)getFundQuoteData
{
    NSString * url = [NSString stringWithFormat:@"%@%@", HOST_NAME, DETAIL_QUOTE];
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
    fundQuoteRequest = [[FundQuoteRequest alloc]initWithUrl:url];
    
	fundQuoteRequest.delegate = self;
    fundQuoteRequest.requestDidFinishSelector = @selector(getFundQuoteRequestSuccess:);
    fundQuoteRequest.requestDidFailedSelector = @selector(getFundQuoteRequestFailed:);
    
    [fundQuoteRequest sendRequest];
}


- (void) getFundQuoteHistoryRequestSuccess:(FundQuoteHistoryRequest *)request
{
	BOOL isRequestSuccess = [fundQuoteHistoryRequest isRequestSuccess];
    if (isRequestSuccess) {
        
        NSMutableArray* arr = [[NSMutableArray alloc]init];
        fundQuoteHistoryDataArray = [fundQuoteHistoryRequest getDataArray];
        int offset = fundQuoteHistoryDataArray.count - 60;
        for (int x = 0; x < 60; ++x) {
            if (offset + x < 0) {
                NSString *xp = [NSString stringWithFormat:@"%d",x];
                NSString *yp = [NSString stringWithFormat:@"%d",0];
                NSMutableDictionary *point1 = [[NSMutableDictionary alloc] initWithObjectsAndKeys:xp, @"x", yp, @"y", nil];
                [dataForPlot1 insertObject:point1 atIndex:x];
                continue;
            }
            FundQuoteHistoryData * data = [fundQuoteHistoryDataArray objectAtIndex:x+offset];
            //添加数
//            if ([dataSourceLinePlot.identifier isEqual:@"Green Plot"])
            {
                if (type == MoneyType) {
                    NSString *xp = [NSString stringWithFormat:@"%d",x];
                    NSString *yp = [NSString stringWithFormat:@"%d",[data.growth_10 intValue]];
                    NSMutableDictionary *point1 = [[NSMutableDictionary alloc] initWithObjectsAndKeys:xp, @"x", yp, @"y", nil];
                    [dataForPlot1 insertObject:point1 atIndex:x];
                    [arr addObject:[NSNumber numberWithInt:[data.growth_10 intValue]]];
                }
                else if (type == NotMoneyType) {
                    NSString *xp = [NSString stringWithFormat:@"%d",x];
                    NSString *yp = [NSString stringWithFormat:@"%d",[data.growth_10 intValue]];
                    NSMutableDictionary *point1 = [[NSMutableDictionary alloc] initWithObjectsAndKeys:xp, @"x", yp, @"y", nil];
                    [dataForPlot1 insertObject:point1 atIndex:x];
                    [arr addObject:[NSNumber numberWithInt:[data.growth_10 intValue]]];
                }
            }
        }
        
        // 升序
        [arr sortUsingComparator:^NSComparisonResult(__strong id obj1,__strong id obj2){
            NSString *str1=(NSString *)obj1;
            NSString *str2=(NSString *)obj2;
            return [str1 compare:str2];
        }];
        fundHistoryMax = [[arr objectAtIndex:arr.count-1]intValue];
        fundHistoryMin = [[arr objectAtIndex:0]intValue];
    }
    else {
        fundHistoryMax = 100;
        fundHistoryMin = 0;
    }
    [self buildChartView];
}

- (void) getFundQuoteHistoryRequestFailed:(FundQuoteHistoryRequest *)request
{
    
}

- (void)getFundQuoteHistoryData
{
    NSString * url = [NSString stringWithFormat:@"%@%@", HOST_NAME, DETAIL_HISTORY_QUOTE];
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
    
    
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSDateComponents *components = [cal components:( NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit ) fromDate:[[NSDate alloc] init]];
    [components setHour:-[components hour]];
    [components setMinute:-[components minute]];
    [components setSecond:-[components second]];
    NSDate *today = [cal dateByAddingComponents:components toDate:[[NSDate alloc] init] options:0];
    [components setDay:-60];
    NSDate *last60Day = [cal dateByAddingComponents:components toDate: today options:0];
    
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyyMMdd"];
    [array addObject:[NSString stringWithFormat:@"%@=%@", @"startDate", [formatter stringFromDate:last60Day]]];
    [array addObject:[NSString stringWithFormat:@"%@=%@", @"endDate", [formatter stringFromDate:today]]];
    NSString * md5Result = [_UI md5EncParam:array];
    url = [url stringByAppendingString:md5Result];
    url = [url URLEncodedString];
    fundQuoteHistoryRequest = [[FundQuoteHistoryRequest alloc]initWithUrl:url];
    
	fundQuoteHistoryRequest.delegate = self;
    fundQuoteHistoryRequest.requestDidFinishSelector = @selector(getFundQuoteHistoryRequestSuccess:);
    fundQuoteHistoryRequest.requestDidFailedSelector = @selector(getFundQuoteHistoryRequestFailed:);
    
    [fundQuoteHistoryRequest sendRequest];
}

- (void) getFundDetailInfoRequestSuccess:(FundDetailInfoRequst *)request
{
	BOOL isRequestSuccess = [fundDetailInfoRequst isRequestSuccess];
    if (isRequestSuccess) {
        fundDetailInfoData = [fundDetailInfoRequst getData];
        NSString * strTake_date = @"";
        NSString * strRr_date = @"";
        if ([dbBase open]) {
            NSString *sqlManagerQuery = [NSString stringWithFormat:@"SELECT * FROM FUNDMANAGERRANK WHERE %@ = '%@'", @"name", fundDetailInfoData.manager ];
            FMResultSet * rs = [dbBase executeQuery:sqlManagerQuery];
            while ([rs next]) {
                strTake_date = [rs stringForColumn:@"take_date"];
                strRr_date = [rs stringForColumn:@"rr_sdate"];
            }
            
            
            [dbBase close];
        }
        for (UIView * v in infoView.subviews) {
            if ([v isKindOfClass:[UILabel class]]) {
                if (v.tag == 1) {
                    UILabel * label = (UILabel *)v;
                    label.text = fundDetailInfoData.estb_date;
                }
                else if (v.tag == 2) {
                    UILabel * label = (UILabel *)v;
                    if ([fundDetailInfoData.invest_type isEqualToString:@"A"]) {
                        label.text = @"股票型";
                    }
                    if ([fundDetailInfoData.invest_type isEqualToString:@"B"]) {
                        label.text = @"普通债券型";
                    }
                    if ([fundDetailInfoData.invest_type isEqualToString:@"C"]) {
                        label.text = @"激进债券";
                    }
                    if ([fundDetailInfoData.invest_type isEqualToString:@"D"]) {
                        label.text = @"纯债基金";
                    }
                    if ([fundDetailInfoData.invest_type isEqualToString:@"E"]) {
                        label.text = @"普通混合型";
                    }
                    if ([fundDetailInfoData.invest_type isEqualToString:@"F"]) {
                        label.text = @"保守混合型";
                    }
                    if ([fundDetailInfoData.invest_type isEqualToString:@"G"]) {
                        label.text = @"激进混合型";
                    }
                    if ([fundDetailInfoData.invest_type isEqualToString:@"H"]) {
                        label.text = @"货币型";
                    }
                    if ([fundDetailInfoData.invest_type isEqualToString:@"I"]) {
                        label.text = @"短债基金";
                    }
                    if ([fundDetailInfoData.invest_type isEqualToString:@"J"]) {
                        label.text = @"FOF";
                    }
                    if ([fundDetailInfoData.invest_type isEqualToString:@"K"]) {
                        label.text = @"保本基金";
                    }
                    if ([fundDetailInfoData.invest_type isEqualToString:@"L"]) {
                        label.text = @"普通型指数基金";
                    }
                    if ([fundDetailInfoData.invest_type isEqualToString:@"M"]) {
                        label.text = @"增强型指数基金";
                    }
                    if ([fundDetailInfoData.invest_type isEqualToString:@"N"]) {
                        label.text = @"分级基金";
                    }
                    if ([fundDetailInfoData.invest_type isEqualToString:@"O"]) {
                        label.text = @"其它";
                    }
                }
                else if (v.tag == 3) {
                    UILabel * label = (UILabel *)v;
                    if ([fundDetailInfoData.type isEqualToString:@"A"]) {
                        label.text = @"开放式";
                    }
                    if ([fundDetailInfoData.type isEqualToString:@"B"]) {
                        label.text = @"封闭式";
                    }
                    if ([fundDetailInfoData.type isEqualToString:@"C"]) {
                        label.text = @"ETF";
                    }
                    if ([fundDetailInfoData.type isEqualToString:@"D"]) {
                        label.text = @"LOF";
                    }
                    if ([fundDetailInfoData.type isEqualToString:@"E"]) {
                        label.text = @"QDII";
                    }
                    if ([fundDetailInfoData.type isEqualToString:@"F"]) {
                        label.text = @"ETF联接基金";
                    }
                }
                else if (v.tag == 4) {
                    UILabel * label = (UILabel *)v;
                    label.text = fundDetailInfoData.corp;
                }
                else if (v.tag == 5) {
                    UILabel * label = (UILabel *)v;
                    label.text = [NSString stringWithFormat:@"%d", fundDetailInfoData.pur_rate_max];
                }
                else if (v.tag == 6) {
                    UILabel * label = (UILabel *)v;
                    label.text = [NSString stringWithFormat:@"%d", fundDetailInfoData.redeem_rate_max];
                }
                else if (v.tag == 7) {
                    UILabel * label = (UILabel *)v;
                    label.text = [NSString stringWithFormat:@"%d", fundDetailInfoData.manage_rate];
                }
                else if (v.tag == 8) {
                    UILabel * label = (UILabel *)v;
                    label.text = [NSString stringWithFormat:@"%d", fundDetailInfoData.custodian_rate];
                }
                else if (v.tag == 9) {
                    UILabel * label = (UILabel *)v;
                    label.text = [NSString stringWithFormat:@"%d", fundDetailInfoData.sales_service];
                }
                else if (v.tag == 10) {
                    UILabel * label = (UILabel *)v;
                    NSRange range = [fundDetailInfoData.manager rangeOfString:@"、"];
                    if (range.location != NSNotFound) {
                        label.text = [fundDetailInfoData.manager substringToIndex:range.location];
                    }
                    else {
                        label.text = fundDetailInfoData.manager;
                    }
                    manager = label.text;
                }
                else if (v.tag == 11) {
                    UILabel * label = (UILabel *)v;
                    label.text = strTake_date;
                }
                else if (v.tag == 12) {
                    UILabel * label = (UILabel *)v;
                    label.text = [NSString stringWithFormat:@"管理时间：%@", strRr_date];
                }
                else if (v.tag == 13) {
                    UILabel * label = (UILabel *)v;
                    label.text = @"";
                }
            }
        }
        if (manager && ![manager isEqualToString:@""]) {
            [self getFundManagerInfoData];
        }
    }
    else {
    }
}

- (void) getFundDetailInfoRequestFailed:(FundDetailInfoRequst *)request
{
    
}

- (void)getFundDetailInfoData
{
    NSString * url = [NSString stringWithFormat:@"%@%@", HOST_NAME, DETAIL_INFO_QUOTE];
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
    fundDetailInfoRequst = [[FundDetailInfoRequst alloc]initWithUrl:url];
    
	fundDetailInfoRequst.delegate = self;
    fundDetailInfoRequst.requestDidFinishSelector = @selector(getFundDetailInfoRequestSuccess:);
    fundDetailInfoRequst.requestDidFailedSelector = @selector(getFundDetailInfoRequestFailed:);
    
    [fundDetailInfoRequst sendRequest];
}


- (void) getFundManagerInfoRequestSuccess:(FundManagerInfoRequest *)request
{
	BOOL isRequestSuccess = [fundManagerInfoRequest isRequestSuccess];
    if (isRequestSuccess) {
        fundManagerInfoData = [fundManagerInfoRequest getData];
        [self buildManagerView];
        [bodyView bringSubviewToFront:propertyView];
    }
    else {
    }
}

- (void) getFundManagerInfoRequestFailed:(FundManagerInfoRequest *)request
{
    
}

- (void)getFundManagerInfoData
{
    NSString * url = [NSString stringWithFormat:@"%@%@", HOST_NAME, DETAIL_MANAGER_INFO_QUOTE];
    NSMutableArray * array = [[NSMutableArray alloc]initWithCapacity:0];
    [array addObject:[NSString stringWithFormat:@"%@=%@", OPENID, OPENID_VALUE]];
    [array addObject:[NSString stringWithFormat:@"%@=%@", TYPE, DATA_FORMAT]];
    if (_UI.isLogin) {
        [array addObject:[NSString stringWithFormat:@"%@=%@", @"user_name", _UI.userName]];
        [array addObject:[NSString stringWithFormat:@"%@=%@", @"access_token", _UI.loginToken]];
    }
    //    [array addObject:[NSString stringWithFormat:@"%@=%@", @"page_no", @"1"]];
    //    [array addObject:[NSString stringWithFormat:@"%@=%@", @"page_size", @"2"]];
    [array addObject:[NSString stringWithFormat:@"%@=%@", @"name", manager]];
    NSString * md5Result = [_UI md5EncParam:array];
    url = [url stringByAppendingString:md5Result];
    url = [url URLEncodedString];
    fundManagerInfoRequest = [[FundManagerInfoRequest alloc]initWithUrl:url];
    
	fundManagerInfoRequest.delegate = self;
    fundManagerInfoRequest.requestDidFinishSelector = @selector(getFundManagerInfoRequestSuccess:);
    fundManagerInfoRequest.requestDidFailedSelector = @selector(getFundManagerInfoRequestFailed:);
    
    [fundManagerInfoRequest sendRequest];
}


- (void) getFundDetailPercentRequestSuccess:(FundDetailPercentRequest *)request
{
	BOOL isRequestSuccess = [fundDetailPercentRequest isRequestSuccess];
    if (isRequestSuccess) {
        fundDetailPercentData = [fundDetailPercentRequest getData];
        [self buildpropertyView];
        [self buildindustryView];
        [bodyView bringSubviewToFront:propertyView];
    }
    else {
    }
}

- (void) getFundDetailPercentRequestFailed:(FundDetailPercentRequest *)request
{
    
}

- (void)getFundDetailPercentData
{
    NSString * url = [NSString stringWithFormat:@"%@%@", HOST_NAME, DETAIL_PERCENT_QUOTE];
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
    fundDetailPercentRequest = [[FundDetailPercentRequest alloc]initWithUrl:url];
    
	fundDetailPercentRequest.delegate = self;
    fundDetailPercentRequest.requestDidFinishSelector = @selector(getFundDetailPercentRequestSuccess:);
    fundDetailPercentRequest.requestDidFailedSelector = @selector(getFundDetailPercentRequestFailed:);
    
    [fundDetailPercentRequest sendRequest];
}

- (void) getAddMyFundRequestSuccess
{
    [[FPTipsManager sharedManager] cleanUp:NO];
	[[FPTipsManager sharedManager] postSuccess:FPString(@"成功关注！")];
    [followBtnView setBackgroundImage:[UIImage imageNamed:@"detail_14_2"] forState:UIControlStateNormal];
}

- (void) getAddMyFundRequestFailed
{
    [[FPTipsManager sharedManager] cleanUp:NO];
    [[FPTipsManager sharedManager] postError:FPString(@"请求失败！")];
}

- (void) getRemoveMyFundRequestSuccess
{
    [[FPTipsManager sharedManager] cleanUp:NO];
	[[FPTipsManager sharedManager] postSuccess:FPString(@"已取消关注！")];
    [followBtnView setBackgroundImage:[UIImage imageNamed:@"detail_14"] forState:UIControlStateNormal];
}

- (void) getRemoveMyFundRequestFailed
{
    [[FPTipsManager sharedManager] cleanUp:NO];
    [[FPTipsManager sharedManager] postError:FPString(@"请求失败！")];
}

@end
