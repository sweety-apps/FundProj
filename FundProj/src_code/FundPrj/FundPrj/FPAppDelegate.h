//
//  FPAppDelegate.h
//  FundPrj
//
//  Created by leesea on 13-10-22.
//  Copyright (c) 2013年 leesea. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "UIMain.h"
#import "NetworkManager.h"
#import "ASIHTTPRequest.h"
#define willRegisiteBack @"willRegisiteBack"
#define willRegisiteActive @"willRegisiteActive"
@interface FPAppDelegate : UIResponder <UIApplicationDelegate,ASIHTTPRequestDelegate,UIAlertViewDelegate>
{
}

@property (strong, nonatomic) UIMain * objUIMain;
@property (strong, nonatomic) FPNetworkManager * objNetworkManager;

@end
