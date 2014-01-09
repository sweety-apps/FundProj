//
//  CMTabBar.m
//
//  Created by Constantine Mureev on 13.03.12.
//  Copyright (c) 2012 Team Force LLC. All rights reserved.
//

#import "CMTabBar.h"
#import "UIControl+Blocks.h"
#import "QuartzCore/CALayer.h"


@interface CMTabBar()

@property (nonatomic, retain) NSArray*      buttons;
@property (nonatomic, retain) UIImageView*  backgroundImageView;
@property (nonatomic, retain) UIImageView*  selectedImageView;

- (UIImage*)defaultBackgroundImage;

@end


@implementation CMTabBar

@synthesize delegate, selectedIndex=_selectedIndex;
@synthesize buttons, backgroundImageView, selectedImageView;


- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        UIImage *syncBgImg = [UIImage imageNamed:@"home01_43"];
        self.backgroundColor = [[UIColor alloc] initWithPatternImage:syncBgImg];
        
        UIImageView * logo = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"logo"]];
        logo.frame = CGRectMake(28, (59-41)/2, 227, 41);
        [self addSubview:logo];
        
//        UIColor *color = [[UIColor alloc] initWithPatternImage:syncBgImg];
//        self.backgroundImageView = [[UIImageView alloc] init];
//        [self.backgroundImageView setBackgroundColor:color];
//        self.backgroundImageView.contentMode = UIViewContentModeBottom;
//        self.backgroundImageView.center = CGPointMake(self.center.x, self.frame.size.height - self.backgroundImageView.frame.size.height / 2);
////        self.backgroundImageView.backgroundColor = [UIColor clearColor];
//        self.backgroundImageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
//        [self addSubview:self.backgroundImageView];
        
//        self.selectedImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, frame.size.height, frame.size.height)];
//        self.selectedImageView.image = [self defaultSelectionIndicatorImage];
//        self.selectedImageView.contentMode = UIViewContentModeBottom;
//        self.selectedImageView.backgroundColor = [UIColor clearColor];
//        self.selectedImageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
//        [self addSubview:self.selectedImageView];
        
    }
    return self;
}

- (void)dealloc {
}

- (void)setSelectedIndex:(NSUInteger)selectedIndex {
    if (_selectedIndex != selectedIndex && selectedIndex < [self.buttons count]) {
        [self willChangeValueForKey:@"selectedIndex"];
        if (self.delegate && [self.delegate respondsToSelector:@selector(tabBar:willSelectItemAtIndex:currentIndex:)]) {
            [self.delegate tabBar:self willSelectItemAtIndex:selectedIndex currentIndex:_selectedIndex];
        }
        
        // check only for first selection
        if (_selectedIndex < [self.buttons count]) {
            UIButton* oldButton = [self.buttons objectAtIndex:_selectedIndex];
            [oldButton setImage:[oldButton imageForState:UIControlStateDisabled] forState:UIControlStateNormal];
            [oldButton setTitleColor:[UIColor colorWithHexValue:0xacacac] forState:UIControlStateNormal];
            oldButton.backgroundColor = [UIColor clearColor];
            [oldButton setBackgroundImage:nil forState:UIControlStateNormal];
        }
        
        UIButton* newButton = [self.buttons objectAtIndex:selectedIndex];
        [newButton setImage:[newButton imageForState:UIControlStateSelected] forState:UIControlStateNormal];
		[newButton setTitleColor:[UIColor colorWithHexValue:0x2780fc] forState:UIControlStateNormal];
        newButton.backgroundColor = [UIColor clearColor];
        
        [newButton setBackgroundImage:[UIImage imageNamed:@"menu-gr"] forState:UIControlStateNormal];
        
        self.selectedImageView.center = newButton.center;
        
        NSUInteger prviousIndex = _selectedIndex;
        _selectedIndex = selectedIndex;
        
        [self didChangeValueForKey:@"selectedIndex"];        
        if (self.delegate && [self.delegate respondsToSelector:@selector(tabBar:didSelectItemAtIndex:prviousIndex:)]) {
            [self.delegate tabBar:self didSelectItemAtIndex:_selectedIndex prviousIndex:prviousIndex];
        }
    }
}


#pragma mark - Public
//#import "QuartzCore/CALayer.h"
//这行import代码会导致工程编译不能通过，移到文件的开始处即可，代为修改
- (void)setItems:(NSArray*)imgNormals imgSelecteds:(NSArray*)imgSelecteds titles:(NSArray*)titles animated:(BOOL)animated
{
    // Add KVO for each UITabBarItem
    
    for (UIButton* button in self.buttons) {
        [button removeActionCompletionBlocksForControlEvents:UIControlEventTouchUpInside];
        [button removeFromSuperview];
    }
    
    NSMutableArray* newButtons = [NSMutableArray array];
    
    NSUInteger offset = 274;
    
    CGSize buttonSize = CGSizeMake((1024 - offset) / [imgNormals count], self.frame.size.height);
    
    for (int i=0; i < [imgNormals count]; i++) {
        UIButton* button = [[UIButton alloc] initWithFrame:CGRectMake(i * buttonSize.width + offset, 0, buttonSize.width, buttonSize.height)];
//        button.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
        CGPoint point = button.center;
        CGRect frame = button.frame;
//        frame.size = CGSizeMake(68, 45);
        button.frame = frame;
        button.center = point;
        button.backgroundColor = [UIColor clearColor];
        
        UIView * line = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 1, frame.size.height)];
        line.backgroundColor = [UIColor colorWithHexValue:0x0b0c10];
        [button addSubview:line];
        
        if (i == 0) {
            
            [button setBackgroundImage:[UIImage imageNamed:@"menu-gr"] forState:UIControlStateNormal];
        }
        
