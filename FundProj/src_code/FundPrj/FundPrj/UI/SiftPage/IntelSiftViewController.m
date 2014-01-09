//
//  IntelSiftViewController.m
//  FundPrj
//
//  Created by leesea on 13-11-11.
//  Copyright (c) 2013年 leesea. All rights reserved.
//

#import "IntelSiftViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "SiftResultViewController.h"

@interface IntelSiftViewController ()
{
    UIScrollView * scrollView;
    
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
    
    UIButton * datePickerBtn;
    UIDatePicker * datePicker;
    UIView * datePickerView;
    
	NSArray *propertyEntries;
	NSMutableDictionary *propertySelectionStates;
	ALPickerView *propertyPicker;
    UIButton * propertyPickerBtn;
    UIView * propertyPickerView;
    
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
    
	NSArray *repay1Entries;
	NSMutableDictionary *repay1SelectionStates;
	ALPickerView *repay1Picker;
    UIButton * repay1PickerBtn;
    UIView * repay1PickerView;
    
	NSArray *repay2Entries;
	NSMutableDictionary *repay2SelectionStates;
	ALPickerView *repay2Picker;
    UIButton * repay2PickerBtn;
    UIView * repay2PickerView;
    
	NSArray *shareEntries;
	NSMutableDictionary *shareSelectionStates;
	ALPickerView *sharePicker;
    UIButton * sharePickerBtn;
    UIView * sharePickerView;
    
	NSArray *bondEntries;
	NSMutableDictionary *bondSelectionStates;
	ALPickerView *bondPicker;
    UIButton * bondPickerBtn;
    UIView * bondPickerView;
    
	NSArray *sharePercentEntries;
	NSMutableDictionary *sharePercentSelectionStates;
	ALPickerView *sharePercentPicker;
    UIButton * sharePercentPickerBtn;
    UIView * sharePercentPickerView;
    
	NSArray *industryEntries;
	NSMutableDictionary *industrySelectionStates;
	ALPickerView *industryPicker;
    UIButton * industryPickerBtn;
    UIView * industryPickerView;
    
	NSArray *bondPercentEntries;
	NSMutableDictionary *bondPercentSelectionStates;
	ALPickerView *bondPercentPicker;
    UIButton * bondPercentPickerBtn;
    UIView * bondPercentPickerView;
    
	NSArray *gradeChangeEntries;
	NSMutableDictionary *gradeChangeSelectionStates;
	ALPickerView *gradeChangePicker;
    UIButton * gradeChangePickerBtn;
    UIView * gradeChangePickerView;
    
    NSString * type;
    NSString * invest_type;
    NSString * estb_date;
    NSInteger size;
    NSInteger grade;
    NSInteger rr_one_year;
    NSInteger rr_this_year;
    NSInteger invest_stock_style;
    NSInteger invest_bond_style;
    NSInteger invest_stock_ratio;
    NSInteger top_industry;
    NSInteger grade_qoq;
    NSInteger shape;
    NSInteger risk;
}

@end

@implementation IntelSiftViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        type = nil;
        invest_type = nil;
        estb_date = nil;
        size = -1;
        grade = -1;
        rr_one_year = -1;
        invest_stock_style = -1;
        invest_bond_style = -1;
        invest_stock_ratio = -1;
        top_industry = -1;
        grade_qoq = -1;
        shape = -1;
        risk = -1;
    }
    return self;
}

- (void)fundOkBtnPress:(id)sender
{
    BOOL flag = YES;
    NSString * str = @"";
	for (int i = 0; i < fundEntries.count; ++i)
    {
        if ([self pickerView:fundPicker selectionStateForRow:i]) {
            if (type == nil) {
                type = @"";
            }
            str = [str stringByAppendingFormat:@"%@ ", [fundEntries objectAtIndex:i]];
            if (i == 0) {
                type = [type stringByAppendingString:@"A"];
            }
            if (i == 1) {
                type = [type stringByAppendingString:@"B"];
            }
            if (i == 2) {
                type = [type stringByAppendingString:@"C"];
            }
            if (i == 3) {
                type = [type stringByAppendingString:@"D"];
            }
            if (i == 4) {
                type = [type stringByAppendingString:@"E"];
            }
            if (i == 5) {
                type = [type stringByAppendingString:@"F"];
            }
            if (i == 6) {
                type = [type stringByAppendingString:@"E"];
            }
        }
        else {
            flag = NO;
        }
    }
    if (flag) {
        [fundPickerBtn setTitle:@"不限" forState:UIControlStateNormal];
        type = nil;
    }
    else {
        [fundPickerBtn setTitle:str forState:UIControlStateNormal];
    }
    [fundPickerView removeFromSuperview];
    fundPickerView = nil;
}

- (void)fundPickBtnPress:(id)sender
{
    fundPickerView = [[UIView alloc]initWithFrame:CGRectMake(270, 40+52-scrollView.contentOffset.y, 472, 268)];
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
            if (invest_type == nil) {
                invest_type = @"";
            }
            str = [str stringByAppendingFormat:@"%@ ", [investmentEntries objectAtIndex:i]];
            if (i == 0) {
                invest_type = [invest_type stringByAppendingString:@"A"];
            }
            if (i == 1) {
                invest_type = [invest_type stringByAppendingString:@"B"];
            }
            if (i == 2) {
                invest_type = [invest_type stringByAppendingString:@"C"];
            }
            if (i == 3) {
                invest_type = [invest_type stringByAppendingString:@"D"];
            }
            if (i == 4) {
                invest_type = [invest_type stringByAppendingString:@"E"];
            }
            if (i == 5) {
                invest_type = [invest_type stringByAppendingString:@"F"];
            }
            if (i == 6) {
                invest_type = [invest_type stringByAppendingString:@"G"];
            }
            if (i == 7) {
                invest_type = [invest_type stringByAppendingString:@"H"];
            }
            if (i == 8) {
                invest_type = [invest_type stringByAppendingString:@"I"];
            }
            if (i == 9) {
                invest_type = [invest_type stringByAppendingString:@"J"];
            }
            if (i == 10) {
                invest_type = [invest_type stringByAppendingString:@"K"];
            }
            if (i == 11) {
                invest_type = [invest_type stringByAppendingString:@"L"];
            }
            if (i == 12) {
                invest_type = [invest_type stringByAppendingString:@"M"];
            }
            if (i == 13) {
                invest_type = [invest_type stringByAppendingString:@"N"];
            }
            if (i == 14) {
                invest_type = [invest_type stringByAppendingString:@"O"];
            }
        }
        else {
            flag = NO;
        }
    }
    if (flag) {
        [investmentPickerBtn setTitle:@"不限" forState:UIControlStateNormal];
        invest_type = nil;
        
    }
    else {
        [investmentPickerBtn setTitle:str forState:UIControlStateNormal];
    }
    [investmentPickerView removeFromSuperview];
    investmentPickerView = nil;
}

- (void)investmentPickBtnPress:(id)sender
{
    investmentPickerView = [[UIView alloc]initWithFrame:CGRectMake(270, 40+52*2-scrollView.contentOffset.y, 472, 268)];
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

- (void)dateOkBtnPress:(id)sender
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    datePickerBtn.titleLabel.text = [formatter stringFromDate:datePicker.date];
    [datePickerView removeFromSuperview];
    datePickerView = nil;
    estb_date = [NSString stringWithFormat:@">=%@", [formatter stringFromDate:datePicker.date]];
}

