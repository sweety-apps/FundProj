//
//  SiftResultViewController.m
//  FundPrj
//
//  Created by leesea on 13-11-21.
//  Copyright (c) 2013年 leesea. All rights reserved.
//

#import "SiftResultViewController.h"
#import "SiftRequest.h"
#import "SiftResult.h"
#import "SiftData.h"
#import "GradeView.h"

@interface SiftResultViewController ()
{
    UITableView * dataTableView;
    NSMutableArray * dataArray;
    UIView * headerTableView;
    
    SiftRequest * siftRequest;
}

@end

@implementation SiftResultViewController

@synthesize siftType;
@synthesize fundType;
@synthesize investType;
@synthesize estbData;
@synthesize status;
@synthesize grade;
@synthesize rr_this_year;
@synthesize fund_corp;

@synthesize size;
@synthesize rr_one_year;
@synthesize invest_stock_style;
@synthesize invest_bond_style;
@synthesize invest_stock_ratio;
@synthesize top_industry;
@synthesize grade_qoq;
@synthesize shape;
@synthesize risk;

- (id)init
{
    self = [super init];
    if (self) {
        // Custom initialization
        dataArray = [[NSMutableArray alloc]initWithCapacity:0];
        siftType = SiftNormalType;
        fundType = nil;
        investType = nil;
        estbData = nil;
        status = -1;
        grade = -1;
        rr_this_year = -1;
        fund_corp = -1;
        
        size = -1;
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

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    //    self.extendedLayoutIncludesOpaqueBars = NO;
    //    self.edgesForExtendedLayout = UIRectEdgeBottom | UIRectEdgeLeft | UIRectEdgeRight;
    
    self.title = @"筛选结果";
    
    [self buildtableView];
    
    if (siftType == SiftNormalType) {
        [self getSiftData];
    }
    else {
        [self getSiftIntelData];
    }
    [self buildheaderTableView];
    
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden = NO;
	
    //	[self onNetConnected];
}

- (void)buildtableView
{
    dataTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 42, 1024, 768-20-44-59-42)
                                             style:UITableViewStylePlain];
    dataTableView.backgroundColor = [UIColor colorWithHexValue:0xf1f1ee];
    dataTableView.dataSource = self;
    dataTableView.delegate = self;
    dataTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
	[self.view addSubview:dataTableView];
}

