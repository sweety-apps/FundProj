//
//  AnalyseViewController.m
//  FundPrj
//
//  Created by leesea on 13-11-4.
//  Copyright (c) 2013年 leesea. All rights reserved.
//

#import "AnalyseViewController.h"
#import "FundAnalyseViewController.h"
#import "FundCompareViewController.h"
#import "FMDatabase.h"
#import "FMDatabaseQueue.h"
#import "FundInfoData.h"
#import <QuartzCore/QuartzCore.h>


#define DB_NAME    @"FundDB.sqlite"
#define NAME      @"name"
#define CODE       @"code"
#define PY   @"py"

@interface AnalyseViewController ()
{
    UITextField * textField;
    
    UILabel * fundLabel1;
    UILabel * fundLabel2;
    UILabel * fundLabel3;
    UILabel * fundLabel4;
    UILabel * fundLabel5;
    
    UIButton * fundBtn1;
    UIButton * fundBtn2;
    UIButton * fundBtn3;
    UIButton * fundBtn4;
    UIButton * fundBtn5;
    
    NSInteger count;
    UIView * popView;
    
    NSString *db_path;
    
    FMDatabase *dbBase;
    
    UIView * searchBg;
    UITableView * searchTableView;
    NSMutableArray * searchArray;
}

@end

@implementation AnalyseViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        count = 0;
        
        db_path = [PATH_OF_DOCUMENT stringByAppendingPathComponent:DB_NAME];
        searchArray = [[NSMutableArray alloc]initWithCapacity:0];
        dbBase = [FMDatabase databaseWithPath:db_path];
    }
    return self;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex

{
    [popView removeFromSuperview];
    popView = nil;
}

