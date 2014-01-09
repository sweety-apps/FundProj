//
//  HomeViewController.m
//  FundPrj
//
//  Created by leesea on 13-10-22.
//  Copyright (c) 2013年 leesea. All rights reserved.
//

#import "HomeViewController.h"
#import "CMTabBarController.h"
#import "ASIFormDataRequest.h"
#import "Utility.h"
#import "SBJson.h"
#import <QuartzCore/QuartzCore.h> 
#import "NewDetailViewController.h"
#import "SettingViewController.h"
#import "RegisterRequest.h"
#import "LoginRequest.h"
#import "DetailViewController.h"
#import "ManagerRankRequest.h"
#import "ManagerRankData.h"
#import "FundRepayRequest.h"
#import "FundRepayData.h"
#import "FundNewsRequest.h"
#import "FundNewsData.h"
#import <sqlite3.h>
#import "FundNotMoneyRequest.h"
#import "FundNotMoneyData.h"
#import "FundMoneyRequest.h"
#import "FundMoneyData.h"
#import "FundRankNotMoneyRequest.h"
#import "FundRankNotMoneyData.h"
#import "FundRankMoneyRequest.h"
#import "FundRankMoneyData.h"
#import "FundInfoData.h"
#import "FMDatabase.h"
#import "FMDatabaseQueue.h"
#import "NTChartView.h"
#import "FundHistoryRequest.h"
#import "FundHistoryData.h"
#import "CCSegmentedControl.h"
#import "MyFavoriteFundList.h"


#define DB_NAME    @"FundDB.sqlite"
#define NAME      @"name"
#define CODE       @"code"
#define PY   @"py"

#define SHARE_TYPE 59000001
#define BOND_TYPE 59000002
#define GROUP_TYPE 59000003


@interface HomeViewController ()
{
    NSMutableArray * leftFirstDataArray;
    NSMutableArray * leftSecond_1_DataArray;
    NSMutableArray * leftSecond_2_DataArray;
    NSMutableArray * leftSecond_3_DataArray;
    NSMutableArray * rightFirstDataArray;
    NSMutableArray * rightSecond_1_DataArray;
    NSMutableArray * rightSecond_2_DataArray;
    NSMutableArray * leftBottom_DataArray;
    
    UIView * leftFirstView;
    UITableView * leftFirstTableView;
    
    UIView * leftSecondView;
    UIView * leftSecondGram1;
    UIView * leftSecondGram2;
    UIView * leftSecondGram3;
    NSInteger leftSecondViewType;
    
    UIView * rightFirstView;
    UITableView * rightFirstTableView;
    
    UIView * rightSecondView;
    UIButton * rightSecondBtn1;
    UIButton * rightSecondBtn2;
    UITableView * rightSecond1TableView;
    UITableView * rightSecond2TableView;
    BOOL isRightSecond1TableViewShow;
    
    CPTXYGraph                  *graph1;             //画板
    CPTScatterPlot              *dataSourceLinePlot1;//线
    NSMutableArray              *dataForPlot1;      //坐标数组
    NSInteger fundHistoryMax1;
    NSInteger fundHistoryMin1;
    
    CPTXYGraph                  *graph2;             //画板
    CPTScatterPlot              *dataSourceLinePlot2;//线
    NSMutableArray              *dataForPlot2;      //坐标数组
    NSInteger fundHistoryMax2;
    NSInteger fundHistoryMin2;
    
    CPTXYGraph                  *graph3;             //画板
    CPTScatterPlot              *dataSourceLinePlot3;//线
    NSMutableArray              *dataForPlot3;      //坐标数组
    NSInteger fundHistoryMax3;
    NSInteger fundHistoryMin3;
    
    UIView * leftBottomView;
    UIView * rightBottomView;
    
    UITextField * searchBox;
    UITextField * nameBox;
    UITextField * pwdBox;
    UIView * bgView;
    UIView * loginView;
    UIView * registerView;
    UITextField * mailBox;
    UITextField * pwdConfirmBox;
    
    RegisterRequest * registerRequest;
    UIAlertView * registerSuccessAlertView;
    LoginRequest * loginRequest;
    UIAlertView * loginSuccessAlertView;
    
    FundRepayRequest * fundRepayRequest;
    ManagerRankRequest * managerRankRequest;
    FundNewsRequest * fundNewsRequest;
    
    
    FundNotMoneyRequest * fundNotMoneyRequest;
    FundMoneyRequest * fundMoneyRequest;
    
    FundRankNotMoneyRequest * fundRankNotMoneyRequest;
    FundRankMoneyRequest * fundRankMoneyRequest;
    NSString *db_path;
    
    FMDatabase *dbBase;
    
    UIView * searchBg;
    UITableView * searchTableView;
    NSMutableArray * searchArray;
    
    FundHistoryRequest * fundHistoryRequest1;
    FundHistoryRequest * fundHistoryRequest2;
    FundHistoryRequest * fundHistoryRequest3;
    NSMutableArray * fundHistoryData1;
    NSMutableArray * fundHistoryData2;
    NSMutableArray * fundHistoryData3;
    
    UIWebView * webView1;
    UIWebView * webView2;
}


@end

@implementation HomeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        isRightSecond1TableViewShow = YES;
        
        dataForPlot1 = [[NSMutableArray alloc]init];
        dataForPlot2 = [[NSMutableArray alloc]init];
        dataForPlot3 = [[NSMutableArray alloc]init];
        
        db_path = [PATH_OF_DOCUMENT stringByAppendingPathComponent:DB_NAME];
        searchArray = [[NSMutableArray alloc]initWithCapacity:0];
        leftFirstDataArray = [[NSMutableArray alloc]initWithCapacity:0];
        rightFirstDataArray = [[NSMutableArray alloc]initWithCapacity:0];
        leftBottom_DataArray = [[NSMutableArray alloc]initWithCapacity:0];
        
//        NSFileManager * fileManager = [NSFileManager defaultManager];
//        if ([fileManager fileExistsAtPath:db_path] == NO) {
            // create it
            dbBase = [FMDatabase databaseWithPath:db_path];
            if ([dbBase open]) {
                
                NSString *sqlDbMoneyCreateTable = @"CREATE TABLE IF NOT EXISTS FUNDMONEY (code INTEGER PRIMARY KEY AUTOINCREMENT, py TEXT, name TEXT, date TEXT, pay_price TEXT, seven_areturn TEXT, type TEXT, invest_type TEXT, pur_status TEXT, redeem_status TEXT, rr_this_year TEXT)";
                BOOL res = [dbBase executeUpdate:sqlDbMoneyCreateTable];
                if (!res) {
                    NSLog(@"error when creating db table");
                } else {
                    NSLog(@"succ to creating db table");
                }
                
                NSString *sqlDbNotMoneyCreateTable = @"CREATE TABLE IF NOT EXISTS FUNDNOTMONEY (code INTEGER PRIMARY KEY AUTOINCREMENT, py TEXT, name TEXT, date TEXT, net_value TEXT, account_value TEXT, type TEXT, invest_type TEXT, pur_status INTEGER, redeem_status INTEGER, limits TEXT, updown TEXT, rr_this_year TEXT, grade TEXT)";
                res = [dbBase executeUpdate:sqlDbNotMoneyCreateTable];
                if (!res) {
                    NSLog(@"error when creating db table");
                } else {
                    NSLog(@"succ to creating db table");
                }
                
                NSString *sqlDbRankMoneyCreateTable = @"CREATE TABLE IF NOT EXISTS FUNDRANKMONEY (code INTEGER PRIMARY KEY AUTOINCREMENT, py TEXT, name TEXT, date TEXT, pay_price INTEGER, seven_areturn INTEGER, rr_one_month INTEGER, rr_one_month_rank INTEGER, rr_three_month INTEGER, rr_three_month_rank INTEGER, rr_six_month INTEGER, rr_six_month_rank INTEGER, rr_this_year INTEGER, rr_this_year_rank INTEGER, rr_one_year INTEGER, rr_one_year_rank INTEGER, rr_two_year INTEGER, rr_two_year_rank INTEGER, rr_three_year INTEGER, rr_three_year_rank INTEGER, estb_date TEXT)";
                res = [dbBase executeUpdate:sqlDbRankMoneyCreateTable];
                if (!res) {
                    NSLog(@"error when creating db table");
                } else {
                    NSLog(@"succ to creating db table");
                }
                
                NSString *sqlDbRankNotMoneyCreateTable = @"CREATE TABLE IF NOT EXISTS FUNDRANKNOTMONEY (code INTEGER PRIMARY KEY AUTOINCREMENT, py TEXT, name TEXT, date TEXT, net_value INTEGER, account_value INTEGER, rr_one_month INTEGER, rr_one_month_rank INTEGER, rr_three_month INTEGER, rr_three_month_rank INTEGER, rr_six_month INTEGER, rr_six_month_rank INTEGER, rr_this_year INTEGER, rr_this_year_rank INTEGER, rr_one_year INTEGER, rr_one_year_rank INTEGER, rr_two_year INTEGER, rr_two_year_rank INTEGER, rr_three_year INTEGER, rr_three_year_rank INTEGER, estb_date TEXT)";
                res = [dbBase executeUpdate:sqlDbRankNotMoneyCreateTable];
                if (!res) {
                    NSLog(@"error when creating db table");
                } else {
                    NSLog(@"succ to creating db table");
                }
                
                NSString *sqlDbFundRepayCreateTable = @"CREATE TABLE IF NOT EXISTS FUNDREPAY (code INTEGER PRIMARY KEY AUTOINCREMENT, py TEXT, name TEXT, date TEXT, net_value INTEGER, account_value INTEGER, limits INTEGER, updown INTEGER, rr_this_year INTEGER, grade INTEGER, invest_type TEXT, pur_status TEXT, redeem_status TEXT)";
                res = [dbBase executeUpdate:sqlDbFundRepayCreateTable];
                if (!res) {
                    NSLog(@"error when creating db table");
                } else {
                    NSLog(@"succ to creating db table");
                }

                NSString *sqlDbManagerRankCreateTable = @"CREATE TABLE IF NOT EXISTS FUNDMANAGERRANK (code INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, take_date TEXT, leave_date TEXT, rr_one_year INTEGER, rr_one_year_rank INTEGER, rr_one_year_eval TEXT, ann_rr_tenure INTEGER, ann_rr_tenure_index INTEGER, rr_sdate INTEGER)";
                res = [dbBase executeUpdate:sqlDbManagerRankCreateTable];
                if (!res) {
                    NSLog(@"error when creating db table");
                } else {
                    NSLog(@"succ to creating db table");
                }
                
                NSString *sqlDbFundNewsCreateTable = @"CREATE TABLE IF NOT EXISTS FUNDNEWS (code INTEGER PRIMARY KEY AUTOINCREMENT, title TEXT, pubtime TEXT, origin TEXT, author TEXT, context TEXT, channel INTEGER)";
                res = [dbBase executeUpdate:sqlDbFundNewsCreateTable];
                if (!res) {
                    NSLog(@"error when creating db table");
                } else {
                    NSLog(@"succ to creating db table");
                }
                
                [dbBase close];
            } else {
                NSLog(@"error when open db");
            }
//        }        
    }
    return self;
}

