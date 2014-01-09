//
//  AnalyseViewController.h
//  FundPrj
//
//  Created by leesea on 13-11-4.
//  Copyright (c) 2013年 leesea. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AnalyseViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UIGestureRecognizerDelegate, UITextFieldDelegate, UIAlertViewDelegate>

- (void)onNetConnected;

@end
