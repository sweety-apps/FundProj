//
//  PersonalViewController.m
//  FundPrj
//
//  Created by leesea on 13-11-4.
//  Copyright (c) 2013年 leesea. All rights reserved.
//

#import "PersonalViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "PersonalInfoRequest.h"
#import "PersonalInfoData.h"
#import "MyFundRequest.h"
#import "MyFundData.h"
#import "CCSegmentedControl.h"
#import "DetailViewController.h"

@interface PersonalViewController ()
{
    UIView * infoView;
    UIView * headerTableView;
    UITableView * tableView;
    UIView * topView;
    UIView * bottomView;
    
    UIButton * maleBtn;
    UIButton * femaleBtn;
    BOOL isMaleBtnOn;
    
    UIButton * datePickerBtn;
    UIDatePicker * datePicker;
    UIView * datePickerView;
    
    PersonalInfoRequest * personalInfoRequest;
    PersonalInfoData * personalInfoData;
    
    MyFundRequest * myFundRequest;
    NSMutableArray * myFundDataArray;
}

@end

@implementation PersonalViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        isMaleBtnOn = YES;
        myFundDataArray = [[NSMutableArray alloc]initWithCapacity:0];
    }
    return self;
}

- (void)segmentAction:(id)sender
{
	UISegmentedControl *segmentedControl = (UISegmentedControl *)sender;
	switch (segmentedControl.selectedSegmentIndex) {
        case 0:
            [self.view bringSubviewToFront:infoView];
            break;
        case 1:
            [self.view bringSubviewToFront:headerTableView];
            [self.view bringSubviewToFront:tableView];
            break;
            
        default:
            break;
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    // 开始获取相关关键字
    
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    return YES;
}

- (void)maleBtnPress:(id)sender
{
    if (!isMaleBtnOn) {
        [maleBtn setBackgroundColor:[UIColor colorWithHexValue:0x156fbd]];
        [femaleBtn setBackgroundColor:[UIColor colorWithHexValue:0xcad3da]];
        [maleBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [femaleBtn setTitleColor:[UIColor colorWithHexValue:0x5c6c7c] forState:UIControlStateNormal];
        isMaleBtnOn = YES;
    }
}

- (void)femaleBtnPress:(id)sender
{
    if (isMaleBtnOn) {
        [maleBtn setBackgroundColor:[UIColor colorWithHexValue:0xcad3da]];
        [femaleBtn setBackgroundColor:[UIColor colorWithHexValue:0x156fbd]];
        [femaleBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [maleBtn setTitleColor:[UIColor colorWithHexValue:0x5c6c7c] forState:UIControlStateNormal];
        isMaleBtnOn = NO;
    }
}

- (void) dateValueChanged:(UIDatePicker *)sender
{
//    datePicker = (UIDatePicker *)sender;
//    NSDate *date_one = datePicker.date;
//    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
//    [formatter setDateFormat:@"yyyy-MM-dd"];
//    datePickerBtn.titleLabel.text = [formatter stringFromDate:date_one];
}

- (void)okBtnPress:(id)sender
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    datePickerBtn.titleLabel.text = [formatter stringFromDate:datePicker.date];
    [datePickerView removeFromSuperview];
    datePickerView = nil;
}

- (void)datePickBtnPress:(id)sender
{
    datePickerView = [[UIView alloc]initWithFrame:CGRectMake(270, 438, 472, 208)];
    datePickerView.backgroundColor = [UIColor lightGrayColor];
    UIView * headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 472, 50)];
    headerView.backgroundColor = [UIColor grayColor];
    [datePickerView addSubview:headerView];
    UIButton * okBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    okBtn.frame = CGRectMake(370, 7, 80, 36);
    [okBtn setBackgroundColor:[UIColor darkGrayColor]];
    [okBtn setTitle:@"完成" forState:UIControlStateNormal];
    [okBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [okBtn addTarget:self action:@selector(okBtnPress:) forControlEvents:UIControlEventTouchUpInside];
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

- (void)confirmBtnPress:(id)sender
{
    
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden = NO;
	
    //	[self onNetConnected];
}

- (void)buildInfoView
{
    infoView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 1024, 768-20-44-59)];
    infoView.backgroundColor = [UIColor colorWithHexValue:0xf1f1ee];
    [self.view addSubview:infoView];
    
    UILabel * _name1Label = [[UILabel alloc] initWithFrame:CGRectMake(270, 37, 100, 18)];
    [_name1Label setTextAlignment:NSTextAlignmentLeft];
    [_name1Label setTextColor:[UIColor colorWithHexValue:0x2582c7]];
    [_name1Label setFont:[UIFont systemFontOfSize:18]];
    [_name1Label setBackgroundColor:[UIColor clearColor]];
    _name1Label.tag = 1;
    [infoView addSubview:_name1Label];
    UILabel * _name2Label = [[UILabel alloc] initWithFrame:CGRectMake(370, 35, 100, 20)];
    [_name2Label setTextAlignment:NSTextAlignmentLeft];
    [_name2Label setTextColor:[UIColor colorWithHexValue:0x2a2a28]];
    [_name2Label setFont:[UIFont systemFontOfSize:20]];
    [_name2Label setBackgroundColor:[UIColor clearColor]];
    _name2Label.text = @"个人资料";
    [infoView addSubview:_name2Label];
    
    UILabel * _name3Label = [[UILabel alloc] initWithFrame:CGRectMake(270, 72, 160, 18)];
    [_name3Label setTextAlignment:NSTextAlignmentLeft];
    [_name3Label setTextColor:[UIColor colorWithHexValue:0x2a2a28]];
    [_name3Label setFont:[UIFont systemFontOfSize:18]];
    [_name3Label setBackgroundColor:[UIColor clearColor]];
    _name3Label.tag = 2;
    [infoView addSubview:_name3Label];
    UILabel * _name4Label = [[UILabel alloc] initWithFrame:CGRectMake(270+160, 72, 160, 18)];
    [_name4Label setTextAlignment:NSTextAlignmentLeft];
    [_name4Label setTextColor:[UIColor colorWithHexValue:0x2a2a28]];
    [_name4Label setFont:[UIFont systemFontOfSize:18]];
    [_name4Label setBackgroundColor:[UIColor clearColor]];
    _name4Label.tag = 3;
    [infoView addSubview:_name4Label];
    
    topView = [[UIView alloc]initWithFrame:CGRectMake(270, 110, 470, 206)];
    topView.backgroundColor = [UIColor colorWithHexValue:0xf7f7f7];
    //UIView设置边框
    [[topView layer] setCornerRadius:15];
    [[topView layer] setBorderWidth:1];
    [[topView layer] setBorderColor:[UIColor colorWithHexValue:0xbbbbbb].CGColor];
    [infoView addSubview:topView];
    UIView * line1Dark = [[UIView alloc]initWithFrame:CGRectMake(0, 50, 470, 1)];
    line1Dark.backgroundColor = [UIColor colorWithHexValue:0xbbbbbb];
    [topView addSubview:line1Dark];
    UIView * line1Light = [[UIView alloc]initWithFrame:CGRectMake(0, 51, 470, 1)];
    line1Light.backgroundColor = [UIColor colorWithHexValue:0xf8f9f6];
    [topView addSubview:line1Light];
    UIView * line2Dark = [[UIView alloc]initWithFrame:CGRectMake(0, 102, 470, 1)];
    line2Dark.backgroundColor = [UIColor colorWithHexValue:0xbbbbbb];
    [topView addSubview:line2Dark];
    UIView * line2Light = [[UIView alloc]initWithFrame:CGRectMake(0, 103, 470, 1)];
    line2Light.backgroundColor = [UIColor colorWithHexValue:0xf8f9f6];
    [topView addSubview:line2Light];
    UIView * line3Dark = [[UIView alloc]initWithFrame:CGRectMake(0, 154, 470, 1)];
    line3Dark.backgroundColor = [UIColor colorWithHexValue:0xbbbbbb];
    [topView addSubview:line3Dark];
    UIView * line3Light = [[UIView alloc]initWithFrame:CGRectMake(0, 155, 470, 1)];
    line3Light.backgroundColor = [UIColor colorWithHexValue:0xf8f9f6];
    [topView addSubview:line3Light];
    
    UILabel * _phoneLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 14, 100, 22)];
    [_phoneLabel setTextAlignment:NSTextAlignmentLeft];
    [_phoneLabel setTextColor:[UIColor colorWithHexValue:0x4f4f4f]];
    [_phoneLabel setFont:[UIFont systemFontOfSize:22]];
    [_phoneLabel setBackgroundColor:[UIColor clearColor]];
    _phoneLabel.text = @"手机";
    [topView addSubview:_phoneLabel];
    UILabel * _mailLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 14+52, 100, 22)];
    [_mailLabel setTextAlignment:NSTextAlignmentLeft];
    [_mailLabel setTextColor:[UIColor colorWithHexValue:0x4f4f4f]];
    [_mailLabel setFont:[UIFont systemFontOfSize:22]];
    [_mailLabel setBackgroundColor:[UIColor clearColor]];
    _mailLabel.text = @"邮箱地址";
    [topView addSubview:_mailLabel];
    UILabel * _jobLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 14+52*2, 100, 22)];
    [_jobLabel setTextAlignment:NSTextAlignmentLeft];
    [_jobLabel setTextColor:[UIColor colorWithHexValue:0x4f4f4f]];
    [_jobLabel setFont:[UIFont systemFontOfSize:22]];
    [_jobLabel setBackgroundColor:[UIColor clearColor]];
    _jobLabel.text = @"职业";
    [topView addSubview:_jobLabel];
    UILabel * _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 14+52*3, 100, 22)];
    [_nameLabel setTextAlignment:NSTextAlignmentLeft];
    [_nameLabel setTextColor:[UIColor colorWithHexValue:0x4f4f4f]];
    [_nameLabel setFont:[UIFont systemFontOfSize:22]];
    [_nameLabel setBackgroundColor:[UIColor clearColor]];
    _nameLabel.text = @"姓名";
    [topView addSubview:_nameLabel];
    
    UITextField * phoneTextField = [[UITextField alloc] initWithFrame:CGRectMake(140, 14, 300, 22)];
    phoneTextField.backgroundColor = [UIColor clearColor];
    phoneTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    phoneTextField.borderStyle = UITextBorderStyleNone;
    phoneTextField.textColor = [UIColor blackColor];
    phoneTextField.font = [UIFont systemFontOfSize:22];
    phoneTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    phoneTextField.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    phoneTextField.returnKeyType = UIReturnKeySearch;
    phoneTextField.delegate = self;
    phoneTextField.autocorrectionType = UITextAutocorrectionTypeNo;
    phoneTextField.enablesReturnKeyAutomatically = YES;
    phoneTextField.tag = 4;
    [topView addSubview:phoneTextField];
    UITextField * mailTextField = [[UITextField alloc] initWithFrame:CGRectMake(140, 14+52, 300, 22)];
    mailTextField.backgroundColor = [UIColor clearColor];
    mailTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    mailTextField.borderStyle = UITextBorderStyleNone;
    mailTextField.textColor = [UIColor blackColor];
    mailTextField.font = [UIFont systemFontOfSize:22];
    mailTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    mailTextField.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    mailTextField.returnKeyType = UIReturnKeySearch;
    mailTextField.delegate = self;
    mailTextField.autocorrectionType = UITextAutocorrectionTypeNo;
    mailTextField.enablesReturnKeyAutomatically = YES;
    mailTextField.tag = 5;
    [topView addSubview:mailTextField];
    UITextField * jobTextField = [[UITextField alloc] initWithFrame:CGRectMake(140, 14+52*2, 300, 22)];
    jobTextField.backgroundColor = [UIColor clearColor];
    jobTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    jobTextField.borderStyle = UITextBorderStyleNone;
    jobTextField.textColor = [UIColor blackColor];
    jobTextField.font = [UIFont systemFontOfSize:22];
    jobTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    jobTextField.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    jobTextField.returnKeyType = UIReturnKeySearch;
    jobTextField.delegate = self;
    jobTextField.autocorrectionType = UITextAutocorrectionTypeNo;
    jobTextField.enablesReturnKeyAutomatically = YES;
    jobTextField.tag = 6;
    [topView addSubview:jobTextField];
    UITextField * nameTextField = [[UITextField alloc] initWithFrame:CGRectMake(140, 14+52*3, 300, 22)];
    nameTextField.backgroundColor = [UIColor clearColor];
    nameTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    nameTextField.borderStyle = UITextBorderStyleNone;
    nameTextField.textColor = [UIColor blackColor];
    nameTextField.font = [UIFont systemFontOfSize:22];
    nameTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    nameTextField.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    nameTextField.returnKeyType = UIReturnKeySearch;
    nameTextField.delegate = self;
    nameTextField.autocorrectionType = UITextAutocorrectionTypeNo;
    nameTextField.enablesReturnKeyAutomatically = YES;
    nameTextField.tag = 7;
    [topView addSubview:nameTextField];
    
    bottomView = [[UIView alloc]initWithFrame:CGRectMake(270, 336, 470, 102)];
    bottomView.backgroundColor = [UIColor colorWithHexValue:0xf7f7f7];
    //UIView设置边框
    [[bottomView layer] setCornerRadius:15];
    [[bottomView layer] setBorderWidth:1];
    [[bottomView layer] setBorderColor:[UIColor colorWithHexValue:0xbbbbbb].CGColor];
    [infoView addSubview:bottomView];
    UIView * _line1Dark = [[UIView alloc]initWithFrame:CGRectMake(0, 50, 470, 1)];
    _line1Dark.backgroundColor = [UIColor colorWithHexValue:0xbbbbbb];
    [bottomView addSubview:_line1Dark];
    UIView * _line1Light = [[UIView alloc]initWithFrame:CGRectMake(0, 51, 470, 1)];
    _line1Light.backgroundColor = [UIColor colorWithHexValue:0xf8f9f6];
    [bottomView addSubview:_line1Light];
    
    UILabel * _sexualLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 14, 100, 22)];
    [_sexualLabel setTextAlignment:NSTextAlignmentLeft];
    [_sexualLabel setTextColor:[UIColor colorWithHexValue:0x4f4f4f]];
    [_sexualLabel setFont:[UIFont systemFontOfSize:22]];
    [_sexualLabel setBackgroundColor:[UIColor clearColor]];
    _sexualLabel.text = @"性别";
    [bottomView addSubview:_sexualLabel];
    UILabel * _birthdayLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 14+52, 100, 22)];
    [_birthdayLabel setTextAlignment:NSTextAlignmentLeft];
    [_birthdayLabel setTextColor:[UIColor colorWithHexValue:0x4f4f4f]];
    [_birthdayLabel setFont:[UIFont systemFontOfSize:22]];
    [_birthdayLabel setBackgroundColor:[UIColor clearColor]];
    _birthdayLabel.text = @"生日";
    [bottomView addSubview:_birthdayLabel];
    
    maleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    maleBtn.frame = CGRectMake(330, 12, 62, 32);
    [maleBtn setBackgroundColor:[UIColor colorWithHexValue:0x156fbd]];
    [maleBtn setTitle:@"男" forState:UIControlStateNormal];
    [maleBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [maleBtn addTarget:self action:@selector(maleBtnPress:) forControlEvents:UIControlEventTouchUpInside];
    UILabel * label = maleBtn.titleLabel;
    label.font = [UIFont boldSystemFontOfSize:24];
    [bottomView addSubview:maleBtn];
    femaleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    femaleBtn.frame = CGRectMake(392, 12, 62, 32);
    [femaleBtn setBackgroundColor:[UIColor colorWithHexValue:0xcad3da]];
    [femaleBtn setTitle:@"女" forState:UIControlStateNormal];
    [femaleBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [femaleBtn addTarget:self action:@selector(femaleBtnPress:) forControlEvents:UIControlEventTouchUpInside];
    UILabel * label1 = femaleBtn.titleLabel;
    label1.font = [UIFont boldSystemFontOfSize:24];
    [bottomView addSubview:femaleBtn];
    datePickerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    datePickerBtn.frame = CGRectMake(330, 12+52, 62*2, 32);
    [datePickerBtn setBackgroundColor:[UIColor clearColor]];
    [datePickerBtn setTitleColor:[UIColor colorWithHexValue:0x5c6c7c] forState:UIControlStateNormal];
    [datePickerBtn addTarget:self action:@selector(datePickBtnPress:) forControlEvents:UIControlEventTouchUpInside];
    UILabel * label2 = datePickerBtn.titleLabel;
    label2.font = [UIFont systemFontOfSize:24];
    [bottomView addSubview:datePickerBtn];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *todayDate = [NSDate date];
    [datePickerBtn setTitle:[formatter stringFromDate:todayDate] forState:UIControlStateNormal];
    
    UIButton * confirmBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    confirmBtn.frame = CGRectMake(420, 460, 191, 68);
    [confirmBtn setBackgroundImage:[UIImage imageNamed:@"img_59"] forState:UIControlStateNormal];
    [confirmBtn setBackgroundImage:[UIImage imageNamed:@"img_59"] forState:UIControlStateHighlighted];
    [confirmBtn setTitle:@"确认" forState:UIControlStateNormal];
    [confirmBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [confirmBtn addTarget:self action:@selector(confirmBtnPress:) forControlEvents:UIControlEventTouchUpInside];
    UILabel * label3 = confirmBtn.titleLabel;
    label3.font = [UIFont boldSystemFontOfSize:34];
    [infoView addSubview:confirmBtn];
}

- (void)buildHeaderTableView
{
    headerTableView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 1024, 42)];
    UIImage *syncBgImg = [UIImage imageNamed:@"list_07"];
    headerTableView.backgroundColor = [[UIColor alloc] initWithPatternImage:syncBgImg];
    
    UILabel * _name1Label = [[UILabel alloc] initWithFrame:CGRectMake(25, 14, 120, 14)];
    [_name1Label setTextAlignment:NSTextAlignmentLeft];
    [_name1Label setTextColor:[UIColor colorWithHexValue:0xc4c7c7]];
    [_name1Label setFont:[UIFont systemFontOfSize:14]];
    [_name1Label setBackgroundColor:[UIColor clearColor]];
    _name1Label.text = @"股票/基金编码";
    [headerTableView addSubview:_name1Label];
    UILabel * _name2Label = [[UILabel alloc] initWithFrame:CGRectMake(150, 14, 150, 14)];
    [_name2Label setTextAlignment:NSTextAlignmentLeft];
    [_name2Label setTextColor:[UIColor colorWithHexValue:0xc4c7c7]];
    [_name2Label setFont:[UIFont systemFontOfSize:14]];
    [_name2Label setBackgroundColor:[UIColor clearColor]];
    _name2Label.text = @"基金名称";
    [headerTableView addSubview:_name2Label];
    UILabel * _name3Label = [[UILabel alloc] initWithFrame:CGRectMake(300, 14, 60, 14)];
    [_name3Label setTextAlignment:NSTextAlignmentLeft];
    [_name3Label setTextColor:[UIColor colorWithHexValue:0xc4c7c7]];
    [_name3Label setFont:[UIFont systemFontOfSize:14]];
    [_name3Label setBackgroundColor:[UIColor clearColor]];
    _name3Label.text = @"基金净值";
    [headerTableView addSubview:_name3Label];
    UILabel * _name4Label = [[UILabel alloc] initWithFrame:CGRectMake(370, 14, 110, 14)];
    [_name4Label setTextAlignment:NSTextAlignmentLeft];
    [_name4Label setTextColor:[UIColor colorWithHexValue:0xc4c7c7]];
    [_name4Label setFont:[UIFont systemFontOfSize:14]];
    [_name4Label setBackgroundColor:[UIColor clearColor]];
    _name4Label.text = @"基金日增长率";
    [headerTableView addSubview:_name4Label];
    UILabel * _name5Label = [[UILabel alloc] initWithFrame:CGRectMake(480, 14, 60, 14)];
    [_name5Label setTextAlignment:NSTextAlignmentLeft];
    [_name5Label setTextColor:[UIColor colorWithHexValue:0xc4c7c7]];
    [_name5Label setFont:[UIFont systemFontOfSize:14]];
    [_name5Label setBackgroundColor:[UIColor clearColor]];
    _name5Label.text = @"涨跌额";
    [headerTableView addSubview:_name5Label];
    UILabel * _name6Label = [[UILabel alloc] initWithFrame:CGRectMake(540, 14, 110, 14)];
    [_name6Label setTextAlignment:NSTextAlignmentLeft];
    [_name6Label setTextColor:[UIColor colorWithHexValue:0xc4c7c7]];
    [_name6Label setFont:[UIFont systemFontOfSize:14]];
    [_name6Label setBackgroundColor:[UIColor clearColor]];
    _name6Label.text = @"加入时间";
    [headerTableView addSubview:_name6Label];
    UILabel * _name7Label = [[UILabel alloc] initWithFrame:CGRectMake(650, 14, 90, 14)];
    [_name7Label setTextAlignment:NSTextAlignmentLeft];
    [_name7Label setTextColor:[UIColor colorWithHexValue:0xc4c7c7]];
    [_name7Label setFont:[UIFont systemFontOfSize:14]];
    [_name7Label setBackgroundColor:[UIColor clearColor]];
    _name7Label.text = @"加入时价格";
    [headerTableView addSubview:_name7Label];
    UILabel * _name8Label = [[UILabel alloc] initWithFrame:CGRectMake(740, 14, 100, 14)];
    [_name8Label setTextAlignment:NSTextAlignmentLeft];
    [_name8Label setTextColor:[UIColor colorWithHexValue:0xc4c7c7]];
    [_name8Label setFont:[UIFont systemFontOfSize:14]];
    [_name8Label setBackgroundColor:[UIColor clearColor]];
    _name8Label.text = @"加入以来回报率";
    [headerTableView addSubview:_name8Label];
    UILabel * _name9Label = [[UILabel alloc] initWithFrame:CGRectMake(850, 14, 120, 14)];
    [_name9Label setTextAlignment:NSTextAlignmentLeft];
    [_name9Label setTextColor:[UIColor colorWithHexValue:0xc4c7c7]];
    [_name9Label setFont:[UIFont systemFontOfSize:14]];
    [_name9Label setBackgroundColor:[UIColor clearColor]];
    _name9Label.text = @"回报率计算时间";
    [headerTableView addSubview:_name9Label];
    UILabel * _name13Label = [[UILabel alloc] initWithFrame:CGRectMake(970, 14, 40, 14)];
    [_name13Label setTextAlignment:NSTextAlignmentLeft];
    [_name13Label setTextColor:[UIColor colorWithHexValue:0xc4c7c7]];
    [_name13Label setFont:[UIFont systemFontOfSize:14]];
    [_name13Label setBackgroundColor:[UIColor clearColor]];
    _name13Label.text = @"操作";
    [headerTableView addSubview:_name13Label];
    [self.view addSubview:headerTableView];
}