//		UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, buttonSize.width, buttonSize.height)];
//		view.backgroundColor = [UIColor clearColor];
//		UIImageView * img = [[UIImageView alloc]initWithImage:[UIImage imageNamed:[imgNormals objectAtIndex:i]]];
//		CGRect frameImg = img.frame;
//		frameImg.origin.x = (buttonSize.width - frameImg.size.width) / 2;
//		frameImg.origin.y = 4;
//		img.frame = frameImg;
//		[view addSubview:img];
//		CGRect frameLabel = frameImg;
//		frameLabel.origin.x = 0;
//		frameLabel.origin.y = frameLabel.origin.y + frameLabel.size.height + 4;
//		frameLabel.size.width = buttonSize.width;
//		frameLabel.size.height = 14;
//		UILabel * label = [[UILabel alloc] initWithFrame:frameLabel];
//		label.text = [titles objectAtIndex:i];
//		label.textColor = [UIColor colorWithHexValue:0xacacac];
//		label.backgroundColor = [UIColor clearColor];
//		label.textAlignment = UITextAlignmentCenter;
//		[view addSubview:label];
//		
//		UIImage *nomalImage;
//		UIGraphicsBeginImageContext(view.frame.size); 
//		[view.layer renderInContext:UIGraphicsGetCurrentContext()]; 
//		nomalImage = UIGraphicsGetImageFromCurrentImageContext(); 
//		UIGraphicsEndImageContext(); 
//		
//		view.backgroundColor = [UIColor blackColor];
//		[img removeFromSuperview];
//		img = [[UIImageView alloc]initWithImage:[UIImage imageNamed:[imgSelecteds objectAtIndex:i]]];
//		img.frame = frameImg;
//		[view addSubview:img];
//		label.textColor = [UIColor colorWithHexValue:0x2780fc];
//		
//		UIImage *selectedImage;
//		UIGraphicsBeginImageContext(view.frame.size); 
//		[view.layer renderInContext:UIGraphicsGetCurrentContext()]; 
//		selectedImage = UIGraphicsGetImageFromCurrentImageContext(); 
//		UIGraphicsEndImageContext(); 
//        
//        [button setImage:nomalImage forState:UIControlStateNormal];
//        [button setImage:nomalImage forState:UIControlStateDisabled];
//        [button setImage:selectedImage forState:UIControlStateHighlighted];
//        [button setImage:selectedImage forState:UIControlStateSelected];
		//        [self addSubview:button];
		
		[button setImage:[UIImage imageNamed:[imgNormals objectAtIndex:i]] forState:UIControlStateNormal]; 
        [button setImage:[UIImage imageNamed:[imgNormals objectAtIndex:i]] forState:UIControlStateDisabled];
		[button setImage:[UIImage imageNamed:[imgSelecteds objectAtIndex:i]] forState:UIControlStateHighlighted];  
        [button setImage:[UIImage imageNamed:[imgSelecteds objectAtIndex:i]] forState:UIControlStateSelected];
//		[button setTitle:[titles objectAtIndex:i] forState:UIControlStateNormal];
//		[button setTitle:[titles objectAtIndex:i] forState:UIControlStateDisabled];
//		[button setTitle:[titles objectAtIndex:i] forState:UIControlStateHighlighted];
//		[button setTitle:[titles objectAtIndex:i] forState:UIControlStateSelected];
//		[button setTitleColor:[UIColor colorWithHexValue:0xacacac] forState:UIControlStateNormal];
//		[button setTitleColor:[UIColor colorWithHexValue:0xacacac] forState:UIControlStateDisabled];
//		[button setTitleColor:[UIColor colorWithHexValue:0x2780fc] forState:UIControlStateHighlighted];
//		[button setTitleColor:[UIColor colorWithHexValue:0x2780fc] forState:UIControlStateSelected];
//		UILabel * label = [button titleLabel];
//		[label setFont:[UIFont systemFontOfSize:14]]; 
//		[button setImageEdgeInsets:UIEdgeInsetsMake(-15, 0.0, 0.0, -button.titleLabel.bounds.size.width)];
//		if (i == imgNormals.count-1) {
//			[button setTitleEdgeInsets:UIEdgeInsetsMake(30, -14-[UIImage imageNamed:[imgNormals objectAtIndex:i]].size.width, 0.0, 0.0)];
//		}
//		else {
//			[button setTitleEdgeInsets:UIEdgeInsetsMake(30, -[UIImage imageNamed:[imgNormals objectAtIndex:i]].size.width, 0.0, 0.0)];
//		}
        [self addSubview:button];
        
        [button addActionCompletionBlock:^(id sender) {
            self.selectedIndex = i;
        } forControlEvents:UIControlEventTouchUpInside];
        
        if (i == self.selectedIndex) {
            [button setImage:[button imageForState:UIControlStateSelected] forState:UIControlStateNormal];
            [button setTitleColor:[UIColor colorWithHexValue:0x2780fc] forState:UIControlStateNormal];
            self.selectedImageView.center = button.center;
        }
        
        [newButtons addObject:button];
    }
    
    self.buttons = newButtons;
}


@end
