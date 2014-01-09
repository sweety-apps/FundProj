//
//  ValueViewController.m
//  FundPrj
//
//  Created by leesea on 13-11-2.
//  Copyright (c) 2013年 leesea. All rights reserved.
//

#import "ValueViewController.h"
#import "FundNotMoneyRequest.h"
#import "FundNotMoneyData.h"
#import "FundMoneyRequest.h"
#import "FundMoneyData.h"
#import "GradeView.h"
#import <sqlite3.h>
#import "FundInfoData.h"
#import <QuartzCore/QuartzCore.h>
#import "DetailViewController.h"
#import "FMDatabase.h"
#import "FMDatabaseQueue.h"
#import "CCSegmentedControl.h"


#define DB_NAME    @"FundDB.sqlite"
#define NAME      @"name"
#define CODE       @"code"
#define PY   @"py"

@interface ValueViewController ()
{
    UITableView * tableView1;
    UITableView * tableView2;
    UITableView * tableView3;
    UITableView * tableView4;
    UITableView * tableView5;
    NSMutableArray * data1;
    NSMutableArray * data2;
    NSMutableArray * data3;
    NSMutableArray * data4;
    NSMutableArray * data5;
    UIView * headerTableViewNotMoney;
    UIView * headerTableViewMoney;
    
    FundNotMoneyRequest * fundNotMoneyRequest;
    FundMoneyRequest * fundMoneyRequest;
    
    NSString *db_path;
    
    FMDatabase *dbBase;
    
    UITextField * searchBox;
    UIView * searchBg;
    UITableView * searchTableView;
    NSMutableArray * searchArray;
}

@end

@implementation ValueViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        data1 = [[NSMutableArray alloc]initWithCapacity:0];
        data2 = [[NSMutableArray alloc]initWithCapacity:0];
        data3 = [[NSMutableArray alloc]initWithCapacity:0];
        data4 = [[NSMutableArray alloc]initWithCapacity:0];
        data5 = [[NSMutableArray alloc]initWithCapacity:0];
        
        db_path = [PATH_OF_DOCUMENT stringByAppendingPathComponent:DB_NAME];
        searchArray = [[NSMutableArray alloc]initWithCapacity:0];
        dbBase = [FMDatabase databaseWithPath:db_path];
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden = NO;
	
    //	[self onNetConnected];
}

- (void)bringSearchTableViewToTop
{
    if (searchBg != nil) {
        [self.view bringSubviewToFront:searchBg];
    }
    if (searchTableView != nil) {
        [self.view bringSubviewToFront:searchTableView];
    }
}

//搜索按钮点击
- (UIBarButtonItem *)createSearchBox
{
    UIView * searchView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 238, 34)];
    UIImageView * searchBoxBg = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 238, 34)];
    searchBoxBg.image = [UIImage imageNamed:@"search"];
    [searchView addSubview:searchBoxBg];
    
    searchBox = [[UITextField alloc] initWithFrame:CGRectMake(40, 0, 198, 34)];
    searchBox.backgroundColor = [UIColor clearColor];
    searchBox.placeholder = @"股票名称或代码";
    searchBox.clearButtonMode = UITextFieldViewModeWhileEditing;
    searchBox.borderStyle = UITextBorderStyleNone;
    //    searchBox.leftViewMode = UITextFieldViewModeAlways;
    //    searchBox.leftView = leftView;
    //    searchBox.rightViewMode = UITextFieldViewModeAlways;
    //    searchBox.rightView = rightView;
    searchBox.textColor = [UIColor colorWithHexValue:0xdbdbdb];
    searchBox.font = [UIFont systemFontOfSize:14];
    searchBox.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    searchBox.returnKeyType = UIReturnKeySearch;
    searchBox.delegate = self;
    searchBox.autocorrectionType = UITextAutocorrectionTypeNo;
    searchBox.enablesReturnKeyAutomatically = YES;
    [searchView addSubview:searchBox];
    [searchBox addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    
    
    UIBarButtonItem* item = [[UIBarButtonItem alloc] initWithCustomView:searchView];
	
	return item;
}

- (void)searchBtnOnPress:(id)sender
{
    UITextField * textField = (UITextField *)sender;
    [textField resignFirstResponder];
    
    [searchTableView removeFromSuperview];
    searchTableView = nil;
    [searchBg removeFromSuperview];
    searchBg = nil;
}

- (void) textFieldDidChange:(id) sender {
    [searchArray removeAllObjects];
    UITextField * textField = (UITextField *)sender;
    if (textField.text == nil || [textField.text isEqualToString: @""]) {
        
        [searchTableView reloadData];
        return;
    }
    // 开始获取相关关键字
    NSString * searchType = @"";
    unichar a = [textField.text characterAtIndex:0];
    if (a >= '0' && a <= '9') {
        searchType = CODE;
    }
    else if ((a >= 'a' && a <= 'z') || (a >= 'A' && a <= 'Z')) {
        searchType = PY;
    }
    else {
        searchType = NAME;
    }
    
    if ([dbBase open]) {
        NSString *sqlMoneyQuery = [NSString stringWithFormat:@"SELECT * FROM FUNDMONEY WHERE %@ LIKE '%@%%'", searchType, textField.text ];
        FMResultSet * rs = [dbBase executeQuery:sqlMoneyQuery];
        while ([rs next]) {
            int ID = [rs intForColumn:@"code"];
            NSString * name = [rs stringForColumn:@"name"];
            
            FundInfoData * data = [[FundInfoData alloc]init];
            data.fund_id = ID;
            data.fund_name = name;
            [searchArray addObject:data];
        }
        
        
        NSString *sqlNotMoneyQuery = [NSString stringWithFormat:@"SELECT * FROM FUNDNOTMONEY WHERE %@ LIKE '%@%%'", searchType, textField.text ];
        FMResultSet * rs1 = [dbBase executeQuery:sqlNotMoneyQuery];
        while ([rs1 next]) {
            int ID = [rs1 intForColumn:@"code"];
            NSString * name = [rs1 stringForColumn:@"name"];
            
            FundInfoData * data = [[FundInfoData alloc]init];
            data.fund_id = ID;
            data.fund_name = name;
            [searchArray addObject:data];
        }
        
        
        NSString *sqlRankMoneyQuery = [NSString stringWithFormat:@"SELECT * FROM FUNDRANKMONEY WHERE %@ LIKE '%@%%'", searchType, textField.text ];
        FMResultSet * rs2 = [dbBase executeQuery:sqlRankMoneyQuery];
        while ([rs2 next]) {
            int ID = [rs2 intForColumn:@"code"];
            NSString * name = [rs2 stringForColumn:@"name"];
            
            FundInfoData * data = [[FundInfoData alloc]init];
            data.fund_id = ID;
            data.fund_name = name;
            [searchArray addObject:data];
        }
        
        
        NSString *sqlRankNotMoneyQuery = [NSString stringWithFormat:@"SELECT * FROM FUNDRANKNOTMONEY WHERE %@ LIKE '%@%%'", searchType, textField.text ];
        FMResultSet * rs3 = [dbBase executeQuery:sqlRankNotMoneyQuery];
        while ([rs3 next]) {
            int ID = [rs3 intForColumn:@"code"];
            NSString * name = [rs3 stringForColumn:@"name"];
            
            FundInfoData * data = [[FundInfoData alloc]init];
            data.fund_id = ID;
            data.fund_name = name;
            [searchArray addObject:data];
        }
        
        
        [dbBase close];
    }
    
    [searchTableView reloadData];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self searchBtnOnPress:textField];
    return YES;
}

