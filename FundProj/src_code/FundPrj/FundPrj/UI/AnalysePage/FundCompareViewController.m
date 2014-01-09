//
//  FundCompareViewController.m
//  FundPrj
//
//  Created by leesea on 13-11-12.
//  Copyright (c) 2013年 leesea. All rights reserved.
//

#import "FundCompareViewController.h"
#import "FMDatabase.h"
#import "FMDatabaseQueue.h"
#import "FundInfoData.h"
#import <QuartzCore/QuartzCore.h>
#import "FundMoneyData.h"
#import "FundNotMoneyData.h"
#import "FundDetailInfoRequst.h"
#import "FundDetailInfoData.h"
#import "FundDetailPercentRequest.h"
#import "FundDetailPercentData.h"
#import "FundGradeRequest.h"
#import "FundGradeData.h"
#import "GradeView.h"
#import "FundQuoteHistoryRequest.h"
#import "FundQuoteHistoryData.h"
#import "NTChartView.h"
#import "FundHistoryRequest.h"
#import "FundHistoryData.h"


#define DB_NAME    @"FundDB.sqlite"
#define NAME      @"name"
#define CODE       @"code"
#define PY   @"py"

@interface FundCompareViewController ()
{
    
    NSString *db_path;
    
    FMDatabase *dbBase;
    
    UIView * view1;
    UIView * view2;
    UIView * view3;
    UIView * view4;
    UIView * view5;
    UIView * view6;
    UIView * view7;
    
    FundDetailInfoRequst * fundDetailInfoRequst1;
    FundDetailInfoRequst * fundDetailInfoRequst2;
    FundDetailInfoRequst * fundDetailInfoRequst3;
    FundDetailInfoRequst * fundDetailInfoRequst4;
    FundDetailInfoRequst * fundDetailInfoRequst5;
    
    FundDetailPercentRequest * fundDetailPercentRequest1;
    FundDetailPercentRequest * fundDetailPercentRequest2;
    FundDetailPercentRequest * fundDetailPercentRequest3;
    FundDetailPercentRequest * fundDetailPercentRequest4;
    FundDetailPercentRequest * fundDetailPercentRequest5;
    
    FundGradeRequest * fundGradeRequest1;
    FundGradeRequest * fundGradeRequest2;
    FundGradeRequest * fundGradeRequest3;
    FundGradeRequest * fundGradeRequest4;
    FundGradeRequest * fundGradeRequest5;
    
    FundQuoteHistoryRequest * fundQuoteHistoryRequest;
    NSMutableArray * fundQuoteHistoryDataArray;
    
    
    CPTXYGraph                  *graph;             //画板
    CPTScatterPlot              *dataSourceLinePlot;//线
    NSMutableArray              *dataForPlot1;      //坐标数组
    
    NSInteger fundHistoryMax;
    NSInteger fundHistoryMin;
    
    FundHistoryRequest * fundHistoryRequest1;
    NSMutableArray * fundHistoryData1;
    FundHistoryRequest * fundHistoryRequest2;
    NSMutableArray * fundHistoryData2;
    FundHistoryRequest * fundHistoryRequest3;
    NSMutableArray * fundHistoryData3;
    FundHistoryRequest * fundHistoryRequest4;
    NSMutableArray * fundHistoryData4;
    FundHistoryRequest * fundHistoryRequest5;
    NSMutableArray * fundHistoryData5;
}

@end

@implementation FundCompareViewController

@synthesize count = _count;
@synthesize fundArray;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        db_path = [PATH_OF_DOCUMENT stringByAppendingPathComponent:DB_NAME];
        dbBase = [FMDatabase databaseWithPath:db_path];
        fundArray = [[NSMutableArray alloc]initWithCapacity:0];
    }
    return self;
}

- (NSString *)getHeaderInfo:(NSInteger)ID
{
    // 开始获取相关关键字
    NSString * searchType = CODE;
    
    if ([dbBase open]) {
            
        
        NSString *sqlMoneyQuery = [NSString stringWithFormat:@"SELECT * FROM FUNDMONEY WHERE %@ = '%d'", searchType, ID ];
        FMResultSet * rs = [dbBase executeQuery:sqlMoneyQuery];
        while ([rs next]) {
            NSString * name = [rs stringForColumn:@"name"];
            if (name) {
                return name;
            }
        }
        
        
        NSString *sqlNotMoneyQuery = [NSString stringWithFormat:@"SELECT * FROM FUNDNOTMONEY WHERE %@ = '%d'", searchType, ID ];
        FMResultSet * rs1 = [dbBase executeQuery:sqlNotMoneyQuery];
        while ([rs1 next]) {
            NSString * name = [rs1 stringForColumn:@"name"];
            if (name) {
                return name;
            }
        }
        
        
        [dbBase close];
    }
    return nil;
}

- (UIView *)buildHeaderCell:(NSString *)codeStr nameStr:(NSString *)nameStr
{
    UIView * cell = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 950/5, 86)];
    cell.backgroundColor = [UIColor clearColor];
    
    UILabel * codeLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 15, 190-20*2, 86/2-15)];
    [codeLabel setTextAlignment:NSTextAlignmentLeft];
    [codeLabel setTextColor:[UIColor whiteColor]];
    [codeLabel setFont:[UIFont systemFontOfSize:16]];
    [codeLabel setBackgroundColor:[UIColor clearColor]];
    codeLabel.text = codeStr;
    [cell addSubview:codeLabel];
    UILabel * nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 86/2, 190-20*2, 86/2-15)];
    [nameLabel setTextAlignment:NSTextAlignmentLeft];
    [nameLabel setTextColor:[UIColor whiteColor]];
    [nameLabel setFont:[UIFont systemFontOfSize:16]];
    [nameLabel setBackgroundColor:[UIColor clearColor]];
    nameLabel.text = nameStr;
    [cell addSubview:nameLabel];
    return cell;
}

- (void)backBtnPress:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
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
    NSInteger ID = [[fundArray objectAtIndex:0]intValue];
    UIView * cell = [self buildHeaderCell:[NSString stringWithFormat: @"代码：%06d", ID] nameStr:[self getHeaderInfo:ID]];
    cell.frame = CGRectMake(63, 0, 190, 86);
    [headerView addSubview:cell];
    UIImageView * line = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"detail_08"]];
    line.frame = CGRectMake(63+190, (86-68)/2, 3, 68);
    [headerView addSubview:line];
    if (_count >= 2) {
        ID = [[fundArray objectAtIndex:1]intValue];
    }
    UIView * cell1 = [self buildHeaderCell:[NSString stringWithFormat: @"代码：%06d", ID] nameStr:[self getHeaderInfo:ID]];
    cell1.frame = CGRectMake(63+190+3, 0, 190, 86);
    [headerView addSubview:cell1];
    UIImageView * line1 = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"detail_08"]];
    line1.frame = CGRectMake(63+190*2+3, (86-68)/2, 3, 68);
    [headerView addSubview:line1];
    if (_count >= 3) {
        ID = [[fundArray objectAtIndex:2]intValue];
    }
    UIView * cell2 = [self buildHeaderCell:[NSString stringWithFormat: @"代码：%06d", ID] nameStr:[self getHeaderInfo:ID]];
    cell2.frame = CGRectMake(63+190*2+3*2, 0, 190, 86);
    [headerView addSubview:cell2];
    UIImageView * line2 = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"detail_08"]];
    line2.frame = CGRectMake(63+190*3+3*2, (86-68)/2, 3, 68);
    [headerView addSubview:line2];
    if (_count >= 4) {
        ID = [[fundArray objectAtIndex:3]intValue];
    }
    UIView * cell3 = [self buildHeaderCell:[NSString stringWithFormat: @"代码：%06d", ID] nameStr:[self getHeaderInfo:ID]];
    cell3.frame = CGRectMake(63+190*3+3*3, 0, 190, 86);
    [headerView addSubview:cell3];
    UIImageView * line3 = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"detail_08"]];
    line3.frame = CGRectMake(63+190*4+3*3, (86-68)/2, 3, 68);
    [headerView addSubview:line3];
    if (_count >= 5) {
        ID = [[fundArray objectAtIndex:4]intValue];
    }
    UIView * cell4 = [self buildHeaderCell:[NSString stringWithFormat: @"代码：%06d", ID] nameStr:[self getHeaderInfo:ID]];
    cell4.frame = CGRectMake(63+190*4+3*4, 0, 190, 86);
    [headerView addSubview:cell4];
    if (_count < 5) {
        cell4.hidden = YES;
    }
    if (_count < 4) {
        cell3.hidden = YES;
    }
    if (_count < 3) {
        cell2.hidden = YES;
    }
    if (_count < 2) {
        cell1.hidden = YES;
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

- (UIView *)buildView1
{
    view1 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 1024/2, 400)];
    view1.backgroundColor = [UIColor clearColor];
    
    UIView * chartView = [[UIView alloc]initWithFrame:CGRectMake(20, 20, 480, 330)];
    chartView.backgroundColor = [UIColor clearColor];
    [view1 addSubview:chartView];
    
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
    graph.plotAreaFrame.paddingTop = 10.0 ;
    graph.plotAreaFrame.paddingRight = 10.0 ;
    graph.plotAreaFrame.paddingBottom = 40.0 ;
    //设置坐标范围
    CPTXYPlotSpace *plotSpace = (CPTXYPlotSpace *)graph.defaultPlotSpace;
    plotSpace.allowsUserInteraction = NO;
    
    plotSpace.xRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(0.0) length:CPTDecimalFromFloat(60.0)];
    plotSpace.yRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(0) length:CPTDecimalFromFloat(fundHistoryMax*2)];
    
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
//    [components setDay:-15];
//    NSDate *last15Day  = [cal dateByAddingComponents:components toDate: today options:0];
    [components setDay:-30];
    NSDate *last30Day  = [cal dateByAddingComponents:components toDate: today options:0];
//    [components setDay:-45];
//    NSDate *this45Day = [cal dateByAddingComponents:components toDate: today options:0];
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
//        }else if (i== 14){
//            newLabel=[[CPTAxisLabel alloc] initWithText:[formatter stringFromDate:this45Day] textStyle:x.labelTextStyle];
        }else if (i== 27){
            newLabel=[[CPTAxisLabel alloc] initWithText:[formatter stringFromDate:last30Day] textStyle:x.labelTextStyle];
//        }else if (i== 40){
//            newLabel=[[CPTAxisLabel alloc] initWithText:[formatter stringFromDate:last15Day] textStyle:x.labelTextStyle];
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
    y. majorIntervalLength = CPTDecimalFromString ( [NSString stringWithFormat:@"%d", fundHistoryMax/2 ] );
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
    
    //刷新画板
    [graph reloadData];
    
//    [self getFundQuoteHistoryData];
    
    UIView * secondView = [self buildChartView2];
    secondView.frame = CGRectMake(518, 20, 480, 330);
    [view1 addSubview:secondView];

    return view1;
}