//网络从未连接到连接时的处理
- (void)onNetConnected
{
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
    if (searchBox == sender) {
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
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (searchBox == textField) {
        [self searchBtnOnPress:textField];
    }
    return YES;
}

//处理点击
-(void)singleTapOfSearchBgView:(UITapGestureRecognizer *)sender
{
    [self searchBtnOnPress:searchBox];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (searchBox == textField) {
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
        headerView.image = [[UIImage imageNamed:@"home_br"] stretchableImageWithLeftCapWidth:252/2 topCapHeight:34/2];
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
}


- (UIBarButtonItem *)createSettingBtn
{
    UIImage * img = [UIImage imageNamed:@"img_18"];
    UIBarButtonItem * btn = [FPNavigationBar createBarButtonFromImg:img
                                                            imgDown:img
                                                             target:self
                                                             action:@selector(tappedSettingButton)];
	return btn;
}

- (void)tappedSettingButton
{
    SettingViewController * settingViewCtrl = [[SettingViewController alloc]init];
    [self.navigationController pushViewController:settingViewCtrl animated:YES];
}

- (UIBarButtonItem *)createLoginBtn
{
    
    UIButton* btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 51, 32)];
    
    [btn setBackgroundImage:[UIImage imageNamed:@"img_23"] forState:UIControlStateNormal];
    //    [btn setImage:[UIImage imageNamed:@"ic_feedback_titlebar"] forState:UIControlStateHighlighted];
    
	[btn setTitle:@"登陆" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
	UILabel * label = [btn titleLabel];
	label.textColor = [UIColor whiteColor];
	label.textAlignment = UITextAlignmentCenter;
	[label setFont:[UIFont systemFontOfSize:16]];
    
    [btn addTarget:self action:@selector(loginBtnPress:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem* item = [[UIBarButtonItem alloc] initWithCustomView:btn];
	
	return item;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView == registerSuccessAlertView) {
        [self registerBackBtnPress:nil];
    }
    if (alertView == loginSuccessAlertView) {
        [self loginBackBtnPress:nil];
    }
}

- (void)loginBackBtnPress:(id)sender
{
    [bgView removeFromSuperview];
    bgView = nil;
}
- (void) loginRequestSuccess:(LoginRequest *)request
{
	BOOL isLoginSuccess = [request isLoginSuccess];
    if (isLoginSuccess) {
        _UI.isLogin = YES;
        _UI.loginToken = [request getAccess_token];
        rightSecondBtn1.enabled = YES;//我的关注按钮可点击
        [self registerBackBtnPress:nil];
        
        //预先拉一下我的列表
        [[MyFavoriteFundList sharedInstance] requestMyFundData:self succeedSel:@selector(getMyFundRequestSuccess) failedSel:@selector(getMyFundRequestFailed)];
        
        loginSuccessAlertView = [[UIAlertView alloc]initWithTitle:@"登录成功！"
                                    
                                                             message:nil
                                    
                                                            delegate:self
                                    
                                                   cancelButtonTitle:@"确定"
                                    
                                                   otherButtonTitles:nil];
        
        [loginSuccessAlertView show];
    }
    else {
        _UI.isLogin = NO;
        _UI.loginToken = nil;
        
        UIAlertView*alert = [[UIAlertView alloc]initWithTitle:@"登录失败，请重试"
                             
                                                      message:[request getMsg]
                             
                                                     delegate:self
                             
                                            cancelButtonTitle:@"确定"
                             
                                            otherButtonTitles:nil];
        
        [alert show];
    }
}

- (void) loginRequestFailed:(LoginRequest *)request
{
    UIAlertView*alert = [[UIAlertView alloc]initWithTitle:@"登录失败，请重试"
                         
                                                  message:nil
                         
                                                 delegate:self
                         
                                        cancelButtonTitle:@"确定"
                         
                                        otherButtonTitles:nil];
    
    [alert show];
    
}

- (void)loginGoBtnPress:(id)sender
{
    NSString * url = [NSString stringWithFormat:@"%@%@", HOST_NAME, LOGIN_FUNC];
    NSMutableArray * array = [[NSMutableArray alloc]initWithCapacity:0];
    [array addObject:[NSString stringWithFormat:@"%@=%@", OPENID, OPENID_VALUE]];
    [array addObject:[NSString stringWithFormat:@"%@=%@", TYPE, DATA_FORMAT]];
    [array addObject:[NSString stringWithFormat:@"%@=%@", @"user_name", nameBox.text]];
    _UI.userName = nameBox.text;
    
    int salt = arc4random() % 999999;
    if (salt < 100000) {
        salt = 999999 - salt;
    }
    [array addObject:[NSString stringWithFormat:@"%@=%d", @"salt", salt]];
    NSString * pwd = [NSString stringWithFormat:@"%@%@", nameBox.text, pwdBox.text];
    pwd = [pwd sha1];
    pwd = [[NSString stringWithFormat:@"%d%@", salt, pwd]sha1];
    [array addObject:[NSString stringWithFormat:@"%@=%@", @"pwd", pwd]];
    NSString * md5Result = [_UI md5EncParam:array];
    url = [url stringByAppendingString:md5Result];
    url = [url URLEncodedString];
    loginRequest = [[LoginRequest alloc]initWithUrl:url];
    
	loginRequest.delegate = self;
    loginRequest.requestDidFinishSelector = @selector(loginRequestSuccess:);
    loginRequest.requestDidFailedSelector = @selector(loginRequestFailed:);
    
    [loginRequest sendRequest];
}


- (void)registerBackBtnPress:(id)sender
{
    [bgView removeFromSuperview];
    bgView = nil;
}
- (void) registerRequestSuccess:(RegisterRequest *)request
{
	BOOL isRegisterSuccess = [request isRegisterSuccess];
    if (isRegisterSuccess) {
        
        registerSuccessAlertView = [[UIAlertView alloc]initWithTitle    :@"注册成功，请登录"
                             
                                                      message:nil
                             
                                                     delegate:self
                             
                                            cancelButtonTitle:@"确定"
                             
                                            otherButtonTitles:nil];
        
        [registerSuccessAlertView show];
    }
    else {
        
        UIAlertView*alert = [[UIAlertView alloc]initWithTitle:@"注册失败，请重试"
                             
                                                      message:nil
                             
                                                     delegate:self
                             
                                            cancelButtonTitle:@"确定"
                             
                                            otherButtonTitles:nil];
        
        [alert show];
    }
}

- (void) registerRequestFailed:(RegisterRequest *)request
{
    UIAlertView*alert = [[UIAlertView alloc]initWithTitle:@"注册失败，请重试"
                         
                                                  message:nil
                         
                                                 delegate:self
                         
                                        cancelButtonTitle:@"确定"
                         
                                        otherButtonTitles:nil];
    
    [alert show];
}

- (void)registerGoBtnPress:(id)sender
{
//    NSString * url = [NSString stringWithFormat:@"%@%@", HOST_NAME, REGISTER_FUNC];
//    NSMutableArray * array = [[NSMutableArray alloc]initWithCapacity:0];
//    [array addObject:[NSString stringWithFormat:@"%@=%@", OPENID, OPENID_VALUE]];
//    [array addObject:[NSString stringWithFormat:@"%@=%@", TYPE, DATA_FORMAT]];
////    [array addObject:[NSString stringWithFormat:@"%@=%@", @"user_name", nameBox.text]];
////    [array addObject:[NSString stringWithFormat:@"%@=%@", @"email", mailBox.text]];
//    //    NSString * pwd = [NSString stringWithFormat:@"%@%@", nameBox.text, pwdBox.text];
//    [array addObject:[NSString stringWithFormat:@"%@=%@", @"username", @"lixueyang"]];
//    [array addObject:[NSString stringWithFormat:@"%@=%@", @"email", @"12345678@qq.com"]];
//    NSString * pwd = [NSString stringWithFormat:@"%@%@", @"lixueyang", @"asdf1234"];
//    pwd = [pwd sha1];
//    [array addObject:[NSString stringWithFormat:@"%@=%@", @"pwd", pwd]];
//    NSString * md5Result = [_UI md5EncParam:array];
//    url = [url stringByAppendingString:md5Result];
//    url = [url URLEncodedString];
//    registerRequest = [[RegisterRequest alloc]initWithUrl:url];
    
    
    NSString * url = [NSString stringWithFormat:@"%@%@", HOST_NAME, REGISTER_FUNC];
    NSMutableArray * array = [[NSMutableArray alloc]initWithCapacity:0];
    [array addObject:[NSString stringWithFormat:@"%@=%@", OPENID, OPENID_VALUE]];
    [array addObject:[NSString stringWithFormat:@"%@=%@", TYPE, DATA_FORMAT]];
    [array addObject:[NSString stringWithFormat:@"%@=%@", @"user_name", @"lixueyang"]];
    [array addObject:[NSString stringWithFormat:@"%@=%@", @"email", @"12345678@qq.com"]];
    NSString * pwd = [NSString stringWithFormat:@"%@%@", @"lixueyang", @"asdf1234"];
    pwd = [pwd sha1];
    [array addObject:[NSString stringWithFormat:@"%@=%@", @"pwd", pwd]];
    NSString * md5Result = [_UI md5EncParamRegister:array];
    
    registerRequest = [[RegisterRequest alloc]initWithUrl:url];
    [registerRequest setPostValueAndKey:OPENID key:OPENID_VALUE];
    [registerRequest setPostValueAndKey:TYPE key:DATA_FORMAT];
    [registerRequest setPostValueAndKey:@"user_name" key:@"lixueyang"];
    [registerRequest setPostValueAndKey:@"email" key:@"12345678@qq.com"];
    [registerRequest setPostValueAndKey:@"pwd" key:pwd];
    [registerRequest setPostValueAndKey:@"sign_type" key:@"MD5"];
    [registerRequest setPostValueAndKey:@"sign" key:md5Result];
    
	registerRequest.delegate = self;
    registerRequest.requestDidFinishSelector = @selector(registerRequestSuccess:);
    registerRequest.requestDidFailedSelector = @selector(registerRequestFailed:);
    
    [registerRequest sendRequest];
}


- (void)registerBtnPress:(id)sender
{
    [loginView removeFromSuperview];
    loginView = nil;
    
    registerView = [[UIView alloc]initWithFrame:CGRectMake(320, 72, 384, 44+303)];
    registerView.backgroundColor = [UIColor colorWithHexValue:0xecf1f2];
    [bgView addSubview:registerView];
    UIImageView * headerView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 384, 44)];
    headerView.userInteractionEnabled = YES;
    headerView.image = [[UIImage imageNamed:@"home33_03"] stretchableImageWithLeftCapWidth:384/2 topCapHeight:44/2];
    [registerView addSubview:headerView];
    //UIView设置阴影
    [[registerView layer] setShadowOffset:CGSizeMake(-1, -1)];
    [[registerView layer] setShadowRadius:1];
    [[registerView layer] setShadowOpacity:1];
    [[registerView layer] setShadowColor:[UIColor grayColor].CGColor];
    //UIView设置边框
    [[registerView layer] setCornerRadius:10];
    
    UIButton* registerBackBtn = [[UIButton alloc] initWithFrame:CGRectMake(12, 6, 51, 32)];
    [registerBackBtn setBackgroundImage:[UIImage imageNamed:@"img_21"] forState:UIControlStateNormal];
    [registerBackBtn addTarget:self action:@selector(registerBackBtnPress:) forControlEvents:UIControlEventTouchUpInside];
    [headerView addSubview:registerBackBtn];
    
	UILabel * titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 384, 44)];
	titleLabel.textColor = [UIColor whiteColor];
	titleLabel.textAlignment = UITextAlignmentCenter;
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.text = @"注册";
	[titleLabel setFont:[UIFont systemFontOfSize:26]];
    [headerView addSubview:titleLabel];
    
    UIView * mailBg = [[UIView alloc]initWithFrame:CGRectMake(23, 20+44, 335, 39)];
    mailBg.backgroundColor = [UIColor whiteColor];
    [registerView addSubview:mailBg];
    //UIView设置阴影
    [[mailBg layer] setShadowOffset:CGSizeMake(-1, -1)];
    [[mailBg layer] setShadowRadius:1];
    [[mailBg layer] setShadowOpacity:1];
    [[mailBg layer] setShadowColor:[UIColor grayColor].CGColor];
    //UIView设置边框
    [[mailBg layer] setCornerRadius:3];
    
	UILabel * mailLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 80, 39)];
	mailLabel.textColor = [UIColor colorWithHexValue:0x657a88];
	mailLabel.textAlignment = UITextAlignmentLeft;
    mailLabel.text = @"邮箱";
	[mailLabel setFont:[UIFont systemFontOfSize:20]];
    [mailBg addSubview:mailLabel];
    mailBox = [[UITextField alloc] initWithFrame:CGRectMake(100, 0, 230, 39)];
    mailBox.backgroundColor = [UIColor clearColor];
    mailBox.clearButtonMode = UITextFieldViewModeWhileEditing;
    mailBox.borderStyle = UITextBorderStyleNone;
    mailBox.textColor = [UIColor colorWithHexValue:0x7f8b94];
    mailBox.font = [UIFont systemFontOfSize:16];
    mailBox.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    mailBox.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    mailBox.returnKeyType = UIReturnKeySearch;
    mailBox.delegate = self;
    mailBox.autocorrectionType = UITextAutocorrectionTypeNo;
    mailBox.enablesReturnKeyAutomatically = YES;
    mailBox.placeholder = @"请输入邮箱";
    [mailBg addSubview:mailBox];
    
    UIView * nameBg = [[UIView alloc]initWithFrame:CGRectMake(23, 20+44+39+10, 335, 39)];
    nameBg.backgroundColor = [UIColor whiteColor];
    [registerView addSubview:nameBg];
    //UIView设置阴影
    [[nameBg layer] setShadowOffset:CGSizeMake(-1, -1)];
    [[nameBg layer] setShadowRadius:1];
    [[nameBg layer] setShadowOpacity:1];
    [[nameBg layer] setShadowColor:[UIColor grayColor].CGColor];
    //UIView设置边框
    [[nameBg layer] setCornerRadius:3];
    
	UILabel * nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 80, 39)];
	nameLabel.textColor = [UIColor colorWithHexValue:0x657a88];
	nameLabel.textAlignment = UITextAlignmentLeft;
    nameLabel.text = @"用户名";
	[nameLabel setFont:[UIFont systemFontOfSize:20]];
    [nameBg addSubview:nameLabel];
    nameBox = [[UITextField alloc] initWithFrame:CGRectMake(100, 0, 230, 39)];
    nameBox.backgroundColor = [UIColor clearColor];
    nameBox.clearButtonMode = UITextFieldViewModeWhileEditing;
    nameBox.borderStyle = UITextBorderStyleNone;
    nameBox.textColor = [UIColor colorWithHexValue:0x7f8b94];
    nameBox.font = [UIFont systemFontOfSize:16];
    nameBox.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    nameBox.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    nameBox.returnKeyType = UIReturnKeySearch;
    nameBox.delegate = self;
    nameBox.autocorrectionType = UITextAutocorrectionTypeNo;
    nameBox.enablesReturnKeyAutomatically = YES;
    nameBox.placeholder = @"请输入用户名";
    [nameBg addSubview:nameBox];
    
    UIView * pwdBg = [[UIView alloc]initWithFrame:CGRectMake(23, 20*2+44+39*2+10, 335, 39)];
    pwdBg.backgroundColor = [UIColor whiteColor];
    [registerView addSubview:pwdBg];
    //UIView设置阴影
    [[pwdBg layer] setShadowOffset:CGSizeMake(-1, -1)];
    [[pwdBg layer] setShadowRadius:1];
    [[pwdBg layer] setShadowOpacity:1];
    [[pwdBg layer] setShadowColor:[UIColor grayColor].CGColor];
    //UIView设置边框
    [[pwdBg layer] setCornerRadius:3];
    
	UILabel * pwdLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 80, 39)];
	pwdLabel.textColor = [UIColor colorWithHexValue:0x657a88];
	pwdLabel.textAlignment = UITextAlignmentLeft;
    pwdLabel.text = @"密码";
	[pwdLabel setFont:[UIFont systemFontOfSize:20]];
    [pwdBg addSubview:pwdLabel];
    pwdBox = [[UITextField alloc] initWithFrame:CGRectMake(100, 0, 230, 39)];
    pwdBox.backgroundColor = [UIColor clearColor];
    pwdBox.clearButtonMode = UITextFieldViewModeWhileEditing;
    pwdBox.borderStyle = UITextBorderStyleNone;
    pwdBox.textColor = [UIColor colorWithHexValue:0x7f8b94];
    pwdBox.font = [UIFont systemFontOfSize:16];
    pwdBox.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    pwdBox.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    pwdBox.returnKeyType = UIReturnKeySearch;
    pwdBox.delegate = self;
    pwdBox.autocorrectionType = UITextAutocorrectionTypeNo;
    pwdBox.enablesReturnKeyAutomatically = YES;
    pwdBox.placeholder = @"请输入密码";
    pwdBox.secureTextEntry = YES;
    [pwdBg addSubview:pwdBox];
    
    UIView * pwdConfirmBg = [[UIView alloc]initWithFrame:CGRectMake(23, 20*2+44+39*3+10*2, 335, 39)];
    pwdConfirmBg.backgroundColor = [UIColor whiteColor];
    [registerView addSubview:pwdConfirmBg];
    //UIView设置阴影
    [[pwdConfirmBg layer] setShadowOffset:CGSizeMake(-1, -1)];
    [[pwdConfirmBg layer] setShadowRadius:1];
    [[pwdConfirmBg layer] setShadowOpacity:1];
    [[pwdConfirmBg layer] setShadowColor:[UIColor grayColor].CGColor];
    //UIView设置边框
    [[pwdConfirmBg layer] setCornerRadius:3];
    
	UILabel * pwdConfirmLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 80, 39)];
	pwdConfirmLabel.textColor = [UIColor colorWithHexValue:0x657a88];
	pwdConfirmLabel.textAlignment = UITextAlignmentLeft;
    pwdConfirmLabel.text = @"确认密码";
	[pwdConfirmLabel setFont:[UIFont systemFontOfSize:20]];
    [pwdConfirmBg addSubview:pwdConfirmLabel];
    pwdConfirmBox = [[UITextField alloc] initWithFrame:CGRectMake(100, 0, 230, 39)];
    pwdConfirmBox.backgroundColor = [UIColor clearColor];
    pwdConfirmBox.clearButtonMode = UITextFieldViewModeWhileEditing;
    pwdConfirmBox.borderStyle = UITextBorderStyleNone;
    pwdConfirmBox.textColor = [UIColor colorWithHexValue:0x7f8b94];
    pwdConfirmBox.font = [UIFont systemFontOfSize:16];
    pwdConfirmBox.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    pwdConfirmBox.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    pwdConfirmBox.returnKeyType = UIReturnKeySearch;
    pwdConfirmBox.delegate = self;
    pwdConfirmBox.autocorrectionType = UITextAutocorrectionTypeNo;
    pwdConfirmBox.enablesReturnKeyAutomatically = YES;
    pwdConfirmBox.placeholder = @"请再输入密码";
    pwdConfirmBox.secureTextEntry = YES;
    [pwdConfirmBg addSubview:pwdConfirmBox];
    
    UIButton* registerBtn = [[UIButton alloc] initWithFrame:CGRectMake(23, 20*3+44+39*4+10*2, 335, 50)];
    UIImage * image = [[UIImage imageNamed:@"home3_07"] stretchableImageWithLeftCapWidth:126/2 topCapHeight:50/2];
    [registerBtn setBackgroundImage:image forState:UIControlStateNormal];
    [registerBtn setTitle:@"确认注册" forState:UIControlStateNormal];
    [registerBtn addTarget:self action:@selector(registerGoBtnPress:) forControlEvents:UIControlEventTouchUpInside];
	UILabel * registerLabel = [registerBtn titleLabel];
	registerLabel.textColor = [UIColor whiteColor];
	registerLabel.textAlignment = UITextAlignmentCenter;
	[registerLabel setFont:[UIFont systemFontOfSize:26]];
    [registerView addSubview:registerBtn];
    
}

