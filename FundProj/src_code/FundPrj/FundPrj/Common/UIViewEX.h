//
//  UIViewEX.h
//  FundPrj
//
//  Created by leesea on 13-10-22.
//  Copyright (c) 2013年 leesea. All rights reserved.
//

#import <Foundation/Foundation.h>

#define ACTIVITY_IND_TAG 999999

typedef enum
{
	DIRECTION_LEFT,
	DIRECTION_TOP,
	DIRECTION_RIGHT,
	DIRECTION_BOTTOM
}UIVIEW_NEARBY_DIRECTION;

@interface UIView (EX)

//获取特定类型子View
- (UIView*)descendantOrSelfWithClass:(Class)cls;

// 截图
- (UIImage *)captureImageInRect:(CGRect)rect;

//添加淡入淡出动画
-(void)addEaseInOutAnimationWithStartAlpha:(BOOL)alpha duration:(float)duration;

//添加等待指示
-(UIActivityIndicatorView*)addActivityIndicator;
-(UIActivityIndicatorView*)addActivityIndicatorOnTop;

- (void)resetFrameNearByTarget:(UIView *)targetView direction:(UIVIEW_NEARBY_DIRECTION)direction distance:(NSInteger)distance;

@end

@interface UILabel (EX)

- (void)resetSizeFitText;


@end
