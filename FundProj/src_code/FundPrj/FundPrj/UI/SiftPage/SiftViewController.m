//
//  SiftViewController.m
//  FundPrj
//
//  Created by leesea on 13-11-4.
//  Copyright (c) 2013年 leesea. All rights reserved.
//

#import "SiftViewController.h"
#import "IntelSiftViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "SiftResultViewController.h"
#import "FundCompanyRequest.h"
#import "FundCompanyData.h"

@interface SiftViewController ()
{
    UIButton * datePickerBtn;
    UIDatePicker * datePicker;
    UIView * datePickerView;
    
	NSArray *fundEntries;
	NSMutableDictionary *fundSelectionStates;
	ALPickerView *fundPicker;
    UIButton * fundPickerBtn;
    UIView * fundPickerView;
    
	NSArray *investmentEntries;
	NSMutableDictionary *investmentSelectionStates;
	ALPickerView *investmentPicker;
    UIButton * investmentPickerBtn;
    UIView * investmentPickerView;
    
	NSArray *gradeEntries;
	NSMutableDictionary *gradeSelectionStates;
	ALPickerView *gradePicker;
    UIButton * gradePickerBtn;
    UIView * gradePickerView;
    
	NSArray *repayEntries;
	NSMutableDictionary *repaySelectionStates;
	ALPickerView *repayPicker;
    UIButton * repayPickerBtn;
    UIView * repayPickerView;
    
	NSMutableArray *companyEntries;
	NSMutableDictionary *companySelectionStates;
	ALPickerView *companyPicker;
    UIButton * companyPickerBtn;
    UIView * companyPickerView;
    
	NSArray *statEntries;
	NSMutableDictionary *statSelectionStates;
	ALPickerView *statPicker;
    UIButton * statPickerBtn;
    UIView * statPickerView;
    
    NSString * fundType;
    NSString * investType;
    NSString * estbData;
    NSInteger status;
    NSInteger grade;
    NSInteger rr_this_year;
    NSInteger fund_corp;
    
    FundCompanyRequest * fundCompanyRequest;
    NSMutableArray * fundCompanyArray;
}

@end

@implementation SiftViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        fundType = nil;
        investType = nil;
        estbData = nil;
        status = -1;
        grade = -1;
        rr_this_year = -1;
        fund_corp = -1;
        
        companyEntries = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return self;
}

- (void)siftBtnClick:(id)sender
{
    IntelSiftViewController * intelSiftCtrl = [[IntelSiftViewController alloc]init];
    [self.navigationController pushViewController:intelSiftCtrl animated:YES];
}

- (void) dateValueChanged:(UIDatePicker *)sender
{
    //    datePicker = (UIDatePicker *)sender;
    //    NSDate *date_one = datePicker.date;
    //    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    //    [formatter setDateFormat:@"yyyy-MM-dd"];
    //    datePickerBtn.titleLabel.text = [formatter stringFromDate:date_one];
}

- (void)fundOkBtnPress:(id)sender
{
    BOOL flag = YES;
    NSString * str = @"";
	for (int i = 0; i < fundEntries.count; ++i)
    {
        if ([self pickerView:fundPicker selectionStateForRow:i]) {
            if (fundType == nil) {
                fundType = @"";
            }
            str = [str stringByAppendingFormat:@"%@ ", [fundEntries objectAtIndex:i]];
            if (i == 0) {
                fundType = [fundType stringByAppendingString:@"A"];
            }
            if (i == 1) {
                fundType = [fundType stringByAppendingString:@"B"];
            }
            if (i == 2) {
                fundType = [fundType stringByAppendingString:@"C"];
            }
            if (i == 3) {
                fundType = [fundType stringByAppendingString:@"D"];
            }
            if (i == 4) {
                fundType = [fundType stringByAppendingString:@"E"];
            }
            if (i == 5) {
                fundType = [fundType stringByAppendingString:@"F"];
            }
            if (i == 6) {
                fundType = [fundType stringByAppendingString:@"E"];
            }
        }
        else {
            flag = NO;
        }
    }
    if (flag) {
        [fundPickerBtn setTitle:@"不限" forState:UIControlStateNormal];
        fundType = nil;
    }
    else {
        [fundPickerBtn setTitle:str forState:UIControlStateNormal];
    }
    [fundPickerView removeFromSuperview];
    fundPickerView = nil;
}

- (void)fundPickBtnPress:(id)sender
{
    fundPickerView = [[UIView alloc]initWithFrame:CGRectMake(270, 40+52, 472, 268)];
    fundPickerView.backgroundColor = [UIColor lightGrayColor];
    UIView * headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 472, 50)];
    headerView.backgroundColor = [UIColor grayColor];
    [fundPickerView addSubview:headerView];
    UIButton * okBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    okBtn.frame = CGRectMake(370, 7, 80, 36);
    [okBtn setBackgroundColor:[UIColor darkGrayColor]];
    [okBtn setTitle:@"完成" forState:UIControlStateNormal];
    [okBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [okBtn addTarget:self action:@selector(fundOkBtnPress:) forControlEvents:UIControlEventTouchUpInside];
    UILabel * label = okBtn.titleLabel;
    label.font = [UIFont boldSystemFontOfSize:24];
    [headerView addSubview:okBtn];
    
	// Create some sample data
	fundEntries = [[NSArray alloc] initWithObjects:@"开放式", @"封闭式", @"ETF", @"LOF", @"QDII", @"ETF联接基金", nil];
	fundSelectionStates = [[NSMutableDictionary alloc] init];
	for (NSString *key in fundEntries)
		[fundSelectionStates setObject:[NSNumber numberWithBool:NO] forKey:key];
	
	// Init picker and add it to view
	fundPicker = [[ALPickerView alloc] initWithFrame:CGRectMake(80,50,300,150) allStr:@"不限"];
//    fundPicker.allStr = ;
	fundPicker.delegate = self;
	[fundPickerView addSubview:fundPicker];
    
    [self.view addSubview:fundPickerView];
}

