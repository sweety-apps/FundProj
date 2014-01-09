//
//  FPImageView.m
//  FundPrj
//
//  Created by leesea on 13-10-22.
//  Copyright (c) 2013年 leesea. All rights reserved.
//

#import "FPImageView.h"

@implementation FPImageView

@synthesize image = _image;
@synthesize style = _style;
@synthesize imageDrawRect = _imageDrawRect;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
    }
    return self;
}

- (void)dealloc
{
    _image = nil;
}

- (void)setImage:(UIImage *)image
{
    _image = image;
    _imageDrawRect = [self calculateImageDrawRect];
    
    [self setNeedsDisplay];
}

- (void)setStyle:(FPImageViewStyle)style
{
    _style = style;
    _imageDrawRect = [self calculateImageDrawRect];
    
    [self setNeedsDisplay];
}

- (void)setImageDrawRect:(CGRect)imageDrawRect
{
    _imageDrawRect = imageDrawRect;
    
    [self setNeedsDisplay];
}

- (CGRect)calculateImageDrawRect
{
    CGRect retRect = CGRectZero;
    
    switch (_style)
    {
        case FPImageViewStyleDefault:
        {
            retRect = self.bounds;
            break;
        }
            
        case FPImageViewStyleCenter:
        {
            if (!self.image) {
                break;
            }
            
            CGFloat frameWidth = self.bounds.size.width;
            CGFloat frameHeight = self.bounds.size.height;
            
            CGSize imgSize = self.image.size;
            CGFloat whScale = imgSize.width / imgSize.height; // 高宽比
            
            CGFloat width = frameWidth;         // 先将宽填满
            CGFloat height = width / whScale;
            
            if (height > frameHeight)
            {
                height = frameHeight;
                width = height * whScale;
            }
            
            retRect = CGRectMake((frameWidth-width)/2, (frameHeight-height)/2, width, height);
            break;
        }
    }
    
    return retRect;
}

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    
    // 绘制图像
    [self.image drawInRect:_imageDrawRect];
}


@end
