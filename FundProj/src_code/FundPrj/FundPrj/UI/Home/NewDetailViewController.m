//
//  NewDetailViewController.m
//  FundPrj
//
//  Created by leesea on 13-11-11.
//  Copyright (c) 2013年 leesea. All rights reserved.
//

#import "NewDetailViewController.h"

@interface NewDetailViewController ()
{
    FundNewsData * newsData;
}

@end

@implementation NewDetailViewController

- (id)initWithData:(FundNewsData *)data
{
    self = [super init];
    if (self) {
        // Custom initialization
        newsData = data;
    }
    return self;
}

- (void)backBtnPress:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
//    self.extendedLayoutIncludesOpaqueBars = NO;
//    self.edgesForExtendedLayout = UIRectEdgeBottom | UIRectEdgeLeft | UIRectEdgeRight;
	
	self.navigationItem.title = newsData.title;
    self.view.backgroundColor = [UIColor colorWithHexValue:0xecf0f3];
    
    UILabel * _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 14, 1024, 16)];
    [_titleLabel setTextAlignment:NSTextAlignmentCenter];
    [_titleLabel setTextColor:[UIColor colorWithHexValue:0xbcbcbc]];
    [_titleLabel setFont:[UIFont boldSystemFontOfSize:16]];
    [_titleLabel setBackgroundColor:[UIColor clearColor]];
    _titleLabel.text = [NSString stringWithFormat:@"%@  %@", newsData.pubtime, newsData.origin];
    [self.view addSubview:_titleLabel];
    
//    UIScrollView * scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 44, 1024, 768-20-44-59-44)];
//    scrollView.backgroundColor = [UIColor clearColor];
//    [self.view addSubview:scrollView];
//    
//    CGSize sizeToFit = [newsData.context sizeWithFont:[UIFont systemFontOfSize:20] constrainedToSize:CGSizeMake(1024-30*2, CGFLOAT_MAX) lineBreakMode:UILineBreakModeWordWrap];
//    int height = sizeToFit.height > scrollView.frame.size.height ? sizeToFit.height : scrollView.frame.size.height;
//    UILabel * _detailLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, 0, 1024-30*2, height)];
//    [_detailLabel setTextAlignment:NSTextAlignmentLeft];
//    [_detailLabel setTextColor:[UIColor colorWithHexValue:0x7c7c7c]];
//    [_detailLabel setFont:[UIFont systemFontOfSize:20]];
//    [_detailLabel setBackgroundColor:[UIColor clearColor]];
//    _detailLabel.numberOfLines = 0;
//    _detailLabel.text = newsData.context;
//    [scrollView addSubview:_detailLabel];
//    
//    [scrollView setContentSize:CGSizeMake(1024-30*2, height)];
    UIWebView * webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 44, 1024, 768-20-44-59-44)];
    [webView loadHTMLString:newsData.context baseURL:nil];
    [self.view addSubview:webView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
