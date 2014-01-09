//
//  RankingViewController.m
//  FundPrj
//
//  Created by leesea on 13-11-4.
//  Copyright (c) 2013年 leesea. All rights reserved.
//

#import "RankingViewController.h"
#import "FundRankNotMoneyRequest.h"
#import "FundRankNotMoneyData.h"
#import "FundRankMoneyRequest.h"
#import "FundRankMoneyData.h"
#import <sqlite3.h>
#import "FundInfoData.h"
#import <QuartzCore/QuartzCore.h>
#import "DetailViewController.h"
#import "FMDatabase.h"
#import "FMDatabaseQueue.h"
#import "FundNotMoneyData.h"
#import "FundMoneyData.h"
#import "CCSegmentedControl.h"


#define DB_NAME    @"FundDB.sqlite"
#define NAME      @"name"
#define CODE       @"code"
#define PY   @"py"

@interface RankingViewController ()
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
    
    FundRankNotMoneyRequest * fundRankNotMoneyRequest;
    FundRankMoneyRequest * fundRankMoneyRequest;
    
    
    NSString *db_path;
    
    FMDatabase *dbBase;
    
    UITextField * searchBox;
    UIView * searchBg;
    UITableView * searchTableView;
    NSMutableArray * searchArray;
}

@end

@implementation RankingViewController

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

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden = NO;
	
    //	[self onNetConnected];
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
//    //	segmentedControl.autoresizingMask = UIViewAutoresizingFlexibleWidth;
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
    
    
//    [self getFundRankNotMoneyData];
    //    [self getFundRankMoneyData];
    
    if ([dbBase open]) {
        [data4 removeAllObjects];
        NSString *sqlFundRankMoneyQuery = [NSString stringWithFormat:@"SELECT * FROM FUNDRANKMONEY ORDER BY pay_price DESC"];
        FMResultSet * rs = [dbBase executeQuery:sqlFundRankMoneyQuery];
        while ([rs next]) {
            FundRankMoneyData * data = [[FundRankMoneyData alloc]init];
            data.name = [rs stringForColumn:@"name"];
            data.py = [rs stringForColumn:@"py"];
            data.date = [rs stringForColumn:@"date"];
            data.pay_price = [rs stringForColumn:@"pay_price"];
            data.seven_areturn = [rs stringForColumn:@"seven_areturn"];
            data.rr_one_month = [rs stringForColumn:@"rr_one_month"];
            data.rr_one_month_rank = [rs stringForColumn:@"rr_one_month_rank"];
            data.rr_three_month = [rs stringForColumn:@"rr_three_month"];
            data.rr_three_month_rank = [rs stringForColumn:@"rr_three_month_rank"];
            data.rr_six_month = [rs stringForColumn:@"rr_six_month"];
            data.rr_six_month_rank = [rs stringForColumn:@"rr_six_month_rank"];
            data.rr_this_year = [rs stringForColumn:@"rr_this_year"];
            data.rr_this_year_rank = [rs stringForColumn:@"rr_this_year_rank"];
            data.rr_one_year = [rs stringForColumn:@"rr_one_year"];
            data.rr_one_year_rank = [rs stringForColumn:@"rr_one_year_rank"];
            data.rr_two_year = [rs stringForColumn:@"rr_two_year"];
            data.rr_two_year_rank = [rs stringForColumn:@"rr_two_year_rank"];
            data.rr_three_year = [rs stringForColumn:@"rr_three_year"];
            data.rr_three_year_rank = [rs stringForColumn:@"rr_three_year_rank"];
            data.estb_date = [rs stringForColumn:@"estb_date"];
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
        NSString *sqlFundNotMoneyQuery = [NSString stringWithFormat:@"SELECT * FROM FUNDRANKNOTMONEY ORDER BY net_value DESC"];
        FMResultSet * rs = [dbBase executeQuery:sqlFundNotMoneyQuery];
        while ([rs next]) {
            FundRankNotMoneyData * data = [[FundRankNotMoneyData alloc]init];
            data.name = [rs stringForColumn:@"name"];
            data.py = [rs stringForColumn:@"py"];
            data.date = [rs stringForColumn:@"date"];
            data.net_value = [rs stringForColumn:@"net_value"];
            data.account_value = [rs stringForColumn:@"account_value"];
            data.rr_one_month = [rs stringForColumn:@"rr_one_month"];
            data.rr_one_month_rank = [rs stringForColumn:@"rr_one_month_rank"];
            data.rr_three_month = [rs stringForColumn:@"rr_three_month"];
            data.rr_three_month_rank = [rs stringForColumn:@"rr_three_month_rank"];
            data.rr_six_month = [rs stringForColumn:@"rr_six_month"];
            data.rr_six_month_rank = [rs stringForColumn:@"rr_six_month_rank"];
            data.rr_this_year = [rs stringForColumn:@"rr_this_year"];
            data.rr_this_year_rank = [rs stringForColumn:@"rr_this_year_rank"];
            data.rr_one_year = [rs stringForColumn:@"rr_one_year"];
            data.rr_one_year_rank = [rs stringForColumn:@"rr_one_year_rank"];
            data.rr_two_year = [rs stringForColumn:@"rr_two_year"];
            data.rr_two_year_rank = [rs stringForColumn:@"rr_two_year_rank"];
            data.rr_three_year = [rs stringForColumn:@"rr_three_year"];
            data.rr_three_year_rank = [rs stringForColumn:@"rr_three_year_rank"];
            data.estb_date = [rs stringForColumn:@"estb_date"];
            data.code = [rs intForColumn:@"code"];
            
            
            NSString *sqlFundNotMoneyQuery = [NSString stringWithFormat:@"SELECT * FROM FUNDNOTMONEY WHERE code = '%d'", data.code];
            FMResultSet * rs = [dbBase executeQuery:sqlFundNotMoneyQuery];
            while ([rs next]) {
                FundNotMoneyData * tempData = [[FundNotMoneyData alloc]init];
                tempData.invest_type = [rs stringForColumn:@"invest_type"];
                
                if ([tempData.invest_type isEqualToString: @"A"]) {
                    [data1 addObject:data];
                }
                else if ([tempData.invest_type isEqualToString: @"B"]) {
                    [data2 addObject:data];
                }
                else if ([tempData.invest_type isEqualToString: @"C"]) {
                    [data3 addObject:data];
                }
                else {
                    [data5 addObject:data];
                }
                break;
            }
        }
        [dbBase close];
        [self buildTableView1];
        [self buildTableView2];
        [self buildTableView3];
        [self buildTableView5];
    }
    
    [self buildheaderTableViewMoney];
    [self buildheaderTableViewNotMoney];
    
    [self.view bringSubviewToFront:tableView1];
    [self.view bringSubviewToFront:headerTableViewNotMoney];
    
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

- (void)buildheaderTableViewMoney
{
    headerTableViewMoney = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 1024, 42)];
    UIImage *syncBgImg = [UIImage imageNamed:@"list_07"];
    headerTableViewMoney.backgroundColor = [[UIColor alloc] initWithPatternImage:syncBgImg];
    
    UILabel * _name1Label = [[UILabel alloc] initWithFrame:CGRectMake(19, 14, 96, 14)];
    [_name1Label setTextAlignment:NSTextAlignmentLeft];
    [_name1Label setTextColor:[UIColor colorWithHexValue:0xc4c7c7]];
    [_name1Label setFont:[UIFont systemFontOfSize:14]];
    [_name1Label setBackgroundColor:[UIColor clearColor]];
    _name1Label.text = @"基金名称";
    [headerTableViewMoney addSubview:_name1Label];
    UILabel * _name2Label = [[UILabel alloc] initWithFrame:CGRectMake(146, 14, 80, 14)];
    [_name2Label setTextAlignment:NSTextAlignmentCenter];
    [_name2Label setTextColor:[UIColor colorWithHexValue:0xc4c7c7]];
    [_name2Label setFont:[UIFont systemFontOfSize:14]];
    [_name2Label setBackgroundColor:[UIColor clearColor]];
    _name2Label.text = @"日期";
    [headerTableViewMoney addSubview:_name2Label];
    UILabel * _name3Label = [[UILabel alloc] initWithFrame:CGRectMake(238, 14, 56, 14)];
    [_name3Label setTextAlignment:NSTextAlignmentRight];
    [_name3Label setTextColor:[UIColor colorWithHexValue:0xc4c7c7]];
    [_name3Label setFont:[UIFont systemFontOfSize:14]];
    [_name3Label setBackgroundColor:[UIColor clearColor]];
    _name3Label.text = @"万分收益";
    [headerTableViewMoney addSubview:_name3Label];
    UILabel * _name4Label = [[UILabel alloc] initWithFrame:CGRectMake(323, 5, 57, 35)];
    [_name4Label setTextAlignment:NSTextAlignmentRight];
    [_name4Label setTextColor:[UIColor colorWithHexValue:0xc4c7c7]];
    [_name4Label setFont:[UIFont systemFontOfSize:14]];
    [_name4Label setBackgroundColor:[UIColor clearColor]];
    _name4Label.numberOfLines = 0;
    _name4Label.text = @"七日年化收益率";
    [headerTableViewMoney addSubview:_name4Label];
    UILabel * _name5Label = [[UILabel alloc] initWithFrame:CGRectMake(413, 14, 43, 14)];
    [_name5Label setTextAlignment:NSTextAlignmentRight];
    [_name5Label setTextColor:[UIColor colorWithHexValue:0xc4c7c7]];
    [_name5Label setFont:[UIFont systemFontOfSize:14]];
    [_name5Label setBackgroundColor:[UIColor clearColor]];
    _name5Label.text = @"近1月";
    [headerTableViewMoney addSubview:_name5Label];
    UILabel * _name6Label = [[UILabel alloc] initWithFrame:CGRectMake(467, 14, 52, 14)];
    [_name6Label setTextAlignment:NSTextAlignmentRight];
    [_name6Label setTextColor:[UIColor colorWithHexValue:0xc4c7c7]];
    [_name6Label setFont:[UIFont systemFontOfSize:14]];
    [_name6Label setBackgroundColor:[UIColor clearColor]];
    _name6Label.text = @"近3月";
    [headerTableViewMoney addSubview:_name6Label];
    UILabel * _name7Label = [[UILabel alloc] initWithFrame:CGRectMake(535, 14, 46, 14)];
    [_name7Label setTextAlignment:NSTextAlignmentRight];
    [_name7Label setTextColor:[UIColor colorWithHexValue:0xc4c7c7]];
    [_name7Label setFont:[UIFont systemFontOfSize:14]];
    [_name7Label setBackgroundColor:[UIColor clearColor]];
    _name7Label.numberOfLines = 0;
    _name7Label.text = @"近6月";
    [headerTableViewMoney addSubview:_name7Label];
    UILabel * _name8Label = [[UILabel alloc] initWithFrame:CGRectMake(602, 14, 50, 14)];
    [_name8Label setTextAlignment:NSTextAlignmentRight];
    [_name8Label setTextColor:[UIColor colorWithHexValue:0xc4c7c7]];
    [_name8Label setFont:[UIFont systemFontOfSize:14]];
    [_name8Label setBackgroundColor:[UIColor clearColor]];
    _name8Label.numberOfLines = 0;
    _name8Label.text = @"近1年";
    [headerTableViewMoney addSubview:_name8Label];
    UILabel * _name9Label = [[UILabel alloc] initWithFrame:CGRectMake(677, 14, 42, 14)];
    [_name9Label setTextAlignment:NSTextAlignmentRight];
    [_name9Label setTextColor:[UIColor colorWithHexValue:0xc4c7c7]];
    [_name9Label setFont:[UIFont systemFontOfSize:14]];
    [_name9Label setBackgroundColor:[UIColor clearColor]];
    _name9Label.numberOfLines = 0;
    _name9Label.text = @"近2年";
    [headerTableViewMoney addSubview:_name9Label];
    UILabel * _name10Label = [[UILabel alloc] initWithFrame:CGRectMake(741, 14, 53, 14)];
    [_name10Label setTextAlignment:NSTextAlignmentRight];
    [_name10Label setTextColor:[UIColor colorWithHexValue:0xc4c7c7]];
    [_name10Label setFont:[UIFont systemFontOfSize:14]];
    [_name10Label setBackgroundColor:[UIColor clearColor]];
    _name10Label.text = @"近3年";
    [headerTableViewMoney addSubview:_name10Label];
    UILabel * _name11Label = [[UILabel alloc] initWithFrame:CGRectMake(813, 14, 52, 14)];
    [_name11Label setTextAlignment:NSTextAlignmentRight];
    [_name11Label setTextColor:[UIColor colorWithHexValue:0xc4c7c7]];
    [_name11Label setFont:[UIFont systemFontOfSize:14]];
    [_name11Label setBackgroundColor:[UIColor clearColor]];
    _name11Label.text = @"近年来";
    [headerTableViewMoney addSubview:_name11Label];
    UILabel * _name12Label = [[UILabel alloc] initWithFrame:CGRectMake(890, 14, 86, 14)];
    [_name12Label setTextAlignment:NSTextAlignmentRight];
    [_name12Label setTextColor:[UIColor colorWithHexValue:0xc4c7c7]];
    [_name12Label setFont:[UIFont systemFontOfSize:14]];
    [_name12Label setBackgroundColor:[UIColor clearColor]];
    _name12Label.text = @"成立日期";
    [headerTableViewMoney addSubview:_name12Label];
    UILabel * _name13Label = [[UILabel alloc] initWithFrame:CGRectMake(981, 14, 39, 14)];
    [_name13Label setTextAlignment:NSTextAlignmentRight];
    [_name13Label setTextColor:[UIColor colorWithHexValue:0xc4c7c7]];
    [_name13Label setFont:[UIFont systemFontOfSize:14]];
    [_name13Label setBackgroundColor:[UIColor clearColor]];
    _name13Label.text = @"操作";
    [headerTableViewMoney addSubview:_name13Label];
    [self.view addSubview:headerTableViewMoney];
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
    
    [self buildheaderTableViewMoney];
}