- (void) textFieldDidChange:(id) sender {
    if (textField == sender) {
        [searchArray removeAllObjects];
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

- (BOOL)textFieldShouldReturn:(UITextField *)tField
{
    [tField resignFirstResponder];
    
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)tField
{
    if (textField == tField) {
        searchBg = [[UIView alloc]initWithFrame:self.view.bounds];
        searchBg.backgroundColor = [UIColor clearColor];
        [self.view addSubview:searchBg];
        [self.view bringSubviewToFront:textField];
        
        UITapGestureRecognizer * singleTapSearchBgView = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tableViewCellOnSelect)];
        [searchBg addGestureRecognizer:singleTapSearchBgView];
        
        searchTableView = [[UITableView alloc]initWithFrame:CGRectMake(720, 10, 290, 350)
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

- (void)fundBtnPress:(id)sender
{
    UIButton * btn = (UIButton *)sender;
    if (btn == fundBtn1) {
        if (count == 1) {
            count--;
            fundLabel1.hidden = YES;
            fundBtn1.hidden = YES;
            return;
        }
        else {
            fundLabel1.text = fundLabel2.text;
            fundLabel2.text = fundLabel3.text;
            fundLabel3.text = fundLabel4.text;
            fundLabel4.text = fundLabel5.text;
            if (count == 2) {
                count--;
                fundLabel2.hidden = YES;
                fundBtn2.hidden = YES;
                return;
            }
            else if (count == 3) {
                count--;
                fundLabel3.hidden = YES;
                fundBtn3.hidden = YES;
                return;
            }
            else if (count == 4) {
                count--;
                fundLabel4.hidden = YES;
                fundBtn4.hidden = YES;
                return;
            }
            else if (count == 5) {
                count--;
                fundLabel5.hidden = YES;
                fundBtn5.hidden = YES;
                return;
            }
        }
    }
    if (btn == fundBtn2) {
        if (count < 2) {
            return;
        }
        else if (count == 2) {
            count--;
            fundLabel2.hidden = YES;
            fundBtn2.hidden = YES;
            return;
        }
        else {
            fundLabel2.text = fundLabel3.text;
            fundLabel3.text = fundLabel4.text;
            fundLabel4.text = fundLabel5.text;
            if (count == 3) {
                count--;
                fundLabel3.hidden = YES;
                fundBtn3.hidden = YES;
                return;
            }
            else if (count == 4) {
                count--;
                fundLabel4.hidden = YES;
                fundBtn4.hidden = YES;
                return;
            }
            else if (count == 5) {
                count--;
                fundLabel5.hidden = YES;
                fundBtn5.hidden = YES;
                return;
            }
        }
    }
    if (btn == fundBtn3) {
        if (count < 3) {
            return;
        }
        else if (count == 3) {
            count--;
            fundLabel3.hidden = YES;
            fundBtn3.hidden = YES;
            return;
        }
        else {
            fundLabel3.text = fundLabel4.text;
            fundLabel4.text = fundLabel5.text;
            if (count == 4) {
                count--;
                fundLabel4.hidden = YES;
                fundBtn4.hidden = YES;
                return;
            }
            else if (count == 5) {
                count--;
                fundLabel5.hidden = YES;
                fundBtn5.hidden = YES;
                return;
            }
        }
    }
    if (btn == fundBtn4) {
        if (count < 4) {
            return;
        }
        else if (count == 4) {
            count--;
            fundLabel4.hidden = YES;
            fundBtn4.hidden = YES;
            return;
        }
        else {
            fundLabel4.text = fundLabel5.text;
            if (count == 5) {
                count--;
                fundLabel5.hidden = YES;
                fundBtn5.hidden = YES;
                return;
            }
        }
    }
    if (btn == fundBtn5) {
        if (count < 5) {
            return;
        }
        else if (count == 5) {
            count--;
            fundLabel5.hidden = YES;
            fundBtn5.hidden = YES;
            return;
        }
    }
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
    
    UIImageView * topImgView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"fenxi_02"]];
    topImgView.frame = CGRectMake(0, 0, 1024, 241);
    [self.view addSubview:topImgView];
    
    UIImageView * midImgView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"fenxi_03"]];
    midImgView.frame = CGRectMake(0, 241, 1024, 69);
    [self.view addSubview:midImgView];
    midImgView.userInteractionEnabled = YES;
    
    textField = [[UITextField alloc] initWithFrame:CGRectMake(160, 241, 740, 50)];
    textField.backgroundColor = [UIColor clearColor];
    textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    textField.borderStyle = UITextBorderStyleNone;
    textField.textColor = [UIColor blackColor];
    textField.font = [UIFont systemFontOfSize:22];
    textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    textField.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    textField.returnKeyType = UIReturnKeySearch;
    textField.delegate = self;
    textField.autocorrectionType = UITextAutocorrectionTypeNo;
    textField.enablesReturnKeyAutomatically = YES;
    textField.placeholder = @"请输入需要检查的基金代码或名称";
    [self.view addSubview:textField];
    [textField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    
    UIImageView * bottomImgView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"fenxi_04"]];
    bottomImgView.frame = CGRectMake(0, 241+69, 1024, 381);
    [self.view addSubview:bottomImgView];
    bottomImgView.userInteractionEnabled = YES;
    
    UIButton * checkBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    checkBtn.frame = CGRectMake(377, 25, 129, 56);
    [checkBtn setBackgroundImage:[UIImage imageNamed:@"img_33"] forState:UIControlStateNormal];
    [checkBtn setBackgroundImage:[UIImage imageNamed:@"img_33"] forState:UIControlStateHighlighted];
    [checkBtn setTitle:@"健康体检" forState:UIControlStateNormal];
    [checkBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [checkBtn addTarget:self action:@selector(checkBtnPress:) forControlEvents:UIControlEventTouchUpInside];
    UILabel * label = checkBtn.titleLabel;
    label.font = [UIFont boldSystemFontOfSize:26];
    [bottomImgView addSubview:checkBtn];
    
    UIButton * addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    addBtn.frame = CGRectMake(517, 25, 129, 56);
    [addBtn setBackgroundImage:[UIImage imageNamed:@"img_33"] forState:UIControlStateNormal];
    [addBtn setBackgroundImage:[UIImage imageNamed:@"img_33"] forState:UIControlStateHighlighted];
    [addBtn setTitle:@"添加对比" forState:UIControlStateNormal];
    [addBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [addBtn addTarget:self action:@selector(addBtnPress:) forControlEvents:UIControlEventTouchUpInside];
    UILabel * label1 = addBtn.titleLabel;
    label1.font = [UIFont boldSystemFontOfSize:26];
    [bottomImgView addSubview:addBtn];
    
    UIView * selectView = [[UIView alloc]initWithFrame:CGRectMake(90, 110, 1024-90*2, 104)];
    selectView.backgroundColor = [UIColor colorWithHexValue:0x87cce6];
    [bottomImgView addSubview:selectView];
    
    fundLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(32, 16, 110, 20)];
    [fundLabel1 setTextAlignment:NSTextAlignmentLeft];
    [fundLabel1 setTextColor:[UIColor whiteColor]];
    [fundLabel1 setFont:[UIFont systemFontOfSize:18]];
    [fundLabel1 setBackgroundColor:[UIColor clearColor]];
    fundLabel1.text = @"广发核心精选";
    [selectView addSubview:fundLabel1];
    fundBtn1 = [UIButton buttonWithType:UIButtonTypeCustom];
    fundBtn1.frame = CGRectMake(32+110+10, 18, 17, 16);
    [fundBtn1 setBackgroundImage:[UIImage imageNamed:@"fenxi2_10"] forState:UIControlStateNormal];
    [fundBtn1 setBackgroundImage:[UIImage imageNamed:@"fenxi2_10"] forState:UIControlStateHighlighted];
    [fundBtn1 addTarget:self action:@selector(fundBtnPress:) forControlEvents:UIControlEventTouchUpInside];
    [selectView addSubview:fundBtn1];
    
    fundLabel2 = [[UILabel alloc] initWithFrame:CGRectMake(32+211, 16, 110, 20)];
    [fundLabel2 setTextAlignment:NSTextAlignmentLeft];
    [fundLabel2 setTextColor:[UIColor whiteColor]];
    [fundLabel2 setFont:[UIFont systemFontOfSize:18]];
    [fundLabel2 setBackgroundColor:[UIColor clearColor]];
    fundLabel2.text = @"广发核心精选1";
    [selectView addSubview:fundLabel2];
    fundBtn2 = [UIButton buttonWithType:UIButtonTypeCustom];
    fundBtn2.frame = CGRectMake(32+110+10+211, 18, 17, 16);
    [fundBtn2 setBackgroundImage:[UIImage imageNamed:@"fenxi2_10"] forState:UIControlStateNormal];
    [fundBtn2 setBackgroundImage:[UIImage imageNamed:@"fenxi2_10"] forState:UIControlStateHighlighted];
    [fundBtn2 addTarget:self action:@selector(fundBtnPress:) forControlEvents:UIControlEventTouchUpInside];
    [selectView addSubview:fundBtn2];
    
    fundLabel3 = [[UILabel alloc] initWithFrame:CGRectMake(32+211*2, 16, 110, 20)];
    [fundLabel3 setTextAlignment:NSTextAlignmentLeft];
    [fundLabel3 setTextColor:[UIColor whiteColor]];
    [fundLabel3 setFont:[UIFont systemFontOfSize:18]];
    [fundLabel3 setBackgroundColor:[UIColor clearColor]];
    fundLabel3.text = @"广发核心精选11";
    [selectView addSubview:fundLabel3];
    fundBtn3 = [UIButton buttonWithType:UIButtonTypeCustom];
    fundBtn3.frame = CGRectMake(32+110+10+211*2, 18, 17, 16);
    [fundBtn3 setBackgroundImage:[UIImage imageNamed:@"fenxi2_10"] forState:UIControlStateNormal];
    [fundBtn3 setBackgroundImage:[UIImage imageNamed:@"fenxi2_10"] forState:UIControlStateHighlighted];
    [fundBtn3 addTarget:self action:@selector(fundBtnPress:) forControlEvents:UIControlEventTouchUpInside];
    [selectView addSubview:fundBtn3];
    
    fundLabel4 = [[UILabel alloc] initWithFrame:CGRectMake(32, 64, 110, 20)];
    [fundLabel4 setTextAlignment:NSTextAlignmentLeft];
    [fundLabel4 setTextColor:[UIColor whiteColor]];
    [fundLabel4 setFont:[UIFont systemFontOfSize:18]];
    [fundLabel4 setBackgroundColor:[UIColor clearColor]];
    fundLabel4.text = @"广发核心精选111";
    [selectView addSubview:fundLabel4];
    fundBtn4 = [UIButton buttonWithType:UIButtonTypeCustom];
    fundBtn4.frame = CGRectMake(32+110+10, 66, 17, 16);
    [fundBtn4 setBackgroundImage:[UIImage imageNamed:@"fenxi2_10"] forState:UIControlStateNormal];
    [fundBtn4 setBackgroundImage:[UIImage imageNamed:@"fenxi2_10"] forState:UIControlStateHighlighted];
    [fundBtn4 addTarget:self action:@selector(fundBtnPress:) forControlEvents:UIControlEventTouchUpInside];
    [selectView addSubview:fundBtn4];
    
    fundLabel5 = [[UILabel alloc] initWithFrame:CGRectMake(32+211, 64, 110, 20)];
    [fundLabel5 setTextAlignment:NSTextAlignmentLeft];
    [fundLabel5 setTextColor:[UIColor whiteColor]];
    [fundLabel5 setFont:[UIFont systemFontOfSize:18]];
    [fundLabel5 setBackgroundColor:[UIColor clearColor]];
    fundLabel5.text = @"广发核心精选1111";
    [selectView addSubview:fundLabel5];
    fundBtn5 = [UIButton buttonWithType:UIButtonTypeCustom];
    fundBtn5.frame = CGRectMake(32+110+10+211, 66, 17, 16);
    [fundBtn5 setBackgroundImage:[UIImage imageNamed:@"fenxi2_10"] forState:UIControlStateNormal];
    [fundBtn5 setBackgroundImage:[UIImage imageNamed:@"fenxi2_10"] forState:UIControlStateHighlighted];
    [fundBtn5 addTarget:self action:@selector(fundBtnPress:) forControlEvents:UIControlEventTouchUpInside];
    [selectView addSubview:fundBtn5];
    
    UIButton * startBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    startBtn.frame = CGRectMake(607, 34, 99, 35);
    [startBtn setBackgroundImage:[UIImage imageNamed:@"fenxi2_14"] forState:UIControlStateNormal];
    [startBtn setBackgroundImage:[UIImage imageNamed:@"fenxi2_14"] forState:UIControlStateHighlighted];
    [startBtn setTitle:@"开始对比" forState:UIControlStateNormal];
    [startBtn setTitleColor:[UIColor colorWithHexValue:0x2b3742] forState:UIControlStateNormal];
    [startBtn addTarget:self action:@selector(startBtnPress:) forControlEvents:UIControlEventTouchUpInside];
    UILabel * label11 = startBtn.titleLabel;
    label11.font = [UIFont boldSystemFontOfSize:20];
    [selectView addSubview:startBtn];
    
    UIButton * groupBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    groupBtn.frame = CGRectMake(719, 34, 99, 35);
    [groupBtn setBackgroundImage:[UIImage imageNamed:@"fenxi2_14"] forState:UIControlStateNormal];
    [groupBtn setBackgroundImage:[UIImage imageNamed:@"fenxi2_14"] forState:UIControlStateHighlighted];
    [groupBtn setTitle:@"组合分析" forState:UIControlStateNormal];
    [groupBtn setTitleColor:[UIColor colorWithHexValue:0x2b3742] forState:UIControlStateNormal];
    [groupBtn addTarget:self action:@selector(groupBtnPress:) forControlEvents:UIControlEventTouchUpInside];
    UILabel * label12 = groupBtn.titleLabel;
    label12.font = [UIFont boldSystemFontOfSize:20];
    [selectView addSubview:groupBtn];
    
    fundLabel1.hidden = YES;
    fundLabel2.hidden = YES;
    fundLabel3.hidden = YES;
    fundLabel4.hidden = YES;
    fundLabel5.hidden = YES;
    fundBtn1.hidden = YES;
    fundBtn2.hidden = YES;
    fundBtn3.hidden = YES;
    fundBtn4.hidden = YES;
    fundBtn5.hidden = YES;
}

