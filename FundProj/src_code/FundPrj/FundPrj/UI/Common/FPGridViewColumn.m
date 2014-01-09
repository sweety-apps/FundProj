//
// FPGridViewColumn.h
//  FundPrj
//
//  Created by leesea on 13-10-22.
//  Copyright (c) 2013年 leesea. All rights reserved.
//
#import "FPGridViewColumn.h"

@interface FPGridViewColumn()
{
@private
    NSInteger _headerHeight;
    UIView * _headerView;
}
@end

@implementation FPGridViewColumn

@synthesize arCells = _arCells;
@synthesize FPGridViewColumnDelegate = _FPGridViewColumnDelegate;
@synthesize leftMargins = _leftMargins;
@synthesize rightMargins = _rightMargins;
@synthesize topMargins = _topMargins;
@synthesize bottomMargins = _bottomMargins;
@synthesize size = _size;
@synthesize index = _index;


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        self.arCells = [NSMutableArray arrayWithCapacity:[_FPGridViewColumnDelegate numberOfColumns:self]];
    }
    
    UITapGestureRecognizer * singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTap:)];
    [self.contentView addGestureRecognizer:singleTap];
    
    return self;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}

-(void)singleTap:(UITapGestureRecognizer *)sender
{
    CGPoint point = [sender locationInView:self.contentView];
    CGFloat x = point.x;
    NSInteger width = (self.contentView.frame.size.width - self.leftMargins - self.rightMargins) / [_FPGridViewColumnDelegate numberOfColumns:self];
    NSInteger index = 0;
    
    if (point.y <= _topMargins || point.y >= self.contentView.frame.size.height - _bottomMargins) {
        return;
    }
    
    // 有误差 leftMargins、rightMargins
	x -= self.leftMargins;
    while (x > 0)
    {
        x -= width;
        ++index;
    }
    --index;
    
    if (index >= self.size || index < 0) 
    {
        return;
    }
	
	if ([_FPGridViewColumnDelegate respondsToSelector:@selector(cellSelectRect)])
	{
		CGRect frame = [_FPGridViewColumnDelegate cellSelectRect];
		x += width;
		CGPoint tempPoint = CGPointMake(x, point.y);
		if (CGRectContainsPoint(frame, tempPoint)) 
		{
			[_FPGridViewColumnDelegate cellDidSelect:self cellDidSelect:[self.arCells objectAtIndex:index]];
		}
	}
    else {
		[_FPGridViewColumnDelegate cellDidSelect:self cellDidSelect:[self.arCells objectAtIndex:index]];
	}
}


- (void)configWithData:(id)data indexOfCell:(NSInteger)indexCell;
{
    if (indexCell >= [_FPGridViewColumnDelegate numberOfColumns:self])
    {
        return;
    }
    
//    UIView * oldCell = [self.arCells objectAtIndex:indexCell];
//    if (oldCell) 
//    {
//        [oldCell removeFromSuperview];
//        [self.arCells removeObject:oldCell];
//    }
    
    CGRect frame = self.bounds;
    frame.size.width = (frame.size.width - self.leftMargins - self.rightMargins) / [_FPGridViewColumnDelegate numberOfColumns:self];
    frame.origin.x += self.leftMargins + frame.size.width * indexCell;
    frame.origin.y += _topMargins;
    frame.size.height -= _topMargins + _bottomMargins;
    
    if (indexCell >= self.arCells.count)
    {
        UIView * cell = (UIView *)[_FPGridViewColumnDelegate cellForColumns:self cell:nil data:data frame:frame];
        [self.contentView addSubview:cell];
        [self.arCells insertObject:cell atIndex:indexCell];
    }
    else
    {
        UIView * cell = (UIView *)[self.arCells objectAtIndex:indexCell];
        [cell removeFromSuperview];
        [self.arCells removeObject:cell];
        cell = [_FPGridViewColumnDelegate cellForColumns:self cell:cell data:data frame:frame];
        [self.contentView addSubview:cell];
        [self.arCells insertObject:cell atIndex:indexCell];
    }
}

- (id)getCellOfColumn:(NSInteger)col
{
    return [self.arCells objectAtIndex:col];
}

- (void)setColumnSize:(NSInteger)columnSize
{
    self.size = columnSize;
    for (int i = columnSize; i < self.arCells.count; ++i)
    {
        UIView * cell = (UIView *)[self.arCells objectAtIndex:i];
        [cell removeFromSuperview];
    }
}

- (void)buildBg:(id)data
{
    [_FPGridViewColumnDelegate bgForColumns:self data:data];
}


@end