- (void)buildheaderTableViewNotMoney
{
    headerTableViewNotMoney = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 1024, 42)];
    UIImage *syncBgImg = [UIImage imageNamed:@"list_07"];
    headerTableViewNotMoney.backgroundColor = [[UIColor alloc] initWithPatternImage:syncBgImg];
    
    UILabel * _name1Label = [[UILabel alloc] initWithFrame:CGRectMake(20, 14, 97, 14)];
    [_name1Label setTextAlignment:NSTextAlignmentLeft];
    [_name1Label setTextColor:[UIColor colorWithHexValue:0xc4c7c7]];
    [_name1Label setFont:[UIFont systemFontOfSize:14]];
    [_name1Label setBackgroundColor:[UIColor clearColor]];
    _name1Label.text = @"基金名称";
    [headerTableViewNotMoney addSubview:_name1Label];
    UILabel * _name2Label = [[UILabel alloc] initWithFrame:CGRectMake(143, 14, 84, 14)];
    [_name2Label setTextAlignment:NSTextAlignmentCenter];
    [_name2Label setTextColor:[UIColor colorWithHexValue:0xc4c7c7]];
    [_name2Label setFont:[UIFont systemFontOfSize:14]];
    [_name2Label setBackgroundColor:[UIColor clearColor]];
    _name2Label.text = @"日期";
    [headerTableViewNotMoney addSubview:_name2Label];
    UILabel * _name3Label = [[UILabel alloc] initWithFrame:CGRectMake(240, 14, 58, 14)];
    [_name3Label setTextAlignment:NSTextAlignmentRight];
    [_name3Label setTextColor:[UIColor colorWithHexValue:0xc4c7c7]];
    [_name3Label setFont:[UIFont systemFontOfSize:14]];
    [_name3Label setBackgroundColor:[UIColor clearColor]];
    _name3Label.text = @"单位净值";
    [headerTableViewNotMoney addSubview:_name3Label];
    UILabel * _name4Label = [[UILabel alloc] initWithFrame:CGRectMake(329, 5, 57, 35)];
    [_name4Label setTextAlignment:NSTextAlignmentRight];
    [_name4Label setTextColor:[UIColor colorWithHexValue:0xc4c7c7]];
    [_name4Label setFont:[UIFont systemFontOfSize:14]];
    [_name4Label setBackgroundColor:[UIColor clearColor]];
    _name4Label.numberOfLines = 0;
    _name4Label.text = @"累计净值";
    [headerTableViewNotMoney addSubview:_name4Label];
    UILabel * _name5Label = [[UILabel alloc] initWithFrame:CGRectMake(406, 14, 43, 14)];
    [_name5Label setTextAlignment:NSTextAlignmentRight];
    [_name5Label setTextColor:[UIColor colorWithHexValue:0xc4c7c7]];
    [_name5Label setFont:[UIFont systemFontOfSize:14]];
    [_name5Label setBackgroundColor:[UIColor clearColor]];
    _name5Label.text = @"近1月";
    [headerTableViewNotMoney addSubview:_name5Label];
    UILabel * _name6Label = [[UILabel alloc] initWithFrame:CGRectMake(465, 14, 56, 14)];
    [_name6Label setTextAlignment:NSTextAlignmentRight];
    [_name6Label setTextColor:[UIColor colorWithHexValue:0xc4c7c7]];
    [_name6Label setFont:[UIFont systemFontOfSize:14]];
    [_name6Label setBackgroundColor:[UIColor clearColor]];
    _name6Label.text = @"近3月";
    [headerTableViewNotMoney addSubview:_name6Label];
    UILabel * _name7Label = [[UILabel alloc] initWithFrame:CGRectMake(532, 14, 51, 14)];
    [_name7Label setTextAlignment:NSTextAlignmentRight];
    [_name7Label setTextColor:[UIColor colorWithHexValue:0xc4c7c7]];
    [_name7Label setFont:[UIFont systemFontOfSize:14]];
    [_name7Label setBackgroundColor:[UIColor clearColor]];
    _name7Label.numberOfLines = 0;
    _name7Label.text = @"近6月";
    [headerTableViewNotMoney addSubview:_name7Label];
    UILabel * _name8Label = [[UILabel alloc] initWithFrame:CGRectMake(600, 14, 50, 14)];
    [_name8Label setTextAlignment:NSTextAlignmentRight];
    [_name8Label setTextColor:[UIColor colorWithHexValue:0xc4c7c7]];
    [_name8Label setFont:[UIFont systemFontOfSize:14]];
    [_name8Label setBackgroundColor:[UIColor clearColor]];
    _name8Label.numberOfLines = 0;
    _name8Label.text = @"近1年";
    [headerTableViewNotMoney addSubview:_name8Label];
    UILabel * _name9Label = [[UILabel alloc] initWithFrame:CGRectMake(665, 14, 58, 14)];
    [_name9Label setTextAlignment:NSTextAlignmentRight];
    [_name9Label setTextColor:[UIColor colorWithHexValue:0xc4c7c7]];
    [_name9Label setFont:[UIFont systemFontOfSize:14]];
    [_name9Label setBackgroundColor:[UIColor clearColor]];
    _name9Label.numberOfLines = 0;
    _name9Label.text = @"近2年";
    [headerTableViewNotMoney addSubview:_name9Label];
    UILabel * _name10Label = [[UILabel alloc] initWithFrame:CGRectMake(739, 14, 56, 14)];
    [_name10Label setTextAlignment:NSTextAlignmentRight];
    [_name10Label setTextColor:[UIColor colorWithHexValue:0xc4c7c7]];
    [_name10Label setFont:[UIFont systemFontOfSize:14]];
    [_name10Label setBackgroundColor:[UIColor clearColor]];
    _name10Label.text = @"近3年";
    [headerTableViewNotMoney addSubview:_name10Label];
    UILabel * _name11Label = [[UILabel alloc] initWithFrame:CGRectMake(817, 14, 52, 14)];
    [_name11Label setTextAlignment:NSTextAlignmentRight];
    [_name11Label setTextColor:[UIColor colorWithHexValue:0xc4c7c7]];
    [_name11Label setFont:[UIFont systemFontOfSize:14]];
    [_name11Label setBackgroundColor:[UIColor clearColor]];
    _name11Label.text = @"近年来";
    [headerTableViewNotMoney addSubview:_name11Label];
    UILabel * _name12Label = [[UILabel alloc] initWithFrame:CGRectMake(883, 14, 86, 14)];
    [_name12Label setTextAlignment:NSTextAlignmentRight];
    [_name12Label setTextColor:[UIColor colorWithHexValue:0xc4c7c7]];
    [_name12Label setFont:[UIFont systemFontOfSize:14]];
    [_name12Label setBackgroundColor:[UIColor clearColor]];
    _name12Label.text = @"成立日期";
    [headerTableViewNotMoney addSubview:_name12Label];
    UILabel * _name13Label = [[UILabel alloc] initWithFrame:CGRectMake(985, 14, 35, 14)];
    [_name13Label setTextAlignment:NSTextAlignmentRight];
    [_name13Label setTextColor:[UIColor colorWithHexValue:0xc4c7c7]];
    [_name13Label setFont:[UIFont systemFontOfSize:14]];
    [_name13Label setBackgroundColor:[UIColor clearColor]];
    _name13Label.text = @"操作";
    [headerTableViewNotMoney addSubview:_name13Label];
    [self.view addSubview:headerTableViewNotMoney];
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
    
    [self buildheaderTableViewNotMoney];
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
        return data1.count;
    }
    if (tableView == tableView3) {
        return data1.count;
    }
    if (tableView == tableView4) {
        return data4.count;
    }
    if (tableView == tableView5) {
        return data1.count;
    }
    else if (tableView == searchTableView) {
        return searchArray.count;
    }
    return 0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == tableView1 || tableView == tableView2 || tableView == tableView3 || tableView == tableView5) {
        static NSString * cellID = @"tableViewNotMoneyCellIdentifier";
        UITableViewCell * cell = (UITableViewCell *)[tableView1 dequeueReusableCellWithIdentifier:cellID];
        if (cell == nil)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
            
            UILabel * _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 7, 97, 16)];
            [_nameLabel setTextAlignment:NSTextAlignmentLeft];
            [_nameLabel setTextColor:[UIColor colorWithHexValue:0x333333]];
            [_nameLabel setFont:[UIFont systemFontOfSize:18]];
            [_nameLabel setBackgroundColor:[UIColor clearColor]];
            _nameLabel.tag = 0;
            [cell addSubview:_nameLabel];
            UILabel * _name1Label = [[UILabel alloc] initWithFrame:CGRectMake(20, 27, 97, 14)];
            [_name1Label setTextAlignment:NSTextAlignmentLeft];
            [_name1Label setTextColor:[UIColor colorWithHexValue:0x333333]];
            [_name1Label setFont:[UIFont systemFontOfSize:14]];
            [_name1Label setBackgroundColor:[UIColor clearColor]];
            _name1Label.tag = 1;
            [cell addSubview:_name1Label];
            UILabel * _name2Label = [[UILabel alloc] initWithFrame:CGRectMake(143, 15, 84, 18)];
            [_name2Label setTextAlignment:NSTextAlignmentRight];
            [_name2Label setTextColor:[UIColor colorWithHexValue:0x333333]];
            [_name2Label setFont:[UIFont systemFontOfSize:16]];
            [_name2Label setBackgroundColor:[UIColor clearColor]];
            _name2Label.tag = 2;
            [cell addSubview:_name2Label];
            UILabel * _name3Label = [[UILabel alloc] initWithFrame:CGRectMake(240, 15, 58, 18)];
            [_name3Label setTextAlignment:NSTextAlignmentRight];
            [_name3Label setTextColor:[UIColor colorWithHexValue:0x333333]];
            [_name3Label setFont:[UIFont systemFontOfSize:16]];
            [_name3Label setBackgroundColor:[UIColor clearColor]];
            _name3Label.tag = 3;
            [cell addSubview:_name3Label];
            UILabel * _name4Label = [[UILabel alloc] initWithFrame:CGRectMake(329, 15, 57, 18)];
            [_name4Label setTextAlignment:NSTextAlignmentRight];
            [_name4Label setTextColor:[UIColor colorWithHexValue:0x333333]];
            [_name4Label setFont:[UIFont systemFontOfSize:16]];
            [_name4Label setBackgroundColor:[UIColor clearColor]];
            _name4Label.tag = 4;
            [cell addSubview:_name4Label];
            UILabel * _name5Label = [[UILabel alloc] initWithFrame:CGRectMake(406, 15, 43, 18)];
            [_name5Label setTextAlignment:NSTextAlignmentRight];
            [_name5Label setTextColor:[UIColor colorWithHexValue:0x333333]];
            [_name5Label setFont:[UIFont systemFontOfSize:16]];
            [_name5Label setBackgroundColor:[UIColor clearColor]];
            _name5Label.tag = 5;
            [cell addSubview:_name5Label];
            UILabel * _name6Label = [[UILabel alloc] initWithFrame:CGRectMake(465, 15, 56, 18)];
            [_name6Label setTextAlignment:NSTextAlignmentRight];
            [_name6Label setTextColor:[UIColor colorWithHexValue:0x333333]];
            [_name6Label setFont:[UIFont systemFontOfSize:16]];
            [_name6Label setBackgroundColor:[UIColor clearColor]];
            _name6Label.tag = 6;
            [cell addSubview:_name6Label];
            UILabel * _name7Label = [[UILabel alloc] initWithFrame:CGRectMake(532, 15, 51, 18)];
            [_name7Label setTextAlignment:NSTextAlignmentRight];
            [_name7Label setTextColor:[UIColor colorWithHexValue:0x333333]];
            [_name7Label setFont:[UIFont systemFontOfSize:16]];
            [_name7Label setBackgroundColor:[UIColor clearColor]];
            _name7Label.numberOfLines = 0;
            _name7Label.tag = 7;
            [cell addSubview:_name7Label];
            UILabel * _name8Label = [[UILabel alloc] initWithFrame:CGRectMake(600, 15, 50, 18)];
            [_name8Label setTextAlignment:NSTextAlignmentRight];
            [_name8Label setTextColor:[UIColor colorWithHexValue:0x333333]];
            [_name8Label setFont:[UIFont systemFontOfSize:16]];
            [_name8Label setBackgroundColor:[UIColor clearColor]];
            _name8Label.numberOfLines = 0;
            _name8Label.tag = 8;
            [cell addSubview:_name8Label];
            UILabel * _name9Label = [[UILabel alloc] initWithFrame:CGRectMake(665, 15, 58, 18)];
            [_name9Label setTextAlignment:NSTextAlignmentRight];
            [_name9Label setTextColor:[UIColor colorWithHexValue:0x333333]];
            [_name9Label setFont:[UIFont systemFontOfSize:16]];
            [_name9Label setBackgroundColor:[UIColor clearColor]];
            _name9Label.numberOfLines = 0;
            _name9Label.tag = 9;
            [cell addSubview:_name9Label];
            UILabel * _name10Label = [[UILabel alloc] initWithFrame:CGRectMake(739, 15, 56, 18)];
            [_name10Label setTextAlignment:NSTextAlignmentRight];
            [_name10Label setTextColor:[UIColor colorWithHexValue:0x333333]];
            [_name10Label setFont:[UIFont systemFontOfSize:16]];
            [_name10Label setBackgroundColor:[UIColor clearColor]];
            _name10Label.tag = 10;
            [cell addSubview:_name10Label];
            UILabel * _name11Label = [[UILabel alloc] initWithFrame:CGRectMake(817, 15, 52, 18)];
            [_name11Label setTextAlignment:NSTextAlignmentRight];
            [_name11Label setTextColor:[UIColor colorWithHexValue:0x333333]];
            [_name11Label setFont:[UIFont systemFontOfSize:16]];
            [_name11Label setBackgroundColor:[UIColor clearColor]];
            _name11Label.tag = 11;
            [cell addSubview:_name11Label];
            UILabel * _name12Label = [[UILabel alloc] initWithFrame:CGRectMake(883, 15, 86, 18)];
            [_name12Label setTextAlignment:NSTextAlignmentRight];
            [_name12Label setTextColor:[UIColor colorWithHexValue:0x333333]];
            [_name12Label setFont:[UIFont systemFontOfSize:16]];
            [_name12Label setBackgroundColor:[UIColor clearColor]];
            _name12Label.tag = 12;
            [cell addSubview:_name12Label];