- (UIView *)buildChartView2
{
    UIView * view21 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 1024/2, 400)];
    view21.backgroundColor = [UIColor clearColor];
    
    UIView * chartView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 480, 330)];
    chartView.backgroundColor = [UIColor clearColor];
    [view21 addSubview:chartView];
    
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
    plotSpace.yRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(fundHistoryMin) length:CPTDecimalFromFloat(fundHistoryMax)];
    
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
    //    [components setDay:-15];
    //    NSDate *last15Day  = [cal dateByAddingComponents:components toDate: today options:0];
    [components setDay:-1];
    NSDate *last30Day  = [cal dateByAddingComponents:components toDate: today options:0];
    //    [components setDay:-45];
    //    NSDate *this45Day = [cal dateByAddingComponents:components toDate: today options:0];
    [components setDay:-2];
    NSDate *last60Day = [cal dateByAddingComponents:components toDate: today options:0];
    
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy年MM月dd日"];
    
    for ( int  i = 1 ; i<=60 ;i++)
    {
        CPTAxisLabel *newLabel ;
        if(i == 1)
        {
            newLabel=[[CPTAxisLabel alloc] initWithText:[formatter stringFromDate:last60Day] textStyle:x.labelTextStyle];
            //        }else if (i== 14){
            //            newLabel=[[CPTAxisLabel alloc] initWithText:[formatter stringFromDate:this45Day] textStyle:x.labelTextStyle];
        }else if (i== 27){
            newLabel=[[CPTAxisLabel alloc] initWithText:[formatter stringFromDate:last30Day] textStyle:x.labelTextStyle];
            //        }else if (i== 40){
            //            newLabel=[[CPTAxisLabel alloc] initWithText:[formatter stringFromDate:last15Day] textStyle:x.labelTextStyle];
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
    y. majorIntervalLength = CPTDecimalFromString ( [NSString stringWithFormat:@"%d", (fundHistoryMax - fundHistoryMin)/4 ] );
    // 坐标原点： 0
    y. orthogonalCoordinateDecimal = CPTDecimalFromString ([NSString stringWithFormat:@"%d", fundHistoryMin]);
    
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
    
//    [self getFundQuoteHistoryData];
    
    return view21;
}

- (BOOL)isFundMoneyType:(NSInteger)ID
{
    // 开始获取相关关键字
    NSString * searchType = CODE;
    
    if ([dbBase open]) {
        NSString *sqlMoneyQuery = [NSString stringWithFormat:@"SELECT * FROM FUNDMONEY WHERE %@ = '%d'", searchType, ID ];
        FMResultSet * rs = [dbBase executeQuery:sqlMoneyQuery];
        while ([rs next]) {
            return YES;
        }
        
    }
    
    if ([dbBase open]) {
        NSString *sqlMoneyQuery = [NSString stringWithFormat:@"SELECT * FROM FUNDNOTMONEY WHERE %@ = '%d'", searchType, ID ];
        FMResultSet * rs = [dbBase executeQuery:sqlMoneyQuery];
        while ([rs next]) {
            return NO;
        }
        
    }
    return NO;
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
                if ([self isFundMoneyType:[fundQuoteHistoryRequest getFundID]]) {
                    NSString *xp = [NSString stringWithFormat:@"%d",x];
                    NSString *yp = [NSString stringWithFormat:@"%d",data.seven_areturn];
                    NSMutableDictionary *point1 = [[NSMutableDictionary alloc] initWithObjectsAndKeys:xp, @"x", yp, @"y", nil];
                    [dataForPlot1 insertObject:point1 atIndex:x];
                    [arr addObject:[NSString stringWithFormat:@"%d", data.seven_areturn]];
                }
                else {
                    NSString *xp = [NSString stringWithFormat:@"%d",x];
                    NSString *yp = [NSString stringWithFormat:@"%d",data.pay_price];
                    NSMutableDictionary *point1 = [[NSMutableDictionary alloc] initWithObjectsAndKeys:xp, @"x", yp, @"y", nil];
                    [dataForPlot1 insertObject:point1 atIndex:x];
                    [arr addObject:[NSString stringWithFormat:@"%d", data.pay_price]];
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
    //刷新画板
    [graph reloadData];
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
    NSInteger fundCode = [[fundArray objectAtIndex:0]intValue];
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

- (NSInteger)getCellColumn:(NSInteger)fundId
{
    for (int i = 0; i < _count; ++i) {
        NSInteger ID = [[fundArray objectAtIndex:i]intValue];
        if (ID == fundId) {
            return i;
        }
    }
}

- (void)setViewCellLabelByTag:(UIView *)view row:(NSInteger)row column:(NSInteger)column text:(NSString *)text
{
    for (UIView * cell in view.subviews) {
        if (cell.tag == row) {
            for (UIView * v in cell.subviews) {
                if (v.tag == column) {
                    UILabel * label = (UILabel *)v;
                    label.text = text;
                }
            }
        }
    }
}

- (void)setViewCellGradeByTag:(UIView *)view row:(NSInteger)row column:(NSInteger)column grade:(float)grade
{
    for (UIView * cell in view.subviews) {
        if (cell.tag == row) {
            for (UIView * v in cell.subviews) {
                if (v.tag == column) {
                    if ([v isKindOfClass:[GradeView class]])
                    {
                        GradeView * gradeView = (GradeView *)v;
                        gradeView.grade = grade;
                    }
                }
            }
        }
    }
}

- (UIView *)buildView2Cell:(NSString *)title str1:(NSString *)str1 str2:(NSString *)str2 str3:(NSString *)str3 str4:(NSString *)str4 str5:(NSString *)str5
{
    UIView * cell = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 984, 38)];
    cell.backgroundColor = [UIColor clearColor];
    UIView * line1 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 1, 38)];
    line1.backgroundColor = [UIColor colorWithHexValue:0xc3dced];
    [cell addSubview:line1];
    UIView * line2 = [[UIView alloc]initWithFrame:CGRectMake(1+102, 0, 1, 38)];
    line2.backgroundColor = [UIColor colorWithHexValue:0xc3dced];
    [cell addSubview:line2];
    UIView * line3 = [[UIView alloc]initWithFrame:CGRectMake(1*2+102+175, 0, 1, 38)];
    line3.backgroundColor = [UIColor colorWithHexValue:0xc3dced];
    [cell addSubview:line3];
    UIView * line4 = [[UIView alloc]initWithFrame:CGRectMake(1*3+102+175*2, 0, 1, 38)];
    line4.backgroundColor = [UIColor colorWithHexValue:0xc3dced];
    [cell addSubview:line4];
    UIView * line5 = [[UIView alloc]initWithFrame:CGRectMake(1*4+102+175*3, 0, 1, 38)];
    line5.backgroundColor = [UIColor colorWithHexValue:0xc3dced];
    [cell addSubview:line5];
    UIView * line6 = [[UIView alloc]initWithFrame:CGRectMake(1*5+102+175*4, 0, 1, 38)];
    line6.backgroundColor = [UIColor colorWithHexValue:0xc3dced];
    [cell addSubview:line6];
    UIView * line7 = [[UIView alloc]initWithFrame:CGRectMake(1*6+102+175*5, 0, 1, 38)];
    line7.backgroundColor = [UIColor colorWithHexValue:0xc3dced];
    [cell addSubview:line7];
    UIView * lineBottom = [[UIView alloc]initWithFrame:CGRectMake(0, 37, 984, 1)];
    lineBottom.backgroundColor = [UIColor colorWithHexValue:0xc3dced];
    [cell addSubview:lineBottom];
    UIView * bg1 = [[UIView alloc]initWithFrame:CGRectMake(1, 0, 102, 37)];
    bg1.backgroundColor = [UIColor colorWithHexValue:0xd5efe7];
    [cell addSubview:bg1];
    
    UILabel * label1 = [[UILabel alloc] initWithFrame:CGRectMake(1+5, 0, 102-10, 38)];
    [label1 setTextAlignment:NSTextAlignmentRight];
    [label1 setTextColor:[UIColor blackColor]];
    [label1 setFont:[UIFont systemFontOfSize:14]];
    [label1 setBackgroundColor:[UIColor clearColor]];
    label1.text = title;
    [cell addSubview:label1];
    UILabel * label2 = [[UILabel alloc] initWithFrame:CGRectMake(1*2+102+10, 0, 175-10*2, 38)];
    [label2 setTextAlignment:NSTextAlignmentLeft];
    [label2 setTextColor:[UIColor blackColor]];
    [label2 setFont:[UIFont systemFontOfSize:14]];
    [label2 setBackgroundColor:[UIColor clearColor]];
    label2.text = str1;
    label2.tag = 111;
    [cell addSubview:label2];
    UILabel * label3 = [[UILabel alloc] initWithFrame:CGRectMake(1*3+102+175+10, 0, 175-10*2, 38)];
    [label3 setTextAlignment:NSTextAlignmentLeft];
    [label3 setTextColor:[UIColor blackColor]];
    [label3 setFont:[UIFont systemFontOfSize:14]];
    [label3 setBackgroundColor:[UIColor clearColor]];
    label3.text = str2;
    label3.tag = 1;
    [cell addSubview:label3];
    UILabel * label4 = [[UILabel alloc] initWithFrame:CGRectMake(1*4+102+175*2+10, 0, 175-10*2, 38)];
    [label4 setTextAlignment:NSTextAlignmentLeft];
    [label4 setTextColor:[UIColor blackColor]];
    [label4 setFont:[UIFont systemFontOfSize:14]];
    [label4 setBackgroundColor:[UIColor clearColor]];
    label4.text = str3;
    label4.tag = 2;
    [cell addSubview:label4];
    UILabel * label5 = [[UILabel alloc] initWithFrame:CGRectMake(1*5+102+175*3+10, 0, 175-10*2, 38)];
    [label5 setTextAlignment:NSTextAlignmentLeft];
    [label5 setTextColor:[UIColor blackColor]];
    [label5 setFont:[UIFont systemFontOfSize:14]];
    [label5 setBackgroundColor:[UIColor clearColor]];
    label5.text = str4;
    label5.tag = 3;
    [cell addSubview:label5];
    UILabel * label6 = [[UILabel alloc] initWithFrame:CGRectMake(1*6+102+175*4+10, 0, 175-10*2, 38)];
    [label6 setTextAlignment:NSTextAlignmentLeft];
    [label6 setTextColor:[UIColor blackColor]];
    [label6 setFont:[UIFont systemFontOfSize:14]];
    [label6 setBackgroundColor:[UIColor clearColor]];
    label6.text = str5;
    label6.tag = 4;
    [cell addSubview:label6];
    if (_count < 5) {
        label6.hidden = YES;
    }
    if (_count < 4) {
        label5.hidden = YES;
    }
    if (_count < 3) {
        label4.hidden = YES;
    }
    if (_count < 2) {
        label3.hidden = YES;
    }
    return cell;
}

- (FundMoneyData *)getView2MoneyTypeInfo:(NSInteger)ID
{
    // 开始获取相关关键字
    NSString * searchType = CODE;
    
    if ([dbBase open]) {
        FundMoneyData * data = [[FundMoneyData alloc]init];
        
        NSString *sqlMoneyQuery = [NSString stringWithFormat:@"SELECT * FROM FUNDMONEY WHERE %@ = '%d'", searchType, ID ];
        FMResultSet * rs = [dbBase executeQuery:sqlMoneyQuery];
        while ([rs next]) {
            data.name = [rs stringForColumn:@"name"];
            data.py = [rs stringForColumn:@"py"];
            data.date = [rs stringForColumn:@"date"];
            data.pay_price = [rs stringForColumn:@"pay_price"];
            data.seven_areturn = [rs stringForColumn:@"seven_areturn"];
            data.type = [rs stringForColumn:@"type"];
            data.invest_type = [rs stringForColumn:@"invest_type"];
            data.pur_status = [rs stringForColumn:@"pur_status"];
            data.redeem_status = [rs stringForColumn:@"redeem_status"];
            data.rr_this_year = [rs stringForColumn:@"rr_this_year"];
            data.code = [rs intForColumn:@"code"];
            [dbBase close];
            return data;
        }
        
    }
    return nil;
}

- (FundNotMoneyData *)getView2NotMoneyTypeInfo:(NSInteger)ID
{
    // 开始获取相关关键字
    NSString * searchType = CODE;
    
    if ([dbBase open]) {
        FundNotMoneyData * data = [[FundNotMoneyData alloc]init];
        
        NSString *sqlMoneyQuery = [NSString stringWithFormat:@"SELECT * FROM FUNDNOTMONEY WHERE %@ = '%d'", searchType, ID ];
        FMResultSet * rs = [dbBase executeQuery:sqlMoneyQuery];
        while ([rs next]) {
            data.name = [rs stringForColumn:@"name"];
            data.py = [rs stringForColumn:@"py"];
            data.date = [rs stringForColumn:@"date"];
            data.type = [rs stringForColumn:@"type"];
            data.invest_type = [rs stringForColumn:@"invest_type"];
            data.net_value = [rs stringForColumn:@"net_value"];
            data.account_value = [rs stringForColumn:@"account_value"];
            data.limits = [rs stringForColumn:@"limits"];
            data.updown = [rs stringForColumn:@"updown"];
            data.rr_this_year = [rs stringForColumn:@"rr_this_year"];
            data.grade = [rs stringForColumn:@"grade"];
            data.pur_status = [rs stringForColumn:@"pur_status"];
            data.redeem_status = [rs stringForColumn:@"redeem_status"];
            data.code = [rs intForColumn:@"code"];
            [dbBase close];
            return data;
        }
        
    }
    return nil;
}