- (void)investmentOkBtnPress:(id)sender
{
    BOOL flag = YES;
    NSString * str = @"";
	for (int i = 0; i < investmentEntries.count; ++i)
    {
        if ([self pickerView:investmentPicker selectionStateForRow:i]) {
            if (investType == nil) {
                fundType = @"";
            }
            str = [str stringByAppendingFormat:@"%@ ", [investmentEntries objectAtIndex:i]];
            if (i == 0) {
                investType = [investType stringByAppendingString:@"A"];
            }
            if (i == 1) {
                investType = [investType stringByAppendingString:@"B"];
            }
            if (i == 2) {
                investType = [investType stringByAppendingString:@"C"];
            }
            if (i == 3) {
                investType = [investType stringByAppendingString:@"D"];
            }
            if (i == 4) {
                investType = [investType stringByAppendingString:@"E"];
            }
            if (i == 5) {
                investType = [investType stringByAppendingString:@"F"];
            }
            if (i == 6) {
                investType = [investType stringByAppendingString:@"G"];
            }
            if (i == 7) {
                investType = [investType stringByAppendingString:@"H"];
            }
            if (i == 8) {
                investType = [investType stringByAppendingString:@"I"];
            }
            if (i == 9) {
                investType = [investType stringByAppendingString:@"J"];
            }
            if (i == 10) {
                investType = [investType stringByAppendingString:@"K"];
            }
            if (i == 11) {
                investType = [investType stringByAppendingString:@"L"];
            }
            if (i == 12) {
                investType = [investType stringByAppendingString:@"M"];
            }
            if (i == 13) {
                investType = [investType stringByAppendingString:@"N"];
            }
            if (i == 14) {
                investType = [investType stringByAppendingString:@"O"];
            }
        }
        else {
            flag = NO;
        }
    }
    if (flag) {
        [investmentPickerBtn setTitle:@"不限" forState:UIControlStateNormal];
        investType = nil;
    }
    else {
        [investmentPickerBtn setTitle:str forState:UIControlStateNormal];
    }
    [investmentPickerView removeFromSuperview];
    investmentPickerView = nil;
}

- (void)investmentPickBtnPress:(id)sender
{
    investmentPickerView = [[UIView alloc]initWithFrame:CGRectMake(270, 40+52*2, 472, 268)];
    investmentPickerView.backgroundColor = [UIColor lightGrayColor];
    UIView * headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 472, 50)];
    headerView.backgroundColor = [UIColor grayColor];
    [investmentPickerView addSubview:headerView];
    UIButton * okBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    okBtn.frame = CGRectMake(370, 7, 80, 36);
    [okBtn setBackgroundColor:[UIColor darkGrayColor]];
    [okBtn setTitle:@"完成" forState:UIControlStateNormal];
    [okBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [okBtn addTarget:self action:@selector(investmentOkBtnPress:) forControlEvents:UIControlEventTouchUpInside];
    UILabel * label = okBtn.titleLabel;
    label.font = [UIFont boldSystemFontOfSize:24];
    [headerView addSubview:okBtn];
    
	// Create some sample data
	investmentEntries = [[NSArray alloc] initWithObjects:@"股票型", @"普通债券型", @"激进债券", @"纯债基金", @"普通混合型", @"保守混合型", @"激进混合型", @"货币型", @"短债基金", @"FOF", @"保本基金", @"普通型指数基金", @"增强型指数基金", @"分级基金", @"其他", nil];
	investmentSelectionStates = [[NSMutableDictionary alloc] init];
	for (NSString *key in investmentEntries)
		[investmentSelectionStates setObject:[NSNumber numberWithBool:NO] forKey:key];
	
	// Init picker and add it to view
	investmentPicker = [[ALPickerView alloc] initWithFrame:CGRectMake(80,50,300,150) allStr:@"不限"];
	investmentPicker.delegate = self;
	[investmentPickerView addSubview:investmentPicker];
    
    [self.view addSubview:investmentPickerView];
}

- (void)gradeOkBtnPress:(id)sender
{
    BOOL flag = YES;
    NSString * str = @"";
	for (int i = 0; i < gradeEntries.count; ++i)
    {
        if ([self pickerView:gradePicker selectionStateForRow:i]) {
            str = [str stringByAppendingFormat:@"%@ ", [gradeEntries objectAtIndex:i]];
            if (i == 0) {
                grade = 5;
            }
            if (i == 1) {
                grade = 4;
            }
            if (i == 2) {
                grade = 3;
            }
            if (i == 3) {
                grade = 2;
            }
            if (i == 4) {
                grade = 1;
            }
            if (i == 5) {
                grade = 0;
            }
        }
        else {
            flag = NO;
        }
    }
    if (flag) {
        [gradePickerBtn setTitle:@"不限" forState:UIControlStateNormal];
    }
    else {
        [gradePickerBtn setTitle:str forState:UIControlStateNormal];
    }
    [gradePickerView removeFromSuperview];
    gradePickerView = nil;
}