//处理点击
-(void)singleTapOfSearchBgView:(UITapGestureRecognizer *)sender
{
    [self searchBtnOnPress:searchBox];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    searchBg = [[UIView alloc]initWithFrame:self.view.frame];
    searchBg.backgroundColor = [UIColor blackColor];
    searchBg.alpha = 0.7;
    [self.view addSubview:searchBg];
    
    UITapGestureRecognizer * singleTapSearchBgView = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapOfSearchBgView:)];
    [searchBg addGestureRecognizer:singleTapSearchBgView];
    
    searchTableView = [[UITableView alloc]initWithFrame:CGRectMake(720, 10, 290, 300)
                                                  style:UITableViewStylePlain];
    searchTableView.dataSource = self;
    searchTableView.delegate = self;
    searchTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
	[self.view addSubview:searchTableView];
    
    UIImageView * headerView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 290, 50)];
    headerView.image = [[UIImage imageNamed:@"home01_13"] stretchableImageWithLeftCapWidth:252/2 topCapHeight:34/2];
    [searchTableView addSubview:headerView];
    
    UILabel * _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 290, 50)];
    [_titleLabel setTextAlignment:NSTextAlignmentCenter];
    [_titleLabel setTextColor:[UIColor whiteColor]];
    [_titleLabel setFont:[UIFont systemFontOfSize:22]];
    [_titleLabel setBackgroundColor:[UIColor clearColor]];
    _titleLabel.text = @"搜索";
    [headerView addSubview:_titleLabel];
    
    //UIView设置阴影
    [[searchTableView layer] setShadowOffset:CGSizeMake(1, 1)];
    [[searchTableView layer] setShadowRadius:5];
    [[searchTableView layer] setShadowOpacity:1];
    [[searchTableView layer] setShadowColor:[UIColor grayColor].CGColor];
    //UIView设置边框
    [[searchTableView layer] setCornerRadius:10];
}

- (void)tappedRefreshBtn:(id)sender
{
    
}

- (UIBarButtonItem *)createRefreshBtn
{
    UIImage * img = [UIImage imageNamed:@"shux_25"];
    UIBarButtonItem * btn = [FPNavigationBar createBarButtonFromImg:img
                                                            imgDown:img
                                                             target:self
                                                             action:@selector(tappedRefreshBtn:)];
    
	return btn;
}

- (void)segmentAction:(id)sender
{
	UISegmentedControl *segmentedControl = (UISegmentedControl *)sender;
	switch (segmentedControl.selectedSegmentIndex) {
        case 0:
            [self.view bringSubviewToFront:tableView1];
            [self.view bringSubviewToFront:headerTableViewNotMoney];
            break;
        case 1:
            [self.view bringSubviewToFront:tableView2];
            [self.view bringSubviewToFront:headerTableViewNotMoney];
            break;
        case 2:
            [self.view bringSubviewToFront:tableView3];
            [self.view bringSubviewToFront:headerTableViewNotMoney];
            break;
        case 3:
            [self.view bringSubviewToFront:tableView4];
            [self.view bringSubviewToFront:headerTableViewMoney];
            break;
        case 4:
            [self.view bringSubviewToFront:tableView5];
            [self.view bringSubviewToFront:headerTableViewNotMoney];
            break;
            
        default:
            break;
    }
    [self bringSearchTableViewToTop];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
//    self.extendedLayoutIncludesOpaqueBars = NO;
//    self.edgesForExtendedLayout = UIRectEdgeBottom | UIRectEdgeLeft | UIRectEdgeRight;
    
    
	//创建 设置按钮、登陆按钮、搜索框
	self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:[self createRefreshBtn], [self createSearchBox], nil];
    
	// segmented control as the custom title view
//	NSArray *segmentTextContent = [NSArray arrayWithObjects:@"股票型", @"混合型", @"债券型", @"货币型", @"QDII", nil];
//	UISegmentedControl *segmentedControl = [[UISegmentedControl alloc] initWithItems:segmentTextContent];
//	segmentedControl.selectedSegmentIndex = 0;
////	segmentedControl.autoresizingMask = UIViewAutoresizingFlexibleWidth;
//	segmentedControl.segmentedControlStyle = UISegmentedControlStyleBar;
//	segmentedControl.frame = CGRectMake(0, 0, 400, 29);
//	[segmentedControl addTarget:self action:@selector(segmentAction:) forControlEvents:UIControlEventValueChanged];
//    
//    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor blackColor],UITextAttributeTextColor,  [UIFont systemFontOfSize:14],UITextAttributeFont ,[UIColor blackColor],UITextAttributeTextShadowColor ,nil];
//    
//    [segmentedControl setTitleTextAttributes:dic forState:UIControlStateNormal];
//    
//    NSDictionary * dict = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],UITextAttributeTextColor,  [UIFont systemFontOfSize:14],UITextAttributeFont ,[UIColor blackColor],UITextAttributeTextShadowColor ,nil];
//    
//    [segmentedControl setTitleTextAttributes:dict forState:UIControlStateSelected];
//    
//	self.navigationItem.titleView = segmentedControl;
    
    
    CCSegmentedControl* segmentedControl = [[CCSegmentedControl alloc] initWithItems:@[@"股票型", @"混合型", @"债券型", @"货币型", @"QDII"] fontSize:16];
    segmentedControl.frame = CGRectMake(0, 0, 400, 29);
    //设置背景图片，或者设置颜色，或者使用默认白色外观
//    segmentedControl.backgroundImage = [UIImage imageNamed:@"segment_bg.png"];
    segmentedControl.backgroundColor = [UIColor clearColor];
    //阴影部分图片，不设置使用默认椭圆外观的stain
    UIImageView * selectedBgView  = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"img_33"]];
    selectedBgView.frame = CGRectMake(0, 0, 72, 24);
    
    segmentedControl.selectedStainView = selectedBgView;
    segmentedControl.selectedSegmentTextColor = [UIColor whiteColor];
    segmentedControl.segmentTextColor = [UIColor blackColor];
    [segmentedControl addTarget:self action:@selector(segmentAction:) forControlEvents:UIControlEventValueChanged];
    self.navigationItem.titleView = segmentedControl;
    
//    [self getFundNotMoneyData];
//    [self getFundMoneyData];
    
    
    if ([dbBase open]) {
        [data4 removeAllObjects];
        NSString *sqlFundMoneyQuery = [NSString stringWithFormat:@"SELECT * FROM FUNDMONEY ORDER BY pay_price DESC"];
        FMResultSet * rs = [dbBase executeQuery:sqlFundMoneyQuery];
        while ([rs next]) {
            FundMoneyData * data = [[FundMoneyData alloc]init];
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
            [data4 addObject:data];
        }
        [dbBase close];
        [self buildTableView4];
    }
    
    if ([dbBase open]) {
        [data1 removeAllObjects];
        [data2 removeAllObjects];
        [data3 removeAllObjects];
        [data5 removeAllObjects];
        NSString *sqlFundNotMoneyQuery = [NSString stringWithFormat:@"SELECT * FROM FUNDNOTMONEY ORDER BY limits DESC"];
        FMResultSet * rs = [dbBase executeQuery:sqlFundNotMoneyQuery];
        while ([rs next]) {
            FundNotMoneyData * data = [[FundNotMoneyData alloc]init];
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
            
            if ([data.invest_type isEqualToString: @"A"]) {
                [data1 addObject:data];
            }
            else if ([data.invest_type isEqualToString: @"B"]) {
                [data2 addObject:data];
            }
            else if ([data.invest_type isEqualToString: @"C"]) {
                [data3 addObject:data];
            }
            else {
                [data5 addObject:data];
            }
        }
        [dbBase close];
        [self buildTableView1];
        [self buildTableView2];
        [self buildTableView3];
        [self buildTableView5];
    }
    
    [self buildheaderTableViewNotMoney];
    [self buildheaderTableViewMoney];
    
    [self.view bringSubviewToFront:tableView1];
    [self.view bringSubviewToFront:headerTableViewNotMoney];
    
    [self bringSearchTableViewToTop];
}