- (NSString *)getFundType:(NSString *)type
{
    NSString * result = nil;
    if ([type isEqualToString:@"A"]) {
        result = @"开放式";
    }
    if ([type isEqualToString:@"B"]) {
        result = @"封闭式";
    }
    if ([type isEqualToString:@"C"]) {
        result = @"ETF";
    }
    if ([type isEqualToString:@"D"]) {
        result = @"LOF";
    }
    if ([type isEqualToString:@"E"]) {
        result = @"QDII";
    }
    if ([type isEqualToString:@"F"]) {
        result = @"ETF联接基金";
    }
    return result;
}

- (NSString *)getFundInvestType:(NSString *)invest_type
{
    NSString * result = nil;
    if ([invest_type isEqualToString:@"A"]) {
        result = @"股票型";
    }
    if ([invest_type isEqualToString:@"B"]) {
        result = @"普通债券型";
    }
    if ([invest_type isEqualToString:@"C"]) {
        result = @"激进债券";
    }
    if ([invest_type isEqualToString:@"D"]) {
        result = @"纯债基金";
    }
    if ([invest_type isEqualToString:@"E"]) {
        result = @"普通混合型";
    }
    if ([invest_type isEqualToString:@"F"]) {
        result = @"保守混合型";
    }
    if ([invest_type isEqualToString:@"G"]) {
        result = @"激进混合型";
    }
    if ([invest_type isEqualToString:@"H"]) {
        result = @"货币型";
    }
    if ([invest_type isEqualToString:@"I"]) {
        result = @"短债基金";
    }
    if ([invest_type isEqualToString:@"J"]) {
        result = @"FOF";
    }
    if ([invest_type isEqualToString:@"K"]) {
        result = @"保本基金";
    }
    if ([invest_type isEqualToString:@"L"]) {
        result = @"普通型指数基金";
    }
    if ([invest_type isEqualToString:@"M"]) {
        result = @"增强型指数基金";
    }
    if ([invest_type isEqualToString:@"N"]) {
        result = @"分级基金";
    }
    if ([invest_type isEqualToString:@"O"]) {
        result = @"其它";
    }
    return result;
}

- (NSString *)getFundStatus:(NSString *)status
{
    NSString * result = nil;
    if ([status isEqualToString:@"1"]) {
        result = @"是";
    }
    else {
        result = @"否";
    }
    return result;
}



- (UIView *)buildView2
{
    UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 1024-20*2, 378)];
    view.backgroundColor = [UIColor clearColor];
    
    UIView * headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 984, 36)];
    headerView.backgroundColor = [UIColor colorWithHexValue:0x1aa0d8];
    [view addSubview:headerView];
    UILabel * titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, 180, 36)];
    [titleLabel setTextAlignment:NSTextAlignmentLeft];
    [titleLabel setTextColor:[UIColor whiteColor]];
    [titleLabel setFont:[UIFont systemFontOfSize:18]];
    [titleLabel setBackgroundColor:[UIColor clearColor]];
    titleLabel.text = @"基本资料";
    [headerView addSubview:titleLabel];
    
    FundMoneyData * dataMoney1 = nil;
    FundNotMoneyData * dataNotMoney1 = nil;
    FundMoneyData * dataMoney2 = nil;
    FundNotMoneyData * dataNotMoney2 = nil;
    FundMoneyData * dataMoney3 = nil;
    FundNotMoneyData * dataNotMoney3 = nil;
    FundMoneyData * dataMoney4 = nil;
    FundNotMoneyData * dataNotMoney4 = nil;
    FundMoneyData * dataMoney5 = nil;
    FundNotMoneyData * dataNotMoney5 = nil;
    dataMoney1 = [self getView2MoneyTypeInfo:[[fundArray objectAtIndex:0]intValue] ];
    dataNotMoney1 = [self getView2NotMoneyTypeInfo:[[fundArray objectAtIndex:0]intValue] ];
    if (_count > 1) {
        dataMoney2 = [self getView2MoneyTypeInfo:[[fundArray objectAtIndex:1]intValue] ];
        dataNotMoney2 = [self getView2NotMoneyTypeInfo:[[fundArray objectAtIndex:1]intValue] ];
    }
    if (_count > 2) {
        dataMoney3 = [self getView2MoneyTypeInfo:[[fundArray objectAtIndex:2]intValue] ];
        dataNotMoney3 = [self getView2NotMoneyTypeInfo:[[fundArray objectAtIndex:2]intValue] ];
    }
    if (_count > 3) {
        dataMoney4 = [self getView2MoneyTypeInfo:[[fundArray objectAtIndex:3]intValue] ];
        dataNotMoney4 = [self getView2NotMoneyTypeInfo:[[fundArray objectAtIndex:3]intValue] ];
    }
    if (_count > 4) {
        dataMoney5 = [self getView2MoneyTypeInfo:[[fundArray objectAtIndex:4]intValue] ];
        dataNotMoney5 = [self getView2NotMoneyTypeInfo:[[fundArray objectAtIndex:4]intValue] ];
    }
    NSString * str1 = dataMoney1?dataMoney1.type:(dataNotMoney1?dataNotMoney1.type:@"");
    NSString * str2 = dataMoney2?dataMoney2.type:(dataNotMoney2?dataNotMoney2.type:@"");
    NSString * str3 = dataMoney3?dataMoney3.type:(dataNotMoney3?dataNotMoney3.type:@"");
    NSString * str4 = dataMoney4?dataMoney4.type:(dataNotMoney4?dataNotMoney4.type:@"");
    NSString * str5 = dataMoney5?dataMoney5.type:(dataNotMoney5?dataNotMoney5.type:@"");
    str1 = [self getFundType:str1];
    str2 = [self getFundType:str2];
    str3 = [self getFundType:str3];
    str4 = [self getFundType:str4];
    str5 = [self getFundType:str5];
    UIView * cell = [self buildView2Cell:@"投资类型" str1:str1 str2:str2 str3:str3 str4:str4 str5:str5];
    cell.frame = CGRectMake(0, 36, 984, 38);
    cell.tag = 111;
    [view addSubview:cell];
    str1 = dataMoney1?dataMoney1.invest_type:(dataNotMoney1?dataNotMoney1.invest_type:@"");
    str2 = dataMoney2?dataMoney2.invest_type:(dataNotMoney2?dataNotMoney2.invest_type:@"");
    str3 = dataMoney3?dataMoney3.invest_type:(dataNotMoney3?dataNotMoney3.invest_type:@"");
    str4 = dataMoney4?dataMoney4.invest_type:(dataNotMoney4?dataNotMoney4.invest_type:@"");
    str5 = dataMoney5?dataMoney5.invest_type:(dataNotMoney5?dataNotMoney5.invest_type:@"");
    str1 = [self getFundInvestType:str1];
    str2 = [self getFundInvestType:str2];
    str3 = [self getFundInvestType:str3];
    str4 = [self getFundInvestType:str4];
    str5 = [self getFundInvestType:str5];
    UIView * cell1 = [self buildView2Cell:@"投资风格" str1:str1 str2:str2 str3:str3 str4:str4 str5:str5];
    cell1.frame = CGRectMake(0, 36+38, 984, 38);
    cell1.tag = 1;
    [view addSubview:cell1];
    str1 = dataMoney1?dataMoney1.pur_status:(dataNotMoney1?dataNotMoney1.pur_status:@"");
    str2 = dataMoney2?dataMoney2.pur_status:(dataNotMoney2?dataNotMoney2.pur_status:@"");
    str3 = dataMoney3?dataMoney3.pur_status:(dataNotMoney3?dataNotMoney3.pur_status:@"");
    str4 = dataMoney4?dataMoney4.pur_status:(dataNotMoney4?dataNotMoney4.pur_status:@"");
    str5 = dataMoney5?dataMoney5.pur_status:(dataNotMoney5?dataNotMoney5.pur_status:@"");
    str1 = [self getFundStatus:str1];
    str2 = [self getFundStatus:str2];
    str3 = [self getFundStatus:str3];
    str4 = [self getFundStatus:str4];
    str5 = [self getFundStatus:str5];
    UIView * cell2 = [self buildView2Cell:@"申购状态" str1:str1 str2:str2 str3:str3 str4:str4 str5:str5];
    cell2.frame = CGRectMake(0, 36+38*2, 984, 38);
    cell2.tag = 2;
    [view addSubview:cell2];
    str1 = dataMoney1?dataMoney1.redeem_status:(dataNotMoney1?dataNotMoney1.redeem_status:@"");
    str2 = dataMoney2?dataMoney2.redeem_status:(dataNotMoney2?dataNotMoney2.redeem_status:@"");
    str3 = dataMoney3?dataMoney3.redeem_status:(dataNotMoney3?dataNotMoney3.redeem_status:@"");
    str4 = dataMoney4?dataMoney4.redeem_status:(dataNotMoney4?dataNotMoney4.redeem_status:@"");
    str5 = dataMoney5?dataMoney5.redeem_status:(dataNotMoney5?dataNotMoney5.redeem_status:@"");
    str1 = [self getFundStatus:str1];
    str2 = [self getFundStatus:str2];
    str3 = [self getFundStatus:str3];
    str4 = [self getFundStatus:str4];
    str5 = [self getFundStatus:str5];
    UIView * cell3 = [self buildView2Cell:@"赎回状态" str1:str1 str2:str2 str3:str3 str4:str4 str5:str5];
    cell3.frame = CGRectMake(0, 36+38*3, 984, 38);
    cell3.tag = 3;
    [view addSubview:cell3];
    str1 = [NSString stringWithFormat:@"%@", dataMoney1?@"0":(dataNotMoney1?dataNotMoney1.net_value:@"0")];
    str2 = [NSString stringWithFormat:@"%@", dataMoney2?@"0":(dataNotMoney2?dataNotMoney2.net_value:@"0")];
    str3 = [NSString stringWithFormat:@"%@", dataMoney3?@"0":(dataNotMoney3?dataNotMoney3.net_value:@"0")];
    str4 = [NSString stringWithFormat:@"%@", dataMoney4?@"0":(dataNotMoney4?dataNotMoney4.net_value:@"0")];
    str5 = [NSString stringWithFormat:@"%@", dataMoney5?@"0":(dataNotMoney5?dataNotMoney5.net_value:@"0")];
    UIView * cell4 = [self buildView2Cell:@"单位净值" str1:str1 str2:str2 str3:str3 str4:str4 str5:str5];
    cell4.frame = CGRectMake(0, 36+38*4, 984, 38);
    cell4.tag = 4;
    [view addSubview:cell4];
    UIView * cell5 = [self buildView2Cell:@"资产规模" str1:@"" str2:@"" str3:@"" str4:@"" str5:@""];
    cell5.frame = CGRectMake(0, 36+38*5, 984, 38);
    cell5.tag = 5;
    [view addSubview:cell5];
    UIView * cell6 = [self buildView2Cell:@"成立日期" str1:@"" str2:@"" str3:@"" str4:@"" str5:@""];
    cell6.frame = CGRectMake(0, 36+38*6, 984, 38);
    cell6.tag = 6;
    [view addSubview:cell6];
    UIView * cell7 = [self buildView2Cell:@"管理人" str1:@"" str2:@"" str3:@"" str4:@"" str5:@""];
    cell7.frame = CGRectMake(0, 36+38*7, 984, 38);
    cell7.tag = 7;
    [view addSubview:cell7];
    UIView * cell8 = [self buildView2Cell:@"托管人" str1:@"" str2:@"" str3:@"" str4:@"" str5:@""];
    cell8.frame = CGRectMake(0, 36+38*8, 984, 38);
    cell8.tag = 8;
    [view addSubview:cell8];
    
    return view;
}