- (void)buildTableView
{
    tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 42, 1024, 768-20-44-59-42)
                                             style:UITableViewStylePlain];
    tableView.backgroundColor = [UIColor colorWithHexValue:0xf1f1ee];
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
	[self.view addSubview:tableView];
    
    [self buildHeaderTableView];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
//    self.extendedLayoutIncludesOpaqueBars = NO;
//    self.edgesForExtendedLayout = UIRectEdgeBottom | UIRectEdgeLeft | UIRectEdgeRight;
    
	// segmented control as the custom title view
//	NSArray *segmentTextContent = [NSArray arrayWithObjects:@"个人资料", @"我的关注", nil];
//	UISegmentedControl *segmentedControl = [[UISegmentedControl alloc] initWithItems:segmentTextContent];
//	segmentedControl.selectedSegmentIndex = 0;
//    //	segmentedControl.autoresizingMask = UIViewAutoresizingFlexibleWidth;
//	segmentedControl.segmentedControlStyle = UISegmentedControlStyleBar;
//	segmentedControl.frame = CGRectMake(0, 0, 200, 29);
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
    
    
    CCSegmentedControl* segmentedControl = [[CCSegmentedControl alloc] initWithItems:@[@"个人资料", @"我的关注"] fontSize:16];
    segmentedControl.frame = CGRectMake(0, 0, 200, 30);
    //设置背景图片，或者设置颜色，或者使用默认白色外观