- (void)datePickBtnPress:(id)sender
{
    datePickerView = [[UIView alloc]initWithFrame:CGRectMake(270, 40+52*3-scrollView.contentOffset.y, 472, 268)];
    datePickerView.backgroundColor = [UIColor lightGrayColor];
    UIView * headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 472, 50)];
    headerView.backgroundColor = [UIColor grayColor];
    [datePickerView addSubview:headerView];
    UIButton * okBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    okBtn.frame = CGRectMake(370, 7, 80, 36);
    [okBtn setBackgroundColor:[UIColor darkGrayColor]];
    [okBtn setTitle:@"完成" forState:UIControlStateNormal];
    [okBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [okBtn addTarget:self action:@selector(companyOkBtnPress:) forControlEvents:UIControlEventTouchUpInside];
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

- (void)propertyOkBtnPress:(id)sender
{
    BOOL flag = YES;
    NSString * str = @"";
	for (int i = 0; i < propertyEntries.count; ++i)
    {
        if ([self pickerView:propertyPicker selectionStateForRow:i]) {
            str = [str stringByAppendingFormat:@"%@ ", [propertyEntries objectAtIndex:i]];
        }
        else {
            flag = NO;
        }
    }
    if (flag) {
        [propertyPickerBtn setTitle:@"不限" forState:UIControlStateNormal];
    }
    else {
        [propertyPickerBtn setTitle:str forState:UIControlStateNormal];
    }
    [propertyPickerView removeFromSuperview];
    propertyPickerView = nil;
    size = -1;//to do
}

- (void)propertyPickBtnPress:(id)sender
{
    propertyPickerView = [[UIView alloc]initWithFrame:CGRectMake(270, 40+52*4-scrollView.contentOffset.y, 472, 268)];
    propertyPickerView.backgroundColor = [UIColor lightGrayColor];
    UIView * headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 472, 50)];
    headerView.backgroundColor = [UIColor grayColor];
    [propertyPickerView addSubview:headerView];
    UIButton * okBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    okBtn.frame = CGRectMake(370, 7, 80, 36);
    [okBtn setBackgroundColor:[UIColor darkGrayColor]];
    [okBtn setTitle:@"完成" forState:UIControlStateNormal];
    [okBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [okBtn addTarget:self action:@selector(propertyOkBtnPress:) forControlEvents:UIControlEventTouchUpInside];
    UILabel * label = okBtn.titleLabel;
    label.font = [UIFont boldSystemFontOfSize:24];
    [headerView addSubview:okBtn];
    
	// Create some sample data
	propertyEntries = [[NSArray alloc] initWithObjects:@"10亿以下", @"10亿~50亿", @"50亿~100亿", @"100亿以上", nil];
	propertySelectionStates = [[NSMutableDictionary alloc] init];
	for (NSString *key in propertyEntries)
		[propertySelectionStates setObject:[NSNumber numberWithBool:NO] forKey:key];
	
	// Init picker and add it to view
	propertyPicker = [[ALPickerView alloc] initWithFrame:CGRectMake(80,50,300,150) allStr:@"不限"];
	propertyPicker.delegate = self;
	[propertyPickerView addSubview:propertyPicker];
    
    [self.view addSubview:propertyPickerView];
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
        [gradePickerBtn setTitle:@"全部" forState:UIControlStateNormal];
        grade = -1;
    }
    else {
        [gradePickerBtn setTitle:str forState:UIControlStateNormal];
    }
    [gradePickerView removeFromSuperview];
    gradePickerView = nil;
}

- (void)gradePickBtnPress:(id)sender
{
    gradePickerView = [[UIView alloc]initWithFrame:CGRectMake(270, 268+52-scrollView.contentOffset.y, 472, 268)];
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
	gradePicker = [[ALPickerView alloc] initWithFrame:CGRectMake(80,50,300,150) allStr:@"全部"];
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
        [repayPickerBtn setTitle:@"全部" forState:UIControlStateNormal];
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
    repayPickerView = [[UIView alloc]initWithFrame:CGRectMake(270, 268+52*2-scrollView.contentOffset.y, 472, 268)];
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
	repayPicker = [[ALPickerView alloc] initWithFrame:CGRectMake(80,50,300,150) allStr:@"全部"];
	repayPicker.delegate = self;
	[repayPickerView addSubview:repayPicker];
    
    [self.view addSubview:repayPickerView];
}

- (void)repay1OkBtnPress:(id)sender
{
    BOOL flag = YES;
    NSString * str = @"";
	for (int i = 0; i < repay1Entries.count; ++i)
    {
        if ([self pickerView:repay1Picker selectionStateForRow:i]) {
            str = [str stringByAppendingFormat:@"%@ ", [repay1Entries objectAtIndex:i]];
            rr_one_year = i+1;
        }
        else {
            flag = NO;
        }
    }
    if (flag) {
        [repay1PickerBtn setTitle:@"全部" forState:UIControlStateNormal];
        rr_one_year = -1;
    }
    else {
        [repay1PickerBtn setTitle:str forState:UIControlStateNormal];
    }
    [repay1PickerView removeFromSuperview];
    repay1PickerView = nil;
}

- (void)repay1PickBtnPress:(id)sender
{
    repay1PickerView = [[UIView alloc]initWithFrame:CGRectMake(270, 268+52*3-scrollView.contentOffset.y, 472, 268)];
    repay1PickerView.backgroundColor = [UIColor lightGrayColor];
    UIView * headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 472, 50)];
    headerView.backgroundColor = [UIColor grayColor];
    [repay1PickerView addSubview:headerView];
    UIButton * okBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    okBtn.frame = CGRectMake(370, 7, 80, 36);
    [okBtn setBackgroundColor:[UIColor darkGrayColor]];
    [okBtn setTitle:@"完成" forState:UIControlStateNormal];
    [okBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [okBtn addTarget:self action:@selector(repay1OkBtnPress:) forControlEvents:UIControlEventTouchUpInside];
    UILabel * label = okBtn.titleLabel;
    label.font = [UIFont boldSystemFontOfSize:24];
    [headerView addSubview:okBtn];
    
	// Create some sample data
	repay1Entries = [[NSArray alloc] initWithObjects:@"大于30%", @"大于20%", @"大于10%", @"前1/4", @"前1/3", @"跑赢沪深300", nil];
	repay1SelectionStates = [[NSMutableDictionary alloc] init];
	for (NSString *key in repay1Entries)
		[repay1SelectionStates setObject:[NSNumber numberWithBool:NO] forKey:key];
	
	// Init picker and add it to view
	repay1Picker = [[ALPickerView alloc] initWithFrame:CGRectMake(80,50,300,150) allStr:@"全部"];
	repay1Picker.delegate = self;
	[repay1PickerView addSubview:repay1Picker];
    
    [self.view addSubview:repay1PickerView];
}

- (void)repay2OkBtnPress:(id)sender
{
    BOOL flag = YES;
    NSString * str = @"";
	for (int i = 0; i < repay2Entries.count; ++i)
    {
        if ([self pickerView:repay2Picker selectionStateForRow:i]) {
            str = [str stringByAppendingFormat:@"%@ ", [repay2Entries objectAtIndex:i]];
        }
        else {
            flag = NO;
        }
    }
    if (flag) {
        [repay2PickerBtn setTitle:@"全部" forState:UIControlStateNormal];
    }
    else {
        [repay2PickerBtn setTitle:str forState:UIControlStateNormal];
    }
    [repay2PickerView removeFromSuperview];
    repay2PickerView = nil;
}

- (void)repay2PickBtnPress:(id)sender
{
    repay2PickerView = [[UIView alloc]initWithFrame:CGRectMake(270, 268+52*4-scrollView.contentOffset.y, 472, 268)];
    repay2PickerView.backgroundColor = [UIColor lightGrayColor];
    UIView * headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 472, 50)];
    headerView.backgroundColor = [UIColor grayColor];
    [repay2PickerView addSubview:headerView];
    UIButton * okBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    okBtn.frame = CGRectMake(370, 7, 80, 36);
    [okBtn setBackgroundColor:[UIColor darkGrayColor]];
    [okBtn setTitle:@"完成" forState:UIControlStateNormal];
    [okBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [okBtn addTarget:self action:@selector(repay2OkBtnPress:) forControlEvents:UIControlEventTouchUpInside];
    UILabel * label = okBtn.titleLabel;
    label.font = [UIFont boldSystemFontOfSize:24];
    [headerView addSubview:okBtn];
    
	// Create some sample data
	repay2Entries = [[NSArray alloc] initWithObjects:@"大于30%", @"大于20%", @"大于10%", @"前1/4", @"前1/3", @"跑赢沪深300", nil];
	repay2SelectionStates = [[NSMutableDictionary alloc] init];
	for (NSString *key in repay2Entries)
		[repay2SelectionStates setObject:[NSNumber numberWithBool:NO] forKey:key];
	
	// Init picker and add it to view
	repay2Picker = [[ALPickerView alloc] initWithFrame:CGRectMake(80,50,300,150) allStr:@"全部"];
	repay2Picker.delegate = self;
	[repay2PickerView addSubview:repay2Picker];
    
    [self.view addSubview:repay2PickerView];
}

- (void)shareOkBtnPress:(id)sender
{
    BOOL flag = YES;
    NSString * str = @"";
	for (int i = 0; i < shareEntries.count; ++i)
    {
        if ([self pickerView:sharePicker selectionStateForRow:i]) {
            str = [str stringByAppendingFormat:@"%@ ", [shareEntries objectAtIndex:i]];
            invest_stock_style = i + 1;
        }
        else {
            flag = NO;
        }
    }
    if (flag) {
        [sharePickerBtn setTitle:@"不限" forState:UIControlStateNormal];
        invest_stock_style = -1;
    }
    else {
        [sharePickerBtn setTitle:str forState:UIControlStateNormal];
    }
    [sharePickerView removeFromSuperview];
    sharePickerView = nil;
}

