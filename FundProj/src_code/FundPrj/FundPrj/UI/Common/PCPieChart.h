/**
 * Copyright (c) 2011 Muh Hon Cheng
 * Created by honcheng on 28/4/11.
 * 
 * Permission is hereby granted, free of charge, to any person obtaining 
 * a copy of this software and associated documentation files (the 
 * "Software"), to deal in the Software without restriction, including 
 * without limitation the rights to use, copy, modify, merge, publish, 
 * distribute, sublicense, and/or sell copies of the Software, and to 
 * permit persons to whom the Software is furnished to do so, subject 
 * to the following conditions:
 * 
 * The above copyright notice and this permission notice shall be 
 * included in all copies or substantial portions of the Software.
 * 
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT 
 * WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, 
 * INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF 
 * MERCHANTABILITY, FITNESS FOR A PARTICULAR 
 * PURPOSE AND NONINFRINGEMENT. IN NO EVENT 
 * SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE 
 * LIABLE FOR ANY CLAIM, DAMAGES OR OTHER 
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, 
 * TORT OR OTHERWISE, ARISING FROM, OUT OF OR 
 * IN CONNECTION WITH THE SOFTWARE OR 
 * THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 * 
 * @author 		Muh Hon Cheng <honcheng@gmail.com>
 * @copyright	2011	Muh Hon Cheng
 * @version
 * 
 */

#import <UIKit/UIKit.h>
#import "PCPieChart.h"

@interface PCPieComponent : NSObject
{
    float value, startDeg, endDeg;
    NSString *title;
    UIColor *colour;
    
}
@property (nonatomic, assign) float value, startDeg, endDeg;
@property (nonatomic, retain) UIColor *colour;
@property (nonatomic, retain) NSString *title;


- (id)initWithTitle:(NSString*)_title value:(float)_value;
+ (id)pieComponentWithTitle:(NSString*)_title value:(float)_value;
@end

#define ColorArray [NSArray 

#define PCColorArray [NSArray arrayWithObjects:\
[UIColor colorWithRed:0x2c/255.0 green:0x5c/255.0 blue:0x9a/255.0 alpha:1.0],\
[UIColor colorWithRed:0xd0/255.0 green:0x42/255.0 blue:0x3e/255.0 alpha:1.0],\
[UIColor colorWithRed:0x89/255.0 green:0xa7/255.0 blue:0x47/255.0 alpha:1.0],\
[UIColor colorWithRed:0x58/255.0 green:0x41/255.0 blue:0x77/255.0 alpha:1.0],\
[UIColor colorWithRed:0x38/255.0 green:0x97/255.0 blue:0xad/255.0 alpha:1.0],\
[UIColor colorWithRed:255/255.0 green:255/255.0 blue:0/255.0 alpha:1.0],\
[UIColor colorWithRed:0/255.0 green:154/255.0 blue:154/255.0 alpha:1.0],\
[UIColor colorWithRed:154/255.0 green:0/255.0 blue:154/255.0 alpha:1.0],\
[UIColor colorWithRed:154/255.0 green:154/255.0 blue:0/255.0 alpha:1.0],\
[UIColor colorWithRed:0/255.0 green:154/255.0 blue:255/255.0 alpha:1.0],\
[UIColor colorWithRed:154/255.0 green:0/255.0 blue:255/255.0 alpha:1.0],\
[UIColor colorWithRed:255/255.0 green:0/255.0 blue:154/255.0 alpha:1.0],\
[UIColor colorWithRed:0/255.0 green:255/255.0 blue:154/255.0 alpha:1.0],\
[UIColor colorWithRed:255/255.0 green:154/255.0 blue:0/255.0 alpha:1.0],\
[UIColor colorWithRed:154/255.0 green:255/255.0 blue:0/255.0 alpha:1.0],\
\
[UIColor colorWithRed:154/255.0 green:255/255.0 blue:0/255.0 alpha:1.0],\
[UIColor colorWithRed:154/255.0 green:255/255.0 blue:0/255.0 alpha:1.0],\
[UIColor colorWithRed:154/255.0 green:255/255.0 blue:0/255.0 alpha:1.0],\
[UIColor colorWithRed:154/255.0 green:255/255.0 blue:0/255.0 alpha:1.0],\
[UIColor colorWithRed:154/255.0 green:255/255.0 blue:0/255.0 alpha:1.0],\
[UIColor colorWithRed:154/255.0 green:255/255.0 blue:0/255.0 alpha:1.0],\
[UIColor colorWithRed:154/255.0 green:255/255.0 blue:0/255.0 alpha:1.0],\
[UIColor colorWithRed:154/255.0 green:255/255.0 blue:0/255.0 alpha:1.0],\
[UIColor colorWithRed:154/255.0 green:255/255.0 blue:0/255.0 alpha:1.0],\
[UIColor colorWithRed:154/255.0 green:255/255.0 blue:0/255.0 alpha:1.0],\
[UIColor colorWithRed:154/255.0 green:255/255.0 blue:0/255.0 alpha:1.0],\
[UIColor colorWithRed:154/255.0 green:255/255.0 blue:0/255.0 alpha:1.0],\
nil];

@interface PCPieChart : UIView {
    NSMutableArray *components;
    int diameter;
	UIFont *titleFont, *percentageFont;
	BOOL showArrow, sameColorLabel;
}
@property (nonatomic, assign) int diameter;
@property (nonatomic, retain) NSMutableArray *components;
@property (nonatomic, retain) UIFont *titleFont, *percentageFont;
@property (nonatomic, assign) BOOL showArrow, sameColorLabel;

@end