//    segmentedControl.backgroundImage = [UIImage imageNamed:@"segment_bg.png"];
    segmentedControl.backgroundColor = [UIColor clearColor];
    //阴影部分图片，不设置使用默认椭圆外观的stain
    UIImageView * selectedBgView  = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"img_33"]];
    selectedBgView.frame = CGRectMake(0, 0, 72, 20);
    
    segmentedControl.selectedStainView = selectedBgView;
    segmentedControl.selectedSegmentTextColor = [UIColor whiteColor];
    segmentedControl.segmentTextColor = [UIColor blackColor];
    [segmentedControl addTarget:self action:@selector(segmentAction:) forControlEvents:UIControlEventValueChanged];
    
    self.navigationItem.titleView = segmentedControl;
    
    [self buildInfoView];
    [self buildTableView];
    
    [self getPersonalInfoData];
    [self getMyFundData];
    
    [self.view bringSubviewToFront:infoView];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return myFundDataArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * cellID = @"tableViewCellIdentifier";
    UITableViewCell * cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        
        UILabel * _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(25, 15, 120, 18)];
        [_nameLabel setTextAlignment:NSTextAlignmentLeft];
        [_nameLabel setTextColor:[UIColor colorWithHexValue:0x333333]];
        [_nameLabel setFont:[UIFont systemFontOfSize:18]];
        [_nameLabel setBackgroundColor:[UIColor clearColor]];
        _nameLabel.tag = 0;
        [cell addSubview:_nameLabel];
        UILabel * _name2Label = [[UILabel alloc] initWithFrame:CGRectMake(150, 15, 150, 18)];
        [_name2Label setTextAlignment:NSTextAlignmentLeft];
        [_name2Label setTextColor:[UIColor colorWithHexValue:0x333333]];
        [_name2Label setFont:[UIFont systemFontOfSize:18]];
        [_name2Label setBackgroundColor:[UIColor clearColor]];
        _name2Label.tag = 1;
        [cell addSubview:_name2Label];
        UILabel * _name3Label = [[UILabel alloc] initWithFrame:CGRectMake(300, 15, 60, 18)];
        [_name3Label setTextAlignment:NSTextAlignmentCenter];
        [_name3Label setTextColor:[UIColor colorWithHexValue:0x333333]];
        [_name3Label setFont:[UIFont systemFontOfSize:18]];
        [_name3Label setBackgroundColor:[UIColor clearColor]];
        _name3Label.tag = 2;
        [cell addSubview:_name3Label];
        UILabel * _name4Label = [[UILabel alloc] initWithFrame:CGRectMake(360, 15, 120, 18)];
        [_name4Label setTextAlignment:NSTextAlignmentCenter];
        [_name4Label setTextColor:[UIColor colorWithHexValue:0x333333]];
        [_name4Label setFont:[UIFont systemFontOfSize:18]];
        [_name4Label setBackgroundColor:[UIColor clearColor]];
        _name4Label.tag = 3;
        [cell addSubview:_name4Label];
        UILabel * _name5Label = [[UILabel alloc] initWithFrame:CGRectMake(480, 15, 60, 18)];
        [_name5Label setTextAlignment:NSTextAlignmentLeft];
        [_name5Label setTextColor:[UIColor colorWithHexValue:0x333333]];
        [_name5Label setFont:[UIFont systemFontOfSize:18]];
        [_name5Label setBackgroundColor:[UIColor clearColor]];
        _name5Label.tag = 4;
        [cell addSubview:_name5Label];
        UILabel * _name6Label = [[UILabel alloc] initWithFrame:CGRectMake(540, 15, 110, 18)];
        [_name6Label setTextAlignment:NSTextAlignmentLeft];
        [_name6Label setTextColor:[UIColor colorWithHexValue:0x333333]];
        [_name6Label setFont:[UIFont systemFontOfSize:18]];
        [_name6Label setBackgroundColor:[UIColor clearColor]];
        _name6Label.tag = 5;
        [cell addSubview:_name6Label];
        UILabel * _name7Label = [[UILabel alloc] initWithFrame:CGRectMake(650, 15, 90, 18)];
        [_name7Label setTextAlignment:NSTextAlignmentCenter];
        [_name7Label setTextColor:[UIColor colorWithHexValue:0x333333]];
        [_name7Label setFont:[UIFont systemFontOfSize:18]];
        [_name7Label setBackgroundColor:[UIColor clearColor]];
        _name7Label.numberOfLines = 0;
        _name7Label.tag = 6;
        [cell addSubview:_name7Label];
        UILabel * _name8Label = [[UILabel alloc] initWithFrame:CGRectMake(740, 15, 100, 18)];
        [_name8Label setTextAlignment:NSTextAlignmentCenter];
        [_name8Label setTextColor:[UIColor colorWithHexValue:0x333333]];
        [_name8Label setFont:[UIFont systemFontOfSize:18]];
        [_name8Label setBackgroundColor:[UIColor clearColor]];
        _name8Label.numberOfLines = 0;
        _name8Label.tag = 7;
        [cell addSubview:_name8Label];
        UILabel * _name9Label = [[UILabel alloc] initWithFrame:CGRectMake(850, 15, 120, 18)];
        [_name9Label setTextAlignment:NSTextAlignmentLeft];
        [_name9Label setTextColor:[UIColor colorWithHexValue:0x333333]];
        [_name9Label setFont:[UIFont systemFontOfSize:18]];
        [_name9Label setBackgroundColor:[UIColor clearColor]];
        _name9Label.numberOfLines = 0;
        _name9Label.tag = 8;
        [cell addSubview:_name9Label];
        UILabel * _name13Label = [[UILabel alloc] initWithFrame:CGRectMake(970, 15, 40, 18)];
        [_name13Label setTextAlignment:NSTextAlignmentLeft];
        [_name13Label setTextColor:[UIColor colorWithHexValue:0x333333]];
        [_name13Label setFont:[UIFont systemFontOfSize:18]];
        [_name13Label setBackgroundColor:[UIColor clearColor]];
        _name13Label.tag = 12;
        [cell addSubview:_name13Label];
        
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
    
    
    MyFundData * data = [myFundDataArray objectAtIndex:indexPath.row];
    for (UIView * v in cell.subviews) {
        if ([v isKindOfClass:[UILabel class]]) {
            UILabel * label = (UILabel *)v;
            if (label.tag == 0) {
                label.text = data.symbol;
            }
            if (label.tag == 1) {
                label.text = data.name;
            }
            if (label.tag == 2) {
                label.text = [NSString stringWithFormat:@"%d", data.close];
            }
            if (label.tag == 3) {
                label.text = [NSString stringWithFormat:@"%d", data.limits];
            }
            if (label.tag == 4) {
                label.text = [NSString stringWithFormat:@"%d", data.updown];
            }
            if (label.tag == 5) {
                label.text = [NSString stringWithFormat:@"%@", data.join_time];
            }
            if (label.tag == 6) {
                label.text = [NSString stringWithFormat:@"%d", data.join_value];
            }
            if (label.tag == 7) {
                label.text = [NSString stringWithFormat:@"%d", data.rr];
            }
            if (label.tag == 8) {
                label.text = [NSString stringWithFormat:@"%@", data.rr_time];
            }
        }
    }
    
    //    [cell configWithData:[self.listDatas objectAtIndex:indexPath.row]];
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell = [tableView cellForRowAtIndexPath:indexPath];
    MyFundData * objData = [myFundDataArray objectAtIndex:indexPath.row];
    NSInteger fundCode = [[objData.symbol substringToIndex:[objData.symbol rangeOfString:@"."].location] integerValue];
    DetailViewController * detailViewCtrl = [[DetailViewController alloc]initWithFundCode:fundCode];
    [self.navigationController pushViewController:detailViewCtrl animated:YES];
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

