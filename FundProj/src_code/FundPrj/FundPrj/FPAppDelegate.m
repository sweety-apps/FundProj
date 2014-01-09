//
//  FPAppDelegate.m
//  FundPrj
//
//  Created by leesea on 13-10-22.
//  Copyright (c) 2013年 leesea. All rights reserved.
//

#import "FPAppDelegate.h"

#import "ASIFormDataRequest.h"
#import "Utility.h"
#import "UIMain.h"

@implementation FPAppDelegate

@synthesize objUIMain = _objUIMain;
@synthesize objNetworkManager = _objNetworkManager;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // 创建网络监控
    self.objNetworkManager = [[FPNetworkManager alloc] init];
    
    // 创建UI window
    self.objUIMain = [[UIMain alloc] init];
    
    [_UI showMainWindow];
    
    return YES;
}
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
}


- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
}

- (void)applicationWillResignActive:(UIApplication *)application
{
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    
	// Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
	// Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
	// Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application
{
    //    int level = (int)OSMemoryNotificationCurrentLevel();
}

@end