- (void)buildheaderTableViewNotMoney
{
    headerTableViewNotMoney = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 1024, 42)];
    UIImage *syncBgImg = [UIImage imageNamed:@"xq_br_05"];
    headerTableViewNotMoney.backgroundColor = [[UIColor alloc] initWithPatternImage:syncBgImg];
    
    UILabel * _name1Label = [[UILabel alloc] initWithFrame:CGRectMake(19, 14, 98, 14)];
    [_name1Label setTextAlignment:NSTextAlignmentLeft];
    [_name1Label setTextColor:[UIColor colorWithHexValue:0xc4c7c7]];
    [_name1Label setFont:[UIFont systemFontOfSize:14]];
    [_name1Label setBackgroundColor:[UIColor clearColor]];
    _name1Label.text = @"基金名称";
    [headerTableViewNotMoney addSubview:_name1Label];
    UILabel * _name2Label = [[UILabel alloc] initWithFrame:CGRectMake(162, 14, 79, 14)];
    [_name2Label setTextAlignment:NSTextAlignmentRight];
    [_name2Label setTextColor:[UIColor colorWithHexValue:0xc4c7c7]];
    [_name2Label setFont:[UIFont systemFontOfSize:14]];
    [_name2Label setBackgroundColor:[UIColor clearColor]];
    _name2Label.text = @"投资类型";
    [headerTableViewNotMoney addSubview:_name2Label];
    UILabel * _name3Label = [[UILabel alloc] initWithFrame:CGRectMake(292, 14, 61, 14)];
    [_name3Label setTextAlignment:NSTextAlignmentRight];
    [_name3Label setTextColor:[UIColor colorWithHexValue:0xc4c7c7]];
    [_name3Label setFont:[UIFont systemFontOfSize:14]];
    [_name3Label setBackgroundColor:[UIColor clearColor]];
    _name3Label.text = @"申购状态";
    [headerTableViewNotMoney addSubview:_name3Label];
    UILabel * _name4Label = [[UILabel alloc] initWithFrame:CGRectMake(377, 14, 59, 14)];
    [_name4Label setTextAlignment:NSTextAlignmentRight];
    [_name4Label setTextColor:[UIColor colorWithHexValue:0xc4c7c7]];
    [_name4Label setFont:[UIFont systemFontOfSize:14]];
    [_name4Label setBackgroundColor:[UIColor clearColor]];
    _name4Label.text = @"赎回状态";
    [headerTableViewNotMoney addSubview:_name4Label];
    UILabel * _name5Label = [[UILabel alloc] initWithFrame:CGRectMake(466, 14, 84, 14)];
    [_name5Label setTextAlignment:NSTextAlignmentRight];
    [_name5Label setTextColor:[UIColor colorWithHexValue:0xc4c7c7]];
    [_name5Label setFont:[UIFont systemFontOfSize:14]];
    [_name5Label setBackgroundColor:[UIColor clearColor]];
    _name5Label.text = @"净值日期";
    [headerTableViewNotMoney addSubview:_name5Label];
    UILabel * _name6Label = [[UILabel alloc] initWithFrame:CGRectMake(589, 14, 80, 14)];
    [_name6Label setTextAlignment:NSTextAlignmentRight];
    [_name6Label setTextColor:[UIColor colorWithHexValue:0xc4c7c7]];
    [_name6Label setFont:[UIFont systemFontOfSize:14]];
    [_name6Label setBackgroundColor:[UIColor clearColor]];
    _name6Label.text = @"评级(三年)";
    [headerTableViewNotMoney addSubview:_name6Label];
    UILabel * _name7Label = [[UILabel alloc] initWithFrame:CGRectMake(695, 5, 85, 33)];
    [_name7Label setTextAlignment:NSTextAlignmentRight];
    [_name7Label setTextColor:[UIColor colorWithHexValue:0xc4c7c7]];
    [_name7Label setFont:[UIFont systemFontOfSize:14]];
    [_name7Label setBackgroundColor:[UIColor clearColor]];
    _name7Label.numberOfLines = 0;
    _name7Label.text = @"今年以来回报(%)";
    [headerTableViewNotMoney addSubview:_name7Label];
    UILabel * _name8Label = [[UILabel alloc] initWithFrame:CGRectMake(802, 5, 57, 33)];
    [_name8Label setTextAlignment:NSTextAlignmentRight];
    [_name8Label setTextColor:[UIColor colorWithHexValue:0xc4c7c7]];
    [_name8Label setFont:[UIFont systemFontOfSize:14]];
    [_name8Label setBackgroundColor:[UIColor clearColor]];
    _name8Label.numberOfLines = 0;
    _name8Label.text = @"单位净值(元)";
    [headerTableViewNotMoney addSubview:_name8Label];
    UILabel * _name9Label = [[UILabel alloc] initWithFrame:CGRectMake(883, 5, 60, 33)];
    [_name9Label setTextAlignment:NSTextAlignmentRight];
    [_name9Label setTextColor:[UIColor colorWithHexValue:0xc4c7c7]];
    [_name9Label setFont:[UIFont systemFontOfSize:14]];
    [_name9Label setBackgroundColor:[UIColor clearColor]];
    _name9Label.numberOfLines = 0;
    _name9Label.text = @"净值日变动(%)";
    [headerTableViewNotMoney addSubview:_name9Label];
    UILabel * _name10Label = [[UILabel alloc] initWithFrame:CGRectMake(972, 14, 40, 14)];
    [_name10Label setTextAlignment:NSTextAlignmentRight];
    [_name10Label setTextColor:[UIColor colorWithHexValue:0xc4c7c7]];
    [_name10Label setFont:[UIFont systemFontOfSize:14]];
    [_name10Label setBackgroundColor:[UIColor clearColor]];
    _name10Label.text = @"操作";
    [headerTableViewNotMoney addSubview:_name10Label];
    [self.view addSubview:headerTableViewNotMoney];
}

- (void)buildTableView1
{
    tableView1 = [[UITableView alloc]initWithFrame:CGRectMake(0, 42, 1024, 768-20-44-59-42)
                                             style:UITableViewStylePlain];
    tableView1.backgroundColor = [UIColor colorWithHexValue:0xf1f1ee];
    tableView1.dataSource = self;
    tableView1.delegate = self;
    tableView1.separatorStyle = UITableViewCellSeparatorStyleNone;
	[self.view addSubview:tableView1];
}