- (void)checkBtnPress:(id)sender
{
    //return;
    [self textFieldShouldReturn:textField];
    
    NSString * str = textField.text;
    str = [str stringByReplacingOccurrencesOfString:@" " withString:@""];
    textField.text = NULL;
    if (str == NULL || str == @"") {
        
        UIAlertView*alert = [[UIAlertView alloc]initWithTitle:@"请输入需要检查的基金代码或名称"
                             
                                                      message:nil
                             
                                                     delegate:self
                             
                                            cancelButtonTitle:@"确定"
                             
                                            otherButtonTitles:nil];
        
        [alert show];
        return ;
    }
    
    FundAnalyseViewController * fundAnalyseCtrl = [[FundAnalyseViewController alloc]initWithFundCode:[self getFundId:str]];
    [self.navigationController pushViewController:fundAnalyseCtrl animated:YES];
}

- (void)addBtnPress:(id)sender
{
    [self textFieldShouldReturn:textField];
    
    NSString * str = textField.text;
    str = [str stringByReplacingOccurrencesOfString:@" " withString:@""];
    textField.text = NULL;
    if (str == NULL || str == @"") {
        
        UIAlertView*alert = [[UIAlertView alloc]initWithTitle:@"请输入需要对比的基金代码或名称"
                             
                                                      message:nil
                             
                                                     delegate:self
                             
                                            cancelButtonTitle:@"确定"
                             
                                            otherButtonTitles:nil];
        
        [alert show];
        return;
    }
    else {
        if (count == 0) {
            fundLabel1.text = str;
            fundLabel1.hidden = NO;
            fundBtn1.hidden = NO;
            count++;
        }
        else if (count == 1) {
            fundLabel2.text = str;
            fundLabel2.hidden = NO;
            fundBtn2.hidden = NO;
            count++;
        }
        else if (count == 2) {
            fundLabel3.text = str;
            fundLabel3.hidden = NO;
            fundBtn3.hidden = NO;
            count++;
        }
        else if (count == 3) {
            fundLabel4.text = str;
            fundLabel4.hidden = NO;
            fundBtn4.hidden = NO;
            count++;
        }
        else if (count == 4) {
            fundLabel5.text = str;
            fundLabel5.hidden = NO;
            fundBtn5.hidden = NO;
            count++;
        }
        else {
            
            UIAlertView*alert = [[UIAlertView alloc]initWithTitle:@"对不起，目前暂时不能对比超过5只基金"
                                 
                                                          message:nil
                                 
                                                         delegate:self
                                 
                                                cancelButtonTitle:@"确定"
                                 
                                                otherButtonTitles:nil];
            
            [alert show];
        }
    }
}