- (void) loginBtnPress:(id)sender
{
    bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 1024, 768-20-44-59)];
    UIView * alphaView = [[UIView alloc]initWithFrame:bgView.frame];
    alphaView.backgroundColor = [UIColor blackColor];
    alphaView.alpha = 0.5f;
    [bgView addSubview:alphaView];
    bgView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:bgView];
    
    loginView = [[UIView alloc]initWithFrame:CGRectMake(320, 72, 330, 294)];
    loginView.backgroundColor = [UIColor colorWithHexValue:0xecf1f2];
    [bgView addSubview:loginView];
    UIImageView * headerView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"home33_03"]];
    headerView.userInteractionEnabled = YES;
    headerView.frame = CGRectMake(0, 0, 330, 44);
    [loginView addSubview:headerView];
    //UIView设置阴影
    [[loginView layer] setShadowOffset:CGSizeMake(-1, -1)];
    [[loginView layer] setShadowRadius:1];
    [[loginView layer] setShadowOpacity:1];
    [[loginView layer] setShadowColor:[UIColor grayColor].CGColor];
    //UIView设置边框
    [[loginView layer] setCornerRadius:10];
    
    UIButton* loginBackBtn = [[UIButton alloc] initWithFrame:CGRectMake(12, 6, 51, 32)];
    [loginBackBtn setBackgroundImage:[UIImage imageNamed:@"img_21"] forState:UIControlStateNormal];
    [loginBackBtn addTarget:self action:@selector(loginBackBtnPress:) forControlEvents:UIControlEventTouchUpInside];
    [headerView addSubview:loginBackBtn];

	UILabel * titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 330, 44)];
	titleLabel.textColor = [UIColor whiteColor];
	titleLabel.textAlignment = UITextAlignmentCenter;
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.text = @"登陆";
	[titleLabel setFont:[UIFont systemFontOfSize:26]];
    [headerView addSubview:titleLabel];
    
    UIView * nameBg = [[UIView alloc]initWithFrame:CGRectMake(23, 31+44, 285, 39)];
    nameBg.backgroundColor = [UIColor whiteColor];
    [loginView addSubview:nameBg];
    //UIView设置阴影
    [[nameBg layer] setShadowOffset:CGSizeMake(-1, -1)];
    [[nameBg layer] setShadowRadius:1];
    [[nameBg layer] setShadowOpacity:1];
    [[nameBg layer] setShadowColor:[UIColor grayColor].CGColor];
    //UIView设置边框
    [[nameBg layer] setCornerRadius:3];
    
	UILabel * nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 65, 39)];
	nameLabel.textColor = [UIColor colorWithHexValue:0x657a88];
	nameLabel.textAlignment = UITextAlignmentLeft;
    nameLabel.text = @"用户名";
	[nameLabel setFont:[UIFont systemFontOfSize:20]];
    [nameBg addSubview:nameLabel];
    nameBox = [[UITextField alloc] initWithFrame:CGRectMake(95, 0, 180, 39)];
    nameBox.backgroundColor = [UIColor clearColor];
    nameBox.clearButtonMode = UITextFieldViewModeWhileEditing;
    nameBox.borderStyle = UITextBorderStyleNone;
    nameBox.textColor = [UIColor colorWithHexValue:0x7f8b94];
    nameBox.font = [UIFont systemFontOfSize:16];
    nameBox.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    nameBox.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    nameBox.returnKeyType = UIReturnKeySearch;
    nameBox.delegate = self;
    nameBox.autocorrectionType = UITextAutocorrectionTypeNo;
    nameBox.enablesReturnKeyAutomatically = YES;
    nameBox.placeholder = @"请输入用户名";
    [nameBg addSubview:nameBox];
    
    UIView * pwdBg = [[UIView alloc]initWithFrame:CGRectMake(23, 31+44+39+28, 285, 39)];
    pwdBg.backgroundColor = [UIColor whiteColor];
    [loginView addSubview:pwdBg];
    //UIView设置阴影
    [[pwdBg layer] setShadowOffset:CGSizeMake(-1, -1)];
    [[pwdBg layer] setShadowRadius:1];
    [[pwdBg layer] setShadowOpacity:1];
    [[pwdBg layer] setShadowColor:[UIColor grayColor].CGColor];
    //UIView设置边框
    [[pwdBg layer] setCornerRadius:3];
    
	UILabel * pwdLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 65, 39)];
	pwdLabel.textColor = [UIColor colorWithHexValue:0x657a88];
	pwdLabel.textAlignment = UITextAlignmentLeft;
    pwdLabel.text = @"密码";
	[pwdLabel setFont:[UIFont systemFontOfSize:20]];
    [pwdBg addSubview:pwdLabel];
    pwdBox = [[UITextField alloc] initWithFrame:CGRectMake(95, 0, 180, 39)];
    pwdBox.backgroundColor = [UIColor clearColor];
    pwdBox.clearButtonMode = UITextFieldViewModeWhileEditing;
    pwdBox.borderStyle = UITextBorderStyleNone;
    pwdBox.textColor = [UIColor colorWithHexValue:0x7f8b94];
    pwdBox.font = [UIFont systemFontOfSize:16];
    pwdBox.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    pwdBox.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    pwdBox.returnKeyType = UIReturnKeySearch;
    pwdBox.delegate = self;
    pwdBox.autocorrectionType = UITextAutocorrectionTypeNo;
    pwdBox.enablesReturnKeyAutomatically = YES;
    pwdBox.placeholder = @"请输入密码";
    pwdBox.secureTextEntry = YES;
    [pwdBg addSubview:pwdBox];
    
	UILabel * forgetPwdLabel = [[UILabel alloc]initWithFrame:CGRectMake(33, 31+44+39*2+28+10, 275, 18)];
    forgetPwdLabel.backgroundColor = [UIColor clearColor];
	forgetPwdLabel.textColor = [UIColor colorWithHexValue:0x657a88];
	forgetPwdLabel.textAlignment = UITextAlignmentRight;
    forgetPwdLabel.text = @"忘记密码？";
	[forgetPwdLabel setFont:[UIFont systemFontOfSize:18]];
    [loginView addSubview:forgetPwdLabel];
    
    UIButton* loginGoBtn = [[UIButton alloc] initWithFrame:CGRectMake(23, 31+44+39*2+28+10*2+18, 126, 50)];
    [loginGoBtn setBackgroundImage:[UIImage imageNamed:@"home3_07"] forState:UIControlStateNormal];
    [loginGoBtn setTitle:@"登陆" forState:UIControlStateNormal];
    [loginGoBtn addTarget:self action:@selector(loginGoBtnPress:) forControlEvents:UIControlEventTouchUpInside];
	UILabel * loginGoLabel = [loginGoBtn titleLabel];
	loginGoLabel.textColor = [UIColor whiteColor];
	loginGoLabel.textAlignment = UITextAlignmentCenter;
	[loginGoLabel setFont:[UIFont systemFontOfSize:26]];
    [loginView addSubview:loginGoBtn];
    
    UIButton* registerBtn = [[UIButton alloc] initWithFrame:CGRectMake(23+126+29, 31+44+39*2+28+10*2+18, 126, 50)];
    [registerBtn setBackgroundImage:[UIImage imageNamed:@"home3_09"] forState:UIControlStateNormal];
    [registerBtn setTitle:@"注册" forState:UIControlStateNormal];
    [registerBtn addTarget:self action:@selector(registerBtnPress:) forControlEvents:UIControlEventTouchUpInside];
	UILabel * registerLabel = [registerBtn titleLabel];
	registerLabel.textColor = [UIColor whiteColor];
	registerLabel.textAlignment = UITextAlignmentCenter;
	[registerLabel setFont:[UIFont systemFontOfSize:26]];
    [loginView addSubview:registerBtn];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
//    self.extendedLayoutIncludesOpaqueBars = NO;
//    self.edgesForExtendedLayout = UIRectEdgeBottom | UIRectEdgeLeft | UIRectEdgeRight;
	
	self.navigationItem.title = self.title;
    self.view.backgroundColor = [UIColor colorWithHexValue:0xf6f5f3];
	self.view.frame = CGRectMake(0, 0, 1024, 768-20-44-59);
    
	//创建 设置按钮、登陆按钮、搜索框
	self.navigationItem.rightBarButtonItem = [self createSearchBox];
	self.navigationItem.leftBarButtonItems = [NSArray arrayWithObjects:[self createSettingBtn], [self createLoginBtn], nil];
	
//    [self buildLeftFirstView];
    [self buildLeftSecondView];
//    [self buildRightFirstView];
    [self buildRightScondView];
//    [self buildLeftBottomView];
    [self buildRightBottomView];
    
    NSString * dateStr = nil;
    id test = [[NSUserDefaults standardUserDefaults] objectForKey:@"LastDataTime"];
    if (test) {
        dateStr = (NSString *)test;
    }
    if (dateStr){
        //将传入时间转化成需要的格式
        NSDateFormatter *format=[[NSDateFormatter alloc] init];
        [format setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSDate *fromdate=[format dateFromString:dateStr];
        NSTimeZone *fromzone = [NSTimeZone systemTimeZone];
        NSInteger frominterval = [fromzone secondsFromGMTForDate: fromdate];
        NSDate *fromDate = [fromdate  dateByAddingTimeInterval: frominterval];
        NSLog(@"fromdate=%@",fromDate);
        //获取当前时间
        NSDate *date = [NSDate date];
        NSTimeZone *zone = [NSTimeZone systemTimeZone];
        NSInteger interval = [zone secondsFromGMTForDate: date];
        NSDate *localeDate = [date  dateByAddingTimeInterval: interval];
        NSLog(@"enddate=%@",localeDate);
        double intervalTime = ([fromDate timeIntervalSinceReferenceDate] - [localeDate timeIntervalSinceReferenceDate]) * -1;
        long lTime = (long)intervalTime;
        if (lTime <= 60*60*3) {
            
            NSInteger flag = 0;
            if ([dbBase open]) {
                [leftFirstDataArray removeAllObjects];
                NSString *sqlFundRepayQuery = [NSString stringWithFormat:@"SELECT * FROM FUNDREPAY ORDER BY rr_this_year DESC"];
                FMResultSet * rs = [dbBase executeQuery:sqlFundRepayQuery];
                while ([rs next] && flag < 8) {
                    ++flag;
                    
                    FundRepayData * data = [[FundRepayData alloc]init];
                    data.name = [rs stringForColumn:@"name"];
                    data.py = [rs stringForColumn:@"py"];
                    data.date = [rs stringForColumn:@"date"];
                    data.invest_type = [rs stringForColumn:@"invest_type"];
                    data.pur_status = [rs stringForColumn:@"pur_status"];
                    data.redeem_status = [rs stringForColumn:@"redeem_status"];
                    data.name = [rs stringForColumn:@"name"];
                    data.code = [rs intForColumn:@"code"];
                    data.net_value = [rs intForColumn:@"net_value"];
                    data.account_value = [rs intForColumn:@"account_value"];
                    data.limits = [rs intForColumn:@"limits"];
                    data.updown = [rs intForColumn:@"updown"];
                    data.rr_this_year = [rs intForColumn:@"rr_this_year"];
                    data.grade = [rs intForColumn:@"grade"];
                    [leftFirstDataArray addObject:data];
                }
                [dbBase close];
            }
            [self buildLeftFirstView];
            
            flag = 0;
            if ([dbBase open]) {
                [rightFirstDataArray removeAllObjects];
                NSString *sqlManagerRankQuery = [NSString stringWithFormat:@"SELECT * FROM FUNDMANAGERRANK ORDER BY ann_rr_tenure DESC"];
                FMResultSet * rs = [dbBase executeQuery:sqlManagerRankQuery];
                while ([rs next] && flag < 8) {
                    ++flag;
                    NSString * name = [rs stringForColumn:@"name"];
                    NSString * take_date = [rs stringForColumn:@"take_date"];
                    NSInteger ann_rr_tenure = [rs intForColumn:@"ann_rr_tenure"];
                    
                    ManagerRankData * data = [[ManagerRankData alloc]init];
                    data.name = name;
                    data.take_date = take_date;
                    data.ann_rr_tenure = ann_rr_tenure;
                    [rightFirstDataArray addObject:data];
                }
                [dbBase close];
            }
            [self buildRightFirstView];
            
            flag = 0;
            if ([dbBase open]) {
                [leftBottom_DataArray removeAllObjects];
                NSString *sqlFundNewsQuery = [NSString stringWithFormat:@"SELECT * FROM FUNDNEWS"];
                FMResultSet * rs = [dbBase executeQuery:sqlFundNewsQuery];
                while ([rs next] && flag < 2) {
                    NSString * title = [rs stringForColumn:@"title"];
                    NSString * pubtime = [rs stringForColumn:@"pubtime"];
                    NSString * origin = [rs stringForColumn:@"origin"];
                    NSString * author = [rs stringForColumn:@"author"];
                    NSString * context = [rs stringForColumn:@"context"];
                    NSInteger channel = [rs intForColumn:@"channel"];
                    
                    FundNewsData * data = [[FundNewsData alloc]init];
                    data.title = title;
                    data.pubtime = pubtime;
                    data.origin = origin;
                    data.author = author;
                    data.context = context;
                    data.channel = channel;
                    [leftBottom_DataArray addObject:data];
                }
                [dbBase close];
            }
            [self buildLeftBottomView];
            
            return;
        }
    }
    
    [self getFundRepayRankData];
    [self getManagerRepayRankData];
    [self getFundNewsData];
    
    [self getFundMoneyData];
    [self getFundNotMoneyData];
    [self getFundRankNotMoneyData];
    [self getFundRankMoneyData];
}