//            UILabel * _name13Label = [[UILabel alloc] initWithFrame:CGRectMake(970, 15, 40, 18)];
//            [_name13Label setTextAlignment:NSTextAlignmentLeft];
//            [_name13Label setTextColor:[UIColor colorWithHexValue:0x333333]];
//            [_name13Label setFont:[UIFont systemFontOfSize:18]];
//            [_name13Label setBackgroundColor:[UIColor clearColor]];
//            _name13Label.tag = 13;
//            [cell addSubview:_name13Label];
            UIButton * operateBtn = [[UIButton alloc] initWithFrame:CGRectMake(985, 16, 16, 16)];
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
        
        
        FundRankNotMoneyData * data = nil;
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
                if (label.tag == 0) {
                    label.text = data.name;
                }
                if (label.tag == 1) {
                    label.text = [NSString stringWithFormat:@"%d", data.code];
                }
                if (label.tag == 2) {
                    label.text = data.date;
                }
                if (label.tag == 3) {
                    label.text = [NSString stringWithFormat:@"%.03f", [data.net_value floatValue]];
                }
                if (label.tag == 4) {
                    label.text = [NSString stringWithFormat:@"%.02f", [data.account_value floatValue]];
                }
                if (label.tag == 5) {
                    if ([data.rr_this_year isEqualToString:@""]) {
                        label.text = @"--";
                    }
                    else {
                        label.text = [NSString stringWithFormat:@"%.02f", [data.rr_one_month floatValue]];
                    }
                }
                if (label.tag == 6) {
                    if ([data.rr_this_year isEqualToString:@""]) {
                        label.text = @"--";
                    }
                    else {
                        label.text = [NSString stringWithFormat:@"%.02f", [data.rr_three_month floatValue]];
                    }
                }
                if (label.tag == 7) {
                    if ([data.rr_this_year isEqualToString:@""]) {
                        label.text = @"--";
                    }
                    else {
                        label.text = [NSString stringWithFormat:@"%.02f", [data.rr_six_month floatValue]];
                    }
                }
                if (label.tag == 8) {
                    if ([data.rr_this_year isEqualToString:@""]) {
                        label.text = @"--";
                    }
                    else {
                        label.text = [NSString stringWithFormat:@"%.02f", [data.rr_one_year floatValue]];
                    }
                }
                if (label.tag == 9) {
                    if ([data.rr_this_year isEqualToString:@""]) {
                        label.text = @"--";
                    }
                    else {
                        label.text = [NSString stringWithFormat:@"%.02f", [data.rr_two_year floatValue]];
                    }
                }
                if (label.tag == 10) {
                    if ([data.rr_this_year isEqualToString:@""]) {
                        label.text = @"--";
                    }
                    else {
                        label.text = [NSString stringWithFormat:@"%.02f", [data.rr_three_year floatValue]];
                    }
                }
                if (label.tag == 11) {
                    if ([data.rr_this_year isEqualToString:@""]) {
                        label.text = @"--";
                    }
                    else {
                        label.text = [NSString stringWithFormat:@"%.02f", [data.rr_this_year floatValue]];
                    }
                }
                if (label.tag == 12) {
                    label.text = data.estb_date;
                }