- (void)startBtnPress:(id)sender
{
    FundCompareViewController * fundCompareCtrl  = [[FundCompareViewController alloc]init];
    if (count == 0) {
        
        UIAlertView*alert = [[UIAlertView alloc]initWithTitle:@"请输入需要检查的基金代码或名称"
                             
                                                      message:nil
                             
                                                     delegate:self
                             
                                            cancelButtonTitle:@"确定"
                             
                                            otherButtonTitles:nil];
        
        [alert show];
        return;
    }
    else if (count == 1) {
        NSInteger ID = [self getFundId:fundLabel1.text];
        if (ID != 0) {
            [fundCompareCtrl.fundArray addObject:[NSNumber numberWithInt:ID]];
        }
    }
    else if (count == 2) {
        NSInteger ID = [self getFundId:fundLabel1.text];
        if (ID != 0) {
            [fundCompareCtrl.fundArray addObject:[NSNumber numberWithInt:ID]];
        }
        ID = [self getFundId:fundLabel2.text];
        if (ID != 0) {
            [fundCompareCtrl.fundArray addObject:[NSNumber numberWithInt:ID]];
        }
    }
    else if (count == 3) {
        NSInteger ID = [self getFundId:fundLabel1.text];
        if (ID != 0) {
            [fundCompareCtrl.fundArray addObject:[NSNumber numberWithInt:ID]];
        }
        ID = [self getFundId:fundLabel2.text];
        if (ID != 0) {
            [fundCompareCtrl.fundArray addObject:[NSNumber numberWithInt:ID]];
        }
        ID = [self getFundId:fundLabel3.text];
        if (ID != 0) {
            [fundCompareCtrl.fundArray addObject:[NSNumber numberWithInt:ID]];
        }
    }
    else if (count == 4) {
        NSInteger ID = [self getFundId:fundLabel1.text];
        if (ID != 0) {
            [fundCompareCtrl.fundArray addObject:[NSNumber numberWithInt:ID]];
        }
        ID = [self getFundId:fundLabel2.text];
        if (ID != 0) {
            [fundCompareCtrl.fundArray addObject:[NSNumber numberWithInt:ID]];
        }
        ID = [self getFundId:fundLabel3.text];
        if (ID != 0) {
            [fundCompareCtrl.fundArray addObject:[NSNumber numberWithInt:ID]];
        }
        ID = [self getFundId:fundLabel4.text];
        if (ID != 0) {
            [fundCompareCtrl.fundArray addObject:[NSNumber numberWithInt:ID]];
        }
    }
    else if (count == 5) {
        NSInteger ID = [self getFundId:fundLabel1.text];
        if (ID != 0) {
            [fundCompareCtrl.fundArray addObject:[NSNumber numberWithInt:ID]];
        }
        ID = [self getFundId:fundLabel2.text];
        if (ID != 0) {
            [fundCompareCtrl.fundArray addObject:[NSNumber numberWithInt:ID]];
        }
        ID = [self getFundId:fundLabel3.text];
        if (ID != 0) {
            [fundCompareCtrl.fundArray addObject:[NSNumber numberWithInt:ID]];
        }
        ID = [self getFundId:fundLabel4.text];
        if (ID != 0) {
            [fundCompareCtrl.fundArray addObject:[NSNumber numberWithInt:ID]];
        }
        ID = [self getFundId:fundLabel5.text];
        if (ID != 0) {
            [fundCompareCtrl.fundArray addObject:[NSNumber numberWithInt:ID]];
        }
    }
    if (fundCompareCtrl.fundArray.count != count) {
        UIAlertView*alert = [[UIAlertView alloc]initWithTitle:@"输入的基金代码或名称有误，请检查"
                             
                                                      message:nil
                             
                                                     delegate:self
                             
                                            cancelButtonTitle:@"确定"
                             
                                            otherButtonTitles:nil];
        
        [alert show];
        return;
    }
    
    fundCompareCtrl.count = count;
    [self.navigationController pushViewController:fundCompareCtrl animated:YES];
}