- (void)gradePickBtnPress:(id)sender
{
    gradePickerView = [[UIView alloc]initWithFrame:CGRectMake(270, 40+52*3, 472, 268)];
    gradePickerView.backgroundColor = [UIColor lightGrayColor];
    UIView * headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 472, 50)];
    headerView.backgroundColor = [UIColor grayColor];
    [gradePickerView addSubview:headerView];
    UIButton * okBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    okBtn.frame = CGRectMake(370, 7, 80, 36);
    [okBtn setBackgroundColor:[UIColor darkGrayColor]];
    [okBtn setTitle:@"完成" forState:UIControlStateNormal];
    [okBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [okBtn addTarget:self action:@selector(gradeOkBtnPress:) forControlEvents:UIControlEventTouchUpInside];
    UILabel * label = okBtn.titleLabel;
    label.font = [UIFont boldSystemFontOfSize:24];
    [headerView addSubview:okBtn];
    
	// Create some sample data
	gradeEntries = [[NSArray alloc] initWithObjects:@"五星", @"四星", @"三星", @"二星", @"一星", @"未评级", nil];
	gradeSelectionStates = [[NSMutableDictionary alloc] init];
	for (NSString *key in gradeEntries)
		[gradeSelectionStates setObject:[NSNumber numberWithBool:NO] forKey:key];
	
	// Init picker and add it to view
	gradePicker = [[ALPickerView alloc] initWithFrame:CGRectMake(80,50,300,150) allStr:@"不限"];
	gradePicker.delegate = self;
	[gradePickerView addSubview:gradePicker];
    
    [self.view addSubview:gradePickerView];
}

- (void)repayOkBtnPress:(id)sender
{
    BOOL flag = YES;
    NSString * str = @"";
	for (int i = 0; i < repayEntries.count; ++i)
    {
        if ([self pickerView:repayPicker selectionStateForRow:i]) {
            str = [str stringByAppendingFormat:@"%@ ", [repayEntries objectAtIndex:i]];
            rr_this_year = i+1;
        }
        else {
            flag = NO;
        }
    }
    if (flag) {
        [repayPickerBtn setTitle:@"不限" forState:UIControlStateNormal];
        rr_this_year = -1;
    }
    else {
        [repayPickerBtn setTitle:str forState:UIControlStateNormal];
    }
    [repayPickerView removeFromSuperview];
    repayPickerView = nil;
}

- (void)repayPickBtnPress:(id)sender
{
    repayPickerView = [[UIView alloc]initWithFrame:CGRectMake(270, 40+52*4, 472, 268)];
    repayPickerView.backgroundColor = [UIColor lightGrayColor];
    UIView * headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 472, 50)];
    headerView.backgroundColor = [UIColor grayColor];
    [repayPickerView addSubview:headerView];
    UIButton * okBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    okBtn.frame = CGRectMake(370, 7, 80, 36);
    [okBtn setBackgroundColor:[UIColor darkGrayColor]];
    [okBtn setTitle:@"完成" forState:UIControlStateNormal];
    [okBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [okBtn addTarget:self action:@selector(repayOkBtnPress:) forControlEvents:UIControlEventTouchUpInside];
    UILabel * label = okBtn.titleLabel;
    label.font = [UIFont boldSystemFontOfSize:24];
    [headerView addSubview:okBtn];
    
	// Create some sample data
	repayEntries = [[NSArray alloc] initWithObjects:@"大于30%", @"大于20%", @"大于10%", @"前1/4", @"前1/3", @"跑赢沪深300", nil];
	repaySelectionStates = [[NSMutableDictionary alloc] init];
	for (NSString *key in repayEntries)
		[repaySelectionStates setObject:[NSNumber numberWithBool:NO] forKey:key];
	
	// Init picker and add it to view
	repayPicker = [[ALPickerView alloc] initWithFrame:CGRectMake(80,50,300,150) allStr:@"不限"];
	repayPicker.delegate = self;
	[repayPickerView addSubview:repayPicker];
    
    [self.view addSubview:repayPickerView];
}

- (void)dateOkBtnPress:(id)sender
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    datePickerBtn.titleLabel.text = [formatter stringFromDate:datePicker.date];
    [datePickerView removeFromSuperview];
    datePickerView = nil;
    estbData = [NSString stringWithFormat:@">=%@", [formatter stringFromDate:datePicker.date]];
}

- (void)datePickBtnPress:(id)sender
{
    datePickerView = [[UIView alloc]initWithFrame:CGRectMake(270, 268+50, 472, 268)];
    datePickerView.backgroundColor = [UIColor lightGrayColor];
    UIView * headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 472, 50)];
    headerView.backgroundColor = [UIColor grayColor];
    [datePickerView addSubview:headerView];
    UIButton * okBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    okBtn.frame = CGRectMake(370, 7, 80, 36);
    [okBtn setBackgroundColor:[UIColor darkGrayColor]];
    [okBtn setTitle:@"完成" forState:UIControlStateNormal];
    [okBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [okBtn addTarget:self action:@selector(dateOkBtnPress:) forControlEvents:UIControlEventTouchUpInside];
    UILabel * label = okBtn.titleLabel;
    label.font = [UIFont boldSystemFontOfSize:24];
    [headerView addSubview:okBtn];
    
    datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(80,50,300,150)];
    datePicker.datePickerMode = UIDatePickerModeDate;
    //定义最小日期
    NSDateFormatter *formatter_minDate = [[NSDateFormatter alloc] init];
    [formatter_minDate setDateFormat:@"yyyy-MM-dd"];
    NSDate *minDate = [formatter_minDate dateFromString:@"1900-01-01"];
    formatter_minDate = nil;
    //最大日期是今天
    NSDate *maxDate = [NSDate date];
    
    [datePicker setMinimumDate:minDate];
    [datePicker setMaximumDate:maxDate];
    [datePickerView addSubview:datePicker];
    [datePicker addTarget:(self) action:(@selector(dateValueChanged:)) forControlEvents:UIControlEventValueChanged];
    
    //    NSDate * dateShow = [formatter_minDate dateFromString:datePickerBtn.titleLabel.text];
    //    [datePicker setDate:dateShow];
    
    [self.view addSubview:datePickerView];
}