//                if (label.tag == 13) {
//                    label.text = @"";
//                }
            }
        }
        cell.tag = data.code;
        
        //    [cell configWithData:[self.listDatas objectAtIndex:indexPath.row]];
        
        return cell;
    }
    else if (tableView == tableView4) {
        static NSString * cellID = @"tableViewMoneyCellIdentifier";
        UITableViewCell * cell = (UITableViewCell *)[tableView2 dequeueReusableCellWithIdentifier:cellID];
        if (cell == nil)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
            
            UILabel * _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(19, 7, 96, 16)];
            [_nameLabel setTextAlignment:NSTextAlignmentLeft];
            [_nameLabel setTextColor:[UIColor colorWithHexValue:0x333333]];
            [_nameLabel setFont:[UIFont systemFontOfSize:16]];
            [_nameLabel setBackgroundColor:[UIColor clearColor]];
            _nameLabel.tag = 0;
            [cell addSubview:_nameLabel];
            UILabel * _name1Label = [[UILabel alloc] initWithFrame:CGRectMake(19, 27, 96, 14)];
            [_name1Label setTextAlignment:NSTextAlignmentLeft];
            [_name1Label setTextColor:[UIColor colorWithHexValue:0x333333]];
            [_name1Label setFont:[UIFont systemFontOfSize:14]];
            [_name1Label setBackgroundColor:[UIColor clearColor]];
            _name1Label.tag = 1;
            [cell addSubview:_name1Label];
            UILabel * _name2Label = [[UILabel alloc] initWithFrame:CGRectMake(146, 16, 84, 16)];
            [_name2Label setTextAlignment:NSTextAlignmentRight];
            [_name2Label setTextColor:[UIColor colorWithHexValue:0x333333]];
            [_name2Label setFont:[UIFont systemFontOfSize:16]];
            [_name2Label setBackgroundColor:[UIColor clearColor]];
            _name2Label.tag = 2;
            [cell addSubview:_name2Label];
            UILabel * _name3Label = [[UILabel alloc] initWithFrame:CGRectMake(238, 16, 56, 16)];
            [_name3Label setTextAlignment:NSTextAlignmentRight];
            [_name3Label setTextColor:[UIColor colorWithHexValue:0x333333]];
            [_name3Label setFont:[UIFont systemFontOfSize:16]];
            [_name3Label setBackgroundColor:[UIColor clearColor]];
            _name3Label.tag = 3;
            [cell addSubview:_name3Label];
            UILabel * _name4Label = [[UILabel alloc] initWithFrame:CGRectMake(323, 16, 57, 16)];
            [_name4Label setTextAlignment:NSTextAlignmentRight];
            [_name4Label setTextColor:[UIColor colorWithHexValue:0x333333]];
            [_name4Label setFont:[UIFont systemFontOfSize:16]];
            [_name4Label setBackgroundColor:[UIColor clearColor]];
            _name4Label.tag = 4;
            [cell addSubview:_name4Label];
            UILabel * _name5Label = [[UILabel alloc] initWithFrame:CGRectMake(413, 16, 43, 16)];
            [_name5Label setTextAlignment:NSTextAlignmentRight];
            [_name5Label setTextColor:[UIColor colorWithHexValue:0x333333]];
            [_name5Label setFont:[UIFont systemFontOfSize:16]];
            [_name5Label setBackgroundColor:[UIColor clearColor]];
            _name5Label.tag = 5;
            [cell addSubview:_name5Label];
            UILabel * _name6Label = [[UILabel alloc] initWithFrame:CGRectMake(467, 16, 52, 16)];
            [_name6Label setTextAlignment:NSTextAlignmentRight];
            [_name6Label setTextColor:[UIColor colorWithHexValue:0x333333]];
            [_name6Label setFont:[UIFont systemFontOfSize:16]];
            [_name6Label setBackgroundColor:[UIColor clearColor]];
            _name6Label.tag = 6;
            [cell addSubview:_name6Label];
            UILabel * _name7Label = [[UILabel alloc] initWithFrame:CGRectMake(535, 16, 46, 16)];
            [_name7Label setTextAlignment:NSTextAlignmentRight];
            [_name7Label setTextColor:[UIColor colorWithHexValue:0x333333]];
            [_name7Label setFont:[UIFont systemFontOfSize:16]];
            [_name7Label setBackgroundColor:[UIColor clearColor]];
            _name7Label.numberOfLines = 0;
            _name7Label.tag = 7;
            [cell addSubview:_name7Label];
            UILabel * _name8Label = [[UILabel alloc] initWithFrame:CGRectMake(602, 16, 50, 16)];
            [_name8Label setTextAlignment:NSTextAlignmentRight];
            [_name8Label setTextColor:[UIColor colorWithHexValue:0x333333]];
            [_name8Label setFont:[UIFont systemFontOfSize:16]];
            [_name8Label setBackgroundColor:[UIColor clearColor]];
            _name8Label.numberOfLines = 0;
            _name8Label.tag = 8;
            [cell addSubview:_name8Label];
            UILabel * _name9Label = [[UILabel alloc] initWithFrame:CGRectMake(667, 16, 42, 16)];
            [_name9Label setTextAlignment:NSTextAlignmentRight];
            [_name9Label setTextColor:[UIColor colorWithHexValue:0x333333]];
            [_name9Label setFont:[UIFont systemFontOfSize:16]];
            [_name9Label setBackgroundColor:[UIColor clearColor]];
            _name9Label.numberOfLines = 0;
            _name9Label.tag = 9;
            [cell addSubview:_name9Label];
            UILabel * _name10Label = [[UILabel alloc] initWithFrame:CGRectMake(741, 16, 53, 16)];
            [_name10Label setTextAlignment:NSTextAlignmentRight];
            [_name10Label setTextColor:[UIColor colorWithHexValue:0x333333]];
            [_name10Label setFont:[UIFont systemFontOfSize:16]];
            [_name10Label setBackgroundColor:[UIColor clearColor]];
            _name10Label.tag = 10;
            [cell addSubview:_name10Label];
            UILabel * _name11Label = [[UILabel alloc] initWithFrame:CGRectMake(813, 16, 52, 16)];
            [_name11Label setTextAlignment:NSTextAlignmentRight];
            [_name11Label setTextColor:[UIColor colorWithHexValue:0x333333]];
            [_name11Label setFont:[UIFont systemFontOfSize:16]];
            [_name11Label setBackgroundColor:[UIColor clearColor]];
            _name11Label.tag = 11;
            [cell addSubview:_name11Label];
            UILabel * _name12Label = [[UILabel alloc] initWithFrame:CGRectMake(890, 16, 86, 16)];
            [_name12Label setTextAlignment:NSTextAlignmentRight];
            [_name12Label setTextColor:[UIColor colorWithHexValue:0x333333]];
            [_name12Label setFont:[UIFont systemFontOfSize:16]];
            [_name12Label setBackgroundColor:[UIColor clearColor]];
            _name12Label.tag = 12;
            [cell addSubview:_name12Label];