- (void)groupBtnPress:(id)sender
{
    [self startBtnPress:sender];
    return;
    if (count == 0) {
        
        UIAlertView*alert = [[UIAlertView alloc]initWithTitle:@"请输入需要检查的基金代码或名称"
                             
                                                      message:nil
                             
                                                     delegate:self
                             
                                            cancelButtonTitle:@"确定"
                             
                                            otherButtonTitles:nil];
        
        [alert show];
        return;
    }
    FundCompareViewController * fundCompareCtrl  = [[FundCompareViewController alloc]init];
    fundCompareCtrl.count = count;
    [self.navigationController pushViewController:fundCompareCtrl animated:YES];
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
#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == searchTableView) {
        return searchArray.count;
    }
    return 0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == searchTableView) {
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
    return 0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell = [tableView cellForRowAtIndexPath:indexPath];
    if (tableView == searchTableView) {
        [self tableViewCellOnSelect];
        textField.text = [NSString  stringWithFormat:@"%d", cell.tag ];
    }
}

- (void)tableViewCellOnSelect
{
    [textField resignFirstResponder];
    
    [searchTableView removeFromSuperview];
    searchTableView = nil;
    [searchBg removeFromSuperview];
    searchBg = nil;
}

- (NSInteger)getFundId:(NSString *)str
{
    // 开始获取相关关键字
    NSString * searchType = @"";
    
    if ([dbBase open]) {
        for (int i = 0; i < 3; ++i) {
            if (i == 0) {
                searchType = CODE;
            }
            else if (i == 1) {
                searchType = PY;
            }
            else {
                searchType = NAME;
            }
            
            
            NSString *sqlMoneyQuery = [NSString stringWithFormat:@"SELECT * FROM FUNDMONEY WHERE %@ = '%@'", searchType, str ];
            FMResultSet * rs = [dbBase executeQuery:sqlMoneyQuery];
            while ([rs next]) {
                int ID = [rs intForColumn:@"code"];
                if (ID != 0) {
                    return ID;
                }
            }
            
            
            NSString *sqlNotMoneyQuery = [NSString stringWithFormat:@"SELECT * FROM FUNDNOTMONEY WHERE %@ = '%@'", searchType, str ];
            FMResultSet * rs1 = [dbBase executeQuery:sqlNotMoneyQuery];
            while ([rs1 next]) {
                int ID = [rs1 intForColumn:@"code"];
                if (ID != 0) {
                    return ID;
                }
            }
        }
        
        
        [dbBase close];
    }
    return 0;
}

@end
