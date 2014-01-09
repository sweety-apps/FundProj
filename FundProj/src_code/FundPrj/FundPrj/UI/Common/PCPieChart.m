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

#import "PCPieChart.h"

@implementation PCPieComponent
@synthesize value, title, startDeg, endDeg;

- (id)initWithTitle:(NSString*)_title value:(float)_value
{
    self = [super init];
    if (self)
    {
        self.title = _title;
        self.value = _value;
        self.colour = [UIColor redColor];
    }
    return self;
}

+ (id)pieComponentWithTitle:(NSString*)_title value:(float)_value
{
    return [[[super alloc] initWithTitle:_title value:_value] autorelease];
}

- (NSString*)description
{
    NSMutableString *text = [NSMutableString string];
    [text appendFormat:@"title: %@\n", self.title];
    [text appendFormat:@"value: %f\n", self.value];
    return text;
}

- (void)dealloc
{
    [colour release];
    [title release];
    [super dealloc];
}

@end

@implementation PCPieChart
@synthesize  components;
@synthesize diameter;
@synthesize titleFont, percentageFont;
@synthesize showArrow, sameColorLabel;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setBackgroundColor:[UIColor clearColor]];
		
		self.titleFont = [UIFont systemFontOfSize:20];
		self.percentageFont = [UIFont systemFontOfSize:14];
		self.showArrow = YES;
		self.sameColorLabel = NO;
		
	}
    return self;
}

#define LABEL_TOP_MARGIN 15
#define ARROW_HEAD_LENGTH 6
#define ARROW_HEAD_WIDTH 4

- (void)drawRect:(CGRect)rect
{
    // Drawing code
    
    float margin = 0;
    if (self.diameter==0)
    {
        diameter = MIN(rect.size.width, rect.size.height) - 2*margin;
    }
    float x = (rect.size.width - diameter)/2;
    float y = 0;//(rect.size.height - diameter)/2;
    float gap = 1;
    float inner_radius = diameter/2;
    float origin_x = x + diameter/2;
    float origin_y = y + diameter/2;
    
    // label stuff
    float left_label_y = diameter+LABEL_TOP_MARGIN;
    
    
    if ([components count]>0)
    {
        
        float total = 0;
        for (PCPieComponent *component in components)
        {
            total += component.value;
        }
        
        CGContextRef ctx = UIGraphicsGetCurrentContext();
		UIGraphicsPushContext(ctx);
		CGContextSetRGBFillColor(ctx, 1.0f, 1.0f, 1.0f, 1.0f);  // white color
		CGContextSetShadow(ctx, CGSizeMake(0.0f, 0.0f), margin);
		CGContextFillEllipseInRect(ctx, CGRectMake(x, y, diameter, diameter));  // a white filled circle with a diameter of 100 pixels, centered in (60, 60)
		UIGraphicsPopContext();
		CGContextSetShadow(ctx, CGSizeMake(0.0f, 0.0f), 0);
		
		float nextStartDeg = 0;
		float endDeg = 0;
		NSMutableArray *tmpComponents = [NSMutableArray array];
		int last_insert = -1;
		for (int i=0; i<[components count]; i++)
		{
			PCPieComponent *component  = [components objectAtIndex:i];
			float perc = [component value]/total;
			endDeg = nextStartDeg+perc*360;
			
			CGContextSetFillColorWithColor(ctx, [component.colour CGColor]);
			CGContextMoveToPoint(ctx, origin_x, origin_y);
			CGContextAddArc(ctx, origin_x, origin_y, inner_radius, (nextStartDeg-90)*M_PI/180.0, (endDeg-90)*M_PI/180.0, 0);
			CGContextClosePath(ctx);
			CGContextFillPath(ctx);
			
			CGContextSetRGBStrokeColor(ctx, 1, 1, 1, 1);
			CGContextSetLineWidth(ctx, gap);
			CGContextMoveToPoint(ctx, origin_x, origin_y);
			CGContextAddArc(ctx, origin_x, origin_y, inner_radius, (nextStartDeg-90)*M_PI/180.0, (endDeg-90)*M_PI/180.0, 0);
			CGContextClosePath(ctx);
			CGContextStrokePath(ctx);
			
			[component setStartDeg:nextStartDeg];
			[component setEndDeg:endDeg];
			if (nextStartDeg<180)
			{
				[tmpComponents addObject:component];
			}
			else
			{
				if (last_insert==-1)
				{
					last_insert = i;
					[tmpComponents addObject:component];
				}
				else
				{
					[tmpComponents insertObject:component atIndex:last_insert];
				}
			}
			
			nextStartDeg = endDeg;
		}
        
		float max_text_width = rect.size.width;
		for (int i=0; i<[tmpComponents count]; i++)
		{
			PCPieComponent *component  = [tmpComponents objectAtIndex:i];
            
            // display percentage label
            if (self.sameColorLabel)
            {
                CGContextSetFillColorWithColor(ctx, [component.colour CGColor]);
            }
            else 
            {
                CGContextSetRGBFillColor(ctx, 0.1f, 0.1f, 0.1f, 1.0f);
            }
            //CGContextSetRGBStrokeColor(ctx, 1.0f, 1.0f, 1.0f, 1.0f);
            //CGContextSetRGBFillColor(ctx, 1.0f, 1.0f, 1.0f, 1.0f);
            CGContextSetShadow(ctx, CGSizeMake(0.0f, 0.0f), 3);
            
            //float text_x = x + 10;
            NSString *percentageText = [NSString stringWithFormat:@"%.1f%% :", component.value/total*100];
            CGSize optimumSize = [percentageText sizeWithFont:self.percentageFont constrainedToSize:CGSizeMake(max_text_width,14)];
            CGRect percFrame = CGRectMake(0, left_label_y,  optimumSize.width, optimumSize.height);
            [percentageText drawInRect:percFrame withFont:self.percentageFont lineBreakMode:UILineBreakModeWordWrap alignment:UITextAlignmentLeft];
            
            // display title on the left
            CGContextSetRGBFillColor(ctx, 0.4f, 0.4f, 0.4f, 1.0f);
            CGSize optimumSize1 = [component.title sizeWithFont:self.titleFont constrainedToSize:CGSizeMake(max_text_width,20)];
            CGRect titleFrame = CGRectMake(80, left_label_y, max_text_width - 80, 20);
            [component.title drawInRect:titleFrame withFont:self.titleFont lineBreakMode:UILineBreakModeWordWrap alignment:UITextAlignmentLeft];
            left_label_y += optimumSize1.height + 10;
		}
    }
	
	
}

- (void)dealloc
{
	[self.titleFont release];
	[self.percentageFont release];
    [self.components release];
    [super dealloc];
}


@end