- (void)sharePickBtnPress:(id)sender
{
    sharePickerView = [[UIView alloc]initWithFrame:CGRectMake(270, 496+52-scrollView.contentOffset.y, 472, 268)];
    sharePickerView.backgroundColor = [UIColor lightGrayColor];
    UIView * headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 472, 50)];
    headerView.backgroundColor = [UIColor grayColor];
    [sharePickerView addSubview:headerView];
    UIButton * okBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    okBtn.frame = CGRectMake(370, 7, 80, 36);
    [okBtn setBackgroundColor:[UIColor darkGrayColor]];
    [okBtn setTitle:@"完成" forState:UIControlStateNormal];
    [okBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [okBtn addTarget:self action:@selector(shareOkBtnPress:) forControlEvents:UIControlEventTouchUpInside];
    UILabel * label = okBtn.titleLabel;
    label.font = [UIFont boldSystemFontOfSize:24];
    [headerView addSubview:okBtn];
    
	// Create some sample data
	shareEntries = [[NSArray alloc] initWithObjects:@"大盘价值", @"大盘平衡", @"大盘成长", @"中盘价值", @"中盘平衡", @"中盘成长", @"小盘价值", @"小盘平衡", @"小盘成长", nil];
	shareSelectionStates = [[NSMutableDictionary alloc] init];
	for (NSString *key in shareEntries)
		[shareSelectionStates setObject:[NSNumber numberWithBool:NO] forKey:key];
	
	// Init picker and add it to view
	sharePicker = [[ALPickerView alloc] initWithFrame:CGRectMake(80,50,300,150) allStr:@"不限"];
	sharePicker.delegate = self;
	[sharePickerView addSubview:sharePicker];
    
    [self.view addSubview:sharePickerView];
}

- (void)bondOkBtnPress:(id)sender
{
    BOOL flag = YES;
    NSString * str = @"";
	for (int i = 0; i < bondEntries.count; ++i)
    {
        if ([self pickerView:bondPicker selectionStateForRow:i]) {
            str = [str stringByAppendingFormat:@"%@ ", [bondEntries objectAtIndex:i]];
            invest_bond_style = i + 1;
        }
        else {
            flag = NO;
        }
    }
    if (flag) {
        [bondPickerBtn setTitle:@"不限" forState:UIControlStateNormal];
        invest_bond_style = -1;
    }
    else {
        [bondPickerBtn setTitle:str forState:UIControlStateNormal];
    }
    [bondPickerView removeFromSuperview];
    bondPickerView = nil;
}

- (void)bondPickBtnPress:(id)sender
{
    bondPickerView = [[UIView alloc]initWithFrame:CGRectMake(270, 496+52*2-scrollView.contentOffset.y, 472, 268)];
    bondPickerView.backgroundColor = [UIColor lightGrayColor];
    UIView * headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 472, 50)];
    headerView.backgroundColor = [UIColor grayColor];
    [bondPickerView addSubview:headerView];
    UIButton * okBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    okBtn.frame = CGRectMake(370, 7, 80, 36);
    [okBtn setBackgroundColor:[UIColor darkGrayColor]];
    [okBtn setTitle:@"完成" forState:UIControlStateNormal];
    [okBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [okBtn addTarget:self action:@selector(bondOkBtnPress:) forControlEvents:UIControlEventTouchUpInside];
    UILabel * label = okBtn.titleLabel;
    label.font = [UIFont boldSystemFontOfSize:24];
    [headerView addSubview:okBtn];
    
	// Create some sample data
	bondEntries = [[NSArray alloc] initWithObjects:@"保守", @"平衡", @"激进", nil];
	bondSelectionStates = [[NSMutableDictionary alloc] init];
	for (NSString *key in bondEntries)
		[bondSelectionStates setObject:[NSNumber numberWithBool:NO] forKey:key];
	
	// Init picker and add it to view
	bondPicker = [[ALPickerView alloc] initWithFrame:CGRectMake(80,50,300,150) allStr:@"不限"];
	bondPicker.delegate = self;
	[bondPickerView addSubview:bondPicker];
    
    [self.view addSubview:bondPickerView];
}

- (void)sharePercentOkBtnPress:(id)sender
{
    BOOL flag = YES;
    NSString * str = @"";
	for (int i = 0; i < sharePercentEntries.count; ++i)
    {
        if ([self pickerView:sharePercentPicker selectionStateForRow:i]) {
            str = [str stringByAppendingFormat:@"%@ ", [sharePercentEntries objectAtIndex:i]];
            invest_stock_ratio = i + 1;
        }
        else {
            flag = NO;
        }
    }
    if (flag) {
        [sharePercentPickerBtn setTitle:@"不限" forState:UIControlStateNormal];
        invest_stock_ratio = -1;
    }
    else {
        [sharePercentPickerBtn setTitle:str forState:UIControlStateNormal];
    }
    [sharePercentPickerView removeFromSuperview];
    sharePercentPickerView = nil;
}

- (void)sharePercentPickBtnPress:(id)sender
{
    sharePercentPickerView = [[UIView alloc]initWithFrame:CGRectMake(270, 620+52-scrollView.contentOffset.y, 472, 268)];
    sharePercentPickerView.backgroundColor = [UIColor lightGrayColor];
    UIView * headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 472, 50)];
    headerView.backgroundColor = [UIColor grayColor];
    [sharePercentPickerView addSubview:headerView];
    UIButton * okBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    okBtn.frame = CGRectMake(370, 7, 80, 36);
    [okBtn setBackgroundColor:[UIColor darkGrayColor]];
    [okBtn setTitle:@"完成" forState:UIControlStateNormal];
    [okBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [okBtn addTarget:self action:@selector(sharePercentOkBtnPress:) forControlEvents:UIControlEventTouchUpInside];
    UILabel * label = okBtn.titleLabel;
    label.font = [UIFont boldSystemFontOfSize:24];
    [headerView addSubview:okBtn];
    
	// Create some sample data
	sharePercentEntries = [[NSArray alloc] initWithObjects:@"大于95%", @"大于90%", @"大于85%", @"大于75%", @"低于75%", nil];
	sharePercentSelectionStates = [[NSMutableDictionary alloc] init];
	for (NSString *key in sharePercentEntries)
		[sharePercentSelectionStates setObject:[NSNumber numberWithBool:NO] forKey:key];
	
	// Init picker and add it to view
	sharePercentPicker = [[ALPickerView alloc] initWithFrame:CGRectMake(80,50,300,150) allStr:@"不限"];
	sharePercentPicker.delegate = self;
	[sharePercentPickerView addSubview:sharePercentPicker];
    
    [self.view addSubview:sharePercentPickerView];
}

- (void)industryOkBtnPress:(id)sender
{
    BOOL flag = YES;
    NSString * str = @"";
	for (int i = 0; i < industryEntries.count; ++i)
    {
        if ([self pickerView:industryPicker selectionStateForRow:i]) {
            str = [str stringByAppendingFormat:@"%@ ", [industryEntries objectAtIndex:i]];
        }
        else {
            flag = NO;
        }
    }
    if (flag) {
        [industryPickerBtn setTitle:@"不限" forState:UIControlStateNormal];
    }
    else {
        [industryPickerBtn setTitle:str forState:UIControlStateNormal];
    }
    [industryPickerView removeFromSuperview];
    industryPickerView = nil;
    top_industry = -1;//to do
}

- (void)industryPickBtnPress:(id)sender
{
    industryPickerView = [[UIView alloc]initWithFrame:CGRectMake(270, 620+52*2-scrollView.contentOffset.y, 472, 268)];
    industryPickerView.backgroundColor = [UIColor lightGrayColor];
    UIView * headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 472, 50)];
    headerView.backgroundColor = [UIColor grayColor];
    [industryPickerView addSubview:headerView];
    UIButton * okBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    okBtn.frame = CGRectMake(370, 7, 80, 36);
    [okBtn setBackgroundColor:[UIColor darkGrayColor]];
    [okBtn setTitle:@"完成" forState:UIControlStateNormal];
    [okBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [okBtn addTarget:self action:@selector(industryOkBtnPress:) forControlEvents:UIControlEventTouchUpInside];
    UILabel * label = okBtn.titleLabel;
    label.font = [UIFont boldSystemFontOfSize:24];
    [headerView addSubview:okBtn];
    
	// Create some sample data
	industryEntries = [[NSArray alloc] initWithObjects:@"农林牧渔业", @"采矿业", @"制造业", @"电热燃及水生产业", @"建筑业", @"批发零售业", @"交运仓储和邮政业", @"住宿和餐饮业", @"软件和信息技术业", @"金融业", @"房地产业", @"租赁和商务服务业", @"科学研究和技术服务业", @"环境和公共设施管理业", @"居民服务和其他服务业", @"教育业", @"卫生和社会工作业", @"文体和娱乐业", @"综合", nil];
	industrySelectionStates = [[NSMutableDictionary alloc] init];
	for (NSString *key in industryEntries)
		[industrySelectionStates setObject:[NSNumber numberWithBool:NO] forKey:key];
	
	// Init picker and add it to view
	industryPicker = [[ALPickerView alloc] initWithFrame:CGRectMake(80,50,300,150) allStr:@"不限"];
	industryPicker.delegate = self;
	[industryPickerView addSubview:industryPicker];
    
    [self.view addSubview:industryPickerView];
}