- (void)buildTableView2
{
    tableView2 = [[UITableView alloc]initWithFrame:CGRectMake(0, 42, 1024, 768-20-44-59-42)
                                             style:UITableViewStylePlain];
    tableView2.backgroundColor = [UIColor colorWithHexValue:0xf1f1ee];
    tableView2.dataSource = self;
    tableView2.delegate = self;
    tableView2.separatorStyle = UITableViewCellSeparatorStyleNone;
	[self.view addSubview:tableView2];
}

- (void)buildTableView3
{
    tableView3 = [[UITableView alloc]initWithFrame:CGRectMake(0, 42, 1024, 768-20-44-59-42)
                                             style:UITableViewStylePlain];
    tableView3.backgroundColor = [UIColor colorWithHexValue:0xf1f1ee];
    tableView3.dataSource = self;
    tableView3.delegate = self;
    tableView3.separatorStyle = UITableViewCellSeparatorStyleNone;
	[self.view addSubview:tableView3];
}

- (void)buildheaderTableViewMoney
{
    headerTableViewMoney = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 1024, 42)];
    UIImage *syncBgImg = [UIImage imageNamed:@"xq_br_05"];
    headerTableViewMoney.backgroundColor = [[UIColor alloc] initWithPatternImage:syncBgImg];
    
    UILabel * _name1Label = [[UILabel alloc] initWithFrame:CGRectMake(17, 14, 101, 14)];
    [_name1Label setTextAlignment:NSTextAlignmentLeft];
    [_name1Label setTextColor:[UIColor colorWithHexValue:0xc4c7c7]];
    [_name1Label setFont:[UIFont systemFontOfSize:14]];
    [_name1Label setBackgroundColor:[UIColor clearColor]];
    _name1Label.text = @"基金名称";
    [headerTableViewMoney addSubview:_name1Label];
    UILabel * _name2Label = [[UILabel alloc] initWithFrame:CGRectMake(158, 14, 83, 14)];
    [_name2Label setTextAlignment:NSTextAlignmentRight];
    [_name2Label setTextColor:[UIColor colorWithHexValue:0xc4c7c7]];
    [_name2Label setFont:[UIFont systemFontOfSize:14]];
    [_name2Label setBackgroundColor:[UIColor clearColor]];
    _name2Label.text = @"投资类型";
    [headerTableViewMoney addSubview:_name2Label];
    UILabel * _name3Label = [[UILabel alloc] initWithFrame:CGRectMake(276, 14, 56, 14)];
    [_name3Label setTextAlignment:NSTextAlignmentRight];
    [_name3Label setTextColor:[UIColor colorWithHexValue:0xc4c7c7]];
    [_name3Label setFont:[UIFont systemFontOfSize:14]];
    [_name3Label setBackgroundColor:[UIColor clearColor]];
    _name3Label.text = @"申购状态";
    [headerTableViewMoney addSubview:_name3Label];
    UILabel * _name4Label = [[UILabel alloc] initWithFrame:CGRectMake(360, 14, 58, 14)];
    [_name4Label setTextAlignment:NSTextAlignmentRight];
    [_name4Label setTextColor:[UIColor colorWithHexValue:0xc4c7c7]];
    [_name4Label setFont:[UIFont systemFontOfSize:14]];
    [_name4Label setBackgroundColor:[UIColor clearColor]];
    _name4Label.text = @"赎回状态";
    [headerTableViewMoney addSubview:_name4Label];
    UILabel * _name5Label = [[UILabel alloc] initWithFrame:CGRectMake(447, 14, 81, 14)];
    [_name5Label setTextAlignment:NSTextAlignmentRight];
    [_name5Label setTextColor:[UIColor colorWithHexValue:0xc4c7c7]];
    [_name5Label setFont:[UIFont systemFontOfSize:14]];
    [_name5Label setBackgroundColor:[UIColor clearColor]];
    _name5Label.text = @"净值日期";
    [headerTableViewMoney addSubview:_name5Label];
    UILabel * _name6Label = [[UILabel alloc] initWithFrame:CGRectMake(573, 14, 67, 14)];
    [_name6Label setTextAlignment:NSTextAlignmentRight];
    [_name6Label setTextColor:[UIColor colorWithHexValue:0xc4c7c7]];
    [_name6Label setFont:[UIFont systemFontOfSize:14]];
    [_name6Label setBackgroundColor:[UIColor clearColor]];
    _name6Label.text = @"万分收益";
    [headerTableViewMoney addSubview:_name6Label];
    UILabel * _name7Label = [[UILabel alloc] initWithFrame:CGRectMake(669, 5, 82, 33)];
    [_name7Label setTextAlignment:NSTextAlignmentRight];
    [_name7Label setTextColor:[UIColor colorWithHexValue:0xc4c7c7]];
    [_name7Label setFont:[UIFont systemFontOfSize:14]];
    [_name7Label setBackgroundColor:[UIColor clearColor]];
    _name7Label.numberOfLines = 0;
    _name7Label.text = @"今年以来回报(%)";
    [headerTableViewMoney addSubview:_name7Label];
    UILabel * _name8Label = [[UILabel alloc] initWithFrame:CGRectMake(787, 5, 59, 33)];
    [_name8Label setTextAlignment:NSTextAlignmentRight];
    [_name8Label setTextColor:[UIColor colorWithHexValue:0xc4c7c7]];
    [_name8Label setFont:[UIFont systemFontOfSize:14]];
    [_name8Label setBackgroundColor:[UIColor clearColor]];
    _name8Label.numberOfLines = 0;
    _name8Label.text = @"七日年化收益率";
    [headerTableViewMoney addSubview:_name8Label];
    UILabel * _name9Label = [[UILabel alloc] initWithFrame:CGRectMake(883, 5, 60, 33)];
    [_name9Label setTextAlignment:NSTextAlignmentRight];
    [_name9Label setTextColor:[UIColor colorWithHexValue:0xc4c7c7]];
    [_name9Label setFont:[UIFont systemFontOfSize:14]];
    [_name9Label setBackgroundColor:[UIColor clearColor]];
    _name9Label.numberOfLines = 0;
    _name9Label.text = @"净值日变动(%)";
    [headerTableViewMoney addSubview:_name9Label];
    UILabel * _name10Label = [[UILabel alloc] initWithFrame:CGRectMake(972, 14, 40, 14)];
    [_name10Label setTextAlignment:NSTextAlignmentLeft];
    [_name10Label setTextColor:[UIColor colorWithHexValue:0xc4c7c7]];
    [_name10Label setFont:[UIFont systemFontOfSize:14]];
    [_name10Label setBackgroundColor:[UIColor clearColor]];
    _name10Label.text = @"操作";
    [headerTableViewMoney addSubview:_name10Label];
    [self.view addSubview:headerTableViewMoney];
}

- (void)buildTableView4
{
    tableView4 = [[UITableView alloc]initWithFrame:CGRectMake(0, 42, 1024, 768-20-44-59-42)
                                             style:UITableViewStylePlain];
    tableView4.backgroundColor = [UIColor colorWithHexValue:0xf1f1ee];
    tableView4.dataSource = self;
    tableView4.delegate = self;
    tableView4.separatorStyle = UITableViewCellSeparatorStyleNone;
	[self.view addSubview:tableView4];
}