- (UIView *)buildView3Cell:(NSString *)title grade1:(float)grade1 grade2:(float)grade2 grade3:(float)grade3 grade4:(float)grade4 grade5:(float)grade5
{
    UIView * cell = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 984, 38)];
    cell.backgroundColor = [UIColor clearColor];
    UIView * line1 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 1, 38)];
    line1.backgroundColor = [UIColor colorWithHexValue:0xc3dced];
    [cell addSubview:line1];
    UIView * line2 = [[UIView alloc]initWithFrame:CGRectMake(1+102, 0, 1, 38)];
    line2.backgroundColor = [UIColor colorWithHexValue:0xc3dced];
    [cell addSubview:line2];
    UIView * line3 = [[UIView alloc]initWithFrame:CGRectMake(1*2+102+175, 0, 1, 38)];
    line3.backgroundColor = [UIColor colorWithHexValue:0xc3dced];
    [cell addSubview:line3];
    UIView * line4 = [[UIView alloc]initWithFrame:CGRectMake(1*3+102+175*2, 0, 1, 38)];
    line4.backgroundColor = [UIColor colorWithHexValue:0xc3dced];
    [cell addSubview:line4];
    UIView * line5 = [[UIView alloc]initWithFrame:CGRectMake(1*4+102+175*3, 0, 1, 38)];
    line5.backgroundColor = [UIColor colorWithHexValue:0xc3dced];
    [cell addSubview:line5];
    UIView * line6 = [[UIView alloc]initWithFrame:CGRectMake(1*5+102+175*4, 0, 1, 38)];
    line6.backgroundColor = [UIColor colorWithHexValue:0xc3dced];
    [cell addSubview:line6];
    UIView * line7 = [[UIView alloc]initWithFrame:CGRectMake(1*6+102+175*5, 0, 1, 38)];
    line7.backgroundColor = [UIColor colorWithHexValue:0xc3dced];
    [cell addSubview:line7];
    UIView * lineBottom = [[UIView alloc]initWithFrame:CGRectMake(0, 37, 984, 1)];
    lineBottom.backgroundColor = [UIColor colorWithHexValue:0xc3dced];
    [cell addSubview:lineBottom];
    UIView * bg1 = [[UIView alloc]initWithFrame:CGRectMake(1, 0, 102, 37)];
    bg1.backgroundColor = [UIColor colorWithHexValue:0xd5efe7];
    [cell addSubview:bg1];
    
    UILabel * label1 = [[UILabel alloc] initWithFrame:CGRectMake(1+5, 0, 102-10, 38)];
    [label1 setTextAlignment:NSTextAlignmentRight];
    [label1 setTextColor:[UIColor blackColor]];
    [label1 setFont:[UIFont systemFontOfSize:14]];
    [label1 setBackgroundColor:[UIColor clearColor]];
    label1.text = title;
    [cell addSubview:label1];
    GradeView * gradeView1 = [[GradeView alloc]initWithFrame:CGRectMake(1*2+102+10, 0, 175-10*2, 38)];
    gradeView1.grade = grade1;
    gradeView1.tag = 111;
    [cell addSubview:gradeView1];
    GradeView * gradeView2 = [[GradeView alloc]initWithFrame:CGRectMake(1*3+102+175+10, 0, 175-10*2, 38)];
    gradeView2.grade = grade2;
    gradeView2.tag = 1;
    [cell addSubview:gradeView2];
    GradeView * gradeView3 = [[GradeView alloc]initWithFrame:CGRectMake(1*4+102+175*2+10, 0, 175-10*2, 38)];
    gradeView3.grade = grade3;
    gradeView3.tag = 2;
    [cell addSubview:gradeView3];
    GradeView * gradeView4 = [[GradeView alloc]initWithFrame:CGRectMake(1*5+102+175*3+10, 0, 175-10*2, 38)];
    gradeView4.grade = grade4;
    gradeView4.tag = 3;
    [cell addSubview:gradeView4];
    GradeView * gradeView5 = [[GradeView alloc]initWithFrame:CGRectMake(1*6+102+175*4+10, 0, 175-10*2, 38)];
    gradeView5.grade = grade5;
    gradeView5.tag = 4;
    [cell addSubview:gradeView5];
    if (_count < 5) {
        gradeView5.hidden = YES;
    }
    if (_count < 4) {
        gradeView4.hidden = YES;
    }
    if (_count < 3) {
        gradeView3.hidden = YES;
    }
    if (_count < 2) {
        gradeView2.hidden = YES;
    }
    return cell;
}

- (UIView *)buildView3
{
    UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 1024-20*2, 150)];
    view.backgroundColor = [UIColor clearColor];
    
    UIView * headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 984, 36)];
    headerView.backgroundColor = [UIColor colorWithHexValue:0x1aa0d8];
    [view addSubview:headerView];
    UILabel * titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, 180, 36)];
    [titleLabel setTextAlignment:NSTextAlignmentLeft];
    [titleLabel setTextColor:[UIColor whiteColor]];
    [titleLabel setFont:[UIFont systemFontOfSize:18]];
    [titleLabel setBackgroundColor:[UIColor clearColor]];
    titleLabel.text = @"i财富评级";
    [headerView addSubview:titleLabel];
    
    UIView * cell = [self buildView2Cell:@"三年评级" str1:@"" str2:@"" str3:@"" str4:@"" str5:@""];
    cell.frame = CGRectMake(0, 36, 984, 38);
    cell.tag = 111;
    [view addSubview:cell];
    UIView * cell1 = [self buildView2Cell:@"超额回报" str1:@"" str2:@"" str3:@"" str4:@"" str5:@""];
    cell1.frame = CGRectMake(0, 36+38, 984, 38);
    cell1.tag = 1;
    [view addSubview:cell1];
    UIView * cell2 = [self buildView2Cell:@"风险评测" str1:@"" str2:@"" str3:@"" str4:@"" str5:@""];
    cell2.frame = CGRectMake(0, 36+38*2, 984, 38);
    cell2.tag = 2;
    [view addSubview:cell2];
    
    return view;
}