- (void)buildLeftFirstView
{
    leftFirstView = [[UIView alloc]initWithFrame:CGRectMake(12, 12, 252, 278)];
    leftFirstView.backgroundColor = [UIColor whiteColor];
    UIImageView * headerBg = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"home_br"]];
    headerBg.frame = CGRectMake(0, 0, 252, 34);
    [leftFirstView addSubview:headerBg];
    
    UILabel * _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 7, 252, 20)];
    [_titleLabel setTextAlignment:NSTextAlignmentCenter];
    [_titleLabel setTextColor:[UIColor whiteColor]];
    [_titleLabel setFont:[UIFont boldSystemFontOfSize:20]];
    [_titleLabel setBackgroundColor:[UIColor clearColor]];
    _titleLabel.text = @"基金回报排行";
    [leftFirstView addSubview:_titleLabel];
    
    UIView * titleView = [[UIView alloc]initWithFrame:CGRectMake(0, 35, 252, 35)];
    titleView.backgroundColor = [UIColor colorWithHexValue:0xf6f7f8];
    [leftFirstView addSubview:titleView];
    UILabel * _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(12, 10, 120, 15)];
    [_nameLabel setTextAlignment:NSTextAlignmentLeft];
    [_nameLabel setTextColor:[UIColor colorWithHexValue:0x333333]];
    [_nameLabel setFont:[UIFont systemFontOfSize:15]];
    [_nameLabel setBackgroundColor:[UIColor clearColor]];
    _nameLabel.text = @"基金名称";
    [titleView addSubview:_nameLabel];
    UILabel * _repayLabel = [[UILabel alloc] initWithFrame:CGRectMake(142, 3, 50, 29)];
    [_repayLabel setTextAlignment:NSTextAlignmentLeft];
    [_repayLabel setTextColor:[UIColor colorWithHexValue:0x333333]];
    [_repayLabel setFont:[UIFont systemFontOfSize:12]];
    _repayLabel.numberOfLines = 0;
    [_repayLabel setBackgroundColor:[UIColor clearColor]];
    _repayLabel.text = @"今年以来回报(%)";
    [titleView addSubview:_repayLabel];
    UILabel * _changeLabel = [[UILabel alloc] initWithFrame:CGRectMake(197, 3, 45, 29)];
    [_changeLabel setTextAlignment:NSTextAlignmentLeft];
    [_changeLabel setTextColor:[UIColor colorWithHexValue:0x333333]];
    [_changeLabel setFont:[UIFont systemFontOfSize:12]];
    _changeLabel.numberOfLines = 0;
    [_changeLabel setBackgroundColor:[UIColor clearColor]];
    _changeLabel.text = @"净值变动(%)";
    [titleView addSubview:_changeLabel];
    
    leftFirstTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 70, 252, (25+1)*8)
                                                  style:UITableViewStylePlain];
    leftFirstTableView.dataSource = self;
    leftFirstTableView.delegate = self;
    leftFirstTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
	[leftFirstView addSubview:leftFirstTableView];

    
    //UIView设置阴影
    [[leftFirstView layer] setShadowOffset:CGSizeMake(1, 1)];
    [[leftFirstView layer] setShadowRadius:5];
    [[leftFirstView layer] setShadowOpacity:1];
    [[leftFirstView layer] setShadowColor:[UIColor grayColor].CGColor];
    //UIView设置边框
    [[leftFirstView layer] setCornerRadius:5];
    
    [self.view addSubview:leftFirstView];
}

- (void)segmentAction:(id)sender
{
	UISegmentedControl *segmentedControl = (UISegmentedControl *)sender;
	switch (segmentedControl.selectedSegmentIndex) {
        case 0:
            [leftSecondView bringSubviewToFront:leftSecondGram1];
            leftSecondViewType = SHARE_TYPE;
            break;
        case 1:
            [leftSecondView bringSubviewToFront:leftSecondGram2];
            leftSecondViewType = BOND_TYPE;
            break;
        case 2:
            [leftSecondView bringSubviewToFront:leftSecondGram3];
            leftSecondViewType = GROUP_TYPE;
            break;
            
        default:
            break;
    }
}

#pragma mark - dataSourceOpt

-(NSUInteger)numberOfRecordsForPlot:(CPTPlot *)plot
{
    NSMutableArray * dataForPlot = nil;
    if ( [(NSString *)plot.identifier isEqualToString:@"SHARE_TYPE"] ) {
        dataForPlot = dataForPlot1;
    }
    if ( [(NSString *)plot.identifier isEqualToString:@"BOND_TYPE"] ) {
        dataForPlot = dataForPlot2;
    }
    if ( [(NSString *)plot.identifier isEqualToString:@"GROUP_TYPE"] ) {
        dataForPlot = dataForPlot3;
    }
    return [dataForPlot count];
}

-(NSNumber *)numberForPlot:(CPTPlot *)plot field:(NSUInteger)fieldEnum recordIndex:(NSUInteger)index
{
    CPTScatterPlot *dataSourceLinePlot = nil;
    NSMutableArray * dataForPlot = nil;
    if ( [(NSString *)plot.identifier isEqualToString:@"SHARE_TYPE"] ) {
        dataSourceLinePlot = dataSourceLinePlot1;
        dataForPlot = dataForPlot1;
    }
    if ( [(NSString *)plot.identifier isEqualToString:@"BOND_TYPE"] ) {
        dataSourceLinePlot = dataSourceLinePlot2;
        dataForPlot = dataForPlot2;
    }
    if ( [(NSString *)plot.identifier isEqualToString:@"GROUP_TYPE"] ) {
        dataSourceLinePlot = dataSourceLinePlot3;
        dataForPlot = dataForPlot3;
    }
    NSString * key = (fieldEnum == CPTScatterPlotFieldX ? @"x" : @"y");
    NSNumber *num;
    //让视图偏移
    num = [[dataForPlot objectAtIndex:index] valueForKey:key];
    if ( fieldEnum == CPTScatterPlotFieldX ) {
        num = [NSNumber numberWithDouble:[num doubleValue]];
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
    UIView * chartView = [[UIView alloc]initWithFrame:CGRectMake(18, 18, (252-18*2), (278-70-18*2))];
    chartView.backgroundColor = [UIColor clearColor];
    [leftSecondGram1 addSubview:chartView];
    
    graph1 = [[CPTXYGraph alloc] initWithFrame:chartView.bounds];
    
    //给画板添加一个主题
    CPTTheme *theme = [CPTTheme themeNamed:kCPTDarkGradientTheme];
    [graph1 applyTheme:theme];
    
    //创建主画板视图添加画板
    CPTGraphHostingView *hostingView = [[CPTGraphHostingView alloc] initWithFrame:chartView.bounds];
    hostingView.hostedGraph = graph1;
    
	[chartView addSubview:hostingView];
    
    //设置留白
    graph1.paddingLeft = 0;
	graph1.paddingTop = 0;
	graph1.paddingRight = 0;
	graph1.paddingBottom = 0;
    
    graph1.plotAreaFrame.paddingLeft = 50 ;
    graph1.plotAreaFrame.paddingTop = 10.0 ;
    graph1.plotAreaFrame.paddingRight = 10.0 ;
    graph1.plotAreaFrame.paddingBottom = 30.0 ;
    //设置坐标范围
    CPTXYPlotSpace *plotSpace = (CPTXYPlotSpace *)graph1.defaultPlotSpace;
    plotSpace.allowsUserInteraction = NO;
    
    plotSpace.xRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(0.0) length:CPTDecimalFromFloat(60.0)];
    plotSpace.yRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(0) length:CPTDecimalFromFloat(fundHistoryMax1*2)];
    
    //设置坐标刻度大小
    CPTXYAxisSet *axisSet = (CPTXYAxisSet *) graph1.axisSet ;
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
    [formatter setDateFormat:@"MM-dd"];
    
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
    y. majorIntervalLength = CPTDecimalFromString ( [NSString stringWithFormat:@"%d", fundHistoryMax1/2 ] );
    // 坐标原点： 0
    y. orthogonalCoordinateDecimal = CPTDecimalFromString ([NSString stringWithFormat:@"%d", 0]);
    y.axisLabels = nil;
    
    //创建绿色区域
    dataSourceLinePlot1 = [[CPTScatterPlot alloc] init];
    dataSourceLinePlot1.identifier = @"SHARE_TYPE";
    
    //设置绿色区域边框的样式
    CPTMutableLineStyle *lineStyle = [dataSourceLinePlot1.dataLineStyle mutableCopy];
    lineStyle.lineWidth = 1.f;
    lineStyle.lineColor = [CPTColor greenColor];
    dataSourceLinePlot1.dataLineStyle = lineStyle;
    //设置透明实现添加动画
    dataSourceLinePlot1.opacity = 0.0f;
    
    //设置数据元代理
    dataSourceLinePlot1.dataSource = self;
    [graph1 addPlot:dataSourceLinePlot1];
    
    // 创建一个颜色渐变：从 建变色 1 渐变到 无色
    CPTGradient *areaGradient = [ CPTGradient gradientWithBeginningColor :[CPTColor greenColor] endingColor :[CPTColor colorWithComponentRed:0.65 green:0.65 blue:0.16 alpha:0.2]];
    // 渐变角度： -90 度（顺时针旋转）
    areaGradient.angle = -90.0f ;
    // 创建一个颜色填充：以颜色渐变进行填充
    CPTFill *areaGradientFill = [ CPTFill fillWithGradient :areaGradient];
    // 为图形设置渐变区
    dataSourceLinePlot1. areaFill = areaGradientFill;
    dataSourceLinePlot1. areaBaseValue = CPTDecimalFromString ( @"0.0" );
    dataSourceLinePlot1.interpolation = CPTScatterPlotInterpolationLinear ;
    
    //刷新画板
    [graph1 reloadData];
    
    return chartView;
}

- (UIView *)buildView2
{
    UIView * chartView = [[UIView alloc]initWithFrame:CGRectMake(18, 18, 252-18*2, 278-70-18*2)];
    chartView.backgroundColor = [UIColor clearColor];
    
    graph2 = [[CPTXYGraph alloc] initWithFrame:chartView.bounds];
    
    //给画板添加一个主题
    CPTTheme *theme = [CPTTheme themeNamed:kCPTDarkGradientTheme];
    [graph2 applyTheme:theme];
    
    //创建主画板视图添加画板
    CPTGraphHostingView *hostingView = [[CPTGraphHostingView alloc] initWithFrame:chartView.bounds];
    hostingView.hostedGraph = graph2;
    
	[chartView addSubview:hostingView];
    
    //设置留白
    graph2.paddingLeft = 0;
	graph2.paddingTop = 0;
	graph2.paddingRight = 0;
	graph2.paddingBottom = 0;
    
    graph2.plotAreaFrame.paddingLeft = 50 ;
    graph2.plotAreaFrame.paddingTop = 10.0 ;
    graph2.plotAreaFrame.paddingRight = 10.0 ;
    graph2.plotAreaFrame.paddingBottom = 30.0 ;
    //设置坐标范围
    CPTXYPlotSpace *plotSpace = (CPTXYPlotSpace *)graph2.defaultPlotSpace;
    plotSpace.allowsUserInteraction = NO;
    
    plotSpace.xRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(0.0) length:CPTDecimalFromFloat(60.0)];
    plotSpace.yRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(0) length:CPTDecimalFromFloat(fundHistoryMax2*2)];
    
    //设置坐标刻度大小
    CPTXYAxisSet *axisSet = (CPTXYAxisSet *) graph2.axisSet ;
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
    [formatter setDateFormat:@"MM-dd"];
    
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
    y. majorIntervalLength = CPTDecimalFromString ( [NSString stringWithFormat:@"%d", fundHistoryMax2/2 ] );
    // 坐标原点： 0
    y. orthogonalCoordinateDecimal = CPTDecimalFromString ([NSString stringWithFormat:@"%d", 0]);
    y.axisLabels = nil;
    
    //创建绿色区域
    dataSourceLinePlot2 = [[CPTScatterPlot alloc] init];
    dataSourceLinePlot2.identifier = @"BOND_TYPE";
    
    //设置绿色区域边框的样式
    CPTMutableLineStyle *lineStyle = [dataSourceLinePlot2.dataLineStyle mutableCopy];
    lineStyle.lineWidth = 1.f;
    lineStyle.lineColor = [CPTColor greenColor];
    dataSourceLinePlot2.dataLineStyle = lineStyle;
    //设置透明实现添加动画
    dataSourceLinePlot2.opacity = 0.0f;
    
    //设置数据元代理
    dataSourceLinePlot2.dataSource = self;
    [graph2 addPlot:dataSourceLinePlot1];
    
    // 创建一个颜色渐变：从 建变色 1 渐变到 无色
    CPTGradient *areaGradient = [ CPTGradient gradientWithBeginningColor :[CPTColor greenColor] endingColor :[CPTColor colorWithComponentRed:0.65 green:0.65 blue:0.16 alpha:0.2]];
    // 渐变角度： -90 度（顺时针旋转）
    areaGradient.angle = -90.0f ;
    // 创建一个颜色填充：以颜色渐变进行填充
    CPTFill *areaGradientFill = [ CPTFill fillWithGradient :areaGradient];
    // 为图形设置渐变区
    dataSourceLinePlot2. areaFill = areaGradientFill;
    dataSourceLinePlot2. areaBaseValue = CPTDecimalFromString ( @"0.0" );
    dataSourceLinePlot2.interpolation = CPTScatterPlotInterpolationLinear ;
    
    //刷新画板
    [graph2 reloadData];
    
    return chartView;
}

- (UIView *)buildView3
{
    UIView * chartView = [[UIView alloc]initWithFrame:CGRectMake(18, 18, 252-18*2, 278-70-18*2)];
    chartView.backgroundColor = [UIColor clearColor];
    
    graph3 = [[CPTXYGraph alloc] initWithFrame:chartView.bounds];
    
    //给画板添加一个主题
    CPTTheme *theme = [CPTTheme themeNamed:kCPTDarkGradientTheme];
    [graph3 applyTheme:theme];
    
    //创建主画板视图添加画板
    CPTGraphHostingView *hostingView = [[CPTGraphHostingView alloc] initWithFrame:chartView.bounds];
    hostingView.hostedGraph = graph3;
    
	[chartView addSubview:hostingView];
    
    //设置留白
    graph3.paddingLeft = 0;
	graph3.paddingTop = 0;
	graph3.paddingRight = 0;
	graph3.paddingBottom = 0;
    
    graph3.plotAreaFrame.paddingLeft = 50 ;
    graph3.plotAreaFrame.paddingTop = 10.0 ;
    graph3.plotAreaFrame.paddingRight = 10.0 ;
    graph3.plotAreaFrame.paddingBottom = 30.0 ;
    //设置坐标范围
    CPTXYPlotSpace *plotSpace = (CPTXYPlotSpace *)graph3.defaultPlotSpace;
    plotSpace.allowsUserInteraction = NO;
    
    plotSpace.xRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(0.0) length:CPTDecimalFromFloat(60.0)];
    plotSpace.yRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(0) length:CPTDecimalFromFloat(fundHistoryMax3*2)];
    
    //设置坐标刻度大小
    CPTXYAxisSet *axisSet = (CPTXYAxisSet *) graph3.axisSet ;
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
    [formatter setDateFormat:@"MM-dd"];
    
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
    y. majorIntervalLength = CPTDecimalFromString ( [NSString stringWithFormat:@"%d", fundHistoryMax3/2 ] );
    // 坐标原点： 0
    y. orthogonalCoordinateDecimal = CPTDecimalFromString ([NSString stringWithFormat:@"%d", 0]);
    y.axisLabels = nil;
    
    //创建绿色区域
    dataSourceLinePlot3 = [[CPTScatterPlot alloc] init];
    dataSourceLinePlot3.identifier = @"GROUP_TYPE";
    
    //设置绿色区域边框的样式
    CPTMutableLineStyle *lineStyle = [dataSourceLinePlot3.dataLineStyle mutableCopy];
    lineStyle.lineWidth = 1.f;
    lineStyle.lineColor = [CPTColor greenColor];
    dataSourceLinePlot3.dataLineStyle = lineStyle;
    //设置透明实现添加动画
    dataSourceLinePlot3.opacity = 0.0f;
    
    //设置数据元代理
    dataSourceLinePlot3.dataSource = self;
    [graph1 addPlot:dataSourceLinePlot3];
    
    // 创建一个颜色渐变：从 建变色 1 渐变到 无色
    CPTGradient *areaGradient = [ CPTGradient gradientWithBeginningColor :[CPTColor greenColor] endingColor :[CPTColor colorWithComponentRed:0.65 green:0.65 blue:0.16 alpha:0.2]];
    // 渐变角度： -90 度（顺时针旋转）
    areaGradient.angle = -90.0f ;
    // 创建一个颜色填充：以颜色渐变进行填充
    CPTFill *areaGradientFill = [ CPTFill fillWithGradient :areaGradient];
    // 为图形设置渐变区
    dataSourceLinePlot3. areaFill = areaGradientFill;
    dataSourceLinePlot3. areaBaseValue = CPTDecimalFromString ( @"0.0" );
    dataSourceLinePlot3.interpolation = CPTScatterPlotInterpolationLinear ;
    
    //刷新画板
    [graph3 reloadData];
    
    return chartView;
}

