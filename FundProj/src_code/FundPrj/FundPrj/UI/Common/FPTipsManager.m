//
// FPTipsManager.m
//  FundPrj
//
//  Created by leesea on 13-10-22.
//  Copyright (c) 2013年 leesea. All rights reserved.
//

#import "FPTipsManager.h"

#define TipLoadingOverTime 20
#define TipNormalOverTime 1

static FPTipsManager * _tipsManagerInstance;

@implementation FPTipsManager

@synthesize HUD = _HUD;
@synthesize maskWindow = _maskWindow;
@synthesize overTimer = _overTimer;

+ (FPTipsManager *)sharedManager{
    @synchronized(_tipsManagerInstance){
        if(nil == _tipsManagerInstance){
            _tipsManagerInstance = [[FPTipsManager alloc] init];
        }
    }
    return _tipsManagerInstance;
}

- (id)init{
    if([super init]){
        
        self.maskWindow = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
        self.maskWindow.hidden = YES;
        self.maskWindow.windowLevel = UIWindowLevelAlert;
        
        self.HUD = [[MBProgressHUD alloc] initWithView:self.maskWindow];
        self.HUD.animationType = MBProgressHUDAnimationFade;
        self.HUD.delegate = self;

    }
    return self;
}

- (void)postMessage:(NSString *)message{
   self.maskWindow.hidden = NO;
    
	UIImage * msgImg = [UIImage imageNamed:@"tmall_notice_info.png"];
    UIImageView * msgImageview = [[UIImageView alloc] initWithImage:msgImg];
	_HUD.customView = msgImageview;
	_HUD.mode = MBProgressHUDModeCustomView;
	_HUD.labelText = message;
    
    [self.maskWindow addSubview:self.HUD];
    [_HUD show:YES];
    
   [self.overTimer invalidate];
    self.overTimer = [NSTimer scheduledTimerWithTimeInterval:TipNormalOverTime target:self
                                                    selector:@selector(overTimerCallback:) userInfo:nil
                                                     repeats:NO];
}
- (void)postError:(NSString *)message{
    
    if([message length] == 0){//不提示空内容
        return;
    }
    
    self.maskWindow.hidden = NO;
    
	UIImage * msgImg = [UIImage imageNamed:@"tmall_notice_failed.png"];
    UIImageView * msgImageview = [[UIImageView alloc] initWithImage:msgImg];
	_HUD.customView = msgImageview;
	_HUD.mode = MBProgressHUDModeCustomView;
	_HUD.labelText = message;
    
    [self.maskWindow addSubview:self.HUD];
    [_HUD show:YES];
    
   [self.overTimer invalidate];
    self.overTimer = [NSTimer scheduledTimerWithTimeInterval:TipNormalOverTime target:self
                                                    selector:@selector(overTimerCallback:) userInfo:nil
                                                     repeats:NO];

}
- (void)postSuccess:(NSString *)message{
    self.maskWindow.hidden = NO;
    
	UIImage * msgImg = [UIImage imageNamed:@"tmall_notice_sucess.png"];
    UIImageView * msgImageview = [[UIImageView alloc] initWithImage:msgImg];
	_HUD.customView = msgImageview;
	_HUD.mode = MBProgressHUDModeCustomView;
	_HUD.labelText = message;
    
    [self.maskWindow addSubview:self.HUD];
    [_HUD show:YES];
    
    [self.overTimer invalidate];
    self.overTimer = [NSTimer scheduledTimerWithTimeInterval:TipNormalOverTime target:self
                                                    selector:@selector(overTimerCallback:) userInfo:nil
                                                     repeats:NO];

}
- (void)postLoading:(NSString *)message{

    self.maskWindow.hidden = NO;
    
	self.HUD.customView = nil;
	self.HUD.mode = MBProgressHUDModeIndeterminate;
	self.HUD.labelText = message;
    [self.maskWindow addSubview:self.HUD];
	[self.HUD show:YES];
    
    [self.overTimer invalidate];
    self.overTimer = [NSTimer scheduledTimerWithTimeInterval:TipLoadingOverTime target:self
                                                    selector:@selector(overTimerCallback:) userInfo:nil
                                                     repeats:NO];
}

- (void)cleanUp:(BOOL)animated{
    self.maskWindow.hidden = YES;
    [_HUD hide:animated];
}

- (void)overTimerCallback:(NSTimer *)timer{
    [self cleanUp:YES];
}
@end