- (void)buildheaderTableView
{
    headerTableView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 1024, 42)];
    UIImage *syncBgImg = [UIImage imageNamed:@"list_07"];
    headerTableView.backgroundColor = [[UIColor alloc] initWithPatternImage:syncBgImg];
    
    UILabel * _name1Label = [[UILabel alloc] initWithFrame:CGRectMake(25, 14, 220, 14)];
    [_name1Label setTextAlignment:NSTextAlignmentLeft];
    [_name1Label setTextColor:[UIColor colorWithHexValue:0xc4c7c7]];
    [_name1Label setFont:[UIFont systemFontOfSize:14]];
    [_name1Label setBackgroundColor:[UIColor clearColor]];
    _name1Label.text = @"基金名称";
    [headerTableView addSubview:_name1Label];
    UILabel * _name2Label = [[UILabel alloc] initWithFrame:CGRectMake(280, 14, 80, 14)];
    [_name2Label setTextAlignment:NSTextAlignmentLeft];
    [_name2Label setTextColor:[UIColor colorWithHexValue:0xc4c7c7]];
    [_name2Label setFont:[UIFont systemFontOfSize:14]];
    [_name2Label setBackgroundColor:[UIColor clearColor]];
    _name2Label.text = @"净值日期";
    [headerTableView addSubview:_name2Label];
    UILabel * _name3Label = [[UILabel alloc] initWithFrame:CGRectMake(360, 14, 60, 14)];
    [_name3Label setTextAlignment:NSTextAlignmentLeft];
    [_name3Label setTextColor:[UIColor colorWithHexValue:0xc4c7c7]];
    [_name3Label setFont:[UIFont systemFontOfSize:14]];
    [_name3Label setBackgroundColor:[UIColor clearColor]];
    _name3Label.text = @"净值";
    [headerTableView addSubview:_name3Label];
    UILabel * _name4Label = [[UILabel alloc] initWithFrame:CGRectMake(410, 14, 70, 14)];
    [_name4Label setTextAlignment:NSTextAlignmentLeft];
    [_name4Label setTextColor:[UIColor colorWithHexValue:0xc4c7c7]];
    [_name4Label setFont:[UIFont systemFontOfSize:14]];
    [_name4Label setBackgroundColor:[UIColor clearColor]];
    _name4Label.numberOfLines = 0;
    _name4Label.text = @"净值日变动";
    [headerTableView addSubview:_name4Label];
    UILabel * _name5Label = [[UILabel alloc] initWithFrame:CGRectMake(520, 14, 170, 14)];
    [_name5Label setTextAlignment:NSTextAlignmentLeft];
    [_name5Label setTextColor:[UIColor colorWithHexValue:0xc4c7c7]];
    [_name5Label setFont:[UIFont systemFontOfSize:14]];
    [_name5Label setBackgroundColor:[UIColor clearColor]];
    _name5Label.text = @"投资类型";
    [headerTableView addSubview:_name5Label];
    UILabel * _name6Label = [[UILabel alloc] initWithFrame:CGRectMake(650, 14, 70, 14)];
    [_name6Label setTextAlignment:NSTextAlignmentLeft];
    [_name6Label setTextColor:[UIColor colorWithHexValue:0xc4c7c7]];
    [_name6Label setFont:[UIFont systemFontOfSize:14]];
    [_name6Label setBackgroundColor:[UIColor clearColor]];
    _name6Label.text = @"申购状态";
    [headerTableView addSubview:_name6Label];
    UILabel * _name7Label = [[UILabel alloc] initWithFrame:CGRectMake(720, 14, 70, 14)];
    [_name7Label setTextAlignment:NSTextAlignmentLeft];
    [_name7Label setTextColor:[UIColor colorWithHexValue:0xc4c7c7]];
    [_name7Label setFont:[UIFont systemFontOfSize:14]];
    [_name7Label setBackgroundColor:[UIColor clearColor]];
    _name7Label.numberOfLines = 0;
    _name7Label.text = @"赎回状态";
    [headerTableView addSubview:_name7Label];
    UILabel * _name8Label = [[UILabel alloc] initWithFrame:CGRectMake(800, 5, 80, 35)];
    [_name8Label setTextAlignment:NSTextAlignmentLeft];
    [_name8Label setTextColor:[UIColor colorWithHexValue:0xc4c7c7]];
    [_name8Label setFont:[UIFont systemFontOfSize:14]];
    [_name8Label setBackgroundColor:[UIColor clearColor]];
    _name8Label.numberOfLines = 0;
    _name8Label.text = @"今年以来回报率(%)";
    [headerTableView addSubview:_name8Label];
    UILabel * _name9Label = [[UILabel alloc] initWithFrame:CGRectMake(900, 14, 80, 14)];
    [_name9Label setTextAlignment:NSTextAlignmentLeft];
    [_name9Label setTextColor:[UIColor colorWithHexValue:0xc4c7c7]];
    [_name9Label setFont:[UIFont systemFontOfSize:14]];
    [_name9Label setBackgroundColor:[UIColor clearColor]];
    _name9Label.numberOfLines = 0;
    _name9Label.text = @"评级";
    [headerTableView addSubview:_name9Label];
    UILabel * _name10Label = [[UILabel alloc] initWithFrame:CGRectMake(970, 14, 60, 14)];
    [_name10Label setTextAlignment:NSTextAlignmentLeft];
    [_name10Label setTextColor:[UIColor colorWithHexValue:0xc4c7c7]];
    [_name10Label setFont:[UIFont systemFontOfSize:14]];
    [_name10Label setBackgroundColor:[UIColor clearColor]];
    _name10Label.text = @"操作";
    [headerTableView addSubview:_name10Label];
    [self.view addSubview:headerTableView];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return dataArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * cellID = @"tableViewCellIdentifier";
    UITableViewCell * cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        
        UILabel * _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(25, 6, 220, 18)];
        [_nameLabel setTextAlignment:NSTextAlignmentLeft];
        [_nameLabel setTextColor:[UIColor colorWithHexValue:0x333333]];
        [_nameLabel setFont:[UIFont systemFontOfSize:18]];
        [_nameLabel setBackgroundColor:[UIColor clearColor]];
        _nameLabel.tag = 0;
        [cell addSubview:_nameLabel];
        UILabel * _name1Label = [[UILabel alloc] initWithFrame:CGRectMake(25, 27, 220, 14)];
        [_name1Label setTextAlignment:NSTextAlignmentLeft];
        [_name1Label setTextColor:[UIColor colorWithHexValue:0x333333]];
        [_name1Label setFont:[UIFont systemFontOfSize:14]];
        [_name1Label setBackgroundColor:[UIColor clearColor]];
        _name1Label.tag = 1;
        [cell addSubview:_name1Label];
        UILabel * _name2Label = [[UILabel alloc] initWithFrame:CGRectMake(250, 15, 120, 18)];
        [_name2Label setTextAlignment:NSTextAlignmentLeft];
        [_name2Label setTextColor:[UIColor colorWithHexValue:0x333333]];
        [_name2Label setFont:[UIFont systemFontOfSize:18]];
        [_name2Label setBackgroundColor:[UIColor clearColor]];
        _name2Label.tag = 2;
        [cell addSubview:_name2Label];
        UILabel * _name3Label = [[UILabel alloc] initWithFrame:CGRectMake(370, 15, 60, 18)];
        [_name3Label setTextAlignment:NSTextAlignmentLeft];
        [_name3Label setTextColor:[UIColor colorWithHexValue:0x333333]];
        [_name3Label setFont:[UIFont systemFontOfSize:18]];
        [_name3Label setBackgroundColor:[UIColor clearColor]];
        _name3Label.tag = 3;
        [cell addSubview:_name3Label];
        UILabel * _name4Label = [[UILabel alloc] initWithFrame:CGRectMake(430, 15, 70, 18)];
        [_name4Label setTextAlignment:NSTextAlignmentLeft];
        [_name4Label setTextColor:[UIColor colorWithHexValue:0x333333]];
        [_name4Label setFont:[UIFont systemFontOfSize:18]];
        [_name4Label setBackgroundColor:[UIColor clearColor]];
        _name4Label.tag = 4;
        [cell addSubview:_name4Label];
        UILabel * _name5Label = [[UILabel alloc] initWithFrame:CGRectMake(500, 15, 170, 18)];
        [_name5Label setTextAlignment:NSTextAlignmentLeft];
        [_name5Label setTextColor:[UIColor colorWithHexValue:0x333333]];
        [_name5Label setFont:[UIFont systemFontOfSize:18]];
        [_name5Label setBackgroundColor:[UIColor clearColor]];
        _name5Label.tag = 5;
        [cell addSubview:_name5Label];
        UILabel * _name6Label = [[UILabel alloc] initWithFrame:CGRectMake(670, 15, 70, 18)];
        [_name6Label setTextAlignment:NSTextAlignmentLeft];
        [_name6Label setTextColor:[UIColor colorWithHexValue:0x333333]];
        [_name6Label setFont:[UIFont systemFontOfSize:18]];
        [_name6Label setBackgroundColor:[UIColor clearColor]];
        _name6Label.tag = 6;
        [cell addSubview:_name6Label];
        UILabel * _name7Label = [[UILabel alloc] initWithFrame:CGRectMake(740, 15, 70, 18)];
        [_name7Label setTextAlignment:NSTextAlignmentLeft];
        [_name7Label setTextColor:[UIColor colorWithHexValue:0x333333]];
        [_name7Label setFont:[UIFont systemFontOfSize:18]];
        [_name7Label setBackgroundColor:[UIColor clearColor]];
        _name7Label.numberOfLines = 0;
        _name7Label.tag = 7;
        [cell addSubview:_name7Label];
        UILabel * _name8Label = [[UILabel alloc] initWithFrame:CGRectMake(810, 15, 50, 18)];
        [_name8Label setTextAlignment:NSTextAlignmentLeft];
        [_name8Label setTextColor:[UIColor colorWithHexValue:0x333333]];
        [_name8Label setFont:[UIFont systemFontOfSize:18]];
        [_name8Label setBackgroundColor:[UIColor clearColor]];
        _name8Label.numberOfLines = 0;
        _name8Label.tag = 8;
        [cell addSubview:_name8Label];
