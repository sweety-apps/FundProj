//
//  FPNonClearBgColorView.m
//  FundPrj
//
//  Created by leesea on 13-10-22.
//  Copyright (c) 2013年 leesea. All rights reserved.
//

#import "FPNonClearBgColorView.h"

#define FLOAT_EQUAL(f1, f2)     ((fabs(f1-f2) < FLT_EPSILON) ? YES : NO)

@implementation FPNonClearBgColorView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
    }
    return self;
}

- (void)setBackgroundColor:(UIColor *)backgroundColor
{
    CGFloat alpha = CGColorGetAlpha(backgroundColor.CGColor);
    if (FLOAT_EQUAL(alpha, 0)) {
        return;
    }
    
    [super setBackgroundColor:backgroundColor];
}
@end
