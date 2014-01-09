//
//  FPImageView.h
//  FundPrj
//
//  Created by leesea on 13-10-22.
//  Copyright (c) 2013年 leesea. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    FPImageViewStyleDefault = 0,
    FPImageViewStyleCenter,         // image原始比例居中；不做ios3和ios4的scale处理；宽高至少一项填满frame
} FPImageViewStyle;


@interface FPImageView : UIView

@property (nonatomic, strong) UIImage * image;
@property (nonatomic, assign) FPImageViewStyle style;

@property (nonatomic, assign) CGRect imageDrawRect; // image绘制时的rect


- (CGRect)calculateImageDrawRect;

@end