- (void)companyOkBtnPress:(id)sender
{
    BOOL flag = YES;
    NSString * str = @"";
	for (int i = 0; i < companyEntries.count; ++i)
    {
        if ([self pickerView:companyPicker selectionStateForRow:i]) {
            for (int j = 0; j < fundCompanyArray.count; ++j) {
                FundCompanyData * data = [fundCompanyArray objectAtIndex:j];
                if ([data.corp_name isEqualToString:(NSString *)[companyEntries objectAtIndex:i]]) {
                    fund_corp = data.corp_id;
                    str = data.corp_name;
                }
            }
        }
        else {
            flag = NO;
        }
    }
    if (flag) {
        [companyPickerBtn setTitle:@"全部" forState:UIControlStateNormal];
        fund_corp = -1;//to do
    }
    else {
        [companyPickerBtn setTitle:str forState:UIControlStateNormal];
    }
    [companyPickerView removeFromSuperview];
    companyPickerView = nil;
}

- (void)companyPickBtnPress:(id)sender
{
    companyPickerView = [[UIView alloc]initWithFrame:CGRectMake(270, 340+50, 472, 268)];
    companyPickerView.backgroundColor = [UIColor lightGrayColor];
    UIView * headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 472, 50)];
    headerView.backgroundColor = [UIColor grayColor];
    [companyPickerView addSubview:headerView];
    UIButton * okBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    okBtn.frame = CGRectMake(370, 7, 80, 36);
    [okBtn setBackgroundColor:[UIColor darkGrayColor]];
    [okBtn setTitle:@"完成" forState:UIControlStateNormal];
    [okBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [okBtn addTarget:self action:@selector(companyOkBtnPress:) forControlEvents:UIControlEventTouchUpInside];
    UILabel * label = okBtn.titleLabel;
    label.font = [UIFont boldSystemFontOfSize:24];
    [headerView addSubview:okBtn];
    
	// Create some sample data
	companySelectionStates = [[NSMutableDictionary alloc] init];
	for (NSString *key in companyEntries)
		[companySelectionStates setObject:[NSNumber numberWithBool:NO] forKey:key];
	
	// Init picker and add it to view
	companyPicker = [[ALPickerView alloc] initWithFrame:CGRectMake(80,50,300,150) allStr:@"全部"];
	companyPicker.delegate = self;
	[companyPickerView addSubview:companyPicker];
    
    [self.view addSubview:companyPickerView];
}

- (void)statOkBtnPress:(id)sender
{
    BOOL flag = YES;
    NSString * str = @"";
	for (int i = 0; i < statEntries.count; ++i)
    {
        if ([self pickerView:statPicker selectionStateForRow:i]) {
            str = [str stringByAppendingFormat:@"%@ ", [statEntries objectAtIndex:i]];
            status = i + 1;
        }
        else {
            flag = NO;
        }
    }
    if (flag) {
        [statPickerBtn setTitle:@"不限" forState:UIControlStateNormal];
        status = -1;
    }
    else {
        [statPickerBtn setTitle:str forState:UIControlStateNormal];
    }
    [statPickerView removeFromSuperview];
    statPickerView = nil;
}

