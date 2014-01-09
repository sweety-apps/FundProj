//
//  DetailViewController.h
//  FundPrj
//
//  Created by leesea on 13-11-18.
//  Copyright (c) 2013年 leesea. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CorePlot-CocoaTouch.h"

@interface DetailViewController : UIViewController<CPTPlotDataSource>

- (id)initWithFundCode:(NSInteger)code;

@end
