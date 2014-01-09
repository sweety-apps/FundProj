//
// FPGridViewColumn.h
//  FundPrj
//
//  Created by leesea on 13-10-22.
//  Copyright (c) 2013年 leesea. All rights reserved.
//
#import <Foundation/Foundation.h>

@protocol FPGridViewColumnDelegate;

@interface FPGridViewColumn : UITableViewCell <UIGestureRecognizerDelegate>
{
    NSMutableArray * arCells;
    NSInteger size;
    id<FPGridViewColumnDelegate> FPGridViewColumnDelegate;
}

// 数据
@property (strong, nonatomic) NSMutableArray * arCells;
@property (assign, nonatomic) id<FPGridViewColumnDelegate> FPGridViewColumnDelegate;
@property (assign, nonatomic) NSInteger leftMargins;
@property (assign, nonatomic) NSInteger rightMargins;
@property (assign, nonatomic) NSInteger topMargins;
@property (assign, nonatomic) NSInteger bottomMargins;
@property (assign, nonatomic) NSInteger size;
@property (assign, nonatomic) NSInteger index;

- (void)configWithData:(id)data indexOfCell:(NSInteger)indexCell;

- (id)getCellOfColumn:(NSInteger)col;

- (void)setColumnSize:(NSInteger)columnSize;

- (void)buildBg:(id)data;



@end

@protocol FPGridViewColumnDelegate <NSObject>

- (NSInteger)numberOfColumns:(FPGridViewColumn *)FPGridViewColumn;

- (UIView *)cellForColumns:(FPGridViewColumn *)FPGridViewColumn cell:(id)cell data:(id)data frame:(CGRect)frame;

- (void)cellDidSelect:(FPGridViewColumn *)FPGridViewColumn cellDidSelect:(UIView *)cellSelect;

@optional

- (CGRect)cellSelectRect;

- (void)bgForColumns:(FPGridViewColumn *)FPGridViewColumn data:(id)data;


@end
