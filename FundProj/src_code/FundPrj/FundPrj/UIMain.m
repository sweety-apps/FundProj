//
//  UIMain.m
//  FundPrj
//
//  Created by leesea on 13-10-22.
//  Copyright (c) 2013年 leesea. All rights reserved.
//
#import "UIMain.h"
#import "FPNavigationController.h"
#import "HomeViewController.h"
#import "ValueViewController.h"
#import "PersonalViewController.h"
#import "RankingViewController.h"
#import "SiftViewController.h"
#import "AnalyseViewController.h"
#import "CMTabBarController.h"

@interface UIMain ()
{
	HomeViewController * homePageCtrl;
	ValueViewController * valueCtrl;
	RankingViewController * rankingsCtrl;
	SiftViewController * siftCtrl;
	AnalyseViewController * analyseCtrl;
	PersonalViewController * personalCtrl;
    
    NSString * userID;
}


- (UIBarButtonItem *)createSearchBox;
- (void)tappedSearchButton;

- (UIBarButtonItem *)createSettingBtn;
- (void)tappedSettingButton;

@end

@implementation UIMain

@synthesize window = _window;
@synthesize mainTabCtrl = _mainTabCtrl;
@synthesize loginToken;
@synthesize isLogin;
@synthesize userName;


#pragma mark - Functions

- (id)init
{
    if (self = [super init])
    {
        // 创建主窗口
        self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
        self.window.backgroundColor = [UIColor clearColor]; 

        
        // 监测navigation pop的情况
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(navigationPopped:)
                                                     name:FPNavigationPoppedNotification
                                                   object:nil];
        
        // 注册网络监测
        [_NETWORK addNetworkObserver:self];
        
        userID = nil;
        isLogin = NO;
        
    }
    
    return self;
}

- (void)dealloc
{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    // 移除网络监测
    [_NETWORK removeNetworkObserver:self];
}

- (void)navigationPopped:(NSNotification*)notification
{
	//
}
- (NSString *)getUserID
{
    return userID;
}

- (BOOL)isLogin
{
    return isLogin;
}

// 显示主窗口
- (void)showMainWindow
{
    // 设置status bar为不透明黑色
//    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleBlackOpaque;
    
    self.mainTabCtrl = [[CMTabBarController alloc] init];
    self.mainTabCtrl.delegate = self;
    
	//首页
	homePageCtrl = [[HomeViewController alloc] init];
	FPNavigationController * homeNavCtrl = [[FPNavigationController alloc] initWithRootViewController:homePageCtrl];
    homePageCtrl.title = @"i财富基金分析师专业版";

	//基金净值
	valueCtrl = [[ValueViewController alloc] init];
	//[valueCtrl.view setBackgroundColor:[UIColor clearColor]];
	UINavigationController * valueNav = [[FPNavigationController alloc] initWithRootViewController:valueCtrl];

	//基金排行
	rankingsCtrl = [[RankingViewController alloc] init];
	//[rankingsCtrl.view setBackgroundColor:[UIColor clearColor]];
	UINavigationController * rankingsNav = [[FPNavigationController alloc] initWithRootViewController:rankingsCtrl];
	rankingsCtrl.title = @"基金排行";
	
	//高级筛选
	siftCtrl = [[SiftViewController alloc] init];
	//[siftCtrl.view setBackgroundColor:[UIColor clearColor]];
	UINavigationController * siftNav = [[FPNavigationController alloc] initWithRootViewController:siftCtrl];
	siftCtrl.title = @"高级筛选";

	
	//基金分析
	analyseCtrl = [[AnalyseViewController alloc] init];
	//[analyseCtrl.view setBackgroundColor:[UIColor clearColor]];
	UINavigationController * analyseNav = [[FPNavigationController alloc] initWithRootViewController:analyseCtrl];
	analyseCtrl.title = @"基金分析";
	
	//个人中心
	personalCtrl = [[PersonalViewController alloc] init];
	//[personalCtrl.view setBackgroundColor:[UIColor clearColor]];
	UINavigationController * personalNav = [[FPNavigationController alloc] initWithRootViewController:personalCtrl];
	
	//tabbar图标、title
    self.mainTabCtrl.viewControllers = [NSArray arrayWithObjects:homeNavCtrl,valueNav,rankingsNav,siftNav,analyseNav,personalNav, nil];
	self.mainTabCtrl.imgNormals = [NSArray arrayWithObjects:@"menu_04",@"menu_05",@"menu_06",@"menu_07",@"menu_08",@"menu_09",nil];
	self.mainTabCtrl.imgSelecteds = [NSArray arrayWithObjects:@"menu_04",@"menu_05",@"menu_06",@"menu_07",@"menu_08",@"menu_09",nil];
//	self.mainTabCtrl.titles = [NSArray arrayWithObjects:@"i财富基金分析师专业版",@"基金净值",@"基金排行",@"高级筛选",@"基金分析",@"个人中心",nil];



	
    self.mainTabCtrl.selectedIndex = 0;
        

    if ([[UIDevice currentDevice].systemVersion floatValue] < 6.0) {
        [self.window addSubview:self.mainTabCtrl.view];
    }
    else
    {
        [self.window setRootViewController:self.mainTabCtrl];
    }
    
    // 检查当前网络状态，并给出提示
    if ([self networkState] == NotReachable) {
        [FPUIKits messageBox:FPString(@"network_disconnect")];
    }
    
    [self.window makeKeyAndVisible];
}