//            UILabel * _name13Label = [[UILabel alloc] initWithFrame:CGRectMake(970, 15, 40, 18)];
//            [_name13Label setTextAlignment:NSTextAlignmentLeft];
//            [_name13Label setTextColor:[UIColor colorWithHexValue:0x333333]];
//            [_name13Label setFont:[UIFont systemFontOfSize:18]];
//            [_name13Label setBackgroundColor:[UIColor clearColor]];
//            _name13Label.tag = 13;
//            [cell addSubview:_name13Label];
            UIButton * operateBtn = [[UIButton alloc] initWithFrame:CGRectMake(991, 16, 16, 16)];
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
        
        FundRankMoneyData * data = [data4 objectAtIndex:indexPath.row];
        for (UIView * v in cell.subviews) {
            if ([v isKindOfClass:[UILabel class]]) {
                UILabel * label = (UILabel *)v;
                if (label.tag == 0) {
                    label.text = data.name;
                }
                if (label.tag == 1) {
                    label.text = [NSString stringWithFormat:@"%d", data.code];
                }
                if (label.tag == 2) {
                    label.text = data.date;
                }
                if (label.tag == 3) {
                    if ([data.rr_this_year isEqualToString:@""]) {
                        label.text = @"--";
                    }
                    else {
                        label.text = [NSString stringWithFormat:@"%.04f", [data.pay_price floatValue]];
                    }
                }
                if (label.tag == 4) {
                    if ([data.rr_this_year isEqualToString:@""]) {
                        label.text = @"--";
                    }
                    else {
                        label.text = [NSString stringWithFormat:@"%.02f", [data.seven_areturn floatValue]];
                    }
                }
                if (label.tag == 5) {
                    if ([data.rr_this_year isEqualToString:@""]) {
                        label.text = @"--";
                    }
                    else {
                        label.text = [NSString stringWithFormat:@"%.02f", [data.rr_one_month floatValue]];
                    }
                }
                if (label.tag == 6) {
                    if ([data.rr_this_year isEqualToString:@""]) {
                        label.text = @"--";
                    }
                    else {
                        label.text = [NSString stringWithFormat:@"%.02f", [data.rr_three_month floatValue]];
                    }
                }
                if (label.tag == 7) {
                    if ([data.rr_this_year isEqualToString:@""]) {
                        label.text = @"--";
                    }
                    else {
                        label.text = [NSString stringWithFormat:@"%.02f", [data.rr_six_month floatValue]];
                    }
                }
                if (label.tag == 8) {
                    if ([data.rr_this_year isEqualToString:@""]) {
                        label.text = @"--";
                    }
                    else {
                        label.text = [NSString stringWithFormat:@"%.02f", [data.rr_one_year floatValue]];
                    }
                }
                if (label.tag == 9) {
                    if ([data.rr_this_year isEqualToString:@""]) {
                        label.text = @"--";
                    }
                    else {
                        label.text = [NSString stringWithFormat:@"%.02f", [data.rr_two_year floatValue]];
                    }
                }
                if (label.tag == 10) {
                    if ([data.rr_this_year isEqualToString:@""]) {
                        label.text = @"--";
                    }
                    else {
                        label.text = [NSString stringWithFormat:@"%.02f", [data.rr_three_year floatValue]];
                    }
                }
                if (label.tag == 11) {
                    if ([data.rr_this_year isEqualToString:@""]) {
                        label.text = @"--";
                    }
                    else {
                        label.text = [NSString stringWithFormat:@"%.02f", [data.rr_this_year floatValue]];
                    }
                }
                if (label.tag == 12) {
                    label.text = data.estb_date;
                }
//                if (label.tag == 13) {
//                    label.text = @"";
//                }
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

- (void)operateBtnPress:(id)sender
{
    
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

- (void) getFundRankNotMoneyRequestSuccess:(FundRankNotMoneyRequest *)request
{
	BOOL isRequestSuccess = [fundRankNotMoneyRequest isRequestSuccess];
    if (isRequestSuccess) {
        data1 = [fundRankNotMoneyRequest getDataArray];
        [self buildTableView1];
        [self buildTableView2];
        [self buildTableView3];
        [self buildTableView5];
    }
    else {
    }
}

- (void) getFundRankNotMoneyRequestFailed:(FundRankNotMoneyRequest *)request
{
    
}

- (void)getFundRankNotMoneyData
{
    NSString * url = [NSString stringWithFormat:@"%@%@", HOST_NAME, VALUE_FUND_RANK_NOT_MONEY];
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
    fundRankNotMoneyRequest = [[FundRankNotMoneyRequest alloc]initWithUrl:url];
    
	fundRankNotMoneyRequest.delegate = self;
    fundRankNotMoneyRequest.requestDidFinishSelector = @selector(getFundRankNotMoneyRequestSuccess:);
    fundRankNotMoneyRequest.requestDidFailedSelector = @selector(getFundRankNotMoneyRequestFailed:);
    
    [fundRankNotMoneyRequest sendRequest];
}

- (void) getFundRankMoneyRequestSuccess:(FundRankMoneyRequest *)request
{
	BOOL isRequestSuccess = [fundRankMoneyRequest isRequestSuccess];
    if (isRequestSuccess) {
        data4 = [fundRankMoneyRequest getDataArray];
        [self buildTableView4];
    }
    else {
    }
}

- (void) getFundRankMoneyRequestFailed:(FundRankMoneyRequest *)request
{
    
}

- (void)getFundRankMoneyData
{
    NSString * url = [NSString stringWithFormat:@"%@%@", HOST_NAME, VALUE_FUND_RANK_MONEY];
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
    fundRankMoneyRequest = [[FundRankMoneyRequest alloc]initWithUrl:url];
    
	fundRankMoneyRequest.delegate = self;
    fundRankMoneyRequest.requestDidFinishSelector = @selector(getFundRankMoneyRequestSuccess:);
    fundRankMoneyRequest.requestDidFailedSelector = @selector(getFundRankMoneyRequestFailed:);
    
    [fundRankMoneyRequest sendRequest];
}

@end

