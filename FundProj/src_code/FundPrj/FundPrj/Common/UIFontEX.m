//
//  UIFontEX.m
//  FundPrj
//
//  Created by leesea on 13-10-22.
//  Copyright (c) 2013年 leesea. All rights reserved.
//

#import "UIFontEX.h"

@implementation UIFont (EX)

- (CGFloat)rowHeight{
    float sysVersion = [[[UIDevice currentDevice] systemVersion] floatValue];

    CGFloat rowH = sysVersion < 4.0?self.leading:self.lineHeight;
    return  rowH;
}
@end