- (UIView *)buildView4Cell:(NSString *)title str1:(NSString *)str1 str2:(NSString *)str2 str3:(NSString *)str3 str4:(NSString *)str4 str5:(NSString *)str5
                      str6:(NSString *)str6 str7:(NSString *)str7 str8:(NSString *)str8 str9:(NSString *)str9 str10:(NSString *)str10 str11:(NSString *)str11
                      str12:(NSString *)str12 str13:(NSString *)str13 str14:(NSString *)str14 str15:(NSString *)str15
{
    UIView * cell = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 984, 38)];
    cell.backgroundColor = [UIColor clearColor];
    UIView * line1 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 1, 38)];
    line1.backgroundColor = [UIColor colorWithHexValue:0xc3dced];
    [cell addSubview:line1];
    UIView * line2 = [[UIView alloc]initWithFrame:CGRectMake(1+102, 0, 1, 38)];
    line2.backgroundColor = [UIColor colorWithHexValue:0xc3dced];
    [cell addSubview:line2];
    UIView * line21 = [[UIView alloc]initWithFrame:CGRectMake(1+102+57, 0, 1, 38)];
    line21.backgroundColor = [UIColor colorWithHexValue:0xc3dced];
    [cell addSubview:line21];
    UIView * line22 = [[UIView alloc]initWithFrame:CGRectMake(1*2+102+57+59, 0, 1, 38)];
    line22.backgroundColor = [UIColor colorWithHexValue:0xc3dced];
    [cell addSubview:line22];
    UIView * line3 = [[UIView alloc]initWithFrame:CGRectMake(1*2+102+175, 0, 1, 38)];
    line3.backgroundColor = [UIColor colorWithHexValue:0xc3dced];
    [cell addSubview:line3];
    UIView * line31 = [[UIView alloc]initWithFrame:CGRectMake(1*3+102+175+57, 0, 1, 38)];
    line31.backgroundColor = [UIColor colorWithHexValue:0xc3dced];
    [cell addSubview:line31];
    UIView * line32 = [[UIView alloc]initWithFrame:CGRectMake(1*4+102+175+57+59, 0, 1, 38)];
    line32.backgroundColor = [UIColor colorWithHexValue:0xc3dced];
    [cell addSubview:line32];
    UIView * line4 = [[UIView alloc]initWithFrame:CGRectMake(1*3+102+175*2, 0, 1, 38)];
    line4.backgroundColor = [UIColor colorWithHexValue:0xc3dced];
    [cell addSubview:line4];
    UIView * line41 = [[UIView alloc]initWithFrame:CGRectMake(1*4+102+175*2+57, 0, 1, 38)];
    line41.backgroundColor = [UIColor colorWithHexValue:0xc3dced];
    [cell addSubview:line41];
    UIView * line42 = [[UIView alloc]initWithFrame:CGRectMake(1*5+102+175*2+57+59, 0, 1, 38)];
    line42.backgroundColor = [UIColor colorWithHexValue:0xc3dced];
    [cell addSubview:line42];
    UIView * line5 = [[UIView alloc]initWithFrame:CGRectMake(1*4+102+175*3, 0, 1, 38)];
    line5.backgroundColor = [UIColor colorWithHexValue:0xc3dced];
    [cell addSubview:line5];
    UIView * line51 = [[UIView alloc]initWithFrame:CGRectMake(1*5+102+175*3+57, 0, 1, 38)];
    line51.backgroundColor = [UIColor colorWithHexValue:0xc3dced];
    [cell addSubview:line51];
    UIView * line52 = [[UIView alloc]initWithFrame:CGRectMake(1*6+102+175*3+57+59, 0, 1, 38)];
    line52.backgroundColor = [UIColor colorWithHexValue:0xc3dced];
    [cell addSubview:line52];
    UIView * line6 = [[UIView alloc]initWithFrame:CGRectMake(1*5+102+175*4, 0, 1, 38)];
    line6.backgroundColor = [UIColor colorWithHexValue:0xc3dced];
    [cell addSubview:line6];
    UIView * line61 = [[UIView alloc]initWithFrame:CGRectMake(1*6+102+175*4+57, 0, 1, 38)];
    line61.backgroundColor = [UIColor colorWithHexValue:0xc3dced];
    [cell addSubview:line61];
    UIView * line62 = [[UIView alloc]initWithFrame:CGRectMake(1*7+102+175*4+57+59, 0, 1, 38)];
    line62.backgroundColor = [UIColor colorWithHexValue:0xc3dced];
    [cell addSubview:line62];
    UIView * line7 = [[UIView alloc]initWithFrame:CGRectMake(1*6+102+175*5, 0, 1, 38)];
    line7.backgroundColor = [UIColor colorWithHexValue:0xc3dced];
    [cell addSubview:line7];
    UIView * lineBottom = [[UIView alloc]initWithFrame:CGRectMake(0, 37, 984, 1)];
    lineBottom.backgroundColor = [UIColor colorWithHexValue:0xc3dced];
    [cell addSubview:lineBottom];
    UIView * bg1 = [[UIView alloc]initWithFrame:CGRectMake(1, 0, 102, 37)];
    bg1.backgroundColor = [UIColor colorWithHexValue:0xd5efe7];
    [cell addSubview:bg1];
    
    UILabel * label1 = [[UILabel alloc] initWithFrame:CGRectMake(1+10, 0, 102-10*2, 38)];
    [label1 setTextAlignment:NSTextAlignmentRight];
    [label1 setTextColor:[UIColor blackColor]];
    [label1 setFont:[UIFont systemFontOfSize:14]];
    [label1 setBackgroundColor:[UIColor clearColor]];
    label1.text = title;
    [cell addSubview:label1];
    UILabel * label2 = [[UILabel alloc] initWithFrame:CGRectMake(1*2+102, 0, 57, 38)];
    [label2 setTextAlignment:NSTextAlignmentCenter];
    [label2 setTextColor:[UIColor blackColor]];
    [label2 setFont:[UIFont systemFontOfSize:14]];
    [label2 setBackgroundColor:[UIColor clearColor]];
    label2.text = str1;
    label2.tag = 111;
    [cell addSubview:label2];
    UILabel * label3 = [[UILabel alloc] initWithFrame:CGRectMake(1*3+102+57, 0, 59, 38)];
    [label3 setTextAlignment:NSTextAlignmentCenter];
    [label3 setTextColor:[UIColor blackColor]];
    [label3 setFont:[UIFont systemFontOfSize:14]];
    [label3 setBackgroundColor:[UIColor clearColor]];
    label3.text = str2;
    label3.tag = 1;
    [cell addSubview:label3];
    UILabel * label4 = [[UILabel alloc] initWithFrame:CGRectMake(1*4+102+57+59, 0, 57, 38)];
    [label4 setTextAlignment:NSTextAlignmentCenter];
    [label4 setTextColor:[UIColor blackColor]];
    [label4 setFont:[UIFont systemFontOfSize:14]];
    [label4 setBackgroundColor:[UIColor clearColor]];
    label4.text = str3;
    label4.tag = 2;
    [cell addSubview:label4];
    UILabel * label5 = [[UILabel alloc] initWithFrame:CGRectMake(1*5+102+57*2+59, 0, 57, 38)];
    [label5 setTextAlignment:NSTextAlignmentCenter];
    [label5 setTextColor:[UIColor blackColor]];
    [label5 setFont:[UIFont systemFontOfSize:14]];
    [label5 setBackgroundColor:[UIColor clearColor]];
    label5.text = str4;
    label5.tag = 3;
    [cell addSubview:label5];
    UILabel * label6 = [[UILabel alloc] initWithFrame:CGRectMake(1*6+102+57*3+59, 0, 59, 38)];
    [label6 setTextAlignment:NSTextAlignmentCenter];
    [label6 setTextColor:[UIColor blackColor]];
    [label6 setFont:[UIFont systemFontOfSize:14]];
    [label6 setBackgroundColor:[UIColor clearColor]];
    label6.text = str5;
    label6.tag = 4;
    [cell addSubview:label6];
    UILabel * label7 = [[UILabel alloc] initWithFrame:CGRectMake(1*7+102+57*3+59*2, 0, 57, 38)];
    [label7 setTextAlignment:NSTextAlignmentCenter];
    [label7 setTextColor:[UIColor blackColor]];
    [label7 setFont:[UIFont systemFontOfSize:14]];
    [label7 setBackgroundColor:[UIColor clearColor]];
    label7.text = str6;
    label7.tag = 5;
    [cell addSubview:label7];
    UILabel * label8 = [[UILabel alloc] initWithFrame:CGRectMake(1*8+102+57*4+59*2, 0, 57, 38)];
    [label8 setTextAlignment:NSTextAlignmentCenter];
    [label8 setTextColor:[UIColor blackColor]];
    [label8 setFont:[UIFont systemFontOfSize:14]];
    [label8 setBackgroundColor:[UIColor clearColor]];
    label8.text = str7;
    label8.tag = 6;
    [cell addSubview:label8];
    UILabel * label9 = [[UILabel alloc] initWithFrame:CGRectMake(1*9+102+57*5+59*2, 0, 59, 38)];
    [label9 setTextAlignment:NSTextAlignmentCenter];
    [label9 setTextColor:[UIColor blackColor]];
    [label9 setFont:[UIFont systemFontOfSize:14]];
    [label9 setBackgroundColor:[UIColor clearColor]];
    label9.text = str8;
    label9.tag = 7;
    [cell addSubview:label9];
    UILabel * label10 = [[UILabel alloc] initWithFrame:CGRectMake(1*10+102+57*5+59*3, 0, 57, 38)];
    [label10 setTextAlignment:NSTextAlignmentCenter];
    [label10 setTextColor:[UIColor blackColor]];
    [label10 setFont:[UIFont systemFontOfSize:14]];
    [label10 setBackgroundColor:[UIColor clearColor]];
    label10.text = str9;
    label10.tag = 8;
    [cell addSubview:label10];
    UILabel * label11 = [[UILabel alloc] initWithFrame:CGRectMake(1*10+102+57*6+59*3, 0, 57, 38)];
    [label11 setTextAlignment:NSTextAlignmentCenter];
    [label11 setTextColor:[UIColor blackColor]];
    [label11 setFont:[UIFont systemFontOfSize:14]];
    [label11 setBackgroundColor:[UIColor clearColor]];
    label11.text = str10;
    label11.tag = 9;
    [cell addSubview:label11];
    UILabel * label12 = [[UILabel alloc] initWithFrame:CGRectMake(1*10+102+57*7+59*3, 0, 59, 38)];
    [label12 setTextAlignment:NSTextAlignmentCenter];
    [label12 setTextColor:[UIColor blackColor]];
    [label12 setFont:[UIFont systemFontOfSize:14]];
    [label12 setBackgroundColor:[UIColor clearColor]];
    label12.text = str11;
    label12.tag = 10;
    [cell addSubview:label12];
    UILabel * label13 = [[UILabel alloc] initWithFrame:CGRectMake(1*10+102+57*7+59*4, 0, 57, 38)];
    [label13 setTextAlignment:NSTextAlignmentCenter];
    [label13 setTextColor:[UIColor blackColor]];
    [label13 setFont:[UIFont systemFontOfSize:14]];
    [label13 setBackgroundColor:[UIColor clearColor]];
    label13.text = str12;
    label13.tag = 11;
    [cell addSubview:label13];
    UILabel * label14 = [[UILabel alloc] initWithFrame:CGRectMake(1*10+102+57*8+59*4, 0, 57, 38)];
    [label14 setTextAlignment:NSTextAlignmentCenter];
    [label14 setTextColor:[UIColor blackColor]];
    [label14 setFont:[UIFont systemFontOfSize:14]];
    [label14 setBackgroundColor:[UIColor clearColor]];
    label14.text = str13;
    label14.tag = 12;
    [cell addSubview:label14];
    UILabel * label15 = [[UILabel alloc] initWithFrame:CGRectMake(1*10+102+57*9+59*4, 0, 59, 38)];
    [label15 setTextAlignment:NSTextAlignmentCenter];
    [label15 setTextColor:[UIColor blackColor]];
    [label15 setFont:[UIFont systemFontOfSize:14]];
    [label15 setBackgroundColor:[UIColor clearColor]];
    label15.text = str14;
    label15.tag = 13;
    [cell addSubview:label15];
    UILabel * label16 = [[UILabel alloc] initWithFrame:CGRectMake(1*10+102+57*9+59*5, 0, 57, 38)];
    [label16 setTextAlignment:NSTextAlignmentCenter];
    [label16 setTextColor:[UIColor blackColor]];
    [label16 setFont:[UIFont systemFontOfSize:14]];
    [label16 setBackgroundColor:[UIColor clearColor]];
    label16.text = str15;
    label16.tag = 14;
    [cell addSubview:label16];
    if (_count < 5) {
        label16.hidden = YES;
        label15.hidden = YES;
        label14.hidden = YES;
    }
    if (_count < 4) {
        label13.hidden = YES;
        label12.hidden = YES;
        label11.hidden = YES;
    }
    if (_count < 3) {
        label10.hidden = YES;
        label9.hidden = YES;
        label8.hidden = YES;
    }
    if (_count < 2) {
        label7.hidden = YES;
        label6.hidden = YES;
        label5.hidden = YES;
    }
    return cell;
}

