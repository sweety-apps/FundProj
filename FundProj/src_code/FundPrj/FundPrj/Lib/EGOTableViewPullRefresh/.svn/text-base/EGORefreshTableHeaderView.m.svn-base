//
//  EGORefreshTableHeaderView.m
//  Demo
//
//  Created by Devin Doty on 10/14/09October14.
//  Copyright 2009 enormego. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

#import "EGORefreshTableHeaderView.h"


#define TEXT_COLOR	 [UIColor colorWithRed:87.0/255.0 green:108.0/255.0 blue:137.0/255.0 alpha:1.0]
#define FLIP_ANIMATION_DURATION 0.18f


//@interface EGORefreshTableHeaderView (Private)
//- (void)setState:(EGOPullRefreshState)aState;
//@end

@implementation EGORefreshTableHeaderView

@synthesize delegate=_delegate;

//isHeader用来区分是下拉还是上拉
- (id)initWithFrame:(CGRect)frame isHeader:(BOOL)isHeader_ {
    if (self = [super initWithFrame:frame]) {
		isHeader = isHeader_;
        
		self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
		//self.backgroundColor = [UIColor colorWithRed:226.0/255.0 green:231.0/255.0 blue:237.0/255.0 alpha:1.0];
        self.backgroundColor = [UIColor clearColor];
        
        //刷新时间Label
        float _lastUpdateLabelOriginY = 0.f;
        if (isHeader) {
            _lastUpdateLabelOriginY = frame.size.height - 30.0f;
        }
        else{
            _lastUpdateLabelOriginY = 10.f;
        }
        
		UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, _lastUpdateLabelOriginY, self.frame.size.width, 20.0f)];
		label.autoresizingMask = UIViewAutoresizingFlexibleWidth;
		label.font = [UIFont systemFontOfSize:12.0f];
		//label.textColor = TEXT_COLOR;
        label.textColor = [UIColor colorWithHexValue:0x999999];
		label.shadowColor = [UIColor colorWithWhite:0.9f alpha:1.0f];
		label.shadowOffset = CGSizeMake(0.0f, 1.0f);
		label.backgroundColor = [UIColor clearColor];
		//label.textAlignment = UITextAlignmentCenter;
		[self addSubview:label];
		_lastUpdatedLabel=label;
        _lastUpdatedLabel.hidden = YES;
        
        //状态文字Label
        float _statusLabelOriginY = 0.f;
        if (isHeader) {
            _statusLabelOriginY = frame.size.height - 48.0f;
        }
        else{
            _statusLabelOriginY = 28.f;
        }
		
		label = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, _statusLabelOriginY, self.frame.size.width, 20.0f)];
		//label.autoresizingMask = UIViewAutoresizingFlexibleWidth;
		label.font = [UIFont boldSystemFontOfSize:20.0f];
		//label.textColor = TEXT_COLOR;
        label.textColor = [UIColor colorWithHexValue:0x999999];
		//label.shadowColor = [UIColor colorWithWhite:0.9f alpha:1.0f];
		label.shadowOffset = CGSizeMake(0.0f, 1.0f);
		label.backgroundColor = [UIColor clearColor];
		label.textAlignment = UITextAlignmentCenter;
		[self addSubview:label];
		_statusLabel=label;
        
        float arrowOriginY = 0.f;
        if (isHeader) {
            arrowOriginY = frame.size.height - 65.0f;
        }
        else{
            arrowOriginY = 10.f;
        }
        
		CALayer *layer = [CALayer layer];
		layer.frame = CGRectMake(25.0f+285.f, arrowOriginY, 30.0f, 55.0f);
		layer.contentsGravity = kCAGravityResizeAspect;
		layer.contents = (id)[UIImage imageNamed:@"ic_loading_down.png"].CGImage;
		
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 40000
		if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)]) {
			layer.contentsScale = [[UIScreen mainScreen] scale];
		}
#endif
		[[self layer] addSublayer:layer];
		_arrowImage=layer;
        
        float actIndOriginY = 0.f;
        if (isHeader) {
            actIndOriginY = frame.size.height - 48.0f;
        }
        else{
            actIndOriginY = 28.f;
        }
		UIActivityIndicatorView *view = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
		view.frame = CGRectMake(25.0f+285.f, actIndOriginY, 20.0f, 20.0f);
		[self addSubview:view];
		_activityView = view;
		
		[self setState:EGOOPullRefreshNormal];
        
    }
	
    return self;
	
}


