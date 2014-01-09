//
// FPUIKits.m
//  FundPrj
//
//  Created by leesea on 13-10-22.
//  Copyright (c) 2013年 leesea. All rights reserved.
//

#import "UIKits.h"
#import "ModalAlert.h"


@implementation FPUIKits

static NSTimer *     g_timerProcMsg = nil;
static UIAlertView * g_procAlert = nil;
static UIAlertView * g_norAlert = nil;

// 进度对话框60秒超时，超时后弹出提示请求超时
#define PROC_MSGBOX_TIMEOUT_TIME    60.0f


+ (void)procMsgBoxTimerProc:(NSTimer*)timer
{
    [self hideProcMsgBox];
    [self messageBox:FPString(@"common_hint_timeout")];
}

+ (void)showProcMsgBox:(NSString*)message
{
    if (g_timerProcMsg)
    {
        [g_timerProcMsg invalidate];
        g_timerProcMsg = nil;
    }
    g_timerProcMsg = 
    [NSTimer scheduledTimerWithTimeInterval:PROC_MSGBOX_TIMEOUT_TIME 
                                     target:self 
                                   selector:@selector(procMsgBoxTimerProc:) 
                                   userInfo:nil 
                                    repeats:NO];
    
    NSString* strMsg = [NSString stringWithFormat:@"\n%@", message];
    if (g_procAlert)
    {
        g_procAlert.title = strMsg;
        return ;
    }
    g_procAlert = [[UIAlertView alloc] initWithTitle:strMsg 
                                             message:nil
                                            delegate:nil 
                                   cancelButtonTitle:nil
                                   otherButtonTitles:nil];
    [g_procAlert show];
    
    UIActivityIndicatorView* indicator = [[UIActivityIndicatorView alloc]
        initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    indicator.center = CGPointMake(g_procAlert.bounds.size.width/2,
                                   g_procAlert.bounds.size.height-50);
    [indicator startAnimating];
    [g_procAlert addSubview:indicator];
}

+ (BOOL)isProcMsgBoxShowing
{
    return (g_procAlert != nil);
}

+ (void)hideProcMsgBox
{
    if (g_timerProcMsg)
    {
        [g_timerProcMsg invalidate];
        g_timerProcMsg = nil;
    }
    [g_procAlert dismissWithClickedButtonIndex:0 animated:YES];
    g_procAlert = nil;
}

// normal alertview
+ (void)messageBox:(NSString*)message 
             title:(NSString*)title 
               tag:(NSInteger)tag
          delegate:(id)delegate 
           buttons:(NSArray*)btnTitleArray
{
	int nBtnCount = 0;
	NSString *strFistBtnTitle = nil;
	if (btnTitleArray)
    {
		nBtnCount = [btnTitleArray count];
		if (nBtnCount != 0)
        {
			strFistBtnTitle = [btnTitleArray objectAtIndex:0];
		}
	}
	g_norAlert = [[UIAlertView alloc] initWithTitle:title 
                                            message:message 
                                           delegate:delegate 
                                  cancelButtonTitle:strFistBtnTitle
                                  otherButtonTitles:nil];
	
	for (int i = 1; i < nBtnCount; ++i)
    {
		[g_norAlert addButtonWithTitle:[btnTitleArray objectAtIndex:i]];
	}
	
	g_norAlert.tag = tag;
    
	[g_norAlert show];
}

+ (void)killCurrentMessageBox
{
    if (g_norAlert)
    {
        [g_norAlert dismissWithClickedButtonIndex:0 animated:NO];
        g_norAlert = nil;
    }
}

+ (void)messageBox:(NSString*)message 
             title:(NSString*)title 
               tag:(NSInteger)tag
          delegate:(id)delegate
{
    [self messageBox:message 
               title:title 
                 tag:tag
            delegate:delegate 
             buttons:[NSArray arrayWithObject:FPString(@"common_ok")]];
}

+ (void)messageBox:(NSString*)message
{
	[self messageBox:message 
               title:FPString(@"common_hint_title") 
                 tag:0
            delegate:nil 
             buttons:[NSArray arrayWithObject:FPString(@"common_ok")]];
}

+ (void)messageBox:(NSString*)message 
             title:(NSString*)title
{
	[self messageBox:message 
               title:title 
                 tag:0
            delegate:nil 
             buttons:[NSArray arrayWithObject:FPString(@"common_ok")]];
}

// width position offset
+ (void)messageBox:(NSString*)message 
             title:(NSString*)title 
               tag:(NSInteger)tag
          delegate:(id)delegate 
           buttons:(NSArray*)btnTitleArray 
            offset:(CGPoint)offset
{
	int nBtnCount = 0;
	NSString *strFistBtnTitle = nil;
	if (btnTitleArray)
    {
		nBtnCount = [btnTitleArray count];
		if (nBtnCount != 0)
        {
			strFistBtnTitle = [btnTitleArray objectAtIndex:0];
		}
	}
	
	g_norAlert = [[UIAlertView alloc] initWithTitle:title 
                                            message:message 
                                           delegate:delegate 
                                  cancelButtonTitle:strFistBtnTitle
                                  otherButtonTitles:nil];
    
	for (int i = 1; i < nBtnCount; ++i)
    {
		[g_norAlert addButtonWithTitle:[btnTitleArray objectAtIndex:i]];
	}
	
	g_norAlert.tag = tag;
	g_norAlert.transform = CGAffineTransformTranslate(g_norAlert.transform,
                                                      offset.x,
                                                      offset.y);
	
	[g_norAlert show];
}

+ (void)messageBox:(NSString*)message 
             title:(NSString*)title 
               tag:(NSInteger)tag
          delegate:(id)delegate 
            offset:(CGPoint)offset
{
    [self messageBox:message 
               title:title 
                 tag:tag
            delegate:delegate 
             buttons:[NSArray arrayWithObject:FPString(@"common_ok")] 
              offset:offset];
}

+ (void)messageBox:(NSString*)message 
            offset:(CGPoint)offset
{
	[self messageBox:message 
               title:FPString(@"common_hint_title") 
                 tag:0
            delegate:nil 
             buttons:[NSArray arrayWithObject:FPString(@"common_ok")] 
              offset:offset];
}

+ (void)messageBox:(NSString*)message 
             title:(NSString*)title 
            offset:(CGPoint)offset
{
	[self messageBox:message 
               title:title 
                 tag:0
            delegate:nil 
             buttons:[NSArray arrayWithObject:FPString(@"common_ok")] 
              offset:offset];
}


// modal message box
+ (NSUInteger)modalMessageBox:(NSString*)message 
                        title:(NSString*)title 
                      button1:(NSString*)button1 
                      button2:(NSString*)button2
{
    return [ModalAlert queryWith:title
                         message:message
                         button1:button1
                         button2:button2];
}




@end