- (UIView *)buildView4
{
    UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 1024-20*2, 226)];
    view.backgroundColor = [UIColor clearColor];
    
    UIView * headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 984, 36)];
    headerView.backgroundColor = [UIColor colorWithHexValue:0x1aa0d8];
    [view addSubview:headerView];
    UILabel * titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, 180, 36)];
    [titleLabel setTextAlignment:NSTextAlignmentLeft];
    [titleLabel setTextColor:[UIColor whiteColor]];
    [titleLabel setFont:[UIFont systemFontOfSize:18]];
    [titleLabel setBackgroundColor:[UIColor clearColor]];
    titleLabel.text = @"历史回报（%）";
    [headerView addSubview:titleLabel];
    
    UIView * cell = [self buildView4Cell:@"" str1:@"总回报" str2:@"+/-基准" str3:@"排名" str4:@"总回报" str5:@"+/-基准" str6:@"排名" str7:@"总回报" str8:@"+/-基准" str9:@"排名" str10:@"总回报" str11:@"+/-基准" str12:@"排名" str13:@"总回报" str14:@"+/-基准" str15:@"排名"];
    cell.frame = CGRectMake(0, 36, 984, 38);
    [view addSubview:cell];
    UIView * cell1 = [self buildView4Cell:@"六个月" str1:@"" str2:@"" str3:@"" str4:@"" str5:@"" str6:@"" str7:@"" str8:@"" str9:@"" str10:@"" str11:@"" str12:@"" str13:@"" str14:@"" str15:@""];
    cell1.frame = CGRectMake(0, 36+38, 984, 38);
    [view addSubview:cell1];
    cell1.tag = 111;
    UIView * cell2 = [self buildView4Cell:@"一年" str1:@"" str2:@"" str3:@"" str4:@"" str5:@"" str6:@"" str7:@"" str8:@"" str9:@"" str10:@"" str11:@"" str12:@"" str13:@"" str14:@"" str15:@""];
    cell2.frame = CGRectMake(0, 36+38*2, 984, 38);
    [view addSubview:cell2];
    cell2.tag = 1;
    UIView * cell3 = [self buildView4Cell:@"两年" str1:@"" str2:@"" str3:@"" str4:@"" str5:@"" str6:@"" str7:@"" str8:@"" str9:@"" str10:@"" str11:@"" str12:@"" str13:@"" str14:@"" str15:@""];
    cell3.frame = CGRectMake(0, 36+38*3, 984, 38);
    [view addSubview:cell3];
    cell3.tag = 2;
    UIView * cell4 = [self buildView4Cell:@"三年" str1:@"" str2:@"" str3:@"" str4:@"" str5:@"" str6:@"" str7:@"" str8:@"" str9:@"" str10:@"" str11:@"" str12:@"" str13:@"" str14:@"" str15:@""];
    cell4.frame = CGRectMake(0, 36+38*4, 984, 38);
    [view addSubview:cell4];
    cell4.tag = 3;
    
    for (int i = 0; i < _count; ++i) {
        if ([dbBase open]) {
            NSString *sqlRankMoneyQuery = [NSString stringWithFormat:@"SELECT * FROM FUNDRANKMONEY WHERE %@ = '%d'", @"code", [[fundArray objectAtIndex:i]intValue] ];
            FMResultSet * rs2 = [dbBase executeQuery:sqlRankMoneyQuery];
            while ([rs2 next]) {
                if (i == 0) {
                    [self setViewCellLabelByTag:view row:111 column:111 text:[NSString stringWithFormat:@"%d", [rs2 intForColumn:@"rr_six_month"]]];
                }
                else {
                    [self setViewCellLabelByTag:view row:111 column:i*3 text:[NSString stringWithFormat:@"%d", [rs2 intForColumn:@"rr_six_month"]]];
                }
//                [self setViewCellLabelByTag:view row:111 column:i*3+1 text:@"1.50"];
                [self setViewCellLabelByTag:view row:111 column:i*3+2 text:[NSString stringWithFormat:@"%d", [rs2 intForColumn:@"rr_six_month_rank"]]];
                
                if (i == 0) {
                    [self setViewCellLabelByTag:view row:1 column:111 text:[NSString stringWithFormat:@"%d", [rs2 intForColumn:@"rr_one_year"]]];
                }
                else {
                    [self setViewCellLabelByTag:view row:1 column:i*3 text:[NSString stringWithFormat:@"%d", [rs2 intForColumn:@"rr_one_year"]]];
                }
//                [self setViewCellLabelByTag:view row:1 column:i*3+1 text:@"1.50"];
                [self setViewCellLabelByTag:view row:1 column:i*3+2 text:[NSString stringWithFormat:@"%d", [rs2 intForColumn:@"rr_one_year_rank"]]];
                
                if (i == 0) {
                    [self setViewCellLabelByTag:view row:2 column:111 text:[NSString stringWithFormat:@"%d", [rs2 intForColumn:@"rr_two_year"]]];
                }
                else {
                    [self setViewCellLabelByTag:view row:2 column:i*3 text:[NSString stringWithFormat:@"%d", [rs2 intForColumn:@"rr_two_year"]]];
                }
//                [self setViewCellLabelByTag:view row:2 column:i*3+1 text:@"1.50"];
                [self setViewCellLabelByTag:view row:2 column:i*3+2 text:[NSString stringWithFormat:@"%d", [rs2 intForColumn:@"rr_two_year_rank"]]];
                
                if (i == 0) {
                    [self setViewCellLabelByTag:view row:3 column:111 text:[NSString stringWithFormat:@"%d", [rs2 intForColumn:@"rr_three_year"]]];
                }
                else {
                    [self setViewCellLabelByTag:view row:3 column:i*3 text:[NSString stringWithFormat:@"%d", [rs2 intForColumn:@"rr_three_year"]]];
                }
//                [self setViewCellLabelByTag:view row:3 column:i*3+1 text:@"1.50"];
                [self setViewCellLabelByTag:view row:3 column:i*3+2 text:[NSString stringWithFormat:@"%d", [rs2 intForColumn:@"rr_three_year_rank"]]];
            }
            
            NSString *sqlRankNotMoneyQuery = [NSString stringWithFormat:@"SELECT * FROM FUNDRANKNOTMONEY WHERE %@ = '%d'", @"code", [[fundArray objectAtIndex:i]intValue] ];
            FMResultSet * rs3 = [dbBase executeQuery:sqlRankNotMoneyQuery];
            while ([rs3 next]) {
                if (i == 0) {
                    [self setViewCellLabelByTag:view row:111 column:111 text:[NSString stringWithFormat:@"%d", [rs3 intForColumn:@"rr_six_month"]]];
                }
                else {
                    [self setViewCellLabelByTag:view row:111 column:i*3 text:[NSString stringWithFormat:@"%d", [rs3 intForColumn:@"rr_six_month"]]];
                }
                //                [self setViewCellLabelByTag:view row:111 column:i*3+1 text:@"1.50"];
                [self setViewCellLabelByTag:view row:111 column:i*3+2 text:[NSString stringWithFormat:@"%d", [rs3 intForColumn:@"rr_six_month_rank"]]];
                
                if (i == 0) {
                    [self setViewCellLabelByTag:view row:1 column:111 text:[NSString stringWithFormat:@"%d", [rs3 intForColumn:@"rr_one_year"]]];
                }
                else {
                    [self setViewCellLabelByTag:view row:1 column:i*3 text:[NSString stringWithFormat:@"%d", [rs3 intForColumn:@"rr_one_year"]]];
                }
                //                [self setViewCellLabelByTag:view row:1 column:i*3+1 text:@"1.50"];
                [self setViewCellLabelByTag:view row:1 column:i*3+2 text:[NSString stringWithFormat:@"%d", [rs3 intForColumn:@"rr_one_year_rank"]]];
                
                if (i == 0) {
                    [self setViewCellLabelByTag:view row:2 column:111 text:[NSString stringWithFormat:@"%d", [rs3 intForColumn:@"rr_two_year"]]];
                }
                else {
                    [self setViewCellLabelByTag:view row:2 column:i*3 text:[NSString stringWithFormat:@"%d", [rs3 intForColumn:@"rr_two_year"]]];
                }
                //                [self setViewCellLabelByTag:view row:2 column:i*3+1 text:@"1.50"];
                [self setViewCellLabelByTag:view row:2 column:i*3+2 text:[NSString stringWithFormat:@"%d", [rs3 intForColumn:@"rr_two_year_rank"]]];
                
                if (i == 0) {
                    [self setViewCellLabelByTag:view row:3 column:111 text:[NSString stringWithFormat:@"%d", [rs3 intForColumn:@"rr_three_year"]]];
                }
                else {
                    [self setViewCellLabelByTag:view row:3 column:i*3 text:[NSString stringWithFormat:@"%d", [rs3 intForColumn:@"rr_three_year"]]];
                }
                //                [self setViewCellLabelByTag:view row:3 column:i*3+1 text:@"1.50"];
                [self setViewCellLabelByTag:view row:3 column:i*3+2 text:[NSString stringWithFormat:@"%d", [rs3 intForColumn:@"rr_three_year_rank"]]];
                
            }
            
            
            [dbBase close];
        }
    }
    return view;
}

- (UIView *)buildView5
{
    UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 1024-20*2, 150)];
    view.backgroundColor = [UIColor clearColor];
    
    UIView * headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 984, 36)];
    headerView.backgroundColor = [UIColor colorWithHexValue:0x1aa0d8];
    [view addSubview:headerView];
    UILabel * titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, 180, 36)];
    [titleLabel setTextAlignment:NSTextAlignmentLeft];
    [titleLabel setTextColor:[UIColor whiteColor]];
    [titleLabel setFont:[UIFont systemFontOfSize:18]];
    [titleLabel setBackgroundColor:[UIColor clearColor]];
    titleLabel.text = @"基金经理";
    [headerView addSubview:titleLabel];
    
    UIView * cell = [self buildView2Cell:@"姓名" str1:@"" str2:@"" str3:@"" str4:@"" str5:@""];
    cell.frame = CGRectMake(0, 36, 984, 38);
    cell.tag = 111;
    [view addSubview:cell];
    UIView * cell1 = [self buildView2Cell:@"任职日期" str1:@"" str2:@"" str3:@"" str4:@"" str5:@""];
    cell1.frame = CGRectMake(0, 36+38, 984, 38);
    cell1.tag = 1;
    [view addSubview:cell1];
    UIView * cell2 = [self buildView2Cell:@"最近年回报率" str1:@"" str2:@"" str3:@"" str4:@"" str5:@""];
    cell2.frame = CGRectMake(0, 36+38*2, 984, 38);
    cell2.tag = 2;
    [view addSubview:cell2];
    return view;
}

- (UIView *)buildView6
{
    UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 1024-20*2, 226)];
    view.backgroundColor = [UIColor clearColor];
    
    UIView * headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 984, 36)];
    headerView.backgroundColor = [UIColor colorWithHexValue:0x1aa0d8];
    [view addSubview:headerView];
    UILabel * titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, 180, 36)];
    [titleLabel setTextAlignment:NSTextAlignmentLeft];
    [titleLabel setTextColor:[UIColor whiteColor]];
    [titleLabel setFont:[UIFont systemFontOfSize:18]];
    [titleLabel setBackgroundColor:[UIColor clearColor]];
    titleLabel.text = @"成本费用";
    [headerView addSubview:titleLabel];
    
    UIView * cell = [self buildView2Cell:@"管理费" str1:@"" str2:@"" str3:@"" str4:@"" str5:@""];
    cell.frame = CGRectMake(0, 36, 984, 38);
    cell.tag = 111;
    [view addSubview:cell];
    UIView * cell1 = [self buildView2Cell:@"托管费" str1:@"" str2:@"" str3:@"" str4:@"" str5:@""];
    cell1.frame = CGRectMake(0, 36+38, 984, 38);
    cell1.tag = 1;
    [view addSubview:cell1];
    UIView * cell2 = [self buildView2Cell:@"最高赎回费率" str1:@"" str2:@"" str3:@"" str4:@"" str5:@""];
    cell2.frame = CGRectMake(0, 36+38*2, 984, 38);
    cell2.tag = 2;
    [view addSubview:cell2];
    UIView * cell3 = [self buildView2Cell:@"最高申购费率" str1:@"" str2:@"" str3:@"" str4:@"" str5:@""];
    cell3.frame = CGRectMake(0, 36+38*3, 984, 38);
    cell3.tag = 3;
    [view addSubview:cell3];
    UIView * cell4 = [self buildView2Cell:@"最高认购费率" str1:@"" str2:@"" str3:@"" str4:@"" str5:@""];
    cell4.frame = CGRectMake(0, 36+38*4, 984, 38);
    cell4.tag = 4;
    [view addSubview:cell4];
    return view;
}

- (UIView *)buildView7Cell:(NSString *)title
{
    UIView * cell = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 984, 38*2)];
    cell.backgroundColor = [UIColor clearColor];
    UIView * line1 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 1, 38*2)];
    line1.backgroundColor = [UIColor colorWithHexValue:0xc3dced];
    [cell addSubview:line1];
    UIView * line2 = [[UIView alloc]initWithFrame:CGRectMake(1+102, 0, 1, 38*2)];
    line2.backgroundColor = [UIColor colorWithHexValue:0xc3dced];
    [cell addSubview:line2];
    UIView * line3 = [[UIView alloc]initWithFrame:CGRectMake(1*2+102+175, 0, 1, 38*2)];
    line3.backgroundColor = [UIColor colorWithHexValue:0xc3dced];
    [cell addSubview:line3];
    UIView * line4 = [[UIView alloc]initWithFrame:CGRectMake(1*3+102+175*2, 0, 1, 38*2)];
    line4.backgroundColor = [UIColor colorWithHexValue:0xc3dced];
    [cell addSubview:line4];
    UIView * line5 = [[UIView alloc]initWithFrame:CGRectMake(1*4+102+175*3, 0, 1, 38*2)];
    line5.backgroundColor = [UIColor colorWithHexValue:0xc3dced];
    [cell addSubview:line5];
    UIView * line6 = [[UIView alloc]initWithFrame:CGRectMake(1*5+102+175*4, 0, 1, 38*2)];
    line6.backgroundColor = [UIColor colorWithHexValue:0xc3dced];
    [cell addSubview:line6];
    UIView * line7 = [[UIView alloc]initWithFrame:CGRectMake(1*6+102+175*5, 0, 1, 38*2)];
    line7.backgroundColor = [UIColor colorWithHexValue:0xc3dced];
    [cell addSubview:line7];
    UIView * lineBottom = [[UIView alloc]initWithFrame:CGRectMake(0, 37+38, 984, 1)];
    lineBottom.backgroundColor = [UIColor colorWithHexValue:0xc3dced];
    [cell addSubview:lineBottom];
    UIView * bg1 = [[UIView alloc]initWithFrame:CGRectMake(1, 0, 102, 37+38)];
    bg1.backgroundColor = [UIColor colorWithHexValue:0xd5efe7];
    [cell addSubview:bg1];
    
    UILabel * label1 = [[UILabel alloc] initWithFrame:CGRectMake(1+5, 0, 102-10, 38)];
    [label1 setTextAlignment:NSTextAlignmentRight];
    [label1 setTextColor:[UIColor blackColor]];
    [label1 setFont:[UIFont systemFontOfSize:14]];
    [label1 setBackgroundColor:[UIColor clearColor]];
    label1.text = title;
    [cell addSubview:label1];
    return cell;
}

- (UIView *)buildView7
{
    UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 1024-20*2, 36+38*6)];
    view.backgroundColor = [UIColor clearColor];
    
    UIView * headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 984, 36)];
    headerView.backgroundColor = [UIColor colorWithHexValue:0x1aa0d8];
    [view addSubview:headerView];
    UILabel * titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, 180, 36)];
    [titleLabel setTextAlignment:NSTextAlignmentLeft];
    [titleLabel setTextColor:[UIColor whiteColor]];
    [titleLabel setFont:[UIFont systemFontOfSize:18]];
    [titleLabel setBackgroundColor:[UIColor clearColor]];
    titleLabel.text = @"成本费用";
    [headerView addSubview:titleLabel];
    