- (void)bondPercentOkBtnPress:(id)sender
{
    BOOL flag = YES;
    NSString * str = @"";
	for (int i = 0; i < bondPercentEntries.count; ++i)
    {
        if ([self pickerView:bondPercentPicker selectionStateForRow:i]) {
            str = [str stringByAppendingFormat:@"%@ ", [bondPercentEntries objectAtIndex:i]];
        }
        else {
            flag = NO;
        }
    }
    if (flag) {
        [bondPercentPickerBtn setTitle:@"不限" forState:UIControlStateNormal];
    }
    else {
        [bondPercentPickerBtn setTitle:str forState:UIControlStateNormal];
    }
    [bondPercentPickerView removeFromSuperview];
    bondPercentPickerView = nil;
}

- (void)bondPercentPickBtnPress:(id)sender
{
    bondPercentPickerView = [[UIView alloc]initWithFrame:CGRectMake(270, 620+52*3-scrollView.contentOffset.y, 472, 268)];
    bondPercentPickerView.backgroundColor = [UIColor lightGrayColor];
    UIView * headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 472, 50)];
    headerView.backgroundColor = [UIColor grayColor];
    [bondPercentPickerView addSubview:headerView];
    UIButton * okBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    okBtn.frame = CGRectMake(370, 7, 80, 36);
    [okBtn setBackgroundColor:[UIColor darkGrayColor]];
    [okBtn setTitle:@"完成" forState:UIControlStateNormal];
    [okBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [okBtn addTarget:self action:@selector(bondPercentOkBtnPress:) forControlEvents:UIControlEventTouchUpInside];
    UILabel * label = okBtn.titleLabel;
    label.font = [UIFont boldSystemFontOfSize:24];
    [headerView addSubview:okBtn];
    
	// Create some sample data
	bondPercentEntries = [[NSArray alloc] initWithObjects:@"大于95%", @"大于90%", @"大于85%", @"大于75%", @"低于75%", nil];
	bondPercentSelectionStates = [[NSMutableDictionary alloc] init];
	for (NSString *key in bondPercentEntries)
		[bondPercentSelectionStates setObject:[NSNumber numberWithBool:NO] forKey:key];
	
	// Init picker and add it to view
	bondPercentPicker = [[ALPickerView alloc] initWithFrame:CGRectMake(80,50,300,150) allStr:@"不限"];
	bondPercentPicker.delegate = self;
	[bondPercentPickerView addSubview:bondPercentPicker];
    
    [self.view addSubview:bondPercentPickerView];
}

- (void)gradeChangeOkBtnPress:(id)sender
{
    BOOL flag = YES;
    NSString * str = @"";
	for (int i = 0; i < gradeChangeEntries.count; ++i)
    {
        if ([self pickerView:gradeChangePicker selectionStateForRow:i]) {
            str = [str stringByAppendingFormat:@"%@ ", [gradeChangeEntries objectAtIndex:i]];
            grade_qoq = i + 1;
        }
        else {
            flag = NO;
        }
    }
    if (flag) {
        [gradeChangePickerBtn setTitle:@"不限" forState:UIControlStateNormal];
        grade_qoq = -1;
    }
    else {
        [gradeChangePickerBtn setTitle:str forState:UIControlStateNormal];
    }
    [gradeChangePickerView removeFromSuperview];
    gradeChangePickerView = nil;
}

