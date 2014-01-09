//
//  UIImageEX.h
//  FundPrj
//
//  Created by leesea on 13-10-22.
//  Copyright (c) 2013年 leesea. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UIImage (EX)

- (UIImage*)iconImageWithWidth:(double)width cornerRadius:(double)radius;
- (UIImage*)grayImage;
- (UIImage*)linghtImage;
- (UIImage*)scaleToSize:(CGSize)size;
- (UIImage *) makeThumbnailOfSize:(CGSize)size;
- (UIImage *)imageWithGaussianBlur;

@end
