//
//  UIImageEX.m
//  FundPrj
//
//  Created by leesea on 13-10-22.
//  Copyright (c) 2013年 leesea. All rights reserved.
//

#import "UIImageEX.h"

@implementation UIImage (EX)

- (UIImage*)iconImageWithWidth:(double)width cornerRadius:(double)radius border:(double)border borderColor:(UIColor*)color {
	
	if ([self respondsToSelector:@selector(scale)]) {
		width = width*self.scale;
	}
	
	CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();                //1
	CGContextRef context = CGBitmapContextCreate(nil, width, width, 8, 0, colorSpace, kCGImageAlphaPremultipliedFirst);                                              //2
    
	CGSize imgSize = self.size;
	CGFloat mid = width/2;
	
#define useContext 1
	// use context
#if useContext	
	CGContextBeginPath(context);
  	CGContextMoveToPoint(context, 0, 0);                                     //3
	CGContextAddLineToPoint(context, 0, 1);
	
	CGContextMoveToPoint(context, 0, 1);
	CGContextMoveToPoint(context, 0, 2);
	
	CGContextAddArcToPoint(context, 0, 0, mid, 0, radius);
	CGContextAddArcToPoint(context, width, 0, width, mid, radius);
	CGContextAddArcToPoint(context, width, width, mid, width, radius);
	CGContextAddArcToPoint(context, 0, width, 0, mid, radius);
	CGContextClosePath(context) ;                                              //4
#else
	// use path	
	CGMutablePathRef paths = CGPathCreateMutable();
	CGPathMoveToPoint(paths, nil, 0, mid);
	CGPathAddArcToPoint(paths, nil, 0, 0, mid, 0, radius);
	CGPathAddArcToPoint(paths,nil, width, 0, width, mid, radius);
	CGPathAddArcToPoint(paths,nil, width, width, mid, width, radius);
	CGPathAddArcToPoint(paths,nil,0, width, 0, mid, radius);
	CGContextAddPath(context, paths);
	CGPathRelease(paths);
#endif
	
	CGContextClip(context);                                                    //5
	CGContextSetStrokeColorWithColor(context, color.CGColor);                  //6
	CGContextSetFillColorWithColor(context, [UIColor clearColor].CGColor);
	
	CGContextBeginPath(context);
	CGContextMoveToPoint(context, 0, mid);
	CGContextAddArcToPoint(context, 0, 0, mid, 0, radius);
	CGContextAddArcToPoint(context, width, 0, width, mid, radius);
	CGContextAddArcToPoint(context, width, width, mid, width, radius);
	CGContextAddArcToPoint(context, 0, width, 0, mid, radius);
	CGContextClosePath(context);
	CGContextSetLineWidth(context, border);
	CGContextDrawPath(context,kCGPathFillStroke);	
	if(imgSize.width>imgSize.height){
		double rate = imgSize.width/imgSize.height;
        
		CGContextDrawImage(context, CGRectMake(floor(-(rate-1)/2*width)+border, border, floor(rate*width)-2*border, floor(width)-2*border), self.CGImage);
	}
	else{
		double rate = imgSize.height/imgSize.width;
        
		CGContextDrawImage(context, CGRectMake(0+border, floor(-(rate-1)/2*width)+border, floor(width)-2*border, floor(rate*width)-2*border), self.CGImage);
	}
    
	CGImageRef cgimg = CGBitmapContextCreateImage(context);
	UIImage *img = nil;
	if ([self respondsToSelector:@selector(scale)]) {
		img = [UIImage imageWithCGImage:cgimg scale:self.scale orientation:self.imageOrientation];
	}else {
		img = [UIImage imageWithCGImage:cgimg];
	}
    
    
	if(cgimg) CGImageRelease(cgimg);
    
	if(context) CGContextRelease (context); 
	if(colorSpace) CGColorSpaceRelease(colorSpace);	
	return img;
}

