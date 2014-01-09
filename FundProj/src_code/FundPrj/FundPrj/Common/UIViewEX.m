//
//  UIViewEX.m
//  FundPrj
//
//  Created by leesea on 13-10-22.
//  Copyright (c) 2013年 leesea. All rights reserved.
//

#import "UIViewEX.h"
#import <QuartzCore/QuartzCore.h>

@implementation UIView (EX)


- (UIView*)descendantOrSelfWithClass:(Class)cls{
    if ([self isKindOfClass:cls])
        return self;
    
    for (UIView* child in self.subviews) {
        
        UIView* it = [child descendantOrSelfWithClass:cls];
        if (it)
            return it;
    }
    
    return nil;
}

- (UIImage *)captureImageInRect:(CGRect)rect
{
    UIGraphicsBeginImageContext(self.frame.size);
    [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage * fullImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    if (CGRectEqualToRect(rect, CGRectMake(0, 0, fullImage.size.width, fullImage.size.height))) {
        return fullImage;
    }
    
    CGImageRef imgRef = CGImageCreateWithImageInRect(fullImage.CGImage, rect);
    UIImage * image = [UIImage imageWithCGImage:imgRef];
    CGImageRelease(imgRef);
    
    return image;
}


-(void)addEaseInOutAnimationWithStartAlpha:(BOOL)alpha duration:(float)duration
{
    self.alpha = alpha;
    [UIView beginAnimations:@"EaseInOut" context:nil];
    [UIView setAnimationDuration:duration];
    self.alpha = !alpha;
    [UIView commitAnimations];
}

//添加等待指示
-(UIActivityIndicatorView*)addActivityIndicator
{
    UIActivityIndicatorView *actIndView = (UIActivityIndicatorView*)[self viewWithTag:ACTIVITY_IND_TAG];
    if (actIndView == nil) {
        //居中显示
        CGRect actIndRect = CGRectMake((CGRectGetWidth(self.frame)-10.f)/2.f, (CGRectGetHeight(self.frame)-10.f)/2.f, 10, 10);
        
        actIndView = [[UIActivityIndicatorView alloc] initWithFrame:actIndRect];
        actIndView.tag = ACTIVITY_IND_TAG;
        [self addSubview:actIndView];
        [self bringSubviewToFront:actIndView];
    }
    
    [actIndView startAnimating];
    
    return actIndView;
}

-(UIActivityIndicatorView*)addActivityIndicatorOnTop
{
    UIActivityIndicatorView *actIndView = (UIActivityIndicatorView*)[self viewWithTag:ACTIVITY_IND_TAG];
    if (actIndView == nil) {
        //居中显示
        CGRect actIndRect = CGRectMake((CGRectGetWidth(self.frame)-10.f)/2.f, (CGRectGetHeight(self.frame)-10.f)/10.f, 10, 10);
        
        actIndView = [[UIActivityIndicatorView alloc] initWithFrame:actIndRect];
        actIndView.tag = ACTIVITY_IND_TAG;
        [self addSubview:actIndView];
        [self bringSubviewToFront:actIndView];
    }
    
    [actIndView startAnimating];
    
    return actIndView;
}

- (void)resetFrameNearByTarget:(UIView *)targetView direction:(UIVIEW_NEARBY_DIRECTION)direction distance:(NSInteger)distance
{
	CGRect viewFrame = self.frame;
	CGRect targetFrame = targetView.frame;
	
	switch (direction) {
		case DIRECTION_LEFT:
			viewFrame.origin.x = targetFrame.origin.x - distance - viewFrame.size.width;
			break;
		case DIRECTION_RIGHT:
			viewFrame.origin.x = targetFrame.origin.x + distance + targetFrame.size.width;
			break;
		case DIRECTION_TOP:
			viewFrame.origin.y = targetFrame.origin.y - distance - viewFrame.size.height;
			break;
		case DIRECTION_BOTTOM:
			viewFrame.origin.y = targetFrame.origin.y + distance - targetFrame.size.height;
			break;
			
		default:
			break;
	}
	self.frame = viewFrame;
}

@end

@implementation UILabel (EX)

- (void)resetSizeFitText
{
	CGRect frame = self.frame;
	frame.size.width = [self.text sizeWithFont:self.font].width;
	self.frame = frame;
}


@end