//    UIView * cell = [self buildView7Cell:@"投资组合"];
//    cell.frame = CGRectMake(0, 36, 984, 38*2);
//    [view addSubview:cell];
    UIView * cell1 = [self buildView2Cell:@"" str1:@"占净资产（%）" str2:@"占净资产（%）" str3:@"占净资产（%）" str4:@"占净资产（%）" str5:@"占净资产（%）"];
    cell1.frame = CGRectMake(0, 36, 984, 38);
    cell1.backgroundColor = [UIColor colorWithHexValue:0xd5efe7];
    [view addSubview:cell1];
    UIView * cell2 = [self buildView2Cell:@"股票" str1:@"" str2:@"" str3:@"" str4:@"" str5:@""];
    cell2.frame = CGRectMake(0, 36+38*1, 984, 38);
    cell2.tag = 111;
    [view addSubview:cell2];
    UIView * cell3 = [self buildView2Cell:@"债券" str1:@"" str2:@"" str3:@"" str4:@"" str5:@""];
    cell3.frame = CGRectMake(0, 36+38*2, 984, 38);
    cell3.tag = 1;
    [view addSubview:cell3];
    UIView * cell4 = [self buildView2Cell:@"权证" str1:@"" str2:@"" str3:@"" str4:@"" str5:@""];
    cell4.frame = CGRectMake(0, 36+38*3, 984, 38);
    cell4.tag = 2;
    [view addSubview:cell4];
    UIView * cell5 = [self buildView2Cell:@"银行存款" str1:@"" str2:@"" str3:@"" str4:@"" str5:@""];
    cell5.frame = CGRectMake(0, 36+38*4, 984, 38);
    cell5.tag = 3;
    [view addSubview:cell5];
    UIView * cell6 = [self buildView2Cell:@"其他资产" str1:@"" str2:@"" str3:@"" str4:@"" str5:@""];
    cell6.frame = CGRectMake(0, 36+38*5, 984, 38);
    cell6.tag = 4;
    [view addSubview:cell6];
    return view;
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
    UIScrollView * scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 86, 1024, 768-20-86-59)];
    [self.view addSubview:scrollView];
    view1 = [self buildView1];
    view1.frame = CGRectMake(0, 0, 1024-20*2, 400);
    [scrollView addSubview:view1];
    view2 = [self buildView2];
    view2.frame = CGRectMake(20, 15*2+400, 1024-20*2, 378);
    [scrollView addSubview:view2];
    view3 = [self buildView3];
    view3.frame = CGRectMake(20, 15*3+400+378, 1024-20*2, 150);
    [scrollView addSubview:view3];
    view4 = [self buildView4];
    view4.frame = CGRectMake(20, 15*4+400+378+150, 1024-20*2, 226);
    [scrollView addSubview:view4];
    view5 = [self buildView5];
    view5.frame = CGRectMake(20, 15*5+400+378+150+226, 1024-20*2, 150);
    [scrollView addSubview:view5];
    view6 = [self buildView6];
    view6.frame = CGRectMake(20, 15*6+400+378+150+226+150, 1024-20*2, 226);
    [scrollView addSubview:view6];
    view7 = [self buildView7];
    view7.frame = CGRectMake(20, 15*7+400+378+150+226+150+226, 1024-20*2, 264);
    [scrollView addSubview:view7];
    [scrollView setContentSize:CGSizeMake(1024, 15*8+400+378+150+226+150+226+264)];
    
    
    for (int i = 0; i < _count; ++i) {
        int fundId = [[fundArray objectAtIndex:i]intValue];
        if (i == 0) {
            fundHistoryRequest1 = [self getFundHistoryData:fundId];
        }
        if (i == 1) {
            fundHistoryRequest2 = [self getFundHistoryData:fundId];
        }
        if (i == 2) {
            fundHistoryRequest3 = [self getFundHistoryData:fundId];
        }
        if (i == 3) {
            fundHistoryRequest4 = [self getFundHistoryData:fundId];
        }
        if (i == 4) {
            fundHistoryRequest5 = [self getFundHistoryData:fundId];
        }
    }
    
    for (int i = 0; i < _count; ++i) {
        int fundId = [[fundArray objectAtIndex:i]intValue];
        if (i == 0) {
            fundDetailInfoRequst1 = [self getFundDetailInfoData:fundId];
        }
        if (i == 1) {
            fundDetailInfoRequst2 = [self getFundDetailInfoData:fundId];
        }
        if (i == 2) {
            fundDetailInfoRequst3 = [self getFundDetailInfoData:fundId];
        }
        if (i == 3) {
            fundDetailInfoRequst4 = [self getFundDetailInfoData:fundId];
        }
        if (i == 4) {
            fundDetailInfoRequst5 = [self getFundDetailInfoData:fundId];
        }
    }
    for (int i = 0; i < _count; ++i) {
        int fundId = [[fundArray objectAtIndex:i]intValue];
        if (i == 0) {
            fundGradeRequest1 = [self getFundGradeData:fundId];
        }
        if (i == 1) {
            fundGradeRequest2 = [self getFundGradeData:fundId];
        }
        if (i == 2) {
            fundGradeRequest3 = [self getFundGradeData:fundId];
        }
        if (i == 3) {
            fundGradeRequest4 = [self getFundGradeData:fundId];
        }
        if (i == 4) {
            fundGradeRequest5 = [self getFundGradeData:fundId];
        }
    }
    for (int i = 0; i < _count; ++i) {
        int fundId = [[fundArray objectAtIndex:i]intValue];
        if (i == 0) {
            fundDetailPercentRequest1 = [self getFundDetailPercentData:fundId];
        }
        if (i == 1) {
            fundDetailPercentRequest2 = [self getFundDetailPercentData:fundId];
        }
        if (i == 2) {
            fundDetailPercentRequest3 = [self getFundDetailPercentData:fundId];
        }
        if (i == 3) {
            fundDetailPercentRequest4 = [self getFundDetailPercentData:fundId];
        }
        if (i == 4) {
            fundDetailPercentRequest5 = [self getFundDetailPercentData:fundId];
        }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) getFundDetailInfoRequestSuccess:(FundDetailInfoRequst *)fundDetailInfoRequst
{
	BOOL isRequestSuccess = [fundDetailInfoRequst isRequestSuccess];
    if (isRequestSuccess) {
        FundDetailInfoData * fundDetailInfoData = [fundDetailInfoRequst getData];
        int col = [self getCellColumn:fundDetailInfoData.code];
        if (col == 0) {
            col = 111;
        }
        [self setViewCellLabelByTag:view2 row:5 column:col text:[NSString stringWithFormat:@"%.02f亿", fundDetailInfoData.size/100000000.0f]];
        [self setViewCellLabelByTag:view2 row:6 column:col text:fundDetailInfoData.estb_date];
        [self setViewCellLabelByTag:view2 row:7 column:col text:fundDetailInfoData.corp];
        [self setViewCellLabelByTag:view2 row:8 column:col text:fundDetailInfoData.corp];
        
        NSString * manager = nil;
        NSRange range = [fundDetailInfoData.manager rangeOfString:@"、"];
        if (range.location != NSNotFound) {
            manager = [fundDetailInfoData.manager substringToIndex:range.location];
        }
        else {
            manager = fundDetailInfoData.manager;
        }
        NSString * strTake_date = @"";
        NSString * strRr_date = @"";
        if ([dbBase open]) {
            NSString *sqlManagerQuery = [NSString stringWithFormat:@"SELECT * FROM FUNDMANAGERRANK WHERE %@ = '%@'", @"name", manager ];
            FMResultSet * rs = [dbBase executeQuery:sqlManagerQuery];
            while ([rs next]) {
                strTake_date = [rs stringForColumn:@"take_date"];
                strRr_date = [rs stringForColumn:@"rr_sdate"];
            }
            
            
            [dbBase close];
        }
        [self setViewCellLabelByTag:view5 row:111 column:col text:manager];
        [self setViewCellLabelByTag:view5 row:1 column:col text:strTake_date];
        [self setViewCellLabelByTag:view5 row:2 column:col text:strRr_date];
        
        [self setViewCellLabelByTag:view6 row:111 column:col text:[NSString stringWithFormat:@"%d", fundDetailInfoData.manage_rate]];
        [self setViewCellLabelByTag:view6 row:1 column:col text:[NSString stringWithFormat:@"%d", fundDetailInfoData.custodian_rate]];
        [self setViewCellLabelByTag:view6 row:2 column:col text:[NSString stringWithFormat:@"%d", fundDetailInfoData.redeem_rate_max]];
        [self setViewCellLabelByTag:view6 row:3 column:col text:[NSString stringWithFormat:@"%d", fundDetailInfoData.pur_rate_max]];
        [self setViewCellLabelByTag:view6 row:4 column:col text:[NSString stringWithFormat:@"%d", fundDetailInfoData.sub_rate_max]];
    }
    else {
    }
}

- (void) getFundDetailInfoRequestFailed:(FundDetailInfoRequst *)request
{
}

- (FundDetailInfoRequst *)getFundDetailInfoData:(NSInteger)fundCode
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
    NSString* fundCodeStr = [NSString stringWithFormat:@"%06d",fundCode];
    [array addObject:[NSString stringWithFormat:@"%@=%@", @"code", fundCodeStr]];
    NSString * md5Result = [_UI md5EncParam:array];
    url = [url stringByAppendingString:md5Result];
    url = [url URLEncodedString];
    FundDetailInfoRequst * fundDetailInfoRequst = [[FundDetailInfoRequst alloc]initWithUrl:url];
    
	fundDetailInfoRequst.delegate = self;
    fundDetailInfoRequst.requestDidFinishSelector = @selector(getFundDetailInfoRequestSuccess:);
    fundDetailInfoRequst.requestDidFailedSelector = @selector(getFundDetailInfoRequestFailed:);
    
    [fundDetailInfoRequst sendRequest];
    return fundDetailInfoRequst;
}


- (void) getFundDetailPercentRequestSuccess:(FundDetailPercentRequest *)fundDetailPercentRequest
{
	BOOL isRequestSuccess = [fundDetailPercentRequest isRequestSuccess];
    if (isRequestSuccess) {
        FundDetailPercentData * fundDetailPercentData = [fundDetailPercentRequest getData];
        int col = [self getCellColumn:fundDetailPercentData.code];
        if (col == 0) {
            col = 111;
        }
        [self setViewCellLabelByTag:view7 row:111 column:col text:[NSString stringWithFormat:@"%.02f", fundDetailPercentData.stock_ratio]];
        [self setViewCellLabelByTag:view7 row:1 column:col text:[NSString stringWithFormat:@"%.02f", fundDetailPercentData.bond_ratio]];
        [self setViewCellLabelByTag:view7 row:2 column:col text:[NSString stringWithFormat:@"%.02f", fundDetailPercentData.warrant_ratio]];
        [self setViewCellLabelByTag:view7 row:3 column:col text:[NSString stringWithFormat:@"%.02f", fundDetailPercentData.money_ratio]];
        [self setViewCellLabelByTag:view7 row:4 column:col text:[NSString stringWithFormat:@"%.02f", fundDetailPercentData.other_ratio]];
    }
    else {
    }
}

- (void) getFundDetailPercentRequestFailed:(FundDetailPercentRequest *)request
{
    
}

- (FundDetailPercentRequest *)getFundDetailPercentData:(NSInteger)fundCode
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
    NSString* fundCodeStr = [NSString stringWithFormat:@"%06d",fundCode];
    [array addObject:[NSString stringWithFormat:@"%@=%@", @"code", fundCodeStr]];
    NSString * md5Result = [_UI md5EncParam:array];
    url = [url stringByAppendingString:md5Result];
    url = [url URLEncodedString];
    FundDetailPercentRequest * fundDetailPercentRequest = [[FundDetailPercentRequest alloc]initWithUrl:url];
    
	fundDetailPercentRequest.delegate = self;
    fundDetailPercentRequest.requestDidFinishSelector = @selector(getFundDetailPercentRequestSuccess:);
    fundDetailPercentRequest.requestDidFailedSelector = @selector(getFundDetailPercentRequestFailed:);
    
    [fundDetailPercentRequest sendRequest];
    return fundDetailPercentRequest;
}


