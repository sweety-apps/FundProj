//
//  SettingViewController.m
//  FundPrj
//
//  Created by leesea on 13-11-17.
//  Copyright (c) 2013年 leesea. All rights reserved.
//

#import "SettingViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface SettingViewController ()
{
    UIView * leftView;
    UIImageView * leftBtnBgView;
    UIButton* settingBtn;
    UIButton* aboutBtn;
    UIButton* updateBtn;
    UIButton* scoreBtn;
    UIView * settingView;
    UIView * aboutView;
    UIView * updateView;
    UIView * scoreView;
}

@end

@implementation SettingViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)leftViewBtnPress:(id)sender
{
    UIButton * btnClick = (UIButton *)sender;
    if (btnClick == settingBtn) {
        leftBtnBgView.frame = CGRectMake(0, 0, 320, 66);
        [settingBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [settingBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        [aboutBtn setTitleColor:[UIColor colorWithHexValue:0x2d3030] forState:UIControlStateNormal];
        [aboutBtn setTitleColor:[UIColor colorWithHexValue:0x2d3030] forState:UIControlStateSelected];
        [updateBtn setTitleColor:[UIColor colorWithHexValue:0x2d3030] forState:UIControlStateNormal];
        [updateBtn setTitleColor:[UIColor colorWithHexValue:0x2d3030] forState:UIControlStateSelected];
        [scoreBtn setTitleColor:[UIColor colorWithHexValue:0x2d3030] forState:UIControlStateNormal];
        [scoreBtn setTitleColor:[UIColor colorWithHexValue:0x2d3030] forState:UIControlStateSelected];
        [self.view bringSubviewToFront:settingView];
    }
    else if (btnClick == aboutBtn) {
        leftBtnBgView.frame = CGRectMake(0, 66, 320, 66);
        [settingBtn setTitleColor:[UIColor colorWithHexValue:0x2d3030] forState:UIControlStateNormal];
        [settingBtn setTitleColor:[UIColor colorWithHexValue:0x2d3030] forState:UIControlStateSelected];
        [aboutBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [aboutBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        [updateBtn setTitleColor:[UIColor colorWithHexValue:0x2d3030] forState:UIControlStateNormal];
        [updateBtn setTitleColor:[UIColor colorWithHexValue:0x2d3030] forState:UIControlStateSelected];
        [scoreBtn setTitleColor:[UIColor colorWithHexValue:0x2d3030] forState:UIControlStateNormal];
        [scoreBtn setTitleColor:[UIColor colorWithHexValue:0x2d3030] forState:UIControlStateSelected];
        [self.view bringSubviewToFront:aboutView];
    }
    else if (btnClick == updateBtn) {
        leftBtnBgView.frame = CGRectMake(0, 66*2, 320, 66);
        [settingBtn setTitleColor:[UIColor colorWithHexValue:0x2d3030] forState:UIControlStateNormal];
        [settingBtn setTitleColor:[UIColor colorWithHexValue:0x2d3030] forState:UIControlStateSelected];
        [aboutBtn setTitleColor:[UIColor colorWithHexValue:0x2d3030] forState:UIControlStateNormal];
        [aboutBtn setTitleColor:[UIColor colorWithHexValue:0x2d3030] forState:UIControlStateSelected];
        [updateBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [updateBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        [scoreBtn setTitleColor:[UIColor colorWithHexValue:0x2d3030] forState:UIControlStateNormal];
        [scoreBtn setTitleColor:[UIColor colorWithHexValue:0x2d3030] forState:UIControlStateSelected];
        [self.view bringSubviewToFront:updateView];
    }
    else if (btnClick == scoreBtn) {
        leftBtnBgView.frame = CGRectMake(0, 66*3, 320, 66);
        [settingBtn setTitleColor:[UIColor colorWithHexValue:0x2d3030] forState:UIControlStateNormal];
        [settingBtn setTitleColor:[UIColor colorWithHexValue:0x2d3030] forState:UIControlStateSelected];
        [aboutBtn setTitleColor:[UIColor colorWithHexValue:0x2d3030] forState:UIControlStateNormal];
        [aboutBtn setTitleColor:[UIColor colorWithHexValue:0x2d3030] forState:UIControlStateSelected];
        [updateBtn setTitleColor:[UIColor colorWithHexValue:0x2d3030] forState:UIControlStateNormal];
        [updateBtn setTitleColor:[UIColor colorWithHexValue:0x2d3030] forState:UIControlStateSelected];
        [scoreBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [scoreBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        [self.view bringSubviewToFront:scoreView];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.title = @"系统设置";
    
    leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 768-20-44-59)];
    leftView.backgroundColor = [UIColor colorWithHexValue:0xebf0f1];
    [self.view addSubview:leftView];
    
    UIImageView * bg1 = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"set_04"]];
    bg1.frame = CGRectMake(0, 0, 320, 66);
    [leftView addSubview:bg1];
    UIImageView * bg2 = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"set_04"]];
    bg2.frame = CGRectMake(0, 66, 320, 66);
    [leftView addSubview:bg2];
    UIImageView * bg3 = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"set_04"]];
    bg3.frame = CGRectMake(0, 66*2, 320, 66);
    [leftView addSubview:bg3];
    UIImageView * bg4 = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"set_04"]];
    bg4.frame = CGRectMake(0, 66*3, 320, 66);
    [leftView addSubview:bg4];
    leftBtnBgView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"set_05"]];
    leftBtnBgView.frame = CGRectMake(0, 0, 320, 66);
    [leftView addSubview:leftBtnBgView];
    
    settingBtn = [[UIButton alloc] initWithFrame:CGRectMake(10, 0, 300, 66)];
    settingBtn.backgroundColor = [UIColor clearColor];
    [settingBtn setTitle:@"参数设置" forState:UIControlStateNormal];
    [settingBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [settingBtn addTarget:self action:@selector(leftViewBtnPress:) forControlEvents:UIControlEventTouchUpInside];
    settingBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
	UILabel * registerLabel = settingBtn.titleLabel;
	[registerLabel setFont:[UIFont systemFontOfSize:26]];
    [leftView addSubview:settingBtn];
    
    aboutBtn = [[UIButton alloc] initWithFrame:CGRectMake(10, 66, 300, 66)];
    aboutBtn.backgroundColor = [UIColor clearColor];
    [aboutBtn setTitle:@"关于我们" forState:UIControlStateNormal];
    [aboutBtn setTitleColor:[UIColor colorWithHexValue:0x2d3030] forState:UIControlStateNormal];
    [aboutBtn addTarget:self action:@selector(leftViewBtnPress:) forControlEvents:UIControlEventTouchUpInside];
    aboutBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
	UILabel * aboutLabel = aboutBtn.titleLabel;
	[aboutLabel setFont:[UIFont systemFontOfSize:26]];
    [leftView addSubview:aboutBtn];
    
    updateBtn = [[UIButton alloc] initWithFrame:CGRectMake(10, 66*2, 300, 66)];
    updateBtn.backgroundColor = [UIColor clearColor];
    [updateBtn setTitle:@"检查更新" forState:UIControlStateNormal];
    [updateBtn setTitleColor:[UIColor colorWithHexValue:0x2d3030] forState:UIControlStateNormal];
    [updateBtn addTarget:self action:@selector(leftViewBtnPress:) forControlEvents:UIControlEventTouchUpInside];
    updateBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
	UILabel * updateLabel = updateBtn.titleLabel;
	[updateLabel setFont:[UIFont systemFontOfSize:26]];
    [leftView addSubview:updateBtn];
    
    scoreBtn = [[UIButton alloc] initWithFrame:CGRectMake(10, 66*3, 300, 66)];
    scoreBtn.backgroundColor = [UIColor clearColor];
    [scoreBtn setTitle:@"系统设置" forState:UIControlStateNormal];
    [scoreBtn setTitleColor:[UIColor colorWithHexValue:0x2d3030] forState:UIControlStateNormal];
    [scoreBtn addTarget:self action:@selector(leftViewBtnPress:) forControlEvents:UIControlEventTouchUpInside];
    scoreBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
	UILabel * scoreLabel = scoreBtn.titleLabel;
	[scoreLabel setFont:[UIFont systemFontOfSize:26]];
    [leftView addSubview:scoreBtn];
    
    settingView = [[UIView alloc]initWithFrame:CGRectMake(320, 0, 1024-320, 768-20-44-59)];
    settingView.backgroundColor = [UIColor colorWithHexValue:0xf5f5f2];
    [self.view addSubview:settingView];
    UIView * changeSrvView = [[UIView alloc]initWithFrame:CGRectMake(130, 30, 472, 52)];
    changeSrvView.backgroundColor = [UIColor colorWithHexValue:0xf7f7f7];
    //UIView设置阴影
    [[changeSrvView layer] setShadowOffset:CGSizeMake(1, 1)];
    [[changeSrvView layer] setShadowRadius:1];
    [[changeSrvView layer] setShadowOpacity:1];
    [[changeSrvView layer] setShadowColor:[UIColor grayColor].CGColor];
    //UIView设置边框
    [[changeSrvView layer] setCornerRadius:10];
    [settingView addSubview:changeSrvView];
	UILabel * label1 = [[UILabel alloc]initWithFrame:CGRectMake(20, 0, 150, 52)];
	label1.textColor = [UIColor blackColor];
	label1.textAlignment = UITextAlignmentLeft;
    label1.backgroundColor = [UIColor clearColor];
    label1.text = @"切换服务器";
	[label1 setFont:[UIFont systemFontOfSize:22]];
    [changeSrvView addSubview:label1];
	UILabel * label2 = [[UILabel alloc]initWithFrame:CGRectMake(472-200-20, 0, 200, 52)];
	label2.textColor = [UIColor blackColor];
	label2.textAlignment = UITextAlignmentRight;
    label2.backgroundColor = [UIColor clearColor];
    label2.text = @"电信服务器";
	[label2 setFont:[UIFont systemFontOfSize:22]];
    [changeSrvView addSubview:label2];
    
    aboutView = [[UIView alloc]initWithFrame:CGRectMake(320, 0, 1024-320, 768-20-44-59)];
    aboutView.backgroundColor = [UIColor colorWithHexValue:0xf5f5f2];
    [self.view addSubview:aboutView];
    UIView * aboutDetailView = [[UIView alloc]initWithFrame:CGRectMake(130, 30, 472, 52*4)];
    aboutDetailView.backgroundColor = [UIColor colorWithHexValue:0xf7f7f7];
    //UIView设置阴影
    [[aboutDetailView layer] setShadowOffset:CGSizeMake(1, 1)];
    [[aboutDetailView layer] setShadowRadius:1];
    [[aboutDetailView layer] setShadowOpacity:1];
    [[aboutDetailView layer] setShadowColor:[UIColor grayColor].CGColor];
    //UIView设置边框
    [[aboutDetailView layer] setCornerRadius:10];
    [aboutView addSubview:aboutDetailView];
	UILabel * label11 = [[UILabel alloc]initWithFrame:CGRectMake(20, 0, 200, 52)];
	label11.textColor = [UIColor blackColor];
	label11.textAlignment = UITextAlignmentLeft;
    label11.backgroundColor = [UIColor clearColor];
    label11.text = @"产品名";
	[label11 setFont:[UIFont systemFontOfSize:22]];
    [aboutDetailView addSubview:label11];
	UILabel * label12 = [[UILabel alloc]initWithFrame:CGRectMake(472-200-20, 0, 200, 52)];
	label12.textColor = [UIColor blackColor];
	label12.textAlignment = UITextAlignmentRight;
    label12.backgroundColor = [UIColor clearColor];
    label12.text = @"i财富基金分析师";
	[label12 setFont:[UIFont systemFontOfSize:22]];
    [aboutDetailView addSubview:label12];
	UILabel * label21 = [[UILabel alloc]initWithFrame:CGRectMake(20, 52, 200, 52)];
	label21.textColor = [UIColor blackColor];
	label21.textAlignment = UITextAlignmentLeft;
    label21.backgroundColor = [UIColor clearColor];
    label21.text = @"版本号";
	[label21 setFont:[UIFont systemFontOfSize:22]];
    [aboutDetailView addSubview:label21];
	UILabel * label22 = [[UILabel alloc]initWithFrame:CGRectMake(472-200-20, 52, 200, 52)];
	label22.textColor = [UIColor blackColor];
	label22.textAlignment = UITextAlignmentRight;
    label22.backgroundColor = [UIColor clearColor];
    label22.text = @"1.0.1";
	[label22 setFont:[UIFont systemFontOfSize:22]];
    [aboutDetailView addSubview:label22];
	UILabel * label31 = [[UILabel alloc]initWithFrame:CGRectMake(20, 52*2, 200, 52)];
	label31.textColor = [UIColor blackColor];
	label31.textAlignment = UITextAlignmentLeft;
    label31.backgroundColor = [UIColor clearColor];
    label31.text = @"电话";
	[label31 setFont:[UIFont systemFontOfSize:22]];
    [aboutDetailView addSubview:label31];
	UILabel * label32 = [[UILabel alloc]initWithFrame:CGRectMake(472-200-20, 52*2, 200, 52)];
	label32.textColor = [UIColor blackColor];
	label32.textAlignment = UITextAlignmentRight;
    label32.backgroundColor = [UIColor clearColor];
    label32.text = @"0755-83442002";
	[label32 setFont:[UIFont systemFontOfSize:22]];
    [aboutDetailView addSubview:label32];
	UILabel * label41 = [[UILabel alloc]initWithFrame:CGRectMake(20, 52*3, 200, 52)];
	label41.textColor = [UIColor blackColor];
	label41.textAlignment = UITextAlignmentLeft;
    label41.backgroundColor = [UIColor clearColor];
    label41.text = @"网址";
	[label41 setFont:[UIFont systemFontOfSize:22]];
    [aboutDetailView addSubview:label41];
	UILabel * label42 = [[UILabel alloc]initWithFrame:CGRectMake(472-250-20, 52*3, 250, 52)];
	label42.textColor = [UIColor blackColor];
	label42.textAlignment = UITextAlignmentRight;
    label42.backgroundColor = [UIColor clearColor];
    label42.text = @"http://www.icaifu.com";
	[label42 setFont:[UIFont systemFontOfSize:22]];
    [aboutDetailView addSubview:label42];
    UIView * line1 = [[UIView alloc]initWithFrame:CGRectMake(0, 52, 472, 1)];
    line1.backgroundColor = [UIColor colorWithHexValue:0xd5d5d5];
    [aboutDetailView addSubview:line1];
    UIView * line2 = [[UIView alloc]initWithFrame:CGRectMake(0, 52*2, 472, 1)];
    line2.backgroundColor = [UIColor colorWithHexValue:0xd5d5d5];
    [aboutDetailView addSubview:line2];
    UIView * line3 = [[UIView alloc]initWithFrame:CGRectMake(0, 52*3, 472, 1)];
    line3.backgroundColor = [UIColor colorWithHexValue:0xd5d5d5];
    [aboutDetailView addSubview:line3];
    
    updateView = [[UIView alloc]initWithFrame:CGRectMake(320, 0, 1024-320, 768-20-44-59)];
    updateView.backgroundColor = [UIColor colorWithHexValue:0xf5f5f2];
    [self.view addSubview:updateView];
    
    scoreView = [[UIView alloc]initWithFrame:CGRectMake(320, 0, 1024-320, 768-20-44-59)];
    scoreView.backgroundColor = [UIColor colorWithHexValue:0xf5f5f2];
    [self.view addSubview:scoreView];
    
    [self.view bringSubviewToFront:settingView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