- (NSInteger)networkState
{
    return [_NETWORK getNetworkStatus];
}

#pragma mark - UITabBarControllerDelegate

- (BOOL)tabBarController:(CMTabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController
{
    return YES;
}

#pragma mark - FPNetworkChangeDelegate

// 网络状态变化的通知
// nNetworkStatus为NotReachable时代表无网络连接
// nNetworkStatus为ReachableViaWiFi时代表WIFI连接
// nNetworkStatus为ReachableViaWWAN时代表2G/3G连接
- (void)onNetworkChange:(NSInteger)nNetworkStatus descriptionDetail:(NSString*)descriptionDetail
{
    NSString * networkInfo = nil;
    BOOL networkConnected = YES;
    
    switch (nNetworkStatus)
    {
        case NotReachable:
            networkInfo = FPString(@"network_disconnect");
            networkConnected = NO;
            break;
        case ReachableViaWiFi:
            networkInfo = FPString(@"network_wifi");
			//网络切换为wifi时页面处理
			[homePageCtrl onNetConnected];
			[valueCtrl onNetConnected];
			[siftCtrl onNetConnected];
			[personalCtrl onNetConnected];
			[analyseCtrl onNetConnected];
			[rankingsCtrl onNetConnected];
            break;
        case ReachableViaWWAN:
            networkInfo = FPString(@"network_edge");
			//网络切换为2g、3g时页面处理
			[homePageCtrl onNetConnected];
			[valueCtrl onNetConnected];
			[siftCtrl onNetConnected];
			[personalCtrl onNetConnected];
			[analyseCtrl onNetConnected];
			[rankingsCtrl onNetConnected];
            break;
        default:
            break;
    }
    
    if ((ReachableViaWWAN == nNetworkStatus || NotReachable == nNetworkStatus) && networkInfo) {
        [FPUIKits messageBox:networkInfo];
    }
    else {
        [FPUIKits killCurrentMessageBox];
    }
}



- (NSString *)md5EncParam:(NSMutableArray *)array
{
    NSMutableArray* arr = array;
    
    // 升序
    [arr sortUsingComparator:^NSComparisonResult(__strong id obj1,__strong id obj2){
        NSString *str1=(NSString *)obj1;
        NSString *str2=(NSString *)obj2;
        return [str1 compare:str2];
    }];
    
    NSString * str = @"";
    for (int i = 0; i < arr.count; ++i) {
        str = [str stringByAppendingString:(NSString *)[arr objectAtIndex:i]];
        if (i != arr.count-1) {
            str = [str stringByAppendingString:@"&"];
        }
    }
    NSString * md5Param = [str stringByAppendingString:APP_KEY_VALUE];
    NSString * md5Str = [md5Param md5];
    
    str = [str stringByAppendingFormat:@"&sign_type=MD5&sign=%@",md5Str];
    str = [@"?" stringByAppendingString:str];
    return str;
}


- (NSString *)md5EncParamRegister:(NSMutableArray *)array
{
    NSMutableArray* arr = array;
    
    // 升序
    [arr sortUsingComparator:^NSComparisonResult(__strong id obj1,__strong id obj2){
        NSString *str1=(NSString *)obj1;
        NSString *str2=(NSString *)obj2;
        return [str1 compare:str2];
    }];
    
    NSString * str = @"";
    for (int i = 0; i < arr.count; ++i) {
        str = [str stringByAppendingString:(NSString *)[arr objectAtIndex:i]];
        if (i != arr.count-1) {
            str = [str stringByAppendingString:@"&"];
        }
    }
    NSString * md5Param = [str stringByAppendingString:APP_KEY_VALUE];
    NSString * md5Str = [md5Param md5];
    
    return md5Str;
}

@end