- (void) getFundGradeRequestSuccess:(FundGradeRequest *)fundGradeRequest
{
	BOOL isRequestSuccess = [fundGradeRequest isRequestSuccess];
    if (isRequestSuccess) {
        FundGradeData * fundGradeData = [fundGradeRequest getData];
        int col = [self getCellColumn:fundGradeData.code];
        if (col == 0) {
            col = 111;
        }
        [self setViewCellGradeByTag:view3 row:111 column:col grade:fundGradeData.grade];
        NSString * risk_ss_rank = nil;
        NSString * profit_rank = nil;
        switch (fundGradeData.risk_ss_rank) {
            case 1:
                risk_ss_rank = @"低";
                break;
            case 2:
                risk_ss_rank = @"较低";
                break;
            case 3:
                risk_ss_rank = @"中等";
                break;
            case 4:
                risk_ss_rank = @"较高";
                break;
            case 5:
                risk_ss_rank = @"高";
                break;
                
            default:
                risk_ss_rank = @"低";
                break;
        }
        switch (fundGradeData.profit_rank) {
            case 1:
                profit_rank = @"低";
                break;
            case 2:
                profit_rank = @"较低";
                break;
            case 3:
                profit_rank = @"中等";
                break;
            case 4:
                profit_rank = @"较高";
                break;
            case 5:
                profit_rank = @"高";
                break;
                
            default:
                profit_rank = @"低";
                break;
        }
        [self setViewCellLabelByTag:view3 row:1 column:col text:risk_ss_rank];
        [self setViewCellLabelByTag:view3 row:2 column:col text:profit_rank];
    }
    else {
    }
}

- (void) getFundGradeRequestFailed:(FundGradeRequest *)request
{
    
}

- (FundGradeRequest *)getFundGradeData:(NSInteger)fundCode
{
    NSString * url = [NSString stringWithFormat:@"%@%@", HOST_NAME, FUND_GRADE];
    NSMutableArray * array = [[NSMutableArray alloc]initWithCapacity:0];
    [array addObject:[NSString stringWithFormat:@"%@=%@", OPENID, OPENID_VALUE]];
    [array addObject:[NSString stringWithFormat:@"%@=%@", TYPE, DATA_FORMAT]];
    if (_UI.isLogin) {
        [array addObject:[NSString stringWithFormat:@"%@=%@", @"user_name", _UI.userName]];
        [array addObject:[NSString stringWithFormat:@"%@=%@", @"access_token", _UI.loginToken]];
    }
    //    [array addObject:[NSString stringWithFormat:@"%@=%@", @"page_no", @"1"]];
    //    [array addObject:[NSString stringWithFormat:@"%@=%@", @"page_size", @"2"]];
    NSString* fundCodeStr = [NSString stringWithFormat:@"%06d",fundCode];
    [array addObject:[NSString stringWithFormat:@"%@=%@", @"code", fundCodeStr]];
    
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit fromDate:[NSDate date]];
    NSInteger day = [components day];
    NSInteger month= [components month];
    NSInteger year = [components year];
    NSString* endDate = [NSString stringWithFormat:@"%04d%02d%02d",year,month,day];
    
    components = [[NSCalendar currentCalendar] components:NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit fromDate:[[NSDate date] dateByAddingTimeInterval:(-3*30.f*24.0f*3600.f)]];
    day = [components day];
    month= [components month];
    year = [components year];
    NSString* startDate = [NSString stringWithFormat:@"%04d%02d%02d",year,month,day];
    
    [array addObject:[NSString stringWithFormat:@"%@=%@", @"startDate", startDate]];
    [array addObject:[NSString stringWithFormat:@"%@=%@", @"endDate", endDate]];
    
    
    NSString * md5Result = [_UI md5EncParam:array];
    url = [url stringByAppendingString:md5Result];
    url = [url URLEncodedString];
    FundGradeRequest * fundGradeRequest = [[FundGradeRequest alloc]initWithUrl:url];
    
	fundGradeRequest.delegate = self;
    fundGradeRequest.requestDidFinishSelector = @selector(getFundGradeRequestSuccess:);
    fundGradeRequest.requestDidFailedSelector = @selector(getFundGradeRequestFailed:);
    
    [fundGradeRequest sendRequest];
    return fundGradeRequest;
}

- (void) getFundHistoryRequestSuccess:(FundHistoryRequest *)request
{
	BOOL isRequestSuccess = [request isRequestSuccess];
    if (isRequestSuccess) {
        
        NSMutableArray* arr = [[NSMutableArray alloc]init];
        
        for (int i = 0; i < fundArray.count; ++i) {
            NSInteger code  = [[fundArray objectAtIndex:i]intValue];
            if (code == [request getCode]) {
                fundHistoryData1 = [request getDataArray];
                
                int offset = fundHistoryData1.count - 60;
                for (int x = 0; x < 60; ++x) {
                    if (offset + x < 0) {
                        NSString *xp = [NSString stringWithFormat:@"%d",x];
                        NSString *yp = [NSString stringWithFormat:@"%d",0];
                        NSMutableDictionary *point1 = [[NSMutableDictionary alloc] initWithObjectsAndKeys:xp, @"x", yp, @"y", nil];
                        [dataForPlot1 insertObject:point1 atIndex:x];
                        continue;
                    }
                    FundHistoryData * data = [fundHistoryData1 objectAtIndex:x+offset];
                    //添加数
                    //            if ([dataSourceLinePlot.identifier isEqual:@"Green Plot"])
                    {
                        NSString *xp = [NSString stringWithFormat:@"%d",x];
                        NSString *yp = [NSString stringWithFormat:@"%d",[data.net_value intValue]];
                        NSMutableDictionary *point1 = [[NSMutableDictionary alloc] initWithObjectsAndKeys:xp, @"x", yp, @"y", nil];
                        [dataForPlot1 insertObject:point1 atIndex:x];
                        [arr addObject:[NSString stringWithFormat:@"%d", [data.net_value intValue]]];
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
                
                for (int j = 0; j < dataForPlot1.count; ++j) {
                    NSDictionary * dic = [dataForPlot1 objectAtIndex:j];
                    CGPoint point = CGPointMake([[dic objectForKey:@"x"]floatValue], [[dic objectForKey:@"y"]floatValue]);
                    NSLog(@"point : %f,%f",point.x,point.y);
                    
                }
                [self buildView1];
                //            [leftSecondGram1 addSubview:gram1];
            }
            //        else if (BOND_TYPE == [request getCode]) {
            //            fundHistoryData2 = [request getDataArray];
            //
            //            int offset = fundHistoryData2.count - 60;
            //            for (int x = 0; x < 60; ++x) {
            //                if (offset + x < 0) {
            //                    NSString *xp = [NSString stringWithFormat:@"%d",x];
            //                    NSString *yp = [NSString stringWithFormat:@"%d",0];
            //                    NSMutableDictionary *point1 = [[NSMutableDictionary alloc] initWithObjectsAndKeys:xp, @"x", yp, @"y", nil];
            //                    [dataForPlot2 insertObject:point1 atIndex:x];
            //                    NSLog(@"*********** %@,%@",xp, yp);
            //                    continue;
            //                }
            //                FundHistoryData * data = [fundHistoryData1 objectAtIndex:x+offset];
            //                //添加数
            //                //            if ([dataSourceLinePlot.identifier isEqual:@"Green Plot"])
            //                {
            //                    NSString *xp = [NSString stringWithFormat:@"%d",x];
            //                    NSString *yp = [NSString stringWithFormat:@"%d",[data.net_value intValue]];
            //                    NSMutableDictionary *point1 = [[NSMutableDictionary alloc] initWithObjectsAndKeys:xp, @"x", yp, @"y", nil];
            //                    [dataForPlot2 insertObject:point1 atIndex:x];
            //                    [arr addObject:[NSString stringWithFormat:@"%d", [data.net_value intValue]]];
            //                    NSLog(@"*********** %@,%@",xp, yp);
            //                }
            //            }
            //
            //            // 升序
            //            [arr sortUsingComparator:^NSComparisonResult(__strong id obj1,__strong id obj2){
            //                NSString *str1=(NSString *)obj1;
            //                NSString *str2=(NSString *)obj2;
            //                return [str1 compare:str2];
            //            }];
            //            fundHistoryMax2 = [[arr objectAtIndex:arr.count-1]intValue];
            //            fundHistoryMin2 = [[arr objectAtIndex:0]intValue];
            //            NSLog(@"*********** %d,%d",fundHistoryMax2, fundHistoryMin2);
            //            UIView * gram2 = [self buildView2];
            //            [leftSecondGram2 addSubview:gram2];
            //        }
            //        else if (GROUP_TYPE == [request getCode]) {
            //            fundHistoryData3 = [request getDataArray];
            //
            //            int offset = fundHistoryData3.count - 60;
            //            for (int x = 0; x < 60; ++x) {
            //                if (offset + x < 0) {
            //                    NSString *xp = [NSString stringWithFormat:@"%d",x];
            //                    NSString *yp = [NSString stringWithFormat:@"%d",0];
            //                    NSMutableDictionary *point1 = [[NSMutableDictionary alloc] initWithObjectsAndKeys:xp, @"x", yp, @"y", nil];
            //                    [dataForPlot3 insertObject:point1 atIndex:x];
            //                    NSLog(@"*********** %@,%@",xp, yp);
            //                    continue;
            //                }
            //                FundHistoryData * data = [fundHistoryData3 objectAtIndex:x+offset];
            //                //添加数
            //                //            if ([dataSourceLinePlot.identifier isEqual:@"Green Plot"])
            //                {
            //                    NSString *xp = [NSString stringWithFormat:@"%d",x];
            //                    NSString *yp = [NSString stringWithFormat:@"%d",[data.net_value intValue]];
            //                    NSMutableDictionary *point1 = [[NSMutableDictionary alloc] initWithObjectsAndKeys:xp, @"x", yp, @"y", nil];
            //                    [dataForPlot3 insertObject:point1 atIndex:x];
            //                    [arr addObject:[NSString stringWithFormat:@"%d", [data.net_value intValue]]];
            //                    NSLog(@"*********** %@,%@",xp, yp);
            //                }
            //            }
            //            
            //            // 升序
            //            [arr sortUsingComparator:^NSComparisonResult(__strong id obj1,__strong id obj2){
            //                NSString *str1=(NSString *)obj1;
            //                NSString *str2=(NSString *)obj2;
            //                return [str1 compare:str2];
            //            }];
            //            fundHistoryMax3 = [[arr objectAtIndex:arr.count-1]intValue];
            //            fundHistoryMin3 = [[arr objectAtIndex:0]intValue];
            //            NSLog(@"*********** %d,%d",fundHistoryMax3, fundHistoryMin3);
            //            UIView * gram3 = [self buildView3];
            //            [leftSecondGram3 addSubview:gram3];
            //        }
        }
        
    }
    else {
        fundHistoryMax = 100;
        fundHistoryMin = 0;
    }
}

- (void) getFundHistoryRequestFailed:(FundHistoryRequest *)request
{
    
}

- (FundHistoryRequest *)getFundHistoryData:(NSInteger)code
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
    NSString* fundCodeStr = [NSString stringWithFormat:@"%06d",code];
    [array addObject:[NSString stringWithFormat:@"%@=%@", @"code", fundCodeStr]];
    
    
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
    NSString * md5Result = [_UI md5EncParam:array];
    url = [url stringByAppendingString:md5Result];
    url = [url URLEncodedString];
    FundHistoryRequest * fundHistoryRequest = [[FundHistoryRequest alloc]initWithUrl:url];
    
	fundHistoryRequest.delegate = self;
    fundHistoryRequest.requestDidFinishSelector = @selector(getFundHistoryRequestSuccess:);
    fundHistoryRequest.requestDidFailedSelector = @selector(getFundHistoryRequestFailed:);
    
    [fundHistoryRequest sendRequest];
    return fundHistoryRequest;
}

@end