- (void)gradeChangePickBtnPress:(id)sender
{
    gradeChangePickerView = [[UIView alloc]initWithFrame:CGRectMake(270, 796+52-scrollView.contentOffset.y, 472, 268)];
    gradeChangePickerView.backgroundColor = [UIColor lightGrayColor];
    UIView * headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 472, 50)];
    headerView.backgroundColor = [UIColor grayColor];
    [gradeChangePickerView addSubview:headerView];
    UIButton * okBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    okBtn.frame = CGRectMake(370, 7, 80, 36);
    [okBtn setBackgroundColor:[UIColor darkGrayColor]];
    [okBtn setTitle:@"完成" forState:UIControlStateNormal];
    [okBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [okBtn addTarget:self action:@selector(gradeChangeOkBtnPress:) forControlEvents:UIControlEventTouchUpInside];
    UILabel * label = okBtn.titleLabel;
    label.font = [UIFont boldSystemFontOfSize:24];
    [headerView addSubview:okBtn];
    
	// Create some sample data
	gradeChangeEntries = [[NSArray alloc] initWithObjects:@"上升", @"持平", @"下降", nil];
	gradeChangeSelectionStates = [[NSMutableDictionary alloc] init];
	for (NSString *key in gradeChangeEntries)
		[gradeChangeSelectionStates setObject:[NSNumber numberWithBool:NO] forKey:key];
	
	// Init picker and add it to view
	gradeChangePicker = [[ALPickerView alloc] initWithFrame:CGRectMake(80,50,300,150) allStr:@"不限"];
	gradeChangePicker.delegate = self;
	[gradeChangePickerView addSubview:gradeChangePicker];
    
    [self.view addSubview:gradeChangePickerView];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
//    self.extendedLayoutIncludesOpaqueBars = NO;
//    self.edgesForExtendedLayout = UIRectEdgeBottom | UIRectEdgeLeft | UIRectEdgeRight;
    self.view.backgroundColor = [UIColor colorWithHexValue:0xf1f1ee];
    self.title = @"智能筛选";
    
    scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, 1024, 768-20-44-59)];
    scrollView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:scrollView];
    
    UIView * view1 = [[UIView alloc]initWithFrame:CGRectMake(230, 40, 544, 206)];
    view1.backgroundColor = [UIColor colorWithHexValue:0xf7f7f7];
    //UIView设置边框
    [[view1 layer] setCornerRadius:15];
    [[view1 layer] setBorderWidth:1];
    [[view1 layer] setBorderColor:[UIColor colorWithHexValue:0xbbbbbb].CGColor];
    [scrollView addSubview:view1];
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
    UILabel * _dayLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 14+52*2, 160, 22)];
    [_dayLabel setTextAlignment:NSTextAlignmentLeft];
    [_dayLabel setTextColor:[UIColor colorWithHexValue:0x4f4f4f]];
    [_dayLabel setFont:[UIFont systemFontOfSize:22]];
    [_dayLabel setBackgroundColor:[UIColor clearColor]];
    _dayLabel.text = @"成立日期";
    [view1 addSubview:_dayLabel];
    UILabel * _propertyLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 14+52*3, 160, 22)];
    [_propertyLabel setTextAlignment:NSTextAlignmentLeft];
    [_propertyLabel setTextColor:[UIColor colorWithHexValue:0x4f4f4f]];
    [_propertyLabel setFont:[UIFont systemFontOfSize:22]];
    [_propertyLabel setBackgroundColor:[UIColor clearColor]];
    _propertyLabel.text = @"资产规模";
    [view1 addSubview:_propertyLabel];
    
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
    datePickerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    datePickerBtn.frame = CGRectMake(160, 14+52*2, 350, 22);
    [datePickerBtn setBackgroundColor:[UIColor clearColor]];
    [datePickerBtn setTitleColor:[UIColor colorWithHexValue:0xacacac] forState:UIControlStateNormal];
    [datePickerBtn addTarget:self action:@selector(datePickBtnPress:) forControlEvents:UIControlEventTouchUpInside];
    datePickerBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    UILabel * _dateValueLabel = datePickerBtn.titleLabel;
    _dateValueLabel.font = [UIFont systemFontOfSize:16];
    [view1 addSubview:datePickerBtn];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *todayDate = [NSDate date];
    [datePickerBtn setTitle:[formatter stringFromDate:todayDate] forState:UIControlStateNormal];
    propertyPickerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    propertyPickerBtn.frame = CGRectMake(160, 14+52*3, 350, 22);
    [propertyPickerBtn setBackgroundColor:[UIColor clearColor]];
    [propertyPickerBtn setTitleColor:[UIColor colorWithHexValue:0xacacac] forState:UIControlStateNormal];
    [propertyPickerBtn addTarget:self action:@selector(propertyPickBtnPress:) forControlEvents:UIControlEventTouchUpInside];
    propertyPickerBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    UILabel * _propertyValueLabel = propertyPickerBtn.titleLabel;
    _propertyValueLabel.font = [UIFont systemFontOfSize:16];
    [propertyPickerBtn setTitle:@"不限" forState:UIControlStateNormal];
    [view1 addSubview:propertyPickerBtn];
    
    UIView * view2 = [[UIView alloc]initWithFrame:CGRectMake(230, 268, 544, 206)];
    view2.backgroundColor = [UIColor colorWithHexValue:0xf7f7f7];
    //UIView设置边框
    [[view2 layer] setCornerRadius:15];
    [[view2 layer] setBorderWidth:1];
    [[view2 layer] setBorderColor:[UIColor colorWithHexValue:0xbbbbbb].CGColor];
    [scrollView addSubview:view2];
    UIView * line21Dark = [[UIView alloc]initWithFrame:CGRectMake(0, 50, 544, 1)];
    line21Dark.backgroundColor = [UIColor colorWithHexValue:0xbbbbbb];
    [view2 addSubview:line21Dark];
    UIView * line21Light = [[UIView alloc]initWithFrame:CGRectMake(0, 51, 544, 1)];
    line21Light.backgroundColor = [UIColor colorWithHexValue:0xf8f9f6];
    [view2 addSubview:line21Light];
    UIView * line22Dark = [[UIView alloc]initWithFrame:CGRectMake(0, 102, 544, 1)];
    line22Dark.backgroundColor = [UIColor colorWithHexValue:0xbbbbbb];
    [view2 addSubview:line22Dark];
    UIView * line22Light = [[UIView alloc]initWithFrame:CGRectMake(0, 103, 544, 1)];
    line22Light.backgroundColor = [UIColor colorWithHexValue:0xf8f9f6];
    [view2 addSubview:line22Light];
    UIView * line23Dark = [[UIView alloc]initWithFrame:CGRectMake(0, 154, 544, 1)];
    line23Dark.backgroundColor = [UIColor colorWithHexValue:0xbbbbbb];
    [view2 addSubview:line23Dark];
    UIView * line23Light = [[UIView alloc]initWithFrame:CGRectMake(0, 155, 544, 1)];
    line23Light.backgroundColor = [UIColor colorWithHexValue:0xf8f9f6];
    [view2 addSubview:line23Light];
    
    UILabel * _yearLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 14, 160, 22)];
    [_yearLabel setTextAlignment:NSTextAlignmentLeft];
    [_yearLabel setTextColor:[UIColor colorWithHexValue:0x4f4f4f]];
    [_yearLabel setFont:[UIFont systemFontOfSize:22]];
    [_yearLabel setBackgroundColor:[UIColor clearColor]];
    _yearLabel.text = @"三年评级";
    [view2 addSubview:_yearLabel];
    UILabel * _achievementLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 14+52, 160, 22)];
    [_achievementLabel setTextAlignment:NSTextAlignmentLeft];
    [_achievementLabel setTextColor:[UIColor colorWithHexValue:0x4f4f4f]];
    [_achievementLabel setFont:[UIFont systemFontOfSize:22]];
    [_achievementLabel setBackgroundColor:[UIColor clearColor]];
    _achievementLabel.text = @"年化业绩（%）";
    [view2 addSubview:_achievementLabel];
    UILabel * _yearAchievementLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 14+52*2, 160, 22)];
    [_yearAchievementLabel setTextAlignment:NSTextAlignmentLeft];
    [_yearAchievementLabel setTextColor:[UIColor colorWithHexValue:0x4f4f4f]];
    [_yearAchievementLabel setFont:[UIFont systemFontOfSize:22]];
    [_yearAchievementLabel setBackgroundColor:[UIColor clearColor]];
    _yearAchievementLabel.text = @"近一年业绩";
    [view2 addSubview:_yearAchievementLabel];
    UILabel * _thisYearLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 14+52*3, 160, 22)];
    [_thisYearLabel setTextAlignment:NSTextAlignmentLeft];
    [_thisYearLabel setTextColor:[UIColor colorWithHexValue:0x4f4f4f]];
    [_thisYearLabel setFont:[UIFont systemFontOfSize:22]];
    [_thisYearLabel setBackgroundColor:[UIColor clearColor]];
    _thisYearLabel.text = @"今年以来业绩";
    [view2 addSubview:_thisYearLabel];
    
    gradePickerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    gradePickerBtn.frame = CGRectMake(160, 14, 350, 22);
    [gradePickerBtn setBackgroundColor:[UIColor clearColor]];
    [gradePickerBtn setTitleColor:[UIColor colorWithHexValue:0xacacac] forState:UIControlStateNormal];
    [gradePickerBtn addTarget:self action:@selector(gradePickBtnPress:) forControlEvents:UIControlEventTouchUpInside];
    gradePickerBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    UILabel * _gradeValueLabel = gradePickerBtn.titleLabel;
    _gradeValueLabel.font = [UIFont systemFontOfSize:16];
    [gradePickerBtn setTitle:@"不限" forState:UIControlStateNormal];
    [view2 addSubview:gradePickerBtn];
    repayPickerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    repayPickerBtn.frame = CGRectMake(160, 14+52, 350, 22);
    [repayPickerBtn setBackgroundColor:[UIColor clearColor]];
    [repayPickerBtn setTitleColor:[UIColor colorWithHexValue:0xacacac] forState:UIControlStateNormal];
    [repayPickerBtn addTarget:self action:@selector(repayPickBtnPress:) forControlEvents:UIControlEventTouchUpInside];
    repayPickerBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    UILabel * _repayValueLabel = repayPickerBtn.titleLabel;
    _repayValueLabel.font = [UIFont systemFontOfSize:16];
    [repayPickerBtn setTitle:@"不限" forState:UIControlStateNormal];
    [view2 addSubview:repayPickerBtn];
    repay1PickerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    repay1PickerBtn.frame = CGRectMake(160, 14+52*2, 350, 22);
    [repay1PickerBtn setBackgroundColor:[UIColor clearColor]];
    [repay1PickerBtn setTitleColor:[UIColor colorWithHexValue:0xacacac] forState:UIControlStateNormal];
    [repay1PickerBtn addTarget:self action:@selector(repay1PickBtnPress:) forControlEvents:UIControlEventTouchUpInside];
    repay1PickerBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    UILabel * _repay1ValueLabel = repay1PickerBtn.titleLabel;
    _repay1ValueLabel.font = [UIFont systemFontOfSize:16];
    [repay1PickerBtn setTitle:@"不限"forState:UIControlStateNormal];
    [view2 addSubview:repay1PickerBtn];
    repay2PickerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    repay2PickerBtn.frame = CGRectMake(160, 14+52*3, 350, 22);
    [repay2PickerBtn setBackgroundColor:[UIColor clearColor]];
    [repay2PickerBtn setTitleColor:[UIColor colorWithHexValue:0xacacac] forState:UIControlStateNormal];
    [repay2PickerBtn addTarget:self action:@selector(repay2PickBtnPress:) forControlEvents:UIControlEventTouchUpInside];
    repay2PickerBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    UILabel * _repay2ValueLabel = repay2PickerBtn.titleLabel;
    _repay2ValueLabel.font = [UIFont systemFontOfSize:16];
    [repay2PickerBtn setTitle:@"不限" forState:UIControlStateNormal];
    [view2 addSubview:repay2PickerBtn];
    
    UIView * view3 = [[UIView alloc]initWithFrame:CGRectMake(230, 496, 544, 102)];
    view3.backgroundColor = [UIColor colorWithHexValue:0xf7f7f7];
    //UIView设置边框
    [[view3 layer] setCornerRadius:15];
    [[view3 layer] setBorderWidth:1];
    [[view3 layer] setBorderColor:[UIColor colorWithHexValue:0xbbbbbb].CGColor];
    [scrollView addSubview:view3];
    UIView * line31Dark = [[UIView alloc]initWithFrame:CGRectMake(0, 50, 544, 1)];
    line31Dark.backgroundColor = [UIColor colorWithHexValue:0xbbbbbb];
    [view3 addSubview:line31Dark];
    UIView * line31Light = [[UIView alloc]initWithFrame:CGRectMake(0, 51, 544, 1)];
    line31Light.backgroundColor = [UIColor colorWithHexValue:0xf8f9f6];
    [view3 addSubview:line31Light];
    
    UILabel * _sharesLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 14, 160, 22)];
    [_sharesLabel setTextAlignment:NSTextAlignmentLeft];
    [_sharesLabel setTextColor:[UIColor colorWithHexValue:0x4f4f4f]];
    [_sharesLabel setFont:[UIFont systemFontOfSize:22]];
    [_sharesLabel setBackgroundColor:[UIColor clearColor]];
    _sharesLabel.text = @"股票投资风格";
    [view3 addSubview:_sharesLabel];
    UILabel * _bondLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 14+52, 160, 22)];
    [_bondLabel setTextAlignment:NSTextAlignmentLeft];
    [_bondLabel setTextColor:[UIColor colorWithHexValue:0x4f4f4f]];
    [_bondLabel setFont:[UIFont systemFontOfSize:22]];
    [_bondLabel setBackgroundColor:[UIColor clearColor]];
    _bondLabel.text = @"债券投资风格";
    [view3 addSubview:_bondLabel];
    
    sharePickerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    sharePickerBtn.frame = CGRectMake(160, 14, 350, 22);
    [sharePickerBtn setBackgroundColor:[UIColor clearColor]];
    [sharePickerBtn setTitleColor:[UIColor colorWithHexValue:0xacacac] forState:UIControlStateNormal];
    [sharePickerBtn addTarget:self action:@selector(sharePickBtnPress:) forControlEvents:UIControlEventTouchUpInside];
    sharePickerBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    UILabel * _shareValueLabel = sharePickerBtn.titleLabel;
    _shareValueLabel.font = [UIFont systemFontOfSize:16];
    [sharePickerBtn setTitle:@"不限" forState:UIControlStateNormal];
    [view3 addSubview:sharePickerBtn];
    bondPickerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    bondPickerBtn.frame = CGRectMake(160, 14+52, 350, 22);
    [bondPickerBtn setBackgroundColor:[UIColor clearColor]];
    [bondPickerBtn setTitleColor:[UIColor colorWithHexValue:0xacacac] forState:UIControlStateNormal];
    [bondPickerBtn addTarget:self action:@selector(bondPickBtnPress:) forControlEvents:UIControlEventTouchUpInside];
    bondPickerBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    UILabel * _bondValueLabel = bondPickerBtn.titleLabel;
    _bondValueLabel.font = [UIFont systemFontOfSize:16];
    [bondPickerBtn setTitle:@"不限" forState:UIControlStateNormal];
    [view3 addSubview:bondPickerBtn];
    
    UIView * view4 = [[UIView alloc]initWithFrame:CGRectMake(230, 620, 544, 154)];
    view4.backgroundColor = [UIColor colorWithHexValue:0xf7f7f7];
    //UIView设置边框
    [[view4 layer] setCornerRadius:15];
    [[view4 layer] setBorderWidth:1];
    [[view4 layer] setBorderColor:[UIColor colorWithHexValue:0xbbbbbb].CGColor];
    [scrollView addSubview:view4];
    UIView * line41Dark = [[UIView alloc]initWithFrame:CGRectMake(0, 50, 544, 1)];
    line41Dark.backgroundColor = [UIColor colorWithHexValue:0xbbbbbb];
    [view4 addSubview:line41Dark];
    UIView * line41Light = [[UIView alloc]initWithFrame:CGRectMake(0, 51, 544, 1)];
    line41Light.backgroundColor = [UIColor colorWithHexValue:0xf8f9f6];
    [view4 addSubview:line41Light];
    UIView * line42Dark = [[UIView alloc]initWithFrame:CGRectMake(0, 102, 544, 1)];
    line42Dark.backgroundColor = [UIColor colorWithHexValue:0xbbbbbb];
    [view4 addSubview:line42Dark];
    UIView * line42Light = [[UIView alloc]initWithFrame:CGRectMake(0, 103, 544, 1)];
    line42Light.backgroundColor = [UIColor colorWithHexValue:0xf8f9f6];
    [view4 addSubview:line42Light];
    
    UILabel * _sharesPercentLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 14, 160, 22)];
    [_sharesPercentLabel setTextAlignment:NSTextAlignmentLeft];
    [_sharesPercentLabel setTextColor:[UIColor colorWithHexValue:0x4f4f4f]];
    [_sharesPercentLabel setFont:[UIFont systemFontOfSize:22]];
    [_sharesPercentLabel setBackgroundColor:[UIColor clearColor]];
    _sharesPercentLabel.text = @"股票投资比例";
    [view4 addSubview:_sharesPercentLabel];
    UILabel * _configLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 14+52, 160, 22)];
    [_configLabel setTextAlignment:NSTextAlignmentLeft];
    [_configLabel setTextColor:[UIColor colorWithHexValue:0x4f4f4f]];
    [_configLabel setFont:[UIFont systemFontOfSize:22]];
    [_configLabel setBackgroundColor:[UIColor clearColor]];
    _configLabel.text = @"行业配置";
    [view4 addSubview:_configLabel];
    UILabel * _bondPercentLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 14+52*2, 160, 22)];
    [_bondPercentLabel setTextAlignment:NSTextAlignmentLeft];
    [_bondPercentLabel setTextColor:[UIColor colorWithHexValue:0x4f4f4f]];
    [_bondPercentLabel setFont:[UIFont systemFontOfSize:22]];
    [_bondPercentLabel setBackgroundColor:[UIColor clearColor]];
    _bondPercentLabel.text = @"债券投资比例";
    [view4 addSubview:_bondPercentLabel];
    
    sharePercentPickerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    sharePercentPickerBtn.frame = CGRectMake(160, 14, 350, 22);
    [sharePercentPickerBtn setBackgroundColor:[UIColor clearColor]];
    [sharePercentPickerBtn setTitleColor:[UIColor colorWithHexValue:0xacacac] forState:UIControlStateNormal];
    [sharePercentPickerBtn addTarget:self action:@selector(sharePercentPickBtnPress:) forControlEvents:UIControlEventTouchUpInside];
    sharePercentPickerBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    UILabel * _sharePercentValueLabel = sharePercentPickerBtn.titleLabel;
    _sharePercentValueLabel.font = [UIFont systemFontOfSize:16];
    [sharePercentPickerBtn setTitle:@"不限" forState:UIControlStateNormal];
    [view4 addSubview:sharePercentPickerBtn];
    industryPickerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    industryPickerBtn.frame = CGRectMake(160, 14+52, 350, 22);
    [industryPickerBtn setBackgroundColor:[UIColor clearColor]];
    [industryPickerBtn setTitleColor:[UIColor colorWithHexValue:0xacacac] forState:UIControlStateNormal];
    [industryPickerBtn addTarget:self action:@selector(industryPickBtnPress:) forControlEvents:UIControlEventTouchUpInside];
    industryPickerBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    UILabel * _industryValueLabel = industryPickerBtn.titleLabel;
    _industryValueLabel.font = [UIFont systemFontOfSize:16];
    [industryPickerBtn setTitle:@"不限" forState:UIControlStateNormal];
    [view4 addSubview:industryPickerBtn];
    bondPercentPickerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    bondPercentPickerBtn.frame = CGRectMake(160, 14+52*2, 350, 22);
    [bondPercentPickerBtn setBackgroundColor:[UIColor clearColor]];
    [bondPercentPickerBtn setTitleColor:[UIColor colorWithHexValue:0xacacac] forState:UIControlStateNormal];
    [bondPercentPickerBtn addTarget:self action:@selector(bondPercentPickBtnPress:) forControlEvents:UIControlEventTouchUpInside];
    bondPercentPickerBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    UILabel * _bondPercentValueLabel = bondPercentPickerBtn.titleLabel;
    _bondPercentValueLabel.font = [UIFont systemFontOfSize:16];
    [bondPercentPickerBtn setTitle:@"不限" forState:UIControlStateNormal];
    [view4 addSubview:bondPercentPickerBtn];
    
    UIView * view5 = [[UIView alloc]initWithFrame:CGRectMake(230, 796, 544, 50)];
    view5.backgroundColor = [UIColor colorWithHexValue:0xf7f7f7];
    //UIView设置边框
    [[view5 layer] setCornerRadius:15];
    [[view5 layer] setBorderWidth:1];
    [[view5 layer] setBorderColor:[UIColor colorWithHexValue:0xbbbbbb].CGColor];
    [scrollView addSubview:view5];
    
    UILabel * _lvlChangeLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 14, 160, 22)];
    [_lvlChangeLabel setTextAlignment:NSTextAlignmentLeft];
    [_lvlChangeLabel setTextColor:[UIColor colorWithHexValue:0x4f4f4f]];
    [_lvlChangeLabel setFont:[UIFont systemFontOfSize:22]];
    [_lvlChangeLabel setBackgroundColor:[UIColor clearColor]];
    _lvlChangeLabel.text = @"评级较上期变动";
    [view5 addSubview:_lvlChangeLabel];
    
    gradeChangePickerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    gradeChangePickerBtn.frame = CGRectMake(160, 14, 350, 22);
    [gradeChangePickerBtn setBackgroundColor:[UIColor clearColor]];
    [gradeChangePickerBtn setTitleColor:[UIColor colorWithHexValue:0xacacac] forState:UIControlStateNormal];
    [gradeChangePickerBtn addTarget:self action:@selector(gradeChangePickBtnPress:) forControlEvents:UIControlEventTouchUpInside];
    gradeChangePickerBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    UILabel * _gradeChangeValueLabel = gradeChangePickerBtn.titleLabel;
    _gradeChangeValueLabel.font = [UIFont systemFontOfSize:16];
    [gradeChangePickerBtn setTitle:@"不限" forState:UIControlStateNormal];
    [view5 addSubview:gradeChangePickerBtn];
    
    UIView * view6 = [[UIView alloc]initWithFrame:CGRectMake(230, 868, 544, 50)];
    view6.backgroundColor = [UIColor clearColor];
    [scrollView addSubview:view6];
    
    UILabel * _sharpLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 14, 120, 22)];
    [_sharpLabel setTextAlignment:NSTextAlignmentLeft];
    [_sharpLabel setTextColor:[UIColor colorWithHexValue:0x4f4f4f]];
    [_sharpLabel setFont:[UIFont systemFontOfSize:22]];
    [_sharpLabel setBackgroundColor:[UIColor clearColor]];
    _sharpLabel.text = @"夏普比例";
    [view6 addSubview:_sharpLabel];
    
	// segmented control as the custom title view
	NSArray *segmentTextContent = [NSArray arrayWithObjects:@"不限", @"低", @"中", @"高", nil];
	UISegmentedControl *segmentedControl = [[UISegmentedControl alloc] initWithItems:segmentTextContent];
	segmentedControl.selectedSegmentIndex = 0;
    //	segmentedControl.autoresizingMask = UIViewAutoresizingFlexibleWidth;
	segmentedControl.segmentedControlStyle = UISegmentedControlStyleBar;
	segmentedControl.frame = CGRectMake(120, 8, 424, 34);
	[segmentedControl addTarget:self action:@selector(segmentAction:) forControlEvents:UIControlEventValueChanged];
    
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor blackColor],UITextAttributeTextColor,  [UIFont systemFontOfSize:14],UITextAttributeFont ,[UIColor blackColor],UITextAttributeTextShadowColor ,nil];
    
    [segmentedControl setTitleTextAttributes:dic forState:UIControlStateNormal];
    
    NSDictionary * dict = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],UITextAttributeTextColor,  [UIFont systemFontOfSize:14],UITextAttributeFont ,[UIColor blackColor],UITextAttributeTextShadowColor ,nil];
    
    [segmentedControl setTitleTextAttributes:dict forState:UIControlStateSelected];
    
    [view6 addSubview:segmentedControl];
    
    UIView * view7 = [[UIView alloc]initWithFrame:CGRectMake(230, 940, 544, 50)];
    view7.backgroundColor = [UIColor clearColor];
    [scrollView addSubview:view7];
    
    UILabel * _riskLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 14, 120, 22)];
    [_riskLabel setTextAlignment:NSTextAlignmentLeft];
    [_riskLabel setTextColor:[UIColor colorWithHexValue:0x4f4f4f]];
    [_riskLabel setFont:[UIFont systemFontOfSize:22]];
    [_riskLabel setBackgroundColor:[UIColor clearColor]];
    _riskLabel.text = @"风险等级";
    [view7 addSubview:_riskLabel];
    
	// segmented control as the custom title view
	UISegmentedControl *segmentedControl1 = [[UISegmentedControl alloc] initWithItems:segmentTextContent];
	segmentedControl1.selectedSegmentIndex = 0;
    //	segmentedControl.autoresizingMask = UIViewAutoresizingFlexibleWidth;
	segmentedControl1.segmentedControlStyle = UISegmentedControlStyleBar;
	segmentedControl1.frame = CGRectMake(120, 8, 424, 34);
	[segmentedControl1 addTarget:self action:@selector(segmentAction1:) forControlEvents:UIControlEventValueChanged];
    
    [segmentedControl1 setTitleTextAttributes:dic forState:UIControlStateNormal];
    
    [segmentedControl1 setTitleTextAttributes:dict forState:UIControlStateSelected];
    
    [view7 addSubview:segmentedControl1];
    
    UIButton * confirmBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    confirmBtn.frame = CGRectMake(420, 1020, 191, 68);
    [confirmBtn setBackgroundImage:[UIImage imageNamed:@"img_59"] forState:UIControlStateNormal];
    [confirmBtn setBackgroundImage:[UIImage imageNamed:@"img_59"] forState:UIControlStateHighlighted];
    [confirmBtn setTitle:@"确认" forState:UIControlStateNormal];
    [confirmBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [confirmBtn addTarget:self action:@selector(confirmBtnPress:) forControlEvents:UIControlEventTouchUpInside];
    UILabel * label3 = confirmBtn.titleLabel;
    label3.font = [UIFont boldSystemFontOfSize:34];
    [scrollView addSubview:confirmBtn];

    [scrollView setContentSize:CGSizeMake(1024, 1118)];
}