- (void)buildTableView5
{
    tableView5 = [[UITableView alloc]initWithFrame:CGRectMake(0, 42, 1024, 768-20-44-59-42)
                                             style:UITableViewStylePlain];
    tableView5.backgroundColor = [UIColor colorWithHexValue:0xf1f1ee];
    tableView5.dataSource = self;
    tableView5.delegate = self;
    tableView5.separatorStyle = UITableViewCellSeparatorStyleNone;
	[self.view addSubview:tableView5];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == tableView1) {
        return data1.count;
    }
    if (tableView == tableView2) {
        return data2.count;
    }
    if (tableView == tableView3) {
        return data3.count;
    }
    if (tableView == tableView4) {
        return data4.count;
    }
    if (tableView == tableView5) {
        return data5.count;
    }
    else if (tableView == searchTableView) {
        return searchArray.count;
    }
    return 0;
}

- (void)operateBtnPress:(id)sender
{
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == tableView1 || tableView == tableView2 || tableView == tableView3 || tableView == tableView5) {
        static NSString * cellID = @"tableViewNotMoneyCellIdentifier";
        UITableViewCell * cell = (UITableViewCell *)[tableView1 dequeueReusableCellWithIdentifier:cellID];
        if (cell == nil)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
            
            UILabel * _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(19, 7, 98, 16)];
            [_nameLabel setTextAlignment:NSTextAlignmentLeft];
            [_nameLabel setTextColor:[UIColor colorWithHexValue:0x333333]];
            [_nameLabel setFont:[UIFont systemFontOfSize:16]];
            [_nameLabel setBackgroundColor:[UIColor clearColor]];
            _nameLabel.tag = 11;
            [cell addSubview:_nameLabel];
            UILabel * _name1Label = [[UILabel alloc] initWithFrame:CGRectMake(19, 27, 98, 14)];
            [_name1Label setTextAlignment:NSTextAlignmentLeft];
            [_name1Label setTextColor:[UIColor colorWithHexValue:0x333333]];
            [_name1Label setFont:[UIFont systemFontOfSize:14]];
            [_name1Label setBackgroundColor:[UIColor clearColor]];
            _name1Label.tag = 1;
            [cell addSubview:_name1Label];
            UILabel * _name2Label = [[UILabel alloc] initWithFrame:CGRectMake(162, 16, 79, 16)];
            [_name2Label setTextAlignment:NSTextAlignmentRight];
            [_name2Label setTextColor:[UIColor colorWithHexValue:0x333333]];
            [_name2Label setFont:[UIFont systemFontOfSize:16]];
            [_name2Label setBackgroundColor:[UIColor clearColor]];
            _name2Label.tag = 2;
            [cell addSubview:_name2Label];
            UILabel * _name3Label = [[UILabel alloc] initWithFrame:CGRectMake(292, 16, 61, 16)];
            [_name3Label setTextAlignment:NSTextAlignmentRight];
            [_name3Label setTextColor:[UIColor colorWithHexValue:0x333333]];
            [_name3Label setFont:[UIFont systemFontOfSize:16]];
            [_name3Label setBackgroundColor:[UIColor clearColor]];
            _name3Label.tag = 3;
            [cell addSubview:_name3Label];
            UILabel * _name4Label = [[UILabel alloc] initWithFrame:CGRectMake(377, 16, 59, 16)];
            [_name4Label setTextAlignment:NSTextAlignmentRight];
            [_name4Label setTextColor:[UIColor colorWithHexValue:0x333333]];
            [_name4Label setFont:[UIFont systemFontOfSize:16]];
            [_name4Label setBackgroundColor:[UIColor clearColor]];
            _name4Label.tag = 4;
            [cell addSubview:_name4Label];
            UILabel * _name5Label = [[UILabel alloc] initWithFrame:CGRectMake(466, 16, 84, 16)];
            [_name5Label setTextAlignment:NSTextAlignmentRight];
            [_name5Label setTextColor:[UIColor colorWithHexValue:0x333333]];
            [_name5Label setFont:[UIFont systemFontOfSize:16]];
            [_name5Label setBackgroundColor:[UIColor clearColor]];
            _name5Label.tag = 5;
            [cell addSubview:_name5Label];
//            UILabel * _name6Label = [[UILabel alloc] initWithFrame:CGRectMake(530, 15, 100, 18)];
//            [_name6Label setTextAlignment:NSTextAlignmentCenter];
//            [_name6Label setTextColor:[UIColor colorWithHexValue:0x333333]];
//            [_name6Label setFont:[UIFont systemFontOfSize:18]];
//            [_name6Label setBackgroundColor:[UIColor clearColor]];
//            _name6Label.tag = 6;
//            [cell addSubview:_name6Label];
            
            GradeView * gradeView = [[GradeView alloc]initWithFrame:CGRectMake(589, 16, 80, 16)];
            gradeView.tag = 6;
            [cell addSubview:gradeView];
            UILabel * _name7Label = [[UILabel alloc] initWithFrame:CGRectMake(695, 16, 85, 16)];
            [_name7Label setTextAlignment:NSTextAlignmentRight];
            [_name7Label setTextColor:[UIColor colorWithHexValue:0x333333]];
            [_name7Label setFont:[UIFont systemFontOfSize:16]];
            [_name7Label setBackgroundColor:[UIColor clearColor]];
            _name7Label.numberOfLines = 0;
            _name7Label.tag = 7;
            [cell addSubview:_name7Label];
            UILabel * _name8Label = [[UILabel alloc] initWithFrame:CGRectMake(802, 16, 57, 16)];
            [_name8Label setTextAlignment:NSTextAlignmentRight];
            [_name8Label setTextColor:[UIColor colorWithHexValue:0x333333]];
            [_name8Label setFont:[UIFont systemFontOfSize:16]];
            [_name8Label setBackgroundColor:[UIColor clearColor]];
            _name8Label.numberOfLines = 0;
            _name8Label.tag = 8;
            [cell addSubview:_name8Label];
            UILabel * _name9Label = [[UILabel alloc] initWithFrame:CGRectMake(883, 16, 60, 16)];
            [_name9Label setTextAlignment:NSTextAlignmentRight];
            [_name9Label setTextColor:[UIColor colorWithHexValue:0x333333]];
            [_name9Label setFont:[UIFont systemFontOfSize:16]];
            [_name9Label setBackgroundColor:[UIColor clearColor]];
            _name9Label.numberOfLines = 0;
            _name9Label.tag = 9;
            [cell addSubview:_name9Label];