//        UILabel * _name9Label = [[UILabel alloc] initWithFrame:CGRectMake(890, 15, 80, 18)];
//        [_name9Label setTextAlignment:NSTextAlignmentLeft];
//        [_name9Label setTextColor:[UIColor colorWithHexValue:0x333333]];
//        [_name9Label setFont:[UIFont systemFontOfSize:18]];
//        [_name9Label setBackgroundColor:[UIColor clearColor]];
//        _name9Label.numberOfLines = 0;
//        _name9Label.tag = 9;
//        [cell addSubview:_name9Label];
        GradeView * gradeView = [[GradeView alloc]initWithFrame:CGRectMake(875, 15, 80, 18)];
        gradeView.tag = 9;
        [cell addSubview:gradeView];
//        UILabel * _name10Label = [[UILabel alloc] initWithFrame:CGRectMake(970, 15, 50, 18)];
//        [_name10Label setTextAlignment:NSTextAlignmentLeft];
//        [_name10Label setTextColor:[UIColor colorWithHexValue:0x333333]];
//        [_name10Label setFont:[UIFont systemFontOfSize:18]];
//        [_name10Label setBackgroundColor:[UIColor clearColor]];
//        _name10Label.numberOfLines = 0;
//        _name10Label.tag = 10;
//        [cell addSubview:_name10Label];
        UIButton * operateBtn = [[UIButton alloc] initWithFrame:CGRectMake(980, 16, 18, 18)];
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
    
    
    SiftData * data = nil;
    data = [dataArray objectAtIndex:indexPath.row];
    for (UIView * v in cell.subviews) {
        if ([v isKindOfClass:[UILabel class]]) {
            UILabel * label = (UILabel *)v;
            if (label.tag == 0) {
                label.text = data.name;
            }
            if (label.tag == 1) {
                label.text = [NSString stringWithFormat:@"%06d", data.code];
            }
            if (label.tag == 2) {
                label.text = data.date;
            }
            if (label.tag == 3) {
                label.text = [NSString stringWithFormat:@"%d", data.net_value];
            }
            if (label.tag == 4) {
                label.text = [NSString stringWithFormat:@"%d", data.limits];
            }
            if (label.tag == 5) {
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
            if (label.tag == 6) {
                if (data.pur_status == 0) {
                    label.text = @"否";
                }
                else {
                    label.text = @"是";
                }
            }
            if (label.tag == 7) {
                if (data.redeem_status == 0) {
                    label.text = @"否";
                }
                else {
                    label.text = @"是";
                }
            }
            if (label.tag == 8) {
                label.text = [NSString stringWithFormat:@"%d", data.rr_this_year];
            }
//            if (label.tag == 9) {
//                if (data.grade == 1) {
//                    label.text = @"一星";
//                }
//                else if (data.grade == 2) {
//                    label.text = @"二星";
//                }
//                else if (data.grade == 3) {
//                    label.text = @"三星";
//                }
//                else if (data.grade == 4) {
//                    label.text = @"四星";
//                }
//                else if (data.grade == 5) {
//                    label.text = @"五星";
//                }
//                else {
//                    label.text = @"未评级";
//                }
//            }
//            if (label.tag == 13) {
//                label.text = @"";
//            }
        }
        if ([v isKindOfClass:[GradeView class]]) {
            GradeView * gradeView = (GradeView *)v;
            [gradeView setGrade:data.grade];
        }
    }
    
    //    [cell configWithData:[self.listDatas objectAtIndex:indexPath.row]];
    
    return cell;
}