#pragma mark -
#pragma mark Setters

- (void)refreshLastUpdatedDate {
	
	if ([_delegate respondsToSelector:@selector(egoRefreshTableHeaderDataSourceLastUpdated:)]) {
		
		NSDate *date = [_delegate egoRefreshTableHeaderDataSourceLastUpdated:self];
		
		NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
		[formatter setAMSymbol:@"AM"];
		[formatter setPMSymbol:@"PM"];
		[formatter setDateFormat:@"MM/dd/yyyy hh:mm:a"];
		_lastUpdatedLabel.text = [NSString stringWithFormat:@"Last Updated: %@", [formatter stringFromDate:date]];
		[[NSUserDefaults standardUserDefaults] setObject:_lastUpdatedLabel.text forKey:@"EGORefreshTableView_LastRefresh"];
		[[NSUserDefaults standardUserDefaults] synchronize];
		
	} else {
		
		_lastUpdatedLabel.text = nil;
		
	}
    
}

- (void)setState:(EGOPullRefreshState)aState{
	
	switch (aState) {
		case EGOOPullRefreshPulling:
			
			_statusLabel.text = NSLocalizedString(@"tableview_up_refresh_pulling", @"Release to refresh status");
			
            [CATransaction begin];
			[CATransaction setAnimationDuration:FLIP_ANIMATION_DURATION];
            if (isHeader) {
                _arrowImage.transform = CATransform3DMakeRotation((M_PI / 180.0) * 180.0f, 0.0f, 0.0f, 1.0f);
            }
            else{
                _arrowImage.transform = CATransform3DMakeRotation(M_PI*2, 0.0f, 0.0f, 1.0f);
            }
			[CATransaction commit];
			
			break;
		case EGOOPullRefreshNormal:
			
			if (_state == EGOOPullRefreshPulling) {
				[CATransaction begin];
				[CATransaction setAnimationDuration:FLIP_ANIMATION_DURATION];
				_arrowImage.transform = CATransform3DIdentity;
				[CATransaction commit];
			}
			
            if (isHeader) {
                _statusLabel.text = NSLocalizedString(@"tableview_down_refresh_normal", @"Pull down to refresh status");
            }
            else{
                _statusLabel.text = NSLocalizedString(@"tableview_up_refresh_normal", @"Pull up to refresh status");
            }
			
			[_activityView stopAnimating];
			[CATransaction begin];
			[CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions];
			_arrowImage.hidden = NO;
			_arrowImage.transform = CATransform3DIdentity;
			[CATransaction commit];
            
            if (!isHeader) {
                _arrowImage.transform = CATransform3DMakeRotation(M_PI, 0.0f, 0.0f, 1.0f);
            }
			
			[self refreshLastUpdatedDate];
			
			break;
		case EGOOPullRefreshLoading:
			
            if (isHeader) {
                _statusLabel.text = NSLocalizedString(@"tableview_down_refresh_loading", @"Loading Status");
            }
            else{
                _statusLabel.text = NSLocalizedString(@"tableview_up_refresh_loading", @"Pull up to refresh status");
            }
			
			[_activityView startAnimating];
			[CATransaction begin];
			[CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions];
			_arrowImage.hidden = YES;
			[CATransaction commit];
			
			break;
		default:
			break;
	}
	
	_state = aState;
}


#pragma mark -
#pragma mark ScrollView Methods

