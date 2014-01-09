//
//  GradeView.m
//  FundPrj
//
//  Created by leesea on 13-10-22.
//  Copyright (c) 2013年 leesea. All rights reserved.
//

#import "GradeView.h"

@implementation GradeView

@synthesize grade;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
		grade = 0.0f;
		self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)setGrade:(float)grades
{
	grade = grades;
	[self setNeedsDisplay];
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
	CGRect frame = self.bounds;
	frame.size.width = self.bounds.size.width / 5.0f;
    // Drawing code
	for (float i = 0; i < 5; ++i) {
//		if (i <= grade && grade - i < 1)
//		{
//			UIImage * image = [UIImage imageNamed:@"img_half_star"];
//			[image drawInRect:frame];
//		}
//		else
        if (i < grade)
		{
			UIImage * image = [UIImage imageNamed:@"img_star"];
			[image drawInRect:frame];
		}
		else //if (i > grade)
		{
			UIImage * image = [UIImage imageNamed:@"img_unstar"];
			[image drawInRect:frame];
		}
		frame.origin.x += frame.size.width;
	}
}


@end