- (void)buildLeftSecondView
{
    leftSecondView = [[UIView alloc]initWithFrame:CGRectMake(12*2+252, 12, 252, 278)];
    leftSecondView.backgroundColor = [UIColor whiteColor];
    UIImageView * headerBg = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"home_br"]];
    headerBg.frame = CGRectMake(0, 0, 252, 34);
    [leftSecondView addSubview:headerBg];
    
    UILabel * _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 7, 252, 20)];
    [_titleLabel setTextAlignment:NSTextAlignmentCenter];
    [_titleLabel setTextColor:[UIColor whiteColor]];
    [_titleLabel setFont:[UIFont boldSystemFontOfSize:20]];
    [_titleLabel setBackgroundColor:[UIColor clearColor]];
    _titleLabel.text = @"大盘指数";
    [leftSecondView addSubview:_titleLabel];
    
	// segmented control as the custom title view
//	NSArray *segmentTextContent = [NSArray arrayWithObjects:@"股票基金指数", @"债券基金指数", @"混合基金指数", nil];
//	UISegmentedControl *segmentedControl = [[UISegmentedControl alloc] initWithItems:segmentTextContent];
//	segmentedControl.selectedSegmentIndex = 0;
//    //	segmentedControl.autoresizingMask = UIViewAutoresizingFlexibleWidth;
//	segmentedControl.segmentedControlStyle = UISegmentedControlStyleBar;
//	segmentedControl.frame = CGRectMake(2, 40, 248, 30);
//	[segmentedControl addTarget:self action:@selector(segmentAction:) forControlEvents:UIControlEventValueChanged];
//    [leftSecondView addSubview:segmentedControl];
    
    CCSegmentedControl* segmentedControl = [[CCSegmentedControl alloc] initWithItems:@[@"股票基金指数", @"债券基金指数", @"混合基金指数"] fontSize:12];
    segmentedControl.frame = CGRectMake(0, 34, 251, 36);
    //设置背景图片，或者设置颜色，或者使用默认白色外观
    segmentedControl.backgroundImage = [UIImage imageNamed:@"segment_bg.png"];
//    segmentedControl.backgroundColor = [UIColor grayColor];
    //阴影部分图片，不设置使用默认椭圆外观的stain
    UIImageView * selectedBgView  = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"img_33"]];
    selectedBgView.frame = CGRectMake(0, 0, 72, 24);
    
    segmentedControl.selectedStainView = selectedBgView;
    segmentedControl.selectedSegmentTextColor = [UIColor whiteColor];
    segmentedControl.segmentTextColor = [UIColor colorWithHexValue:0x333333];
    [segmentedControl addTarget:self action:@selector(segmentAction:) forControlEvents:UIControlEventValueChanged];
    [leftSecondView addSubview:segmentedControl];
    
    leftSecondGram1 = [[UIView alloc]initWithFrame:CGRectMake(0, 70, 252, 278-70)];
    leftSecondGram1.backgroundColor = [UIColor whiteColor];
    [leftSecondView addSubview:leftSecondGram1];
    
    leftSecondGram2 = [[UIView alloc]initWithFrame:CGRectMake(0, 70, 252, 278-70)];
    leftSecondGram2.backgroundColor = [UIColor whiteColor];
    [leftSecondView addSubview:leftSecondGram2];
    
    leftSecondGram3 = [[UIView alloc]initWithFrame:CGRectMake(0, 70, 252, 278-70)];
    leftSecondGram3.backgroundColor = [UIColor whiteColor];
    [leftSecondView addSubview:leftSecondGram3];
    
//    UIView * gram = [[UIView alloc]initWithFrame:CGRectMake(18, 36, 180, 140)];
//    gram.backgroundColor = [UIColor colorWithHexValue:0xd7d8d9];
//    [leftSecondGram1 addSubview:gram];
    
    [leftSecondView bringSubviewToFront:leftSecondGram1];
    leftSecondViewType = SHARE_TYPE;
    
    fundHistoryRequest1 = [self getFundHistoryData:@"MSSFI"];
    fundHistoryRequest2 = [self getFundHistoryData:@"MSBFI"];
    fundHistoryRequest3 = [self getFundHistoryData:@"MSMFI"];
    
    //UIView设置阴影
    [[leftSecondView layer] setShadowOffset:CGSizeMake(1, 1)];
    [[leftSecondView layer] setShadowRadius:5];
    [[leftSecondView layer] setShadowOpacity:1];
    [[leftSecondView layer] setShadowColor:[UIColor grayColor].CGColor];
    //UIView设置边框
    [[leftSecondView layer] setCornerRadius:5];
    
    [self.view addSubview:leftSecondView];
}

- (void)buildRightFirstView
{
    rightFirstView = [[UIView alloc]initWithFrame:CGRectMake(12*3 + 252*2, 12, 252, 278)];
    rightFirstView.backgroundColor = [UIColor whiteColor];
    UIImageView * headerBg = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"home_br"]];
    headerBg.frame = CGRectMake(0, 0, 252, 34);
    [rightFirstView addSubview:headerBg];
    
    UILabel * _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 7, 252, 20)];
    [_titleLabel setTextAlignment:NSTextAlignmentCenter];
    [_titleLabel setTextColor:[UIColor whiteColor]];
    [_titleLabel setFont:[UIFont boldSystemFontOfSize:20]];
    [_titleLabel setBackgroundColor:[UIColor clearColor]];
    _titleLabel.text = @"基金经理业绩排行";
    [rightFirstView addSubview:_titleLabel];
    
    UIView * titleView = [[UIView alloc]initWithFrame:CGRectMake(0, 35, 252, 35)];
    titleView.backgroundColor = [UIColor colorWithHexValue:0xf6f7f8];
    [rightFirstView addSubview:titleView];
    UILabel * _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(12, 10, 80, 15)];
    [_nameLabel setTextAlignment:NSTextAlignmentLeft];
    [_nameLabel setTextColor:[UIColor colorWithHexValue:0x333333]];
    [_nameLabel setFont:[UIFont systemFontOfSize:15]];
    [_nameLabel setBackgroundColor:[UIColor clearColor]];
    _nameLabel.text = @"基金经理";
    [titleView addSubview:_nameLabel];
    UILabel * _repayLabel = [[UILabel alloc] initWithFrame:CGRectMake(112, 11, 50, 12)];
    [_repayLabel setTextAlignment:NSTextAlignmentLeft];
    [_repayLabel setTextColor:[UIColor colorWithHexValue:0x333333]];
    [_repayLabel setFont:[UIFont systemFontOfSize:12]];
    _repayLabel.numberOfLines = 0;
    [_repayLabel setBackgroundColor:[UIColor clearColor]];
    _repayLabel.text = @"任职时间";
    [titleView addSubview:_repayLabel];
    UILabel * _changeLabel = [[UILabel alloc] initWithFrame:CGRectMake(197, 3, 50, 29)];
    [_changeLabel setTextAlignment:NSTextAlignmentLeft];
    [_changeLabel setTextColor:[UIColor colorWithHexValue:0x333333]];
    [_changeLabel setFont:[UIFont systemFontOfSize:12]];
    _changeLabel.numberOfLines = 0;
    [_changeLabel setBackgroundColor:[UIColor clearColor]];
    _changeLabel.text = @"任职期年回报(%)";
    [titleView addSubview:_changeLabel];
    
    rightFirstTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 70, 252, (25+1)*8)
                                                     style:UITableViewStylePlain];
    rightFirstTableView.dataSource = self;
    rightFirstTableView.delegate = self;
    rightFirstTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
	[rightFirstView addSubview:rightFirstTableView];
    
    
    //UIView设置阴影
    [[rightFirstView layer] setShadowOffset:CGSizeMake(1, 1)];
    [[rightFirstView layer] setShadowRadius:5];
    [[rightFirstView layer] setShadowOpacity:1];
    [[rightFirstView layer] setShadowColor:[UIColor grayColor].CGColor];
    //UIView设置边框
    [[rightFirstView layer] setCornerRadius:5];
    
    [self.view addSubview:rightFirstView];
}

- (void)rightSecondBtn1Press:(id)sender
{
    if (!isRightSecond1TableViewShow) {
        [rightSecondBtn1 setBackgroundImage:[UIImage imageNamed:@"home2_16"] forState:UIControlStateNormal];
        [rightSecondBtn2 setBackgroundImage:[UIImage imageNamed:@"home02_17"] forState:UIControlStateNormal];
        [rightSecondBtn1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [rightSecondBtn2 setTitleColor:[UIColor colorWithHexValue:0x606a76] forState:UIControlStateNormal];
        isRightSecond1TableViewShow = YES;
        
        [rightSecondView bringSubviewToFront:rightSecond1TableView];
    }
}


- (void)rightSecondBtn2Press:(id)sender
{
    if (isRightSecond1TableViewShow) {
        [rightSecondBtn1 setBackgroundImage:[UIImage imageNamed:@"home02_16"] forState:UIControlStateNormal];
        [rightSecondBtn2 setBackgroundImage:[UIImage imageNamed:@"home2_17"] forState:UIControlStateNormal];
        [rightSecondBtn2 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [rightSecondBtn1 setTitleColor:[UIColor colorWithHexValue:0x606a76] forState:UIControlStateNormal];
        isRightSecond1TableViewShow = NO;
        
        [rightSecondView bringSubviewToFront:rightSecond2TableView];
    }
}

- (void)buildRightScondView
{
    rightSecondView = [[UIView alloc]initWithFrame:CGRectMake(12*4 + 252*3, 12, 208, 34+35+28*16)];
    rightSecondView.backgroundColor = [UIColor whiteColor];
    
    rightSecondBtn1 = [UIButton buttonWithType:UIButtonTypeCustom];
    rightSecondBtn1.frame = CGRectMake(0, 0, 108, 34);
    [rightSecondBtn1 setBackgroundImage:[UIImage imageNamed:@"home02_16"] forState:UIControlStateNormal];
    [rightSecondBtn1 setTitle:@"我的关注" forState:UIControlStateNormal];
    [rightSecondBtn1 setTitleColor:[UIColor colorWithHexValue:0x606a76] forState:UIControlStateNormal];
    [rightSecondBtn1 addTarget:self action:@selector(rightSecondBtn1Press:) forControlEvents:UIControlEventTouchUpInside];
    UILabel * label = rightSecondBtn1.titleLabel;
    label.font = [UIFont boldSystemFontOfSize:20];
    [rightSecondView addSubview:rightSecondBtn1];
    rightSecondBtn1.enabled = NO;
    rightSecondBtn2 = [UIButton buttonWithType:UIButtonTypeCustom];
    rightSecondBtn2.frame = CGRectMake(108, 0, 100, 34);
    [rightSecondBtn2 setBackgroundImage:[UIImage imageNamed:@"home2_17"] forState:UIControlStateNormal];
    [rightSecondBtn2 setTitle:@"热门基金" forState:UIControlStateNormal];
    [rightSecondBtn2 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [rightSecondBtn2 addTarget:self action:@selector(rightSecondBtn2Press:) forControlEvents:UIControlEventTouchUpInside];
    UILabel * label2 = rightSecondBtn2.titleLabel;
    label2.font = [UIFont boldSystemFontOfSize:20];
    [rightSecondView addSubview:rightSecondBtn2];
    
    UIView * titleView = [[UIView alloc]initWithFrame:CGRectMake(0, 35, 208, 35)];
    titleView.backgroundColor = [UIColor colorWithHexValue:0xf6f7f8];
    [rightSecondView addSubview:titleView];
    UILabel * _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(12, 10, 80, 15)];
    [_nameLabel setTextAlignment:NSTextAlignmentLeft];
    [_nameLabel setTextColor:[UIColor colorWithHexValue:0x333333]];
    [_nameLabel setFont:[UIFont systemFontOfSize:15]];
    [_nameLabel setBackgroundColor:[UIColor clearColor]];
    _nameLabel.text = @"基金名称";
    [titleView addSubview:_nameLabel];
    UILabel * _changeLabel = [[UILabel alloc] initWithFrame:CGRectMake(150, 3, 50, 29)];
    [_changeLabel setTextAlignment:NSTextAlignmentLeft];
    [_changeLabel setTextColor:[UIColor colorWithHexValue:0x333333]];
    [_changeLabel setFont:[UIFont systemFontOfSize:12]];
    _changeLabel.numberOfLines = 0;
    [_changeLabel setBackgroundColor:[UIColor clearColor]];
    _changeLabel.text = @"单位净值(元)";
    [titleView addSubview:_changeLabel];
    
    rightSecond1TableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 70, 208, (27+1)*(8+8))
                                                      style:UITableViewStylePlain];
    rightSecond1TableView.dataSource = self;
    rightSecond1TableView.delegate = self;
    rightSecond1TableView.separatorStyle = UITableViewCellSeparatorStyleNone;
	[rightSecondView addSubview:rightSecond1TableView];
    
    rightSecond2TableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 70, 208, (27+1)*(8+8))
                                                      style:UITableViewStylePlain];
    rightSecond2TableView.dataSource = self;
    rightSecond2TableView.delegate = self;
    rightSecond2TableView.separatorStyle = UITableViewCellSeparatorStyleNone;
	[rightSecondView addSubview:rightSecond2TableView];
    
    [rightSecondView bringSubviewToFront:rightSecond2TableView];
    
    
    //UIView设置阴影
    [[rightSecondView layer] setShadowOffset:CGSizeMake(1, 1)];
    [[rightSecondView layer] setShadowRadius:5];
    [[rightSecondView layer] setShadowOpacity:1];
    [[rightSecondView layer] setShadowColor:[UIColor grayColor].CGColor];
    //UIView设置边框
    [[rightSecondView layer] setCornerRadius:5];
    //    [[rightFirstView layer] setBorderWidth:0];
    //    [[rightFirstView layer] setBorderColor:[UIColor whiteColor].CGColor];
    
    [self.view addSubview:rightSecondView];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}

//处理点击
-(void)singleTapOfTopView:(UITapGestureRecognizer *)sender
{
    FundNewsData * data = [leftBottom_DataArray objectAtIndex:0];
    NewDetailViewController * newsDetailCtrl = [[NewDetailViewController alloc]initWithData:data];
    [self.navigationController pushViewController: newsDetailCtrl animated:YES];
}