- (void)statPickBtnPress:(id)sender
{
    statPickerView = [[UIView alloc]initWithFrame:CGRectMake(270, 412+50, 472, 268)];
    statPickerView.backgroundColor = [UIColor lightGrayColor];
    UIView * headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 472, 50)];
    headerView.backgroundColor = [UIColor grayColor];
    [statPickerView addSubview:headerView];
    UIButton * okBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    okBtn.frame = CGRectMake(370, 7, 80, 36);
    [okBtn setBackgroundColor:[UIColor darkGrayColor]];
    [okBtn setTitle:@"完成" forState:UIControlStateNormal];
    [okBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [okBtn addTarget:self action:@selector(statOkBtnPress:) forControlEvents:UIControlEventTouchUpInside];
    UILabel * label = okBtn.titleLabel;
    label.font = [UIFont boldSystemFontOfSize:24];
    [headerView addSubview:okBtn];
    
	// Create some sample data
	statEntries = [[NSArray alloc] initWithObjects:@"申购开放", @"赎回开放", nil];
	statSelectionStates = [[NSMutableDictionary alloc] init];
	for (NSString *key in statEntries)
		[statSelectionStates setObject:[NSNumber numberWithBool:NO] forKey:key];
	
	// Init picker and add it to view
	statPicker = [[ALPickerView alloc] initWithFrame:CGRectMake(80,50,300,150) allStr:@"不限"];
	statPicker.delegate = self;
	[statPickerView addSubview:statPicker];
    
    [self.view addSubview:statPickerView];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
//    self.extendedLayoutIncludesOpaqueBars = NO;
//    self.edgesForExtendedLayout = UIRectEdgeBottom | UIRectEdgeLeft | UIRectEdgeRight;
    self.view.backgroundColor = [UIColor colorWithHexValue:0xf1f1ee];
    
    UIButton* btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 95, 33)];
    
    [btn setBackgroundImage:[UIImage imageNamed:@"img_07"] forState:UIControlStateNormal];
    //    [btn setImage:[UIImage imageNamed:@"ic_feedback_titlebar"] forState:UIControlStateHighlighted];
    
    [btn setTitle:@"智能筛选" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    UILabel * label = [btn titleLabel];
    label.textColor = [UIColor whiteColor];
    label.textAlignment = UITextAlignmentCenter;
    [label setFont:[UIFont systemFontOfSize:16]];
    
    [btn addTarget:self action:@selector(siftBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
    
    UIView * view1 = [[UIView alloc]initWithFrame:CGRectMake(230, 40, 544, 206)];
    view1.backgroundColor = [UIColor colorWithHexValue:0xf7f7f7];
    //UIView设置边框
    [[view1 layer] setCornerRadius:15];
    [[view1 layer] setBorderWidth:1];
    [[view1 layer] setBorderColor:[UIColor colorWithHexValue:0xbbbbbb].CGColor];
    [self.view addSubview:view1];
    UIView * line1Dark = [[UIView alloc]initWithFrame:CGRectMake(0, 50, 544, 1)];
    line1Dark.backgroundColor = [UIColor colorWithHexValue:0xbbbbbb];
    [view1 addSubview:line1Dark];
    UIView * line1Light = [[UIView alloc]initWithFrame:CGRectMake(0, 51, 544, 1)];
    line1Light.backgroundColor = [UIColor colorWithHexValue:0xf8f9f6];
    [view1 addSubview:line1Light];
    UIView * line2Dark = [[UIView alloc]initWithFrame:CGRectMake(0, 102, 544, 1)];
    line2Dark.backgroundColor = [UIColor colorWithHexValue:0xbbbbbb];
    [view1 addSubview:line2Dark];
    UIView * line2Light = [[UIView alloc]initWithFrame:CGRectMake(0, 103, 544, 1)];
    line2Light.backgroundColor = [UIColor colorWithHexValue:0xf8f9f6];
    [view1 addSubview:line2Light];
    UIView * line3Dark = [[UIView alloc]initWithFrame:CGRectMake(0, 154, 544, 1)];
    line3Dark.backgroundColor = [UIColor colorWithHexValue:0xbbbbbb];
    [view1 addSubview:line3Dark];
    UIView * line3Light = [[UIView alloc]initWithFrame:CGRectMake(0, 155, 544, 1)];
    line3Light.backgroundColor = [UIColor colorWithHexValue:0xf8f9f6];
    [view1 addSubview:line3Light];
    
    UILabel * _fundLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 14, 160, 22)];
    [_fundLabel setTextAlignment:NSTextAlignmentLeft];
    [_fundLabel setTextColor:[UIColor colorWithHexValue:0x4f4f4f]];
    [_fundLabel setFont:[UIFont systemFontOfSize:22]];
    [_fundLabel setBackgroundColor:[UIColor clearColor]];
    _fundLabel.text = @"基金类型";
    [view1 addSubview:_fundLabel];
    UILabel * _typeLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 14+52, 160, 22)];
    [_typeLabel setTextAlignment:NSTextAlignmentLeft];
    [_typeLabel setTextColor:[UIColor colorWithHexValue:0x4f4f4f]];
    [_typeLabel setFont:[UIFont systemFontOfSize:22]];
    [_typeLabel setBackgroundColor:[UIColor clearColor]];
    _typeLabel.text = @"投资类型";
    [view1 addSubview:_typeLabel];
    UILabel * _gradeLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 14+52*2, 160, 22)];
    [_gradeLabel setTextAlignment:NSTextAlignmentLeft];
    [_gradeLabel setTextColor:[UIColor colorWithHexValue:0x4f4f4f]];
    [_gradeLabel setFont:[UIFont systemFontOfSize:22]];
    [_gradeLabel setBackgroundColor:[UIColor clearColor]];
    _gradeLabel.text = @"三年评级";
    [view1 addSubview:_gradeLabel];
    UILabel * _changeLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 14+52*3, 160, 22)];
    [_changeLabel setTextAlignment:NSTextAlignmentLeft];
    [_changeLabel setTextColor:[UIColor colorWithHexValue:0x4f4f4f]];
    [_changeLabel setFont:[UIFont systemFontOfSize:22]];
    [_changeLabel setBackgroundColor:[UIColor clearColor]];
    _changeLabel.text = @"年化";
    [view1 addSubview:_changeLabel];
    
    fundPickerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    fundPickerBtn.frame = CGRectMake(160, 14, 350, 22);
    [fundPickerBtn setBackgroundColor:[UIColor clearColor]];
    [fundPickerBtn setTitleColor:[UIColor colorWithHexValue:0xacacac] forState:UIControlStateNormal];
    [fundPickerBtn addTarget:self action:@selector(fundPickBtnPress:) forControlEvents:UIControlEventTouchUpInside];
    fundPickerBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    UILabel * _fundValueLabel = fundPickerBtn.titleLabel;
    _fundValueLabel.font = [UIFont systemFontOfSize:16];
    [fundPickerBtn setTitle:@"不限" forState:UIControlStateNormal];
    [view1 addSubview:fundPickerBtn];
    investmentPickerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    investmentPickerBtn.frame = CGRectMake(160, 14+52, 350, 22);
    [investmentPickerBtn setBackgroundColor:[UIColor clearColor]];
    [investmentPickerBtn setTitleColor:[UIColor colorWithHexValue:0xacacac] forState:UIControlStateNormal];
    [investmentPickerBtn addTarget:self action:@selector(investmentPickBtnPress:) forControlEvents:UIControlEventTouchUpInside];
    investmentPickerBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    UILabel * _investmentValueLabel = investmentPickerBtn.titleLabel;
    _investmentValueLabel.font = [UIFont systemFontOfSize:16];
    [investmentPickerBtn setTitle:@"不限" forState:UIControlStateNormal];
    [view1 addSubview:investmentPickerBtn];
    gradePickerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    gradePickerBtn.frame = CGRectMake(160, 14+52*2, 350, 22);
    [gradePickerBtn setBackgroundColor:[UIColor clearColor]];
    [gradePickerBtn setTitleColor:[UIColor colorWithHexValue:0xacacac] forState:UIControlStateNormal];
    [gradePickerBtn addTarget:self action:@selector(gradePickBtnPress:) forControlEvents:UIControlEventTouchUpInside];
    gradePickerBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    UILabel * _gradeValueLabel = gradePickerBtn.titleLabel;
    _gradeValueLabel.font = [UIFont systemFontOfSize:16];
    [gradePickerBtn setTitle:@"不限" forState:UIControlStateNormal];
    [view1 addSubview:gradePickerBtn];
    repayPickerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    repayPickerBtn.frame = CGRectMake(160, 14+52*3, 350, 22);
    [repayPickerBtn setBackgroundColor:[UIColor clearColor]];
    [repayPickerBtn setTitleColor:[UIColor colorWithHexValue:0xacacac] forState:UIControlStateNormal];
    [repayPickerBtn addTarget:self action:@selector(repayPickBtnPress:) forControlEvents:UIControlEventTouchUpInside];
    repayPickerBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    UILabel * _repayValueLabel = repayPickerBtn.titleLabel;
    _repayValueLabel.font = [UIFont systemFontOfSize:16];
    [repayPickerBtn setTitle:@"不限" forState:UIControlStateNormal];
    [view1 addSubview:repayPickerBtn];
    
    UIView * view2 = [[UIView alloc]initWithFrame:CGRectMake(230, 268, 544, 50)];
    view2.backgroundColor = [UIColor colorWithHexValue:0xf7f7f7];
    //UIView设置边框
    [[view2 layer] setCornerRadius:15];
    [[view2 layer] setBorderWidth:1];
    [[view2 layer] setBorderColor:[UIColor colorWithHexValue:0xbbbbbb].CGColor];
    [self.view addSubview:view2];
    
    UILabel * _dayLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 14, 160, 22)];
    [_dayLabel setTextAlignment:NSTextAlignmentLeft];
    [_dayLabel setTextColor:[UIColor colorWithHexValue:0x4f4f4f]];
    [_dayLabel setFont:[UIFont systemFontOfSize:22]];
    [_dayLabel setBackgroundColor:[UIColor clearColor]];
    _dayLabel.text = @"成立日期";
    [view2 addSubview:_dayLabel];
    datePickerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    datePickerBtn.frame = CGRectMake(160, 14, 350, 22);
    [datePickerBtn setBackgroundColor:[UIColor clearColor]];
    [datePickerBtn setTitleColor:[UIColor colorWithHexValue:0xacacac] forState:UIControlStateNormal];
    [datePickerBtn addTarget:self action:@selector(datePickBtnPress:) forControlEvents:UIControlEventTouchUpInside];
    datePickerBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    UILabel * _dateValueLabel = datePickerBtn.titleLabel;
    _dateValueLabel.font = [UIFont systemFontOfSize:16];
    [view2 addSubview:datePickerBtn];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *todayDate = [NSDate date];
    [datePickerBtn setTitle:[formatter stringFromDate:todayDate] forState:UIControlStateNormal];
    
    UIView * view3 = [[UIView alloc]initWithFrame:CGRectMake(230, 340, 544, 50)];
    view3.backgroundColor = [UIColor colorWithHexValue:0xf7f7f7];
    //UIView设置边框
    [[view3 layer] setCornerRadius:15];
    [[view3 layer] setBorderWidth:1];
    [[view3 layer] setBorderColor:[UIColor colorWithHexValue:0xbbbbbb].CGColor];
    [self.view addSubview:view3];
    
    UILabel * _companyLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 14, 160, 22)];
    [_companyLabel setTextAlignment:NSTextAlignmentLeft];
    [_companyLabel setTextColor:[UIColor colorWithHexValue:0x4f4f4f]];
    [_companyLabel setFont:[UIFont systemFontOfSize:22]];
    [_companyLabel setBackgroundColor:[UIColor clearColor]];
    _companyLabel.text = @"选择基金公司";
    [view3 addSubview:_companyLabel];
    companyPickerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    companyPickerBtn.frame = CGRectMake(160, 14, 350, 22);
    [companyPickerBtn setBackgroundColor:[UIColor clearColor]];
    [companyPickerBtn setTitleColor:[UIColor colorWithHexValue:0xacacac] forState:UIControlStateNormal];
    [companyPickerBtn addTarget:self action:@selector(companyPickBtnPress:) forControlEvents:UIControlEventTouchUpInside];
    companyPickerBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    UILabel * _companyValueLabel = companyPickerBtn.titleLabel;
    _companyValueLabel.font = [UIFont systemFontOfSize:16];
    [companyPickerBtn setTitle:@"全部" forState:UIControlStateNormal];
    [view3 addSubview:companyPickerBtn];
    
    UIView * view4 = [[UIView alloc]initWithFrame:CGRectMake(230, 412, 544, 50)];
    view4.backgroundColor = [UIColor colorWithHexValue:0xf7f7f7];
    //UIView设置边框
    [[view4 layer] setCornerRadius:15];
    [[view4 layer] setBorderWidth:1];
    [[view4 layer] setBorderColor:[UIColor colorWithHexValue:0xbbbbbb].CGColor];
    [self.view addSubview:view4];
    
    UILabel * _statusLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 14, 160, 22)];
    [_statusLabel setTextAlignment:NSTextAlignmentLeft];
    [_statusLabel setTextColor:[UIColor colorWithHexValue:0x4f4f4f]];
    [_statusLabel setFont:[UIFont systemFontOfSize:22]];
    [_statusLabel setBackgroundColor:[UIColor clearColor]];
    _statusLabel.text = @"选择基金状态";
    [view4 addSubview:_statusLabel];
    statPickerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    statPickerBtn.frame = CGRectMake(160, 14, 350, 22);
    [statPickerBtn setBackgroundColor:[UIColor clearColor]];
    [statPickerBtn setTitleColor:[UIColor colorWithHexValue:0xacacac] forState:UIControlStateNormal];
    [statPickerBtn addTarget:self action:@selector(statPickBtnPress:) forControlEvents:UIControlEventTouchUpInside];
    statPickerBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    UILabel * _statValueLabel = statPickerBtn.titleLabel;
    _statValueLabel.font = [UIFont systemFontOfSize:16];
    [statPickerBtn setTitle:@"不限" forState:UIControlStateNormal];
    [view4 addSubview:statPickerBtn];
    
    UIButton * confirmBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    confirmBtn.frame = CGRectMake(420, 484, 191, 68);
    [confirmBtn setBackgroundImage:[UIImage imageNamed:@"img_59"] forState:UIControlStateNormal];
    [confirmBtn setBackgroundImage:[UIImage imageNamed:@"img_59"] forState:UIControlStateHighlighted];
    [confirmBtn setTitle:@"确认" forState:UIControlStateNormal];
    [confirmBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [confirmBtn addTarget:self action:@selector(confirmBtnPress:) forControlEvents:UIControlEventTouchUpInside];
    UILabel * label3 = confirmBtn.titleLabel;
    label3.font = [UIFont boldSystemFontOfSize:34];
    [self.view addSubview:confirmBtn];
    
    [self getfundCompanyRequestData];
}