//            UILabel * _name10Label = [[UILabel alloc] initWithFrame:CGRectMake(980, 15, 40, 18)];
//            [_name10Label setTextAlignment:NSTextAlignmentCenter];
//            [_name10Label setTextColor:[UIColor colorWithHexValue:0x333333]];
//            [_name10Label setFont:[UIFont systemFontOfSize:18]];
//            [_name10Label setBackgroundColor:[UIColor clearColor]];
//            _name10Label.tag = 10;
//            [cell addSubview:_name10Label];
            UIButton * operateBtn = [[UIButton alloc] initWithFrame:CGRectMake(994, 16, 16, 16)];
            [operateBtn setBackgroundImage:[UIImage imageNamed:@"img_unstar"] forState:UIControlStateNormal];
            [operateBtn addTarget:self action:@selector(operateBtnPress:) forControlEvents:UIControlEventTouchUpInside];
            [cell addSubview:operateBtn];
            
            UIView * lineDark = [[UIView alloc]initWithFrame:CGRectMake(0, 48, 1024, 1)];
            lineDark.backgroundColor = [UIColor colorWithHexValue:0xd6d7d4];
            [cell addSubview:lineDark];
            UIView * lineLight = [[UIView alloc]initWithFrame:CGRectMake(0, 49, 1024, 1)];
            lineLight.backgroundColor = [UIColor colorWithHexValue:0xf8f9f6];
            [cell addSubview:lineLight];
        }
        cell.frame = CGRectMake(0, 0, 1024, 50);
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor clearColor];
        
        FundNotMoneyData * data = nil;
        if (tableView == tableView1) {
            data = [data1 objectAtIndex:indexPath.row];
        }
        if (tableView == tableView2) {
            data = [data2 objectAtIndex:indexPath.row];
        }
        if (tableView == tableView3) {
            data = [data3 objectAtIndex:indexPath.row];
        }
        if (tableView == tableView5) {
            data = [data5 objectAtIndex:indexPath.row];
        }
        for (UIView * v in cell.subviews) {
            if ([v isKindOfClass:[UILabel class]]) {
                UILabel * label = (UILabel *)v;
                if (label.tag == 11) {
                    label.text = data.name;
                }
                if (label.tag == 1) {
                    label.text = [NSString stringWithFormat:@"%d", data.code];
                }
                if (label.tag == 2) {
                    if ([data.invest_type isEqualToString:@"A"]) {
                        label.text = @"股票型";
                    }
                    if ([data.invest_type isEqualToString:@"B"]) {
                        label.text = @"普通债券型";
                    }
                    if ([data.invest_type isEqualToString:@"C"]) {
                        label.text = @"激进债券";
                    }
                    if ([data.invest_type isEqualToString:@"D"]) {
                        label.text = @"纯债基金";
                    }
                    if ([data.invest_type isEqualToString:@"E"]) {
                        label.text = @"普通混合型";
                    }
                    if ([data.invest_type isEqualToString:@"F"]) {
                        label.text = @"保守混合型";
                    }
                    if ([data.invest_type isEqualToString:@"G"]) {
                        label.text = @"激进混合型";
                    }
                    if ([data.invest_type isEqualToString:@"H"]) {
                        label.text = @"货币型";
                    }
                    if ([data.invest_type isEqualToString:@"I"]) {
                        label.text = @"短债基金";
                    }
                    if ([data.invest_type isEqualToString:@"J"]) {
                        label.text = @"FOF";
                    }
                    if ([data.invest_type isEqualToString:@"K"]) {
                        label.text = @"保本基金";
                    }
                    if ([data.invest_type isEqualToString:@"L"]) {
                        label.text = @"普通型指数基金";
                    }
                    if ([data.invest_type isEqualToString:@"M"]) {
                        label.text = @"增强型指数基金";
                    }
                    if ([data.invest_type isEqualToString:@"N"]) {
                        label.text = @"分级基金";
                    }
                    if ([data.invest_type isEqualToString:@"O"]) {
                        label.text = @"其它";
                    }
                }
                if (label.tag == 3) {
                    if (data.pur_status == 0) {
                        label.text = @"关闭";
                    }
                    else {
                        label.text = @"开放";
                    }
                }
                if (label.tag == 4) {
                    if (data.redeem_status == 0) {
                        label.text = @"关闭";
                    }
                    else {
                        label.text = @"开放";
                    }
                }
                if (label.tag == 5) {
                    label.text = data.date;
                }
//                if (label.tag == 6) {
//                    label.text = [NSString stringWithFormat:@"%@", data.grade];
//                }
                if (label.tag == 7) {
                    if ([data.rr_this_year isEqualToString:@""]) {
                        label.text = @"--";
                    }
                    else {
                        label.text = [NSString stringWithFormat:@"%.02f", [data.rr_this_year floatValue]];
                    }
                }
                if (label.tag == 8) {
                    label.text = [NSString stringWithFormat:@"%.03f", [data.net_value floatValue]];
                }
                if (label.tag == 9) {
                    label.text = [NSString stringWithFormat:@"%.02f", [data.limits floatValue]*100];
                }
//                if (label.tag == 10) {
//                    label.text = @"";
//                }
            }
            if ([v isKindOfClass:[GradeView class]]) {
                GradeView * gradeView = (GradeView *)v;
                [gradeView setGrade:[data.grade floatValue]];
            }
        }
        cell.tag = data.code;
        
        //    [cell configWithData:[self.listDatas objectAtIndex:indexPath.row]];
        
        return cell;
    }
    else if (tableView == tableView4) {
        static NSString * cellID = @"tableView4CellIdentifier";
        UITableViewCell * cell = (UITableViewCell *)[tableView4 dequeueReusableCellWithIdentifier:cellID];
        if (cell == nil)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
            
            UILabel * _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(17, 7, 101, 16)];
            [_nameLabel setTextAlignment:NSTextAlignmentLeft];
            [_nameLabel setTextColor:[UIColor colorWithHexValue:0x333333]];
            [_nameLabel setFont:[UIFont systemFontOfSize:16]];
            [_nameLabel setBackgroundColor:[UIColor clearColor]];
            _nameLabel.tag = 11;
            [cell addSubview:_nameLabel];
            UILabel * _name1Label = [[UILabel alloc] initWithFrame:CGRectMake(17, 27, 101, 14)];
            [_name1Label setTextAlignment:NSTextAlignmentLeft];
            [_name1Label setTextColor:[UIColor colorWithHexValue:0x333333]];
            [_name1Label setFont:[UIFont systemFontOfSize:14]];
            [_name1Label setBackgroundColor:[UIColor clearColor]];
            _name1Label.tag = 1;
            [cell addSubview:_name1Label];
            UILabel * _name2Label = [[UILabel alloc] initWithFrame:CGRectMake(168, 16, 83, 16)];
            [_name2Label setTextAlignment:NSTextAlignmentRight];
            [_name2Label setTextColor:[UIColor colorWithHexValue:0x333333]];
            [_name2Label setFont:[UIFont systemFontOfSize:16]];
            [_name2Label setBackgroundColor:[UIColor clearColor]];
            _name2Label.tag = 2;
            [cell addSubview:_name2Label];
            UILabel * _name3Label = [[UILabel alloc] initWithFrame:CGRectMake(276, 16, 56, 16)];
            [_name3Label setTextAlignment:NSTextAlignmentRight];
            [_name3Label setTextColor:[UIColor colorWithHexValue:0x333333]];
            [_name3Label setFont:[UIFont systemFontOfSize:16]];
            [_name3Label setBackgroundColor:[UIColor clearColor]];
            _name3Label.tag = 3;
            [cell addSubview:_name3Label];
            UILabel * _name4Label = [[UILabel alloc] initWithFrame:CGRectMake(360, 16, 58, 16)];
            [_name4Label setTextAlignment:NSTextAlignmentRight];
            [_name4Label setTextColor:[UIColor colorWithHexValue:0x333333]];
            [_name4Label setFont:[UIFont systemFontOfSize:16]];
            [_name4Label setBackgroundColor:[UIColor clearColor]];
            _name4Label.tag = 4;
            [cell addSubview:_name4Label];
            UILabel * _name5Label = [[UILabel alloc] initWithFrame:CGRectMake(447, 16, 83, 16)];
            [_name5Label setTextAlignment:NSTextAlignmentRight];
            [_name5Label setTextColor:[UIColor colorWithHexValue:0x333333]];
            [_name5Label setFont:[UIFont systemFontOfSize:16]];
            [_name5Label setBackgroundColor:[UIColor clearColor]];
            _name5Label.tag = 5;
            [cell addSubview:_name5Label];
            UILabel * _name6Label = [[UILabel alloc] initWithFrame:CGRectMake(573, 16, 67, 16)];
            [_name6Label setTextAlignment:NSTextAlignmentRight];
            [_name6Label setTextColor:[UIColor colorWithHexValue:0x333333]];
            [_name6Label setFont:[UIFont systemFontOfSize:16]];
            [_name6Label setBackgroundColor:[UIColor clearColor]];
            _name6Label.tag = 6;
            [cell addSubview:_name6Label];
            UILabel * _name7Label = [[UILabel alloc] initWithFrame:CGRectMake(669, 16, 82, 16)];
            [_name7Label setTextAlignment:NSTextAlignmentRight];
            [_name7Label setTextColor:[UIColor colorWithHexValue:0x333333]];
            [_name7Label setFont:[UIFont systemFontOfSize:16]];
            [_name7Label setBackgroundColor:[UIColor clearColor]];
            _name7Label.numberOfLines = 0;
            _name7Label.tag = 7;
            [cell addSubview:_name7Label];
            UILabel * _name8Label = [[UILabel alloc] initWithFrame:CGRectMake(787, 16, 59, 16)];
            [_name8Label setTextAlignment:NSTextAlignmentRight];
            [_name8Label setTextColor:[UIColor colorWithHexValue:0x333333]];
            [_name8Label setFont:[UIFont systemFontOfSize:16]];
            [_name8Label setBackgroundColor:[UIColor clearColor]];
            _name8Label.numberOfLines = 0;
            _name8Label.tag = 8;
            [cell addSubview:_name8Label];
            UILabel * _name9Label = [[UILabel alloc] initWithFrame:CGRectMake(883, 16, 60, 16)];
            [_name9Label setTextAlignment:NSTextAlignmentRight];
            [_name9Label setTextColor:[UIColor colorWithHexValue:0x333333]];
            [_name9Label setFont:[UIFont systemFontOfSize:16]];
            [_name9Label setBackgroundColor:[UIColor clearColor]];
            _name9Label.numberOfLines = 0;
            _name9Label.tag = 9;
            [cell addSubview:_name9Label];