//处理点击
-(void)singleTapOfBottomView:(UITapGestureRecognizer *)sender
{
    FundNewsData * data = [leftBottom_DataArray objectAtIndex:1];
    NewDetailViewController * newsDetailCtrl = [[NewDetailViewController alloc]initWithData:data];
    [self.navigationController pushViewController: newsDetailCtrl animated:YES];
}

- (void)buildLeftBottomView
{
    leftBottomView = [[UIView alloc]initWithFrame:CGRectMake(12, 12+278+12, 12*2+252*3, 768-20-44-59-278-12*3)];
    leftBottomView.backgroundColor = [UIColor whiteColor];
    
    UIImageView * headerBg = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 12*2+252*3, 34)];
    headerBg.image = [[UIImage imageNamed:@"home_br"] stretchableImageWithLeftCapWidth:252/2 topCapHeight:34/2];
    [leftBottomView addSubview:headerBg];
    UILabel * _titleHeaderLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 12*2+252*3, 34)];
    [_titleHeaderLabel setTextAlignment:NSTextAlignmentCenter];
    [_titleHeaderLabel setTextColor:[UIColor whiteColor]];
    [_titleHeaderLabel setFont:[UIFont systemFontOfSize:22]];
    [_titleHeaderLabel setBackgroundColor:[UIColor clearColor]];
    _titleHeaderLabel.text = @"基金学堂";
    [headerBg addSubview:_titleHeaderLabel];
    
    UIView * topView = [[UIView alloc]initWithFrame:CGRectMake(0, 34, 524, (768-20-44-59-278-12*3-34)/2)];
    topView.backgroundColor = [UIColor clearColor];
    [leftBottomView addSubview:topView];
    UIImageView * topImgView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"home01_20"]];
    topImgView.frame = CGRectMake(14, 20, 25, 23);
    [topView addSubview:topImgView];
    UILabel * _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, 20, 380, 23)];
    [_titleLabel setTextAlignment:NSTextAlignmentLeft];
    [_titleLabel setTextColor:[UIColor colorWithHexValue:0x57a8e9]];
    [_titleLabel setFont:[UIFont systemFontOfSize:18]];
    [_titleLabel setBackgroundColor:[UIColor clearColor]];
    FundNewsData * data = [leftBottom_DataArray objectAtIndex:0];
    _titleLabel.text = data.title;
    [topView addSubview:_titleLabel];
    UILabel * _timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(440, 20, 80, 23)];
    [_timeLabel setTextAlignment:NSTextAlignmentLeft];
    [_timeLabel setTextColor:[UIColor colorWithHexValue:0x7a7a7a]];
    [_timeLabel setFont:[UIFont systemFontOfSize:14]];
    [_timeLabel setBackgroundColor:[UIColor clearColor]];
    NSRange range = [data.pubtime rangeOfString:@" "];
    if (range.location != NSNotFound) {
        _timeLabel.text = [data.pubtime substringToIndex:range.location + range.length];
    }
    else {
        _timeLabel.text = data.pubtime;
    }
    [topView addSubview:_timeLabel];
//    UILabel * _detailLabel = [[UILabel alloc] initWithFrame:CGRectMake(14, 60, 510, 64)];
//    [_detailLabel setTextAlignment:NSTextAlignmentLeft];
//    [_detailLabel setTextColor:[UIColor colorWithHexValue:0xb9b9b9]];
//    [_detailLabel setFont:[UIFont systemFontOfSize:16]];
//    [_detailLabel setBackgroundColor:[UIColor clearColor]];
//    _detailLabel.numberOfLines = 0;
//    NSString * str = [data.context stringByReplacingPercentEscapesUsingEncoding:NSUnicodeStringEncoding];
//    _detailLabel.text = str;
//    [topView addSubview:_detailLabel];]
    webView1 = [[UIWebView alloc]initWithFrame:CGRectMake(14, 60, 510, 64)];
    [webView1 loadHTMLString:data.context baseURL:nil];
    [topView addSubview:webView1];
    
    UITapGestureRecognizer * singleTapTopView = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapOfTopView:)];
    [topView addGestureRecognizer:singleTapTopView];
    
    UIView * line = [[UIView alloc]initWithFrame:CGRectMake(14, 140, 515, 1)];
    line.backgroundColor = [UIColor colorWithHexValue:0xf1f1f1];
    [topView addSubview:line];
    
    UIView * bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, 34+(768-20-44-59-278-12*3-34)/2, 524, (768-20-44-59-278-12*3-34)/2)];
    bottomView.backgroundColor = [UIColor clearColor];
    [leftBottomView addSubview:bottomView];
    UIImageView * bottomImgView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"home01_20"]];
    bottomImgView.frame = CGRectMake(14, 20, 25, 23);
    [bottomView addSubview:bottomImgView];
    UILabel * _bottomTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, 20, 380, 23)];
    [_bottomTitleLabel setTextAlignment:NSTextAlignmentLeft];
    [_bottomTitleLabel setTextColor:[UIColor colorWithHexValue:0x57a8e9]];
    [_bottomTitleLabel setFont:[UIFont systemFontOfSize:18]];
    [_bottomTitleLabel setBackgroundColor:[UIColor clearColor]];
    FundNewsData * data2 = [leftBottom_DataArray objectAtIndex:1];
    _bottomTitleLabel.text = data2.title;
    [bottomView addSubview:_bottomTitleLabel];
    UILabel * _bottomTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(440, 20, 80, 23)];
    [_bottomTimeLabel setTextAlignment:NSTextAlignmentLeft];
    [_bottomTimeLabel setTextColor:[UIColor colorWithHexValue:0x7a7a7a]];
    [_bottomTimeLabel setFont:[UIFont systemFontOfSize:14]];
    [_bottomTimeLabel setBackgroundColor:[UIColor clearColor]];
    NSRange range2 = [data.pubtime rangeOfString:@" "];
    if (range.location != NSNotFound) {
        _bottomTimeLabel.text = [data.pubtime substringToIndex:range.location + range.length];
    }
    else {
        _bottomTimeLabel.text = data.pubtime;
    }
    [bottomView addSubview:_bottomTimeLabel];
//    UILabel * _bottomDetailLabel = [[UILabel alloc] initWithFrame:CGRectMake(14, 60, 510, 64)];
//    [_bottomDetailLabel setTextAlignment:NSTextAlignmentLeft];
//    [_bottomDetailLabel setTextColor:[UIColor colorWithHexValue:0xb9b9b9]];
//    [_bottomDetailLabel setFont:[UIFont systemFontOfSize:16]];
//    [_bottomDetailLabel setBackgroundColor:[UIColor clearColor]];
//    _bottomDetailLabel.numberOfLines = 0;
//    NSString * str1 = [data2.context stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//    _bottomDetailLabel.text = str1;
//    [bottomView addSubview:_bottomDetailLabel];
    webView2 = [[UIWebView alloc]initWithFrame:CGRectMake(14, 60, 510, 64)];
    [webView2 loadHTMLString:data2.context baseURL:nil];
    [bottomView addSubview:webView2];
    
    UITapGestureRecognizer * singleTapBottomView = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapOfBottomView:)];
    [bottomView addGestureRecognizer:singleTapBottomView];
    
    UIImageView * imgView = [[UIImageView alloc]init];
    imgView.image = [UIImage imageNamed:@"home_bg"];
    imgView.frame = CGRectMake(535, 34+10, 240, 270);
    [leftBottomView addSubview:imgView];
    
    //UIView设置阴影
    [[leftBottomView layer] setShadowOffset:CGSizeMake(1, 1)];
    [[leftBottomView layer] setShadowRadius:5];
    [[leftBottomView layer] setShadowOpacity:1];
    [[leftBottomView layer] setShadowColor:[UIColor grayColor].CGColor];
    //UIView设置边框
    [[leftBottomView layer] setCornerRadius:5];
    
    [self.view addSubview:leftBottomView];
}

- (void)rightBottomBtn1Click:(id)sender
{
    
}

- (void)rightBottomBtn2Click:(id)sender
{
    
}

- (void)rightBottomBtn3Click:(id)sender
{
    
}

- (void)rightBottomBtn4Click:(id)sender
{
    
}