//网络从未连接到连接时的处理
- (void)onNetConnected
{
}


- (void) getPersonalInfoRequestSuccess:(PersonalInfoRequest *)request
{
	BOOL isRequestSuccess = [personalInfoRequest isRequestSuccess];
    if (isRequestSuccess) {
        personalInfoData = [personalInfoRequest getData];
        for (UIView * v in infoView.subviews) {
            if ([v isKindOfClass:[UILabel class]]) {
                UILabel * label = (UILabel *)v;
                if (label.tag == 1) {
                    label.text = personalInfoData.username;
                }
                else if (label.tag == 2) {
                    label.text = [NSString stringWithFormat:@"现金：%d元", personalInfoData.cash];
                }
                else if (label.tag == 3) {
                    label.text = [NSString stringWithFormat:@"i财富币：%d个", personalInfoData.money];
                }
            }
        }
        for (UIView * v in topView.subviews) {
            if ([v isKindOfClass:[UITextField class]]) {
                UITextField * textField = (UITextField *)v;
                if (textField.tag == 4) {
                    textField.placeholder = [NSString stringWithFormat:@"%lli", personalInfoData.mobile];
                }
                else if (textField.tag == 5) {
                    textField.placeholder = personalInfoData.email;
                }
                else if (textField.tag == 6) {
                    textField.placeholder = @"";
                }
                else if (textField.tag == 7) {
                    textField.placeholder = @"";
                }
            }
        }
        if ([personalInfoData.gender isEqualToString:@"男"]) {
            [self maleBtnPress:maleBtn];
        }
        else {
            [self femaleBtnPress:femaleBtn];
        }
        [datePickerBtn setTitle:personalInfoData.birthday forState:UIControlStateNormal];
    }
    else {
    }
}