- (void)operateBtnPress:(id)sender
{
    
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //    PeopleItemCell * cell = (PeopleItemCell *)[self.tableView cellForRowAtIndexPath:indexPath];
    //
    //    // 打开Detail页面
    //
    //	PeopleItem * item = [cell getPeopleItem];
    //    PeopleDetailViewController * detailCtrl = [[PeopleDetailViewController alloc] initWithPeopleID:item.userid];
    //
    //    [[self navigationController] pushViewController:detailCtrl animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
}

- (void) getSiftRequestSuccess:(SiftRequest *)request
{
	BOOL isRequestSuccess = [siftRequest isRequestSuccess];
    if (isRequestSuccess) {
        dataArray = [siftRequest getDataArray];
        [self buildtableView];
        if (dataArray.count == 0) {
            UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"该筛选组合无数据，请重新确定筛选条件"
                                     
                                                              message:nil
                                     
                                                             delegate:self
                                     
                                                    cancelButtonTitle:@"确定"
                                     
                                                    otherButtonTitles:nil];
            
            [alertView show];
        }
    }
    else {
    }
}

- (void) getSiftRequestFailed:(SiftRequest *)request
{
    
}

- (void)getSiftData
{
    NSString * url = [NSString stringWithFormat:@"%@%@", HOST_NAME, SIFT];
    NSMutableArray * array = [[NSMutableArray alloc]initWithCapacity:0];
    [array addObject:[NSString stringWithFormat:@"%@=%@", OPENID, OPENID_VALUE]];
    [array addObject:[NSString stringWithFormat:@"%@=%@", TYPE, DATA_FORMAT]];
    if (_UI.isLogin) {
        [array addObject:[NSString stringWithFormat:@"%@=%@", @"user_name", _UI.userName]];
        [array addObject:[NSString stringWithFormat:@"%@=%@", @"access_token", _UI.loginToken]];
    }
//    [array addObject:[NSString stringWithFormat:@"%@=%@", @"page_no", @"1"]];
//    [array addObject:[NSString stringWithFormat:@"%@=%@", @"page_size", @"2"]];
    
    if (fundType != nil) {
        [array addObject:[NSString stringWithFormat:@"%@=%@", @"type", fundType]];
    }
    if (investType != nil) {
        [array addObject:[NSString stringWithFormat:@"%@=%@", @"invest_type", investType]];
    }
    if (estbData != nil) {
        [array addObject:[NSString stringWithFormat:@"%@=%@", @"estb_date", estbData]];
    }
    if (status != -1) {
        [array addObject:[NSString stringWithFormat:@"%@=%d", @"status", status]];
    }
    if (grade != -1) {
        [array addObject:[NSString stringWithFormat:@"%@=%d", @"grade", grade]];
    }
    if (rr_this_year != -1) {
        [array addObject:[NSString stringWithFormat:@"%@=%d", @"rr_this_year", rr_this_year]];
    }
    if (fund_corp != -1) {
        [array addObject:[NSString stringWithFormat:@"%@=%d", @"fund_corp", fund_corp]];
    }
    
    NSString * md5Result = [_UI md5EncParam:array];
    url = [url stringByAppendingString:md5Result];
    url = [url URLEncodedString];
    siftRequest = [[SiftRequest alloc]initWithUrl:url];
    
	siftRequest.delegate = self;
    siftRequest.requestDidFinishSelector = @selector(getSiftRequestSuccess:);
    siftRequest.requestDidFailedSelector = @selector(getSiftRequestFailed:);
    
    [siftRequest sendRequest];
}