- (void)buildRightBottomView
{
    rightBottomView = [[UIView alloc]initWithFrame:CGRectMake(12*4 + 252*3, 12*2+34+35+28*16, 208, 768-20-44-59-34-35-28*16-12*3)];
    rightBottomView.backgroundColor = [UIColor whiteColor];
    
    UIButton * rightBottomBtn1 = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBottomBtn1.frame = CGRectMake(8, 12, 92, 30);
    [rightBottomBtn1 setBackgroundImage:[UIImage imageNamed:@"img_36"] forState:UIControlStateNormal];
    [rightBottomBtn1 setBackgroundImage:[UIImage imageNamed:@"img_36"] forState:UIControlStateHighlighted];
    [rightBottomBtn1 setTitle:@"选基向导" forState:UIControlStateNormal];
    [rightBottomBtn1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [rightBottomBtn1 addTarget:self action:@selector(rightBottomBtn1Click:) forControlEvents:UIControlEventTouchUpInside];
    UILabel * label = rightBottomBtn1.titleLabel;
    label.font = [UIFont boldSystemFontOfSize:20];
    [rightBottomView addSubview:rightBottomBtn1];
    UIButton * rightBottomBtn2 = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBottomBtn2.frame = CGRectMake(108, 12, 92, 30);
    [rightBottomBtn2 setBackgroundImage:[UIImage imageNamed:@"img_38"] forState:UIControlStateNormal];
    [rightBottomBtn2 setBackgroundImage:[UIImage imageNamed:@"img_38"] forState:UIControlStateHighlighted];
    [rightBottomBtn2 setTitle:@"理财规划" forState:UIControlStateNormal];
    [rightBottomBtn2 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [rightBottomBtn2 addTarget:self action:@selector(rightBottomBtn2Click:) forControlEvents:UIControlEventTouchUpInside];
    UILabel * label2 = rightBottomBtn2.titleLabel;
    label2.font = [UIFont boldSystemFontOfSize:20];
    [rightBottomView addSubview:rightBottomBtn2];
    UIButton * rightBottomBtn3 = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBottomBtn3.frame = CGRectMake(8, 50, 91, 30);
    [rightBottomBtn3 setBackgroundImage:[UIImage imageNamed:@"img_47"] forState:UIControlStateNormal];
    [rightBottomBtn3 setBackgroundImage:[UIImage imageNamed:@"img_47"] forState:UIControlStateHighlighted];
    [rightBottomBtn3 setTitle:@"量化基池" forState:UIControlStateNormal];
    [rightBottomBtn3 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [rightBottomBtn3 addTarget:self action:@selector(rightBottomBtn3Click:) forControlEvents:UIControlEventTouchUpInside];
    UILabel * label3 = rightBottomBtn1.titleLabel;
    label3.font = [UIFont boldSystemFontOfSize:20];
    [rightBottomView addSubview:rightBottomBtn3];
    UIButton * rightBottomBtn4 = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBottomBtn4.frame = CGRectMake(108, 50, 91, 30);
    [rightBottomBtn4 setBackgroundImage:[UIImage imageNamed:@"img_49"] forState:UIControlStateNormal];
    [rightBottomBtn4 setBackgroundImage:[UIImage imageNamed:@"img_49"] forState:UIControlStateHighlighted];
    [rightBottomBtn4 setTitle:@"我的基金" forState:UIControlStateNormal];
    [rightBottomBtn4 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [rightBottomBtn4 addTarget:self action:@selector(rightBottomBtn4Click:) forControlEvents:UIControlEventTouchUpInside];
    UILabel * label4 = rightBottomBtn4.titleLabel;
    label4.font = [UIFont boldSystemFontOfSize:20];
    [rightBottomView addSubview:rightBottomBtn4];
    
    
    //UIView设置阴影
    [[rightBottomView layer] setShadowOffset:CGSizeMake(1, 1)];
    [[rightBottomView layer] setShadowRadius:5];
    [[rightBottomView layer] setShadowOpacity:1];
    [[rightBottomView layer] setShadowColor:[UIColor grayColor].CGColor];
    //UIView设置边框
    [[rightBottomView layer] setCornerRadius:5];
    
    [self.view addSubview:rightBottomView];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == leftFirstTableView) {
        return 5;
    }
    else if (tableView == rightFirstTableView) {
        return 5;
    }
    else if (tableView == rightSecond1TableView || tableView == rightSecond2TableView) {
        return 11;
    }
    else if (tableView == searchTableView) {
        return searchArray.count;
    }

}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == leftFirstTableView) {
        static NSString * cellID = @"leftFirstTableViewCellIdentifier";
        UITableViewCell * cell = (UITableViewCell *)[leftFirstTableView dequeueReusableCellWithIdentifier:cellID];
        if (cell == nil)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
            
            cell.frame = CGRectMake(0, 0, 252, 40);
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            UILabel * _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(12, 12, 120, 16)];
            [_nameLabel setTextAlignment:NSTextAlignmentLeft];
            [_nameLabel setTextColor:[UIColor colorWithHexValue:0x333333]];
            [_nameLabel setFont:[UIFont systemFontOfSize:12]];
            [_nameLabel setBackgroundColor:[UIColor clearColor]];
            _nameLabel.tag = 1;
            [cell addSubview:_nameLabel];
            UILabel * _repayLabel = [[UILabel alloc] initWithFrame:CGRectMake(142, 12, 50, 16)];
            [_repayLabel setTextAlignment:NSTextAlignmentLeft];
            [_repayLabel setTextColor:[UIColor colorWithHexValue:0x333333]];
            [_repayLabel setFont:[UIFont systemFontOfSize:12]];
            [_repayLabel setBackgroundColor:[UIColor clearColor]];
            _repayLabel.tag = 2;
            [cell addSubview:_repayLabel];
            UILabel * _changeLabel = [[UILabel alloc] initWithFrame:CGRectMake(197, 12, 45, 16)];
            [_changeLabel setTextAlignment:NSTextAlignmentLeft];
            [_changeLabel setTextColor:[UIColor colorWithHexValue:0x333333]];
            [_changeLabel setFont:[UIFont systemFontOfSize:12]];
            [_changeLabel setBackgroundColor:[UIColor clearColor]];
            _changeLabel.tag = 3;
            [cell addSubview:_changeLabel];
            UIView * line = [[UIView alloc]initWithFrame:CGRectMake(0, 40, 252, 1)];
            line.backgroundColor = [UIColor colorWithHexValue:0xf1f1f1];
            [cell addSubview:line];
        }
        
        FundRepayData * data = [leftFirstDataArray objectAtIndex:indexPath.row];
        for (UIView * v in cell.subviews) {
            if ([v isKindOfClass:[UILabel class]]) {
                UILabel * label = (UILabel *)v;
                if (label.tag == 1) {
                    label.text = data.name;
                }
                if (label.tag == 2) {
                    label.text = [NSString stringWithFormat:@"%d", data.rr_this_year];
                }
                if (label.tag == 3) {
                    label.text = [NSString stringWithFormat:@"%d", data.limits];
                }
            }
        }
        cell.tag = data.code;
        
        //    [cell configWithData:[self.listDatas objectAtIndex:indexPath.row]];
        
        return cell;
    }
    else if (tableView == rightFirstTableView) {
        static NSString * cellID = @"rightFirstTableViewCellIdentifier";
        UITableViewCell * cell = (UITableViewCell *)[rightFirstTableView dequeueReusableCellWithIdentifier:cellID];
        if (cell == nil)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
            
            cell.frame = CGRectMake(0, 0, 252, 40);
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            UILabel * _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(12, 12, 80, 16)];
            [_nameLabel setTextAlignment:NSTextAlignmentLeft];
            [_nameLabel setTextColor:[UIColor colorWithHexValue:0x333333]];
            [_nameLabel setFont:[UIFont systemFontOfSize:12]];
            [_nameLabel setBackgroundColor:[UIColor clearColor]];
            _nameLabel.tag = 1;
            [cell addSubview:_nameLabel];
            UILabel * _repayLabel = [[UILabel alloc] initWithFrame:CGRectMake(102, 12, 70, 16)];
            [_repayLabel setTextAlignment:NSTextAlignmentLeft];
            [_repayLabel setTextColor:[UIColor colorWithHexValue:0x333333]];
            [_repayLabel setFont:[UIFont systemFontOfSize:12]];
            [_repayLabel setBackgroundColor:[UIColor clearColor]];
            _repayLabel.tag = 2;
            [cell addSubview:_repayLabel];
            UILabel * _changeLabel = [[UILabel alloc] initWithFrame:CGRectMake(197, 12, 45, 16)];
            [_changeLabel setTextAlignment:NSTextAlignmentLeft];
            [_changeLabel setTextColor:[UIColor colorWithHexValue:0x333333]];
            [_changeLabel setFont:[UIFont systemFontOfSize:12]];
            [_changeLabel setBackgroundColor:[UIColor clearColor]];
            _changeLabel.tag = 3;
            [cell addSubview:_changeLabel];
            UIView * line = [[UIView alloc]initWithFrame:CGRectMake(0, 40, 252, 1)];
            line.backgroundColor = [UIColor colorWithHexValue:0xf1f1f1];
            [cell addSubview:line];
        }
        
        ManagerRankData * data = [rightFirstDataArray objectAtIndex:indexPath.row];
        for (UIView * v in cell.subviews) {
            if ([v isKindOfClass:[UILabel class]]) {
                UILabel * label = (UILabel *)v;
                if (label.tag == 1) {
                    label.text = data.name;
                }
                if (label.tag == 2) {
                    label.text = data.take_date;
                }
                if (label.tag == 3) {
                    label.text = [NSString stringWithFormat:@"%d", data.ann_rr_tenure];
                }
            }
        }
        
        //    [cell configWithData:[self.listDatas objectAtIndex:indexPath.row]];
        
        return cell;
    }
    else if (tableView == rightSecond1TableView) {
        static NSString * cellID = @"rightSecond1TableViewCellIdentifier";
        UITableViewCell * cell = (UITableViewCell *)[rightSecond1TableView dequeueReusableCellWithIdentifier:cellID];
        if (cell == nil)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        }
        cell.frame = CGRectMake(0, 0, 252, 40);
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        UILabel * _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(12, 12, 80, 16)];
        [_nameLabel setTextAlignment:NSTextAlignmentLeft];
        [_nameLabel setTextColor:[UIColor colorWithHexValue:0x333333]];
        [_nameLabel setFont:[UIFont systemFontOfSize:12]];
        [_nameLabel setBackgroundColor:[UIColor clearColor]];
        _nameLabel.text = @"广发核心精选";
        [cell addSubview:_nameLabel];
        UILabel * _repayLabel = [[UILabel alloc] initWithFrame:CGRectMake(150, 12, 55, 16)];
        [_repayLabel setTextAlignment:NSTextAlignmentLeft];
        [_repayLabel setTextColor:[UIColor colorWithHexValue:0x333333]];
        [_repayLabel setFont:[UIFont systemFontOfSize:12]];
        [_repayLabel setBackgroundColor:[UIColor clearColor]];
        _repayLabel.text = @"1.927";
        [cell addSubview:_repayLabel];
        UIView * line = [[UIView alloc]initWithFrame:CGRectMake(0, 40, 252, 1)];
        line.backgroundColor = [UIColor colorWithHexValue:0xf1f1f1];
        [cell addSubview:line];
        
        //    [cell configWithData:[self.listDatas objectAtIndex:indexPath.row]];
        
        return cell;
    }
    else if (tableView == rightSecond2TableView) {
        static NSString * cellID = @"rightSecond2TableViewCellIdentifier";
        UITableViewCell * cell = (UITableViewCell *)[rightSecond2TableView dequeueReusableCellWithIdentifier:cellID];
        if (cell == nil)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        }
        cell.frame = CGRectMake(0, 0, 252, 40);
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        UILabel * _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(12, 12, 80, 16)];
        [_nameLabel setTextAlignment:NSTextAlignmentLeft];
        [_nameLabel setTextColor:[UIColor colorWithHexValue:0x333333]];
        [_nameLabel setFont:[UIFont systemFontOfSize:12]];
        [_nameLabel setBackgroundColor:[UIColor clearColor]];
        _nameLabel.text = @"广发核心精选";
        [cell addSubview:_nameLabel];
        UILabel * _repayLabel = [[UILabel alloc] initWithFrame:CGRectMake(150, 12, 55, 16)];
        [_repayLabel setTextAlignment:NSTextAlignmentLeft];
        [_repayLabel setTextColor:[UIColor colorWithHexValue:0x333333]];
        [_repayLabel setFont:[UIFont systemFontOfSize:12]];
        [_repayLabel setBackgroundColor:[UIColor clearColor]];
        _repayLabel.text = @"1.927";
        [cell addSubview:_repayLabel];
        UIView * line = [[UIView alloc]initWithFrame:CGRectMake(0, 40, 252, 1)];
        line.backgroundColor = [UIColor colorWithHexValue:0xf1f1f1];
        [cell addSubview:line];
        
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
    if (tableView == leftFirstTableView) {
        return 40;
    }
    else if (tableView == rightFirstTableView) {
        return 40;
    }
    else if (tableView == rightSecond1TableView || tableView == rightSecond2TableView) {
        return 40;
    }
    else if (tableView == searchTableView) {
        return 45;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell = [tableView cellForRowAtIndexPath:indexPath];
    if (tableView == leftFirstTableView) {
        DetailViewController * detailViewCtrl = [[DetailViewController alloc]initWithFundCode:cell.tag];
        [self.navigationController pushViewController:detailViewCtrl animated:YES];
    }
    else if (tableView == rightFirstTableView) {
    }
    else if (tableView == rightSecond1TableView) {
//        DetailViewController * detailViewCtrl = [[DetailViewController alloc]init];
//        [self.navigationController pushViewController:detailViewCtrl animated:YES];
    }
    else if (tableView == rightSecond2TableView) {
//        DetailViewController * detailViewCtrl = [[DetailViewController alloc]init];
//        [self.navigationController pushViewController:detailViewCtrl animated:YES];
    }
    else if (tableView == searchTableView) {
        [self searchBtnOnPress:nil];
        DetailViewController * detailViewCtrl = [[DetailViewController alloc]initWithFundCode:cell.tag];
        [self.navigationController pushViewController:detailViewCtrl animated:YES];
    }
}


- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (void)dealloc
{
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return (interfaceOrientation == UIInterfaceOrientationLandscapeLeft || interfaceOrientation == UIInterfaceOrientationLandscapeRight);
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden = NO;
	
//	[self onNetConnected];
}

//tab切换时，判断状态是否更新数据
- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)updateLastDataTime
{
    //获取当前时间
    NSDate *date = [NSDate date];
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString * strToday = [formatter stringFromDate:date];
    [[NSUserDefaults standardUserDefaults] setObject:strToday forKey:@"LastDataTime"];
}

- (void) getFundRepayRankDataSuccess:(FundRepayRequest *)request
{
    [self updateLastDataTime];
	BOOL isRequestSuccess = [fundRepayRequest isRequestSuccess];
    if (isRequestSuccess) {
        leftFirstDataArray = [request getDataArray];
        [self buildLeftFirstView];
        
        if ([dbBase open]) {
            
            for (int i = 0; i < leftFirstDataArray.count; ++i) {
                FundRepayData * data = (FundRepayData *)[leftFirstDataArray objectAtIndex:i];
                
                NSString *sql = [NSString stringWithFormat:
                                 @"REPLACE INTO 'FUNDREPAY' ('code', 'py', 'name', 'date', 'net_value', 'account_value', 'limits', 'updown', 'invest_type', 'pur_status', 'redeem_status', 'rr_this_year', 'grade') VALUES ('%d', '%@', '%@', '%@', '%d', '%d', '%d', '%d', '%@', '%@', '%@', '%d', '%d')", data.code, data.py, data.name, data.date, data.net_value, data.account_value, data.limits, data.updown, data.invest_type, data.pur_status, data.redeem_status, data.rr_this_year, data.grade];
                
                BOOL res = [dbBase executeUpdate:sql];
                if (!res) {
                    NSLog(@"error to insert data");
                } else {
                    NSLog(@"succ to insert data");
                }
            }
            
            [dbBase close];
        }
    }
    else {
    }
}

- (void) getFundRepayRankDataRequestFailed:(FundRepayRequest *)request
{
    
}

- (void)getFundRepayRankData
{
    NSString * url = [NSString stringWithFormat:@"%@%@", HOST_NAME, HOME_FUND_REPAY];
    NSMutableArray * array = [[NSMutableArray alloc]initWithCapacity:0];
    [array addObject:[NSString stringWithFormat:@"%@=%@", OPENID, OPENID_VALUE]];
    [array addObject:[NSString stringWithFormat:@"%@=%@", TYPE, DATA_FORMAT]];
    if (_UI.isLogin) {
        [array addObject:[NSString stringWithFormat:@"%@=%@", @"user_name", _UI.userName]];
        [array addObject:[NSString stringWithFormat:@"%@=%@", @"access_token", _UI.loginToken]];
    }
    [array addObject:[NSString stringWithFormat:@"%@=%@", @"page_no", @"1"]];
    [array addObject:[NSString stringWithFormat:@"%@=%@", @"page_size", @"10"]];
    [array addObject:[NSString stringWithFormat:@"%@=%@", @"order_by", @"rr_this_year:desc"]];
    NSString * md5Result = [_UI md5EncParam:array];
    url = [url stringByAppendingString:md5Result];
    url = [url URLEncodedString];
    fundRepayRequest = [[FundRepayRequest alloc]initWithUrl:url];
    
	fundRepayRequest.delegate = self;
    fundRepayRequest.requestDidFinishSelector = @selector(getFundRepayRankDataSuccess:);
    fundRepayRequest.requestDidFailedSelector = @selector(getFundRepayRankDataRequestFailed:);
    
    [fundRepayRequest sendRequest];
}

- (void) getManagerRepayRankDataSuccess:(ManagerRankRequest *)request
{
    [self updateLastDataTime];
	BOOL isRequestSuccess = [managerRankRequest isRequestSuccess];
    if (isRequestSuccess) {
        rightFirstDataArray = [request getDataArray];
        [self buildRightFirstView];
        
        if ([dbBase open]) {
            
            for (int i = 0; i < rightFirstDataArray.count; ++i) {
                ManagerRankData * data = (ManagerRankData *)[rightFirstDataArray objectAtIndex:i];
                
                NSString *sql = [NSString stringWithFormat:
                                 @"REPLACE INTO 'FUNDMANAGERRANK' ('code', 'name', 'take_date', 'leave_date', 'rr_one_year', 'rr_one_year_rank', 'rr_one_year_eval', 'ann_rr_tenure', 'ann_rr_tenure_index', 'rr_sdate') VALUES ('%d', '%@', '%@', '%@', '%d', '%d', '%@', '%d', '%d', '%d')", data.code, data.name, data.take_date, data.leave_date, data.rr_one_year, data.rr_one_year_rank, data.rr_one_year_eval, data.ann_rr_tenure, data.ann_rr_tenure_index, data.rr_sdate];
                
                BOOL res = [dbBase executeUpdate:sql];
                if (!res) {
                    NSLog(@"error to insert data");
                } else {
                    NSLog(@"succ to insert data");
                }
            }
            
            [dbBase close];
        }
    }
    else {
    }
}

- (void) getManagerRepayRankDataRequestFailed:(ManagerRankRequest *)request
{
    
}

- (void)getManagerRepayRankData
{
    NSString * url = [NSString stringWithFormat:@"%@%@", HOST_NAME, HOME_MANAGER_RANK];
    NSMutableArray * array = [[NSMutableArray alloc]initWithCapacity:0];
    [array addObject:[NSString stringWithFormat:@"%@=%@", OPENID, OPENID_VALUE]];
    [array addObject:[NSString stringWithFormat:@"%@=%@", TYPE, DATA_FORMAT]];
    if (_UI.isLogin) {
        [array addObject:[NSString stringWithFormat:@"%@=%@", @"user_name", _UI.userName]];
        [array addObject:[NSString stringWithFormat:@"%@=%@", @"access_token", _UI.loginToken]];
    }
    NSString * md5Result = [_UI md5EncParam:array];
    url = [url stringByAppendingString:md5Result];
    url = [url URLEncodedString];
    managerRankRequest = [[ManagerRankRequest alloc]initWithUrl:url];
    
	managerRankRequest.delegate = self;
    managerRankRequest.requestDidFinishSelector = @selector(getManagerRepayRankDataSuccess:);
    managerRankRequest.requestDidFailedSelector = @selector(getManagerRepayRankDataRequestFailed:);
    
    [managerRankRequest sendRequest];
}

- (void) getFundNewsDataRequestSuccess:(FundNewsRequest *)request
{
    [self updateLastDataTime];
	BOOL isRequestSuccess = [fundNewsRequest isRequestSuccess];
    if (isRequestSuccess) {
        leftBottom_DataArray = [request getDataArray];
        [self buildLeftBottomView];
        if ([dbBase open]) {
            
            for (int i = 0; i < leftBottom_DataArray.count; ++i) {
                FundNewsData * data = (FundNewsData *)[leftBottom_DataArray objectAtIndex:i];
                
                NSString *sql = [NSString stringWithFormat:
                                 @"REPLACE INTO 'FUNDNEWS' ('code', 'pubtime', 'title', 'origin', 'author', 'context', 'channel') VALUES ('%d', '%@', '%@', '%@', '%@', '%@', '%d')", i, data.pubtime, data.title, data.origin, data.author, data.context, data.channel];
                
                BOOL res = [dbBase executeUpdate:sql];
                if (!res) {
                    NSLog(@"error to insert data");
                } else {
                    NSLog(@"succ to insert data");
                }
            }
            
            [dbBase close];
        }
    }
    else {
    }
}

- (void) getFundNewsDataRequestFailed:(FundNewsRequest *)request
{
    
}

