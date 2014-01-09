//
//  CMTabBarController.h
//
//  Created by Constantine Mureev on 13.03.12.
//  Copyright (c) 2012 Team Force LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "CMTabBar.h"

#define SYSTEM_VERSION_EQUAL_TO(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)

@interface CMTabBarController : UIViewController <CMTabBarDelegate>

+ (id)sharedTabBarController;

@property (nonatomic, retain) NSArray*              viewControllers;
@property (nonatomic, retain) NSArray*              imgNormals;
@property (nonatomic, retain) NSArray*              imgSelecteds;
@property (nonatomic, retain) NSArray*              titles;

@property (nonatomic, readonly) UIViewController*   selectedViewController;
@property (nonatomic, assign) NSUInteger            selectedIndex;

@property (nonatomic, retain) CMTabBar*             tabBar;

@property (nonatomic, assign) id<UITabBarControllerDelegate> delegate;

@end