- (UIImage*)iconImageWithWidth:(double)width cornerRadius:(double)radius{
	return [self iconImageWithWidth:width cornerRadius:radius border:0.0 borderColor:[UIColor clearColor]];
}

typedef enum {
    ALPHA = 0,
    BLUE = 1,
    GREEN = 2,
    RED = 3
} PIXELS;

-(UIImage*)grayImage{
	
    
    CGSize size = [self size];
	
    //	int _tmp = 1 ;
    //	DeviceType _type = [[MSFImagePool defaultPool] deviceVersion];
    //	
    //	if(DeviceiPhone4 == _type || DeviceiPodTouch4G == _type) _tmp = 2 ;
    //
    int width = size.width ;
	int height = size.height ;
	
	if ([self respondsToSelector:@selector(scale)]) {
		int scale = 2;
		width = width*scale;
		height = height*scale;
	}
	
    // the pixels will be painted to this array
    uint32_t *pixels = (uint32_t *) malloc(width * height * sizeof(uint32_t));
	
    // clear the pixels so any transparency is preserved
    memset(pixels, 0, width * height * sizeof(uint32_t));
	
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
	
    // create a context with RGBA pixels
    CGContextRef context = CGBitmapContextCreate(pixels, width, height, 8, width * sizeof(uint32_t), colorSpace, 
                                                 kCGBitmapByteOrder32Little | kCGImageAlphaPremultipliedLast);
	
    // paint the bitmap to our context which will fill in the pixels array
    CGContextDrawImage(context, CGRectMake(0, 0, width, height), [self CGImage]);
    //  CGContextDrawImage(context, CGRectMake(0, 0, width, height), img.CGImage);
	
    for(int y = 0; y < height; y++) {
        for(int x = 0; x < width; x++) {
            uint8_t *rgbaPixel = (uint8_t *) &pixels[y * width + x];
			
            // convert to grayscale using recommended method: http://en.wikipedia.org/wiki/Grayscale#Converting_color_to_grayscale
            uint32_t gray = 0.3 * rgbaPixel[RED] + 0.59 * rgbaPixel[GREEN] + 0.11 * rgbaPixel[BLUE];
			
            // set the pixels to gray
            rgbaPixel[RED] = gray;
            rgbaPixel[GREEN] = gray;
            rgbaPixel[BLUE] = gray;
        }
    }
	
    // create a new CGImageRef from our context with the modified pixels
    CGImageRef image = CGBitmapContextCreateImage(context);
	
    // we're done with the context, color space, and pixels
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
	if (pixels) {
        free(pixels);
	}
	UIImage *resultUIImage = nil;
	if ([self respondsToSelector:@selector(scale)]) {
		resultUIImage = [UIImage imageWithCGImage:image scale:2 orientation:[self imageOrientation]];
	}else {
		resultUIImage = [UIImage imageWithCGImage:image];
	}
    
    
	
    // we're done with image now too
	if (image) {
		CGImageRelease(image);
	}
    
	
    return resultUIImage;
}

