//
//  HomeViewController.h
//  FundPrj
//
//  Created by leesea on 13-10-22.
//  Copyright (c) 2013年 leesea. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CorePlot-CocoaTouch.h"


@interface HomeViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UIGestureRecognizerDelegate, UITextFieldDelegate, UIAlertViewDelegate, CPTPlotDataSource, UIWebViewDelegate>
{
}

- (void)onNetConnected;

@end