- (void)confirmBtnPress:(id)sender
{
    SiftResultViewController * siftResultViewCtrl = [[SiftResultViewController alloc]init];
    siftResultViewCtrl.siftType = SiftNormalType;
    
    if (fundType != nil) {
        siftResultViewCtrl.fundType = fundType;
    }
    if (investType != nil) {
        siftResultViewCtrl.investType = investType;
    }
    if (estbData != nil) {
        siftResultViewCtrl.estbData = estbData;
    }
    if (status != -1) {
        siftResultViewCtrl.status = status;
    }
    if (grade != -1) {
        siftResultViewCtrl.grade = grade;
    }
    if (rr_this_year != -1) {
        siftResultViewCtrl.rr_this_year = rr_this_year;
    }
    if (fund_corp != -1) {
        siftResultViewCtrl.fund_corp = fund_corp;
    }
    
    [self.navigationController pushViewController:siftResultViewCtrl animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//网络从未连接到连接时的处理
- (void)onNetConnected
{
}
#pragma mark -
#pragma mark ALPickerView delegate methods

- (NSInteger)numberOfRowsForPickerView:(ALPickerView *)pickerView {
    if (pickerView == fundPicker) {
        return [fundEntries count];
    }
    if (pickerView == investmentPicker) {
        return [investmentEntries count];
    }
    if (pickerView == gradePicker) {
        return [gradeEntries count];
    }
    if (pickerView == repayPicker) {
        return [repayEntries count];
    }
    if (pickerView == companyPicker) {
        return [companyEntries count];
    }
    if (pickerView == statPicker) {
        return [statEntries count];
    }
	return 0;
}

- (NSString *)pickerView:(ALPickerView *)pickerView textForRow:(NSInteger)row {
    if (pickerView == fundPicker) {
        return [fundEntries objectAtIndex:row];
    }
    if (pickerView == investmentPicker) {
        return [investmentEntries objectAtIndex:row];
    }
    if (pickerView == gradePicker) {
        return [gradeEntries objectAtIndex:row];
    }
    if (pickerView == repayPicker) {
        return [repayEntries objectAtIndex:row];
    }
    if (pickerView == companyPicker) {
        return [companyEntries objectAtIndex:row];
    }
    if (pickerView == statPicker) {
        return [statEntries objectAtIndex:row];
    }
	return nil;
}

- (BOOL)pickerView:(ALPickerView *)pickerView selectionStateForRow:(NSInteger)row {
    if (pickerView == fundPicker) {
        return [[fundSelectionStates objectForKey:[fundEntries objectAtIndex:row]] boolValue];
    }
    if (pickerView == investmentPicker) {
        return [[investmentSelectionStates objectForKey:[investmentEntries objectAtIndex:row]] boolValue];
    }
    if (pickerView == gradePicker) {
        return [[gradeSelectionStates objectForKey:[gradeEntries objectAtIndex:row]] boolValue];
    }
    if (pickerView == repayPicker) {
        return [[repaySelectionStates objectForKey:[repayEntries objectAtIndex:row]] boolValue];
    }
    if (pickerView == companyPicker) {
        return [[companySelectionStates objectForKey:[companyEntries objectAtIndex:row]] boolValue];
    }
    if (pickerView == statPicker) {
        return [[statSelectionStates objectForKey:[statEntries objectAtIndex:row]] boolValue];
    }
	return NO;
}

- (void)pickerView:(ALPickerView *)pickerView didCheckRow:(NSInteger)row {
    if (pickerView == fundPicker) {
        if (row == -1)
            for (id key in [fundSelectionStates allKeys])
                [fundSelectionStates setObject:[NSNumber numberWithBool:YES] forKey:key];
        else
            [fundSelectionStates setObject:[NSNumber numberWithBool:YES] forKey:[fundEntries objectAtIndex:row]];
    }
    if (pickerView == investmentPicker) {
        if (row == -1)
            for (id key in [investmentSelectionStates allKeys])
                [investmentSelectionStates setObject:[NSNumber numberWithBool:YES] forKey:key];
        else
            [investmentSelectionStates setObject:[NSNumber numberWithBool:YES] forKey:[investmentEntries objectAtIndex:row]];
    }
    if (pickerView == gradePicker) {
        if (row == -1)
            for (id key in [gradeSelectionStates allKeys])
                [gradeSelectionStates setObject:[NSNumber numberWithBool:YES] forKey:key];
        else
            [gradeSelectionStates setObject:[NSNumber numberWithBool:YES] forKey:[gradeEntries objectAtIndex:row]];
    }
    if (pickerView == repayPicker) {
        if (row == -1)
            for (id key in [repaySelectionStates allKeys])
                [repaySelectionStates setObject:[NSNumber numberWithBool:YES] forKey:key];
        else
            [repaySelectionStates setObject:[NSNumber numberWithBool:YES] forKey:[repayEntries objectAtIndex:row]];
    }
    if (pickerView == companyPicker) {
        if (row == -1)
            for (id key in [companySelectionStates allKeys])
                [companySelectionStates setObject:[NSNumber numberWithBool:YES] forKey:key];
        else
            [companySelectionStates setObject:[NSNumber numberWithBool:YES] forKey:[companyEntries objectAtIndex:row]];
    }
    if (pickerView == statPicker) {
        if (row == -1)
            for (id key in [statSelectionStates allKeys])
                [statSelectionStates setObject:[NSNumber numberWithBool:YES] forKey:key];
        else
            [statSelectionStates setObject:[NSNumber numberWithBool:YES] forKey:[statEntries objectAtIndex:row]];
    }
}

- (void)pickerView:(ALPickerView *)pickerView didUncheckRow:(NSInteger)row {
    if (pickerView == fundPicker) {
        if (row == -1)
            for (id key in [fundSelectionStates allKeys])
                [fundSelectionStates setObject:[NSNumber numberWithBool:NO] forKey:key];
        else
            [fundSelectionStates setObject:[NSNumber numberWithBool:NO] forKey:[fundEntries objectAtIndex:row]];
    }
    if (pickerView == investmentPicker) {
        if (row == -1)
            for (id key in [investmentSelectionStates allKeys])
                [investmentSelectionStates setObject:[NSNumber numberWithBool:NO] forKey:key];
        else
            [investmentSelectionStates setObject:[NSNumber numberWithBool:NO] forKey:[investmentEntries objectAtIndex:row]];
    }
    if (pickerView == gradePicker) {
        if (row == -1)
            for (id key in [gradeSelectionStates allKeys])
                [gradeSelectionStates setObject:[NSNumber numberWithBool:NO] forKey:key];
        else
            [gradeSelectionStates setObject:[NSNumber numberWithBool:NO] forKey:[gradeEntries objectAtIndex:row]];
    }
    if (pickerView == repayPicker) {
        if (row == -1)
            for (id key in [repaySelectionStates allKeys])
                [repaySelectionStates setObject:[NSNumber numberWithBool:NO] forKey:key];
        else
            [repaySelectionStates setObject:[NSNumber numberWithBool:NO] forKey:[repayEntries objectAtIndex:row]];
    }
    if (pickerView == companyPicker) {
        if (row == -1)
            for (id key in [companySelectionStates allKeys])
                [companySelectionStates setObject:[NSNumber numberWithBool:NO] forKey:key];
        else
            [companySelectionStates setObject:[NSNumber numberWithBool:NO] forKey:[companyEntries objectAtIndex:row]];
    }
    if (pickerView == statPicker) {
        if (row == -1)
            for (id key in [statSelectionStates allKeys])
                [statSelectionStates setObject:[NSNumber numberWithBool:NO] forKey:key];
        else
            [statSelectionStates setObject:[NSNumber numberWithBool:NO] forKey:[statEntries objectAtIndex:row]];
    }
}

- (void) getFundCompanyRequestSuccess:(FundCompanyRequest *)request
{
	BOOL isRequestSuccess = [fundCompanyRequest isRequestSuccess];
    if (isRequestSuccess) {
        fundCompanyArray = [fundCompanyRequest getDataArray];
        for (int i = 0; i < fundCompanyArray.count; ++i) {
            FundCompanyData * data = [fundCompanyArray objectAtIndex:i];
            [companyEntries addObject:data.corp_name];
        }
    }
    else {
    }
}

- (void) getFundCompanyRequestFailed:(FundCompanyRequest *)request
{
    
}

- (void)getfundCompanyRequestData
{
    NSString * url = [NSString stringWithFormat:@"%@%@", HOST_NAME, SIFT_FUND_COMPANY];
    NSMutableArray * array = [[NSMutableArray alloc]initWithCapacity:0];
    [array addObject:[NSString stringWithFormat:@"%@=%@", OPENID, OPENID_VALUE]];
    [array addObject:[NSString stringWithFormat:@"%@=%@", TYPE, DATA_FORMAT]];
    if (_UI.isLogin) {
        [array addObject:[NSString stringWithFormat:@"%@=%@", @"user_name", _UI.userName]];
        [array addObject:[NSString stringWithFormat:@"%@=%@", @"access_token", _UI.loginToken]];
    }
    //    [array addObject:[NSString stringWithFormat:@"%@=%@", @"page_no", @"1"]];
    //    [array addObject:[NSString stringWithFormat:@"%@=%@", @"page_size", @"2"]];
    
    NSString * md5Result = [_UI md5EncParam:array];
    url = [url stringByAppendingString:md5Result];
    url = [url URLEncodedString];
    fundCompanyRequest = [[FundCompanyRequest alloc]initWithUrl:url];
    
	fundCompanyRequest.delegate = self;
    fundCompanyRequest.requestDidFinishSelector = @selector(getFundCompanyRequestSuccess:);
    fundCompanyRequest.requestDidFailedSelector = @selector(getFundCompanyRequestFailed:);
    
    [fundCompanyRequest sendRequest];
}

@end