- (void)confirmBtnPress:(id)sender
{
    SiftResultViewController * siftResultViewCtrl = [[SiftResultViewController alloc]init];
    siftResultViewCtrl.siftType = SiftIntelType;
    
    if (type != nil) {
        siftResultViewCtrl.fundType = type;
    }
    if (invest_type != nil) {
        siftResultViewCtrl.investType = invest_type;
    }
    if (estb_date != nil) {
        siftResultViewCtrl.estbData = estb_date;
    }
    if (grade != -1) {
        siftResultViewCtrl.grade = grade;
    }
    if (rr_this_year != -1) {
        siftResultViewCtrl.rr_this_year = rr_this_year;
    }
    if (rr_one_year != -1) {
        siftResultViewCtrl.fund_corp = rr_one_year;
    }
    
    if (size != -1) {
        siftResultViewCtrl.size = size;
    }
    if (rr_one_year != -1) {
        siftResultViewCtrl.rr_one_year = rr_one_year;
    }
    if (invest_stock_style != -1) {
        siftResultViewCtrl.fund_corp = invest_stock_style;
    }
    if (invest_bond_style != -1) {
        siftResultViewCtrl.fund_corp = invest_bond_style;
    }
    if (invest_stock_ratio != -1) {
        siftResultViewCtrl.fund_corp = invest_stock_ratio;
    }
    if (top_industry != -1) {
        siftResultViewCtrl.fund_corp = top_industry;
    }
    if (grade_qoq != -1) {
        siftResultViewCtrl.fund_corp = grade_qoq;
    }
    if (shape != -1) {
        siftResultViewCtrl.fund_corp = shape;
    }
    if (risk != -1) {
        siftResultViewCtrl.fund_corp = risk;
    }
    
    [self.navigationController pushViewController:siftResultViewCtrl animated:YES];
}