//            UILabel * _name10Label = [[UILabel alloc] initWithFrame:CGRectMake(980, 15, 40, 18)];
//            [_name10Label setTextAlignment:NSTextAlignmentCenter];
//            [_name10Label setTextColor:[UIColor colorWithHexValue:0x333333]];
//            [_name10Label setFont:[UIFont systemFontOfSize:18]];
//            [_name10Label setBackgroundColor:[UIColor clearColor]];
//            _name10Label.tag = 10;
//            [cell addSubview:_name10Label];
            UIButton * operateBtn = [[UIButton alloc] initWithFrame:CGRectMake(984, 16, 16, 16)];
            [operateBtn setBackgroundImage:[UIImage imageNamed:@"img_unstar"] forState:UIControlStateNormal];
            [operateBtn addTarget:self action:@selector(operateBtnPress:) forControlEvents:UIControlEventTouchUpInside];
            [cell addSubview:operateBtn];
            
            UIView * lineDark = [[UIView alloc]initWithFrame:CGRectMake(0, 48, 1024, 1)];
            lineDark.backgroundColor = [UIColor colorWithHexValue:0xd6d7d4];
            [cell addSubview:lineDark];
            UIView * lineLight = [[UIView alloc]initWithFrame:CGRectMake(0, 49, 1024, 1)];
            lineLight.backgroundColor = [UIColor colorWithHexValue:0xf8f9f6];
            [cell addSubview:lineLight];
        }
        cell.frame = CGRectMake(0, 0, 1024, 50);
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor clearColor];
        
        
        FundMoneyData * data = [data4 objectAtIndex:indexPath.row];
        for (UIView * v in cell.subviews) {
            if ([v isKindOfClass:[UILabel class]]) {
                UILabel * label = (UILabel *)v;
                if (label.tag == 11) {
                    label.text = data.name;
                }
                if (label.tag == 1) {
                    label.text = [NSString stringWithFormat:@"%d", data.code];
                }
                if (label.tag == 2) {
                    if ([data.invest_type isEqualToString:@"A"]) {
                        label.text = @"股票型";
                    }
                    if ([data.invest_type isEqualToString:@"B"]) {
                        label.text = @"普通债券型";
                    }
                    if ([data.invest_type isEqualToString:@"C"]) {
                        label.text = @"激进债券";
                    }
                    if ([data.invest_type isEqualToString:@"D"]) {
                        label.text = @"纯债基金";
                    }
                    if ([data.invest_type isEqualToString:@"E"]) {
                        label.text = @"普通混合型";
                    }
                    if ([data.invest_type isEqualToString:@"F"]) {
                        label.text = @"保守混合型";
                    }
                    if ([data.invest_type isEqualToString:@"G"]) {
                        label.text = @"激进混合型";
                    }
                    if ([data.invest_type isEqualToString:@"H"]) {
                        label.text = @"货币型";
                    }
                    if ([data.invest_type isEqualToString:@"I"]) {
                        label.text = @"短债基金";
                    }
                    if ([data.invest_type isEqualToString:@"J"]) {
                        label.text = @"FOF";
                    }
                    if ([data.invest_type isEqualToString:@"K"]) {
                        label.text = @"保本基金";
                    }
                    if ([data.invest_type isEqualToString:@"L"]) {
                        label.text = @"普通型指数基金";
                    }
                    if ([data.invest_type isEqualToString:@"M"]) {
                        label.text = @"增强型指数基金";
                    }
                    if ([data.invest_type isEqualToString:@"N"]) {
                        label.text = @"分级基金";
                    }
                    if ([data.invest_type isEqualToString:@"O"]) {
                        label.text = @"其它";
                    }
                }
                if (label.tag == 3) {
                    if (data.pur_status == 0) {
                        label.text = @"关闭";
                    }
                    else {
                        label.text = @"开放";
                    }
                }
                if (label.tag == 4) {
                    if (data.redeem_status == 0) {
                        label.text = @"关闭";
                    }
                    else {
                        label.text = @"开放";
                    }
                }
                if (label.tag == 5) {
                    label.text = data.date;
                }
                if (label.tag == 6) {
                    label.text = [NSString stringWithFormat:@"%.04f", [data.pay_price floatValue]];
                }
                if (label.tag == 7) {
                    if ([data.rr_this_year isEqualToString:@""]) {
                        label.text = @"--";
                    }
                    else {
                        label.text = [NSString stringWithFormat:@"%.02f", [data.rr_this_year floatValue]];
                    }
                }
                if (label.tag == 8) {
                    if ([data.rr_this_year isEqualToString:@""]) {
                        label.text = @"--";
                    }
                    else {
                        label.text = [NSString stringWithFormat:@"%.03f", [data.seven_areturn floatValue]];
                    }
                }
                if (label.tag == 9) {
                    label.text = [NSString stringWithFormat:@"%@", @"--"];
                }
                if (label.tag == 10) {
                    label.text = @"";
                }
            }
        }
        cell.tag = data.code;
        //    [cell configWithData:[self.listDatas objectAtIndex:indexPath.row]];
        
        return cell;
    }
    else if (tableView == searchTableView) {
        static NSString * cellID = @"searchTableViewCellIdentifier";
        UITableViewCell * cell = (UITableViewCell *)[searchTableView dequeueReusableCellWithIdentifier:cellID];
        if (cell == nil)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
            
            cell.frame = CGRectMake(0, 0, 290, 44);
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            UILabel * _codeLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 14, 80, 16)];
            [_codeLabel setTextAlignment:NSTextAlignmentLeft];
            [_codeLabel setTextColor:[UIColor colorWithHexValue:0x464646]];
            [_codeLabel setFont:[UIFont systemFontOfSize:12]];
            [_codeLabel setBackgroundColor:[UIColor clearColor]];
            _codeLabel.tag = 1;
            [cell addSubview:_codeLabel];
            UILabel * _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(105, 14, 180, 16)];
            [_nameLabel setTextAlignment:NSTextAlignmentLeft];
            [_nameLabel setTextColor:[UIColor colorWithHexValue:0x464646]];
            [_nameLabel setFont:[UIFont systemFontOfSize:12]];
            [_nameLabel setBackgroundColor:[UIColor clearColor]];
            _nameLabel.tag = 2;
            [cell addSubview:_nameLabel];
            UIView * line = [[UIView alloc]initWithFrame:CGRectMake(0, 44, 290, 1)];
            line.backgroundColor = [UIColor colorWithHexValue:0xf8f7f7];
            [cell addSubview:line];
        }
        
        FundInfoData * data = [searchArray objectAtIndex:indexPath.row];
        for (UIView * v in cell.subviews) {
            if ([v isKindOfClass:[UILabel class]]) {
                UILabel * label = (UILabel *)v;
                if (label.tag == 1) {
                    label.text = [NSString stringWithFormat:@"%d", data.fund_id];
                }
                if (label.tag == 2) {
                    label.text = data.fund_name;
                }
            }
        }
        cell.tag = data.fund_id;
        
        //    [cell configWithData:[self.listDatas objectAtIndex:indexPath.row]];
        
        return cell;
    }
    return nil;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == searchTableView) {
    return 45;
    }
    else {
        return 50;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell = [tableView cellForRowAtIndexPath:indexPath];
    if (tableView == searchTableView) {
        [self searchBtnOnPress:nil];
        DetailViewController * detailViewCtrl = [[DetailViewController alloc]initWithFundCode:cell.tag];
        [self.navigationController pushViewController:detailViewCtrl animated:YES];
    }
    else {
        DetailViewController * detailViewCtrl = [[DetailViewController alloc]initWithFundCode:cell.tag];
        [self.navigationController pushViewController:detailViewCtrl animated:YES];
    }
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

- (void) getFundNotMoneyRequestSuccess:(FundNotMoneyRequest *)request
{
	BOOL isRequestSuccess = [fundNotMoneyRequest isRequestSuccess];
    if (isRequestSuccess) {
        NSMutableArray * array = [fundNotMoneyRequest getDataArray];
        for (int i = 0; i < array.count; ++i) {
            FundNotMoneyData * data = (FundNotMoneyData *)[array objectAtIndex:i];
            if ([data.invest_type isEqualToString: @"A"]) {
                [data1 addObject:data];
            }
            else if ([data.invest_type isEqualToString: @"B"]) {
                [data2 addObject:data];
            }
            else if ([data.invest_type isEqualToString: @"C"]) {
                [data3 addObject:data];
            }
            else {
                [data5 addObject:data];
            }
        }
        [self buildTableView1];
        [self buildTableView2];
        [self buildTableView3];
        [self buildTableView5];
    }
    else {
    }
}

- (void) getFundNotMoneyRequestFailed:(FundNotMoneyRequest *)request
{
    
}

- (void)getFundNotMoneyData
{
    NSString * url = [NSString stringWithFormat:@"%@%@", HOST_NAME, VALUE_FUND_NOT_MONEY];
    NSMutableArray * array = [[NSMutableArray alloc]initWithCapacity:0];
    [array addObject:[NSString stringWithFormat:@"%@=%@", OPENID, OPENID_VALUE]];
    [array addObject:[NSString stringWithFormat:@"%@=%@", TYPE, DATA_FORMAT]];
    //    [array addObject:[NSString stringWithFormat:@"%@=%@", @"user_name", @"nico"]];
    //    [array addObject:[NSString stringWithFormat:@"%@=%@", @"access_token", @"B55228A75E12AE6B429810B3C3569316-n4"]];
    //    [array addObject:[NSString stringWithFormat:@"%@=%@", @"page_no", @"1"]];
    //    [array addObject:[NSString stringWithFormat:@"%@=%@", @"page_size", @"2"]];
    NSString * md5Result = [_UI md5EncParam:array];
    url = [url stringByAppendingString:md5Result];
    url = [url URLEncodedString];
    fundNotMoneyRequest = [[FundNotMoneyRequest alloc]initWithUrl:url];
    
	fundNotMoneyRequest.delegate = self;
    fundNotMoneyRequest.requestDidFinishSelector = @selector(getFundNotMoneyRequestSuccess:);
    fundNotMoneyRequest.requestDidFailedSelector = @selector(getFundNotMoneyRequestFailed:);
    
    [fundNotMoneyRequest sendRequest];
}

- (void) getFundMoneyRequestSuccess:(FundMoneyRequest *)request
{
	BOOL isRequestSuccess = [fundMoneyRequest isRequestSuccess];
    if (isRequestSuccess) {
        data4 = [fundMoneyRequest getDataArray];
        [self buildTableView4];
    }
    else {
    }
}

- (void) getFundMoneyRequestFailed:(FundMoneyRequest *)request
{
    
}

- (void)getFundMoneyData
{
    NSString * url = [NSString stringWithFormat:@"%@%@", HOST_NAME, VALUE_FUND_MONEY];
    NSMutableArray * array = [[NSMutableArray alloc]initWithCapacity:0];
    [array addObject:[NSString stringWithFormat:@"%@=%@", OPENID, OPENID_VALUE]];
    [array addObject:[NSString stringWithFormat:@"%@=%@", TYPE, DATA_FORMAT]];
    //    [array addObject:[NSString stringWithFormat:@"%@=%@", @"user_name", @"nico"]];
    //    [array addObject:[NSString stringWithFormat:@"%@=%@", @"access_token", @"B55228A75E12AE6B429810B3C3569316-n4"]];
//    [array addObject:[NSString stringWithFormat:@"%@=%@", @"page_no", @"1"]];
//    [array addObject:[NSString stringWithFormat:@"%@=%@", @"page_size", @"2"]];
    NSString * md5Result = [_UI md5EncParam:array];
    url = [url stringByAppendingString:md5Result];
    url = [url URLEncodedString];
    fundMoneyRequest = [[FundMoneyRequest alloc]initWithUrl:url];
    
	fundMoneyRequest.delegate = self;
    fundMoneyRequest.requestDidFinishSelector = @selector(getFundMoneyRequestSuccess:);
    fundMoneyRequest.requestDidFailedSelector = @selector(getFundMoneyRequestFailed:);
    
    [fundMoneyRequest sendRequest];
}

@end