-(UIImage*)linghtImage{
	
	
    CGSize size = [self size];
	
	
    int width = size.width ;
	int height = size.height;
	if ([self respondsToSelector:@selector(scale)]) {
		int scale = 2;
		width = scale * width;
		height = scale *height;
	}
	
    // the pixels will be painted to this array
    uint32_t *pixels = (uint32_t *) malloc(width * height * sizeof(uint32_t));
	
    // clear the pixels so any transparency is preserved
    memset(pixels, 0, width * height * sizeof(uint32_t));
	
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
	
    // create a context with RGBA pixels
    CGContextRef context = CGBitmapContextCreate(pixels, width, height, 8, width * sizeof(uint32_t), colorSpace, 
                                                 kCGBitmapByteOrder32Little | kCGImageAlphaPremultipliedLast);
	
    // paint the bitmap to our context which will fill in the pixels array
    CGContextDrawImage(context, CGRectMake(0, 0, width, height), [self CGImage]);
    //  CGContextDrawImage(context, CGRectMake(0, 0, width, height), img.CGImage);
	
    for(int y = 0; y < height; y++) {
        for(int x = 0; x < width; x++) {
            uint8_t *rgbaPixel = (uint8_t *) &pixels[y * width + x];
			
            // convert to grayscale using recommended method: http://en.wikipedia.org/wiki/Grayscale#Converting_color_to_grayscale
            float _gray = 0.8f;
			
            uint32_t gray = _gray * rgbaPixel[RED] + _gray * rgbaPixel[GREEN] + _gray * rgbaPixel[BLUE];
			
            // set the pixels to gray
            //rgbaPixel[ALPHA] = 0.5f ;
            rgbaPixel[RED] = gray;
            rgbaPixel[GREEN] = gray;
            rgbaPixel[BLUE] = gray;
        }
    }
	
    // create a new CGImageRef from our context with the modified pixels
    CGImageRef image = CGBitmapContextCreateImage(context);
	
    // we're done with the context, color space, and pixels
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
	if (pixels) {
		free(pixels);
	}
	
	
    // make a new UIImage to return
    UIImage *resultUIImage = nil;
	if ([self respondsToSelector:@selector(scale)]) {
		resultUIImage = [UIImage imageWithCGImage:image scale:2 orientation:[self imageOrientation]];
	}else {
		resultUIImage= [UIImage imageWithCGImage:image];
	}
    
	
	
    // we're done with image now too
	if (image) {
		CGImageRelease(image);
	}
	
	
    return resultUIImage;
}

-(UIImage*)scaleToSize:(CGSize)size  
{  
    if (NULL != UIGraphicsBeginImageContextWithOptions) {
        UIGraphicsBeginImageContextWithOptions(size, YES, 0);
    } else {
        UIGraphicsBeginImageContext(size);
    }
    
    [self drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return scaledImage;
}

//用来替代scaleToSize，scaleToSize压缩ico图片的时候透明的地方会变成黑色
- (UIImage *) makeThumbnailOfSize:(CGSize)size
{
    UIGraphicsBeginImageContext(size);  
    // draw scaled image into thumbnail context
    [self drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *newThumbnail = UIGraphicsGetImageFromCurrentImageContext();        
    // pop the context
    UIGraphicsEndImageContext();
    if(newThumbnail == nil) 
        NSLog(@"could not scale image");
    return newThumbnail;
}

- (UIImage *)imageWithGaussianBlur {
    float weight[5] = {0.2270270270, 0.1945945946, 0.1216216216, 0.0540540541, 0.0162162162};
    // Blur horizontally
    UIGraphicsBeginImageContext(self.size);
    [self drawInRect:CGRectMake(0, 0, self.size.width, self.size.height) blendMode:kCGBlendModePlusLighter alpha:weight[0]];
    for (int x = 1; x < 5; ++x) {
        [self drawInRect:CGRectMake(x, 0, self.size.width, self.size.height) blendMode:kCGBlendModePlusLighter alpha:weight[x]];
        [self drawInRect:CGRectMake(-x, 0, self.size.width, self.size.height) blendMode:kCGBlendModePlusLighter alpha:weight[x]];
    }
    UIImage *horizBlurredImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    // Blur vertically
    UIGraphicsBeginImageContext(self.size);
    [horizBlurredImage drawInRect:CGRectMake(0, 0, self.size.width, self.size.height) blendMode:kCGBlendModePlusLighter alpha:weight[0]];
    for (int y = 1; y < 5; ++y) {
        [horizBlurredImage drawInRect:CGRectMake(0, y, self.size.width, self.size.height) blendMode:kCGBlendModePlusLighter alpha:weight[y]];
        [horizBlurredImage drawInRect:CGRectMake(0, -y, self.size.width, self.size.height) blendMode:kCGBlendModePlusLighter alpha:weight[y]];
    }
    UIImage *blurredImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    //
    return blurredImage;
}

@end