- (void)egoRefreshScrollViewDidScroll:(UIScrollView *)scrollView {
	//NSLog(@"%f,%f,%f",scrollView.contentOffset.y,scrollView.contentSize.height,scrollView.frame.size.height);
    
	if (_state == EGOOPullRefreshLoading) {
		
        if (isHeader) {
            CGFloat offset = MAX(scrollView.contentOffset.y * -1, 0);
            offset = MIN(offset, 60);
            scrollView.contentInset = UIEdgeInsetsMake(offset, 0.0f, 0.0f, 0.0f);
        }
        else{
            CGFloat offset = MAX(((self.frame.origin.y-scrollView.bounds.size.height) - scrollView.contentOffset.y) * -1, 0);
            offset = MIN(offset, 60+20);
            scrollView.contentInset = UIEdgeInsetsMake(0.0f, 0.0f, offset, 0.0f);
        }
		
		
	} else if (scrollView.isDragging) {
		
        if (isHeader) {
            
            BOOL _loading = NO;
            if ([_delegate respondsToSelector:@selector(egoRefreshTableHeaderDataSourceIsLoading:)]) {
                _loading = [_delegate egoRefreshTableHeaderDataSourceIsLoading:self];
            }
            
            if (_state == EGOOPullRefreshPulling && scrollView.contentOffset.y > -65.0f && scrollView.contentOffset.y < 0.0f && !_loading) {
                [self setState:EGOOPullRefreshNormal];
            } else if (_state == EGOOPullRefreshNormal && scrollView.contentOffset.y < -65.0f && !_loading) {
                [self setState:EGOOPullRefreshPulling];
            }
            
            if (scrollView.contentInset.top != 0) {
                scrollView.contentInset = UIEdgeInsetsZero;
            }
        }
        else{
            
            BOOL _loadingForFooter = NO;
            if ([_delegate respondsToSelector:@selector(egoRefreshTableFooterDataSourceIsLoading:)]) {
                _loadingForFooter = [_delegate egoRefreshTableFooterDataSourceIsLoading:self];
            }
            
            if (_state == EGOOPullRefreshPulling && scrollView.contentOffset.y + scrollView.frame.size.height < scrollView.contentSize.height + 65.0f+20.f && scrollView.contentOffset.y + scrollView.frame.size.height > scrollView.contentSize.height && !_loadingForFooter) {
                [self setState:EGOOPullRefreshNormal];
            } else if (_state == EGOOPullRefreshNormal && scrollView.contentOffset.y + scrollView.frame.size.height > scrollView.contentSize.height + 65.0f+20.f && !_loadingForFooter) {
                [self setState:EGOOPullRefreshPulling];
            }
            
            if (scrollView.contentInset.bottom != 0) {
                scrollView.contentInset = UIEdgeInsetsZero;
            }
        }
		
		
	}
	
}

- (void)egoRefreshScrollViewDidEndDragging:(UIScrollView *)scrollView {
	
	
    if (isHeader) {
        
        BOOL _loading = NO;
        if ([_delegate respondsToSelector:@selector(egoRefreshTableHeaderDataSourceIsLoading:)]) {
            _loading = [_delegate egoRefreshTableHeaderDataSourceIsLoading:self];
        }
        
        if (scrollView.contentOffset.y <= - 65.0f && !_loading) {
            
            if ([_delegate respondsToSelector:@selector(egoRefreshTableHeaderDidTriggerRefresh:)]) {
                [_delegate egoRefreshTableHeaderDidTriggerRefresh:self];
            }
            
            [self setState:EGOOPullRefreshLoading];
            [UIView beginAnimations:nil context:NULL];
            [UIView setAnimationDuration:0.2];
            scrollView.contentInset = UIEdgeInsetsMake(60.0f, 0.0f, 0.0f, 0.0f);
            [UIView commitAnimations];
            
        }
    }
    else{
        
        BOOL _loadingForFooter = NO;
        if ([_delegate respondsToSelector:@selector(egoRefreshTableFooterDataSourceIsLoading:)]) {
            _loadingForFooter = [_delegate egoRefreshTableFooterDataSourceIsLoading:self];
        }
        
        if (scrollView.contentOffset.y + scrollView.frame.size.height >= scrollView.contentSize.height + 65.0f+20.f && !_loadingForFooter) {
            
            if ([_delegate respondsToSelector:@selector(egoRefreshTableFooterDidTriggerRefresh:)]) {
                [_delegate egoRefreshTableFooterDidTriggerRefresh:self];
            }
            
            [self setState:EGOOPullRefreshLoading];
            [UIView beginAnimations:nil context:NULL];
            [UIView setAnimationDuration:0.2];
            scrollView.contentInset = UIEdgeInsetsMake(0.0f, 0.0f, 60.0f, 0.0f);
            [UIView commitAnimations];
            
        }
    }
}

- (void)egoRefreshScrollViewDataSourceDidFinishedLoading:(UIScrollView *)scrollView {
	
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:.3];
	[scrollView setContentInset:UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, 0.0f)];
	[UIView commitAnimations];
	
	[self setState:EGOOPullRefreshNormal];
    
}


#pragma mark -
#pragma mark Dealloc

- (void)dealloc {
	
	_delegate=nil;
	_activityView = nil;
	_statusLabel = nil;
	_arrowImage = nil;
	_lastUpdatedLabel = nil;
}


@end
