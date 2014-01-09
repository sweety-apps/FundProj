//
//  NewDetailViewController.h
//  FundPrj
//
//  Created by leesea on 13-11-11.
//  Copyright (c) 2013年 leesea. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FundNewsData.h"

@interface NewDetailViewController : UIViewController <UIWebViewDelegate>

- (id)initWithData:(FundNewsData *)data;

@end