- (void)getSiftIntelData
{
    NSString * url = [NSString stringWithFormat:@"%@%@", HOST_NAME, SIFT_INTEL];
    NSMutableArray * array = [[NSMutableArray alloc]initWithCapacity:0];
    [array addObject:[NSString stringWithFormat:@"%@=%@", OPENID, OPENID_VALUE]];
    [array addObject:[NSString stringWithFormat:@"%@=%@", TYPE, DATA_FORMAT]];
    
    if (_UI.isLogin) {
        [array addObject:[NSString stringWithFormat:@"%@=%@", @"user_name", _UI.userName]];
        [array addObject:[NSString stringWithFormat:@"%@=%@", @"access_token", _UI.loginToken]];
    }
//    [array addObject:[NSString stringWithFormat:@"%@=%@", @"page_no", @"1"]];
//    [array addObject:[NSString stringWithFormat:@"%@=%@", @"page_size", @"2"]];
    
    if (fundType != nil) {
        [array addObject:[NSString stringWithFormat:@"%@=%@", @"type", fundType]];
    }
    if (investType != nil) {
        [array addObject:[NSString stringWithFormat:@"%@=%@", @"invest_type", investType]];
    }
    if (estbData != nil) {
        [array addObject:[NSString stringWithFormat:@"%@=%@", @"estb_date", estbData]];
    }
    if (status != -1) {
        [array addObject:[NSString stringWithFormat:@"%@=%d", @"status", status]];
    }
    if (grade != -1) {
        [array addObject:[NSString stringWithFormat:@"%@=%d", @"grade", grade]];
    }
    if (rr_this_year != -1) {
        [array addObject:[NSString stringWithFormat:@"%@=%d", @"rr_this_year", rr_this_year]];
    }
    if (fund_corp != -1) {
        [array addObject:[NSString stringWithFormat:@"%@=%d", @"fund_corp", fund_corp]];
    }
    
    if (size != -1) {
        [array addObject:[NSString stringWithFormat:@"%@=%d", @"size", size]];
    }
    if (rr_one_year != -1) {
        [array addObject:[NSString stringWithFormat:@"%@=%d", @"rr_one_year", rr_one_year]];
    }
    if (invest_stock_style != -1) {
        [array addObject:[NSString stringWithFormat:@"%@=%d", @"invest_stock_style", invest_stock_style]];
    }
    if (invest_bond_style != -1) {
        [array addObject:[NSString stringWithFormat:@"%@=%d", @"invest_bond_style", invest_bond_style]];
    }
    if (invest_stock_ratio != -1) {
        [array addObject:[NSString stringWithFormat:@"%@=%d", @"invest_stock_ratio", invest_stock_ratio]];
    }
    if (top_industry != -1) {
        [array addObject:[NSString stringWithFormat:@"%@=%d", @"top_industry", top_industry]];
    }
    if (grade_qoq != -1) {
        [array addObject:[NSString stringWithFormat:@"%@=%d", @"grade_qoq", grade_qoq]];
    }
    if (shape != -1) {
        [array addObject:[NSString stringWithFormat:@"%@=%d", @"shape", shape]];
    }
    if (risk != -1) {
        [array addObject:[NSString stringWithFormat:@"%@=%d", @"risk", risk]];
    }
    
    NSString * md5Result = [_UI md5EncParam:array];
    url = [url stringByAppendingString:md5Result];
    url = [url URLEncodedString];
    siftRequest = [[SiftRequest alloc]initWithUrl:url];
    
	siftRequest.delegate = self;
    siftRequest.requestDidFinishSelector = @selector(getSiftRequestSuccess:);
    siftRequest.requestDidFailedSelector = @selector(getSiftRequestFailed:);
    
    [siftRequest sendRequest];
}

@end

