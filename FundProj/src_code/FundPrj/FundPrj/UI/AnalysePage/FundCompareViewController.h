//
//  FundCompareViewController.h
//  FundPrj
//
//  Created by leesea on 13-11-12.
//  Copyright (c) 2013年 leesea. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CorePlot-CocoaTouch.h"

@interface FundCompareViewController : UIViewController<CPTPlotDataSource>

@property (assign, nonatomic) NSInteger count;
@property (strong, nonatomic) NSMutableArray * fundArray;

@end