- (void)getFundNewsData
{
    NSString * url = [NSString stringWithFormat:@"%@%@", HOST_NAME, HOME_FUND_NEWS];
    NSMutableArray * array = [[NSMutableArray alloc]initWithCapacity:0];
    [array addObject:[NSString stringWithFormat:@"%@=%@", OPENID, OPENID_VALUE]];
    [array addObject:[NSString stringWithFormat:@"%@=%@", TYPE, DATA_FORMAT]];
    if (_UI.isLogin) {
        [array addObject:[NSString stringWithFormat:@"%@=%@", @"user_name", _UI.userName]];
        [array addObject:[NSString stringWithFormat:@"%@=%@", @"access_token", _UI.loginToken]];
    }
    [array addObject:[NSString stringWithFormat:@"%@=%@", @"page_no", @"1"]];
    [array addObject:[NSString stringWithFormat:@"%@=%@", @"page_size", @"5"]];
    NSString * md5Result = [_UI md5EncParam:array];
    url = [url stringByAppendingString:md5Result];
    url = [url URLEncodedString];
    fundNewsRequest = [[FundNewsRequest alloc]initWithUrl:url];
    
	fundNewsRequest.delegate = self;
    fundNewsRequest.requestDidFinishSelector = @selector(getFundNewsDataRequestSuccess:);
    fundNewsRequest.requestDidFailedSelector = @selector(getFundNewsDataRequestFailed:);
    
    [fundNewsRequest sendRequest];
}

- (void) getFundNotMoneyRequestSuccess:(FundNotMoneyRequest *)request
{
    [self updateLastDataTime];
    NSLog(@"getFundNotMoneyRequestSuccess:");
	BOOL isRequestSuccess = [fundNotMoneyRequest isRequestSuccess];
    if (isRequestSuccess) {
        NSMutableArray * array = [fundNotMoneyRequest getDataArray];
        
        if ([dbBase open]) {
            
            for (int i = 0; i < array.count; ++i) {
                FundNotMoneyData * data = (FundNotMoneyData *)[array objectAtIndex:i];
                
                NSString *sql = [NSString stringWithFormat:
                                 @"REPLACE INTO 'FUNDNOTMONEY' ('code', 'py', 'name', 'date', 'net_value', 'account_value', 'type', 'invest_type', 'pur_status', 'redeem_status', 'limits', 'updown', 'rr_this_year', 'grade') VALUES ('%d', '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%d', '%d', '%@', '%@', '%@', '%@')", data.code, data.py, data.name, data.date, data.net_value, data.account_value, data.type, data.invest_type, data.pur_status, data.redeem_status, data.limits, data.updown, data.rr_this_year, data.grade];
                
                BOOL res = [dbBase executeUpdate:sql];
                if (!res) {
                    NSLog(@"error to insert data");
                } else {
                    NSLog(@"succ to insert data");
                }
            }
            
            [dbBase close];
        }
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
    if (_UI.isLogin) {
        [array addObject:[NSString stringWithFormat:@"%@=%@", @"user_name", _UI.userName]];
        [array addObject:[NSString stringWithFormat:@"%@=%@", @"access_token", _UI.loginToken]];
    }
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
    [self updateLastDataTime];
    NSLog(@"getFundMoneyRequestSuccess:");
	BOOL isRequestSuccess = [fundMoneyRequest isRequestSuccess];
    if (isRequestSuccess) {
        NSMutableArray * array = [fundMoneyRequest getDataArray];
        
        if ([dbBase open]) {
            
            for (int i = 0; i < array.count; ++i) {
                FundMoneyData * data = (FundMoneyData *)[array objectAtIndex:i];
                
                NSString *sql = [NSString stringWithFormat:
                                 @"REPLACE INTO 'FUNDMONEY' ('code', 'py', 'name', 'date', 'pay_price', 'seven_areturn', 'type', 'invest_type', 'pur_status', 'redeem_status', 'rr_this_year') VALUES ('%d', '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@')", data.code, data.py, data.name, data.date, data.pay_price, data.seven_areturn, data.type, data.invest_type, data.pur_status, data.redeem_status, data.rr_this_year];
                
                BOOL res = [dbBase executeUpdate:sql];
                if (!res) {
                    NSLog(@"error to insert data");
                } else {
                    NSLog(@"succ to insert data");
                }
            }
            
            [dbBase close];
        }
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
    if (_UI.isLogin) {
        [array addObject:[NSString stringWithFormat:@"%@=%@", @"user_name", _UI.userName]];
        [array addObject:[NSString stringWithFormat:@"%@=%@", @"access_token", _UI.loginToken]];
    }
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

- (void) getFundRankNotMoneyRequestSuccess:(FundRankNotMoneyRequest *)request
{
    [self updateLastDataTime];
    NSLog(@"getFundRankNotMoneyRequestSuccess:");
	BOOL isRequestSuccess = [fundRankNotMoneyRequest isRequestSuccess];
    if (isRequestSuccess) {
        NSMutableArray * array = [fundRankNotMoneyRequest getDataArray];
        
        if ([dbBase open]) {
            
            for (int i = 0; i < array.count; ++i) {
                FundRankNotMoneyData * data = (FundRankNotMoneyData *)[array objectAtIndex:i];
                
                NSString *sql = [NSString stringWithFormat:
                                 @"REPLACE INTO 'FUNDRANKNOTMONEY' ('code', 'py', 'name', 'date', 'net_value', 'account_value', 'rr_one_month', 'rr_one_month_rank', 'rr_three_month', 'rr_three_month_rank', 'rr_six_month', 'rr_six_month_rank', 'rr_this_year', 'rr_this_year_rank', 'rr_one_year', 'rr_one_year_rank', 'rr_two_year', 'rr_two_year_rank', 'rr_three_year', 'rr_three_year_rank', 'estb_date') VALUES ('%d', '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@')", data.code, data.py, data.name, data.date, data.net_value, data.account_value, data.rr_one_month, data.rr_one_month_rank, data.rr_three_month, data.rr_three_month_rank, data.rr_six_month, data.rr_six_month_rank, data.rr_this_year, data.rr_this_year_rank, data.rr_one_year, data.rr_one_year_rank, data.rr_two_year, data.rr_two_year_rank, data.rr_three_year, data.rr_three_year_rank, data.estb_date];
                
                BOOL res = [dbBase executeUpdate:sql];
                if (!res) {
                    NSLog(@"error to insert data");
                } else {
                    NSLog(@"succ to insert data");
                }
            }
            
            [dbBase close];
        }
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
    if (_UI.isLogin) {
        [array addObject:[NSString stringWithFormat:@"%@=%@", @"user_name", _UI.userName]];
        [array addObject:[NSString stringWithFormat:@"%@=%@", @"access_token", _UI.loginToken]];
    }
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
    [self updateLastDataTime];
    NSLog(@"getFundRankMoneyRequestSuccess:");
	BOOL isRequestSuccess = [fundRankMoneyRequest isRequestSuccess];
    if (isRequestSuccess) {
        NSMutableArray * array = [fundRankMoneyRequest getDataArray];
        
        if ([dbBase open]) {
            
            for (int i = 0; i < array.count; ++i) {
                FundRankMoneyData * data = (FundRankMoneyData *)[array objectAtIndex:i];
                
                NSString *sql = [NSString stringWithFormat:
                                 @"REPLACE INTO 'FUNDRANKMONEY' ('code', 'py', 'name', 'date', 'pay_price', 'seven_areturn', 'rr_one_month', 'rr_one_month_rank', 'rr_three_month', 'rr_three_month_rank', 'rr_six_month', 'rr_six_month_rank', 'rr_this_year', 'rr_this_year_rank', 'rr_one_year', 'rr_one_year_rank', 'rr_two_year', 'rr_two_year_rank', 'rr_three_year', 'rr_three_year_rank', 'estb_date') VALUES ('%d', '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@')", data.code, data.py, data.name, data.date, data.pay_price, data.seven_areturn, data.rr_one_month, data.rr_one_month_rank, data.rr_three_month, data.rr_three_month_rank, data.rr_six_month, data.rr_six_month_rank, data.rr_this_year, data.rr_this_year_rank, data.rr_one_year, data.rr_one_year_rank, data.rr_two_year, data.rr_two_year_rank, data.rr_three_year, data.rr_three_year_rank, data.estb_date];
                
                BOOL res = [dbBase executeUpdate:sql];
                if (!res) {
                    NSLog(@"error to insert data");
                } else {
                    NSLog(@"succ to insert data");
                }
            }
            
            [dbBase close];
        }
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
    if (_UI.isLogin) {
        [array addObject:[NSString stringWithFormat:@"%@=%@", @"user_name", _UI.userName]];
        [array addObject:[NSString stringWithFormat:@"%@=%@", @"access_token", _UI.loginToken]];
    }
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

- (void) getFundHistoryRequestSuccess:(FundHistoryRequest *)request
{
	BOOL isRequestSuccess = [request isRequestSuccess];
    @try {
        if (isRequestSuccess) {
            NSMutableArray* arr = [[NSMutableArray alloc]init];
            if (SHARE_TYPE == [request getCode]) {
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
                fundHistoryMax1 = [[arr objectAtIndex:arr.count-1]intValue];
                fundHistoryMin1 = [[arr objectAtIndex:0]intValue];
                NSLog(@"*********** %d,%d",fundHistoryMax1, fundHistoryMin1);
                
                for (int j = 0; j < dataForPlot1.count; ++j) {
                    NSDictionary * dic = [dataForPlot1 objectAtIndex:j];
                    CGPoint point = CGPointMake([[dic objectForKey:@"x"]floatValue], [[dic objectForKey:@"y"]floatValue]);
                    NSLog(@"point : %f,%f",point.x,point.y);
                    
                }
                UIView * gram1 = [self buildView1];
                //            [leftSecondGram1 addSubview:gram1];
            }
            else if (BOND_TYPE == [request getCode]) {
                fundHistoryData2 = [request getDataArray];
                
                int offset = fundHistoryData2.count - 60;
                for (int x = 0; x < 60; ++x) {
                    if (offset + x < 0) {
                        NSString *xp = [NSString stringWithFormat:@"%d",x];
                        NSString *yp = [NSString stringWithFormat:@"%d",0];
                        NSMutableDictionary *point1 = [[NSMutableDictionary alloc] initWithObjectsAndKeys:xp, @"x", yp, @"y", nil];
                        [dataForPlot2 insertObject:point1 atIndex:x];
                        NSLog(@"*********** %@,%@",xp, yp);
                        continue;
                    }
                    FundHistoryData * data = [fundHistoryData1 objectAtIndex:x+offset];
                    //添加数
                    //            if ([dataSourceLinePlot.identifier isEqual:@"Green Plot"])
                    {
                        NSString *xp = [NSString stringWithFormat:@"%d",x];
                        NSString *yp = [NSString stringWithFormat:@"%d",[data.net_value intValue]];
                        NSMutableDictionary *point1 = [[NSMutableDictionary alloc] initWithObjectsAndKeys:xp, @"x", yp, @"y", nil];
                        [dataForPlot2 insertObject:point1 atIndex:x];
                        [arr addObject:[NSString stringWithFormat:@"%d", [data.net_value intValue]]];
                        NSLog(@"*********** %@,%@",xp, yp);
                    }
                }
                
                // 升序
                [arr sortUsingComparator:^NSComparisonResult(__strong id obj1,__strong id obj2){
                    NSString *str1=(NSString *)obj1;
                    NSString *str2=(NSString *)obj2;
                    return [str1 compare:str2];
                }];
                fundHistoryMax2 = [[arr objectAtIndex:arr.count-1]intValue];
                fundHistoryMin2 = [[arr objectAtIndex:0]intValue];
                NSLog(@"*********** %d,%d",fundHistoryMax2, fundHistoryMin2);
                UIView * gram2 = [self buildView2];
                [leftSecondGram2 addSubview:gram2];
            }
            else if (GROUP_TYPE == [request getCode]) {
                fundHistoryData3 = [request getDataArray];
                
                int offset = fundHistoryData3.count - 60;
                for (int x = 0; x < 60; ++x) {
                    if (offset + x < 0) {
                        NSString *xp = [NSString stringWithFormat:@"%d",x];
                        NSString *yp = [NSString stringWithFormat:@"%d",0];
                        NSMutableDictionary *point1 = [[NSMutableDictionary alloc] initWithObjectsAndKeys:xp, @"x", yp, @"y", nil];
                        [dataForPlot3 insertObject:point1 atIndex:x];
                        NSLog(@"*********** %@,%@",xp, yp);
                        continue;
                    }
                    FundHistoryData * data = [fundHistoryData3 objectAtIndex:x+offset];
                    //添加数
                    //            if ([dataSourceLinePlot.identifier isEqual:@"Green Plot"])
                    {
                        NSString *xp = [NSString stringWithFormat:@"%d",x];
                        NSString *yp = [NSString stringWithFormat:@"%d",[data.net_value intValue]];
                        NSMutableDictionary *point1 = [[NSMutableDictionary alloc] initWithObjectsAndKeys:xp, @"x", yp, @"y", nil];
                        [dataForPlot3 insertObject:point1 atIndex:x];
                        [arr addObject:[NSString stringWithFormat:@"%d", [data.net_value intValue]]];
                        NSLog(@"*********** %@,%@",xp, yp);
                    }
                }
                
                // 升序
                [arr sortUsingComparator:^NSComparisonResult(__strong id obj1,__strong id obj2){
                    NSString *str1=(NSString *)obj1;
                    NSString *str2=(NSString *)obj2;
                    return [str1 compare:str2];
                }];
                fundHistoryMax3 = [[arr objectAtIndex:arr.count-1]intValue];
                fundHistoryMin3 = [[arr objectAtIndex:0]intValue];
                NSLog(@"*********** %d,%d",fundHistoryMax3, fundHistoryMin3);
                UIView * gram3 = [self buildView3];
                [leftSecondGram3 addSubview:gram3];
            }
        }
        else {
            fundHistoryMax1 = 100;
            fundHistoryMin1 = 0;
            fundHistoryMax2 = 100;
            fundHistoryMin2 = 0;
            fundHistoryMax3 = 100;
            fundHistoryMin3 = 0;
        }
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
}

- (void) getFundHistoryRequestFailed:(FundHistoryRequest *)request
{
    
}

- (void) getMyFundRequestSuccess
{
	BOOL isRequestSuccess = [[MyFavoriteFundList sharedInstance] isFundDataReady];
    @try {
        if (isRequestSuccess) {
        }
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
}

- (void) getMyFundRequestFailed
{
    
}

- (FundHistoryRequest *)getFundHistoryData:(NSString *)code
{
    NSString * url = [NSString stringWithFormat:@"%@%@", HOST_NAME, FUND_HISTORY];
    NSMutableArray * array = [[NSMutableArray alloc]initWithCapacity:0];
    [array addObject:[NSString stringWithFormat:@"%@=%@", OPENID, OPENID_VALUE]];
    [array addObject:[NSString stringWithFormat:@"%@=%@", TYPE, DATA_FORMAT]];
    if (_UI.isLogin) {
        [array addObject:[NSString stringWithFormat:@"%@=%@", @"user_name", _UI.userName]];
        [array addObject:[NSString stringWithFormat:@"%@=%@", @"access_token", _UI.loginToken]];
    }
    //    [array addObject:[NSString stringWithFormat:@"%@=%@", @"page_no", @"1"]];
    //    [array addObject:[NSString stringWithFormat:@"%@=%@", @"page_size", @"2"]];
    [array addObject:[NSString stringWithFormat:@"%@=%@", @"code", code]];
    
    
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
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    return YES;
}
- (void)webViewDidStartLoad:(UIWebView *)webView
{
    
}
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    
}
@end