- (void)segmentAction:(id)sender
{
	UISegmentedControl *segmentedControl = (UISegmentedControl *)sender;
	switch (segmentedControl.selectedSegmentIndex) {
        case 0:
            shape = -1;
            break;
        case 1:
            shape = 1;
            break;
        case 2:
            shape = 3;
            break;
        case 3:
            shape = 5;
            break;
            
        default:
            shape = -1;
            break;
    }
}

- (void)segmentAction1:(id)sender
{
	UISegmentedControl *segmentedControl = (UISegmentedControl *)sender;
	switch (segmentedControl.selectedSegmentIndex) {
        case 0:
            risk = -1;
            break;
        case 1:
            risk = 1;
            break;
        case 2:
            risk = 3;
            break;
        case 3:
            risk = 5;
            break;
            
        default:
            risk = -1;
            break;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    if (pickerView == propertyPicker) {
        return [propertyEntries count];
    }
    if (pickerView == gradePicker) {
        return [gradeEntries count];
    }
    if (pickerView == repayPicker) {
        return [repayEntries count];
    }
    if (pickerView == repay1Picker) {
        return [repay1Entries count];
    }
    if (pickerView == repay2Picker) {
        return [repay2Entries count];
    }
    if (pickerView == sharePicker) {
        return [shareEntries count];
    }
    if (pickerView == bondPicker) {
        return [bondEntries count];
    }
    if (pickerView == sharePercentPicker) {
        return [sharePercentEntries count];
    }
    if (pickerView == industryPicker) {
        return [industryEntries count];
    }
    if (pickerView == bondPercentPicker) {
        return [bondPercentEntries count];
    }
    if (pickerView == gradeChangePicker) {
        return [gradeChangeEntries count];
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
    if (pickerView == propertyPicker) {
        return [propertyEntries objectAtIndex:row];
    }
    if (pickerView == gradePicker) {
        return [gradeEntries objectAtIndex:row];
    }
    if (pickerView == repayPicker) {
        return [repayEntries objectAtIndex:row];
    }
    if (pickerView == repay1Picker) {
        return [repay1Entries objectAtIndex:row];
    }
    if (pickerView == repay2Picker) {
        return [repay2Entries objectAtIndex:row];
    }
    if (pickerView == sharePicker) {
        return [shareEntries objectAtIndex:row];
    }
    if (pickerView == bondPicker) {
        return [bondEntries objectAtIndex:row];
    }
    if (pickerView == sharePercentPicker) {
        return [sharePercentEntries objectAtIndex:row];
    }
    if (pickerView == industryPicker) {
        return [industryEntries objectAtIndex:row];
    }
    if (pickerView == bondPercentPicker) {
        return [bondPercentEntries objectAtIndex:row];
    }
    if (pickerView == gradeChangePicker) {
        return [gradeChangeEntries objectAtIndex:row];
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
    if (pickerView == propertyPicker) {
        return [[propertySelectionStates objectForKey:[propertyEntries objectAtIndex:row]] boolValue];
    }
    if (pickerView == gradePicker) {
        return [[gradeSelectionStates objectForKey:[gradeEntries objectAtIndex:row]] boolValue];
    }
    if (pickerView == repayPicker) {
        return [[repaySelectionStates objectForKey:[repayEntries objectAtIndex:row]] boolValue];
    }
    if (pickerView == repay1Picker) {
        return [[repay1SelectionStates objectForKey:[repay1Entries objectAtIndex:row]] boolValue];
    }
    if (pickerView == repay2Picker) {
        return [[repay2SelectionStates objectForKey:[repay2Entries objectAtIndex:row]] boolValue];
    }
    if (pickerView == sharePicker) {
        return [[shareSelectionStates objectForKey:[shareEntries objectAtIndex:row]] boolValue];
    }
    if (pickerView == bondPicker) {
        return [[bondSelectionStates objectForKey:[bondEntries objectAtIndex:row]] boolValue];
    }
    if (pickerView == sharePercentPicker) {
        return [[sharePercentSelectionStates objectForKey:[sharePercentEntries objectAtIndex:row]] boolValue];
    }
    if (pickerView == industryPicker) {
        return [[industrySelectionStates objectForKey:[industryEntries objectAtIndex:row]] boolValue];
    }
    if (pickerView == bondPercentPicker) {
        return [[bondPercentSelectionStates objectForKey:[bondPercentEntries objectAtIndex:row]] boolValue];
    }
    if (pickerView == gradeChangePicker) {
        return [[gradeChangeSelectionStates objectForKey:[gradeChangeEntries objectAtIndex:row]] boolValue];
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
    if (pickerView == propertyPicker) {
        if (row == -1)
            for (id key in [propertySelectionStates allKeys])
                [propertySelectionStates setObject:[NSNumber numberWithBool:YES] forKey:key];
        else
            [propertySelectionStates setObject:[NSNumber numberWithBool:YES] forKey:[propertyEntries objectAtIndex:row]];
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
    if (pickerView == repay1Picker) {
        if (row == -1)
            for (id key in [repay1SelectionStates allKeys])
                [repay1SelectionStates setObject:[NSNumber numberWithBool:YES] forKey:key];
        else
            [repay1SelectionStates setObject:[NSNumber numberWithBool:YES] forKey:[repay1Entries objectAtIndex:row]];
    }
    if (pickerView == repay2Picker) {
        if (row == -1)
            for (id key in [repay2SelectionStates allKeys])
                [repay2SelectionStates setObject:[NSNumber numberWithBool:YES] forKey:key];
        else
            [repay2SelectionStates setObject:[NSNumber numberWithBool:YES] forKey:[repay2Entries objectAtIndex:row]];
    }
    if (pickerView == sharePicker) {
        if (row == -1)
            for (id key in [shareSelectionStates allKeys])
                [shareSelectionStates setObject:[NSNumber numberWithBool:YES] forKey:key];
        else
            [shareSelectionStates setObject:[NSNumber numberWithBool:YES] forKey:[shareEntries objectAtIndex:row]];
    }
    if (pickerView == industryPicker) {
        if (row == -1)
            for (id key in [industrySelectionStates allKeys])
                [industrySelectionStates setObject:[NSNumber numberWithBool:YES] forKey:key];
        else
            [industrySelectionStates setObject:[NSNumber numberWithBool:YES] forKey:[industryEntries objectAtIndex:row]];
    }
    if (pickerView == bondPicker) {
        if (row == -1)
            for (id key in [bondSelectionStates allKeys])
                [bondSelectionStates setObject:[NSNumber numberWithBool:YES] forKey:key];
        else
            [bondSelectionStates setObject:[NSNumber numberWithBool:YES] forKey:[bondEntries objectAtIndex:row]];
    }
    if (pickerView == sharePercentPicker) {
        if (row == -1)
            for (id key in [sharePercentSelectionStates allKeys])
                [sharePercentSelectionStates setObject:[NSNumber numberWithBool:YES] forKey:key];
        else
            [sharePercentSelectionStates setObject:[NSNumber numberWithBool:YES] forKey:[sharePercentEntries objectAtIndex:row]];
    }
    if (pickerView == bondPercentPicker) {
        if (row == -1)
            for (id key in [bondPercentSelectionStates allKeys])
                [bondPercentSelectionStates setObject:[NSNumber numberWithBool:YES] forKey:key];
        else
            [bondPercentSelectionStates setObject:[NSNumber numberWithBool:YES] forKey:[bondPercentEntries objectAtIndex:row]];
    }
    if (pickerView == gradeChangePicker) {
        if (row == -1)
            for (id key in [gradeChangeSelectionStates allKeys])
                [gradeChangeSelectionStates setObject:[NSNumber numberWithBool:YES] forKey:key];
        else
            [gradeChangeSelectionStates setObject:[NSNumber numberWithBool:YES] forKey:[gradeChangeEntries objectAtIndex:row]];
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
    if (pickerView == propertyPicker) {
        if (row == -1)
            for (id key in [propertySelectionStates allKeys])
                [propertySelectionStates setObject:[NSNumber numberWithBool:NO] forKey:key];
        else
            [propertySelectionStates setObject:[NSNumber numberWithBool:NO] forKey:[propertyEntries objectAtIndex:row]];
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
    if (pickerView == repay1Picker) {
        if (row == -1)
            for (id key in [repay1SelectionStates allKeys])
                [repay1SelectionStates setObject:[NSNumber numberWithBool:NO] forKey:key];
        else
            [repay1SelectionStates setObject:[NSNumber numberWithBool:NO] forKey:[repay1Entries objectAtIndex:row]];
    }
    if (pickerView == repay2Picker) {
        if (row == -1)
            for (id key in [repay2SelectionStates allKeys])
                [repay2SelectionStates setObject:[NSNumber numberWithBool:NO] forKey:key];
        else
            [repay2SelectionStates setObject:[NSNumber numberWithBool:NO] forKey:[repay2Entries objectAtIndex:row]];
    }
    if (pickerView == sharePicker) {
        if (row == -1)
            for (id key in [shareSelectionStates allKeys])
                [shareSelectionStates setObject:[NSNumber numberWithBool:NO] forKey:key];
        else
            [shareSelectionStates setObject:[NSNumber numberWithBool:NO] forKey:[shareEntries objectAtIndex:row]];
    }
    if (pickerView == bondPicker) {
        if (row == -1)
            for (id key in [bondSelectionStates allKeys])
                [bondSelectionStates setObject:[NSNumber numberWithBool:NO] forKey:key];
        else
            [bondSelectionStates setObject:[NSNumber numberWithBool:NO] forKey:[bondEntries objectAtIndex:row]];
    }
    if (pickerView == sharePercentPicker) {
        if (row == -1)
            for (id key in [sharePercentSelectionStates allKeys])
                [sharePercentSelectionStates setObject:[NSNumber numberWithBool:NO] forKey:key];
        else
            [sharePercentSelectionStates setObject:[NSNumber numberWithBool:NO] forKey:[sharePercentEntries objectAtIndex:row]];
    }
    if (pickerView == industryPicker) {
        if (row == -1)
            for (id key in [industrySelectionStates allKeys])
                [industrySelectionStates setObject:[NSNumber numberWithBool:NO] forKey:key];
        else
            [industrySelectionStates setObject:[NSNumber numberWithBool:NO] forKey:[industryEntries objectAtIndex:row]];
    }
    if (pickerView == bondPercentPicker) {
        if (row == -1)
            for (id key in [bondPercentSelectionStates allKeys])
                [bondPercentSelectionStates setObject:[NSNumber numberWithBool:NO] forKey:key];
        else
            [bondPercentSelectionStates setObject:[NSNumber numberWithBool:NO] forKey:[bondPercentEntries objectAtIndex:row]];
    }
    if (pickerView == gradeChangePicker) {
        if (row == -1)
            for (id key in [gradeChangeSelectionStates allKeys])
                [gradeChangeSelectionStates setObject:[NSNumber numberWithBool:NO] forKey:key];
        else
            [gradeChangeSelectionStates setObject:[NSNumber numberWithBool:NO] forKey:[gradeChangeEntries objectAtIndex:row]];
    }
}

@end