- (void) getPersonalInfoRequestFailed:(PersonalInfoRequest *)request
{
    
}

- (void)getPersonalInfoData
{
    NSString * url = [NSString stringWithFormat:@"%@%@", HOST_NAME, PERSONAL_INFO];
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
    personalInfoRequest = [[PersonalInfoRequest alloc]initWithUrl:url];
    
	personalInfoRequest.delegate = self;
    personalInfoRequest.requestDidFinishSelector = @selector(getPersonalInfoRequestSuccess:);
    personalInfoRequest.requestDidFailedSelector = @selector(getPersonalInfoRequestFailed:);
    
    [personalInfoRequest sendRequest];
}


- (void) getMyFundRequestSuccess:(MyFundRequest *)request
{
	BOOL isRequestSuccess = [myFundRequest isRequestSuccess];
    if (isRequestSuccess) {
        myFundDataArray = [myFundRequest getDataArray];
        [tableView reloadData];
    }
    else {
    }
}

- (void) getMyFundRequestFailed:(MyFundRequest *)request
{
    
}

- (void)getMyFundData
{
    NSString * url = [NSString stringWithFormat:@"%@%@", HOST_NAME, PERSONAL_MYFUND];
    NSMutableArray * array = [[NSMutableArray alloc]initWithCapacity:0];
    [array addObject:[NSString stringWithFormat:@"%@=%@", OPENID, OPENID_VALUE]];
    [array addObject:[NSString stringWithFormat:@"%@=%@", TYPE, DATA_FORMAT]];
    if (_UI.isLogin) {
        [array addObject:[NSString stringWithFormat:@"%@=%@", @"user_name", _UI.userName]];
        [array addObject:[NSString stringWithFormat:@"%@=%@", @"access_token", _UI.loginToken]];
    }
    [array addObject:[NSString stringWithFormat:@"%@=%@", @"security_type", @"1"]];
    NSString * md5Result = [_UI md5EncParam:array];
    url = [url stringByAppendingString:md5Result];
    url = [url URLEncodedString];
    myFundRequest = [[MyFundRequest alloc]initWithUrl:url];
    
	myFundRequest.delegate = self;
    myFundRequest.requestDidFinishSelector = @selector(getMyFundRequestSuccess:);
    myFundRequest.requestDidFailedSelector = @selector(getMyFundRequestFailed:);
    
    [myFundRequest sendRequest];
}

@end
