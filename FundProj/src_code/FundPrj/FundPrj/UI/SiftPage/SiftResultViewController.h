//
//  SiftResultViewController.h
//  FundPrj
//
//  Created by leesea on 13-11-21.
//  Copyright (c) 2013年 leesea. All rights reserved.
//


#import <UIKit/UIKit.h>

typedef enum _SiftType {
	SiftNormalType = 0,
    SiftIntelType = 1
} SiftType;

@interface SiftResultViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UIAlertViewDelegate>

@property (nonatomic, assign) SiftType siftType;
@property (nonatomic, copy) NSString * fundType;
@property (nonatomic, copy) NSString * investType;
@property (nonatomic, copy) NSString * estbData;
@property (nonatomic, assign) NSInteger status;
@property (nonatomic, assign) NSInteger grade;
@property (nonatomic, assign) NSInteger rr_this_year;
@property (nonatomic, assign) NSInteger fund_corp;

@property (nonatomic, assign) NSInteger size;
@property (nonatomic, assign) NSInteger rr_one_year;
@property (nonatomic, assign) NSInteger invest_stock_style;
@property (nonatomic, assign) NSInteger invest_bond_style;
@property (nonatomic, assign) NSInteger invest_stock_ratio;
@property (nonatomic, assign) NSInteger top_industry;
@property (nonatomic, assign) NSInteger grade_qoq;
@property (nonatomic, assign) NSInteger shape;
@property (nonatomic, assign) NSInteger risk;

@end
