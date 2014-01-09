//
//  CMTabBar.h
//
//  Created by Constantine Mureev on 13.03.12.
//  Copyright (c) 2012 Team Force LLC. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol CMTabBarDelegate <NSObject>

- (void)tabBar:(id)tabBar willSelectItemAtIndex:(NSUInteger)index currentIndex:(NSUInteger)currentIndex;
- (void)tabBar:(id)tabBar didSelectItemAtIndex:(NSUInteger)index prviousIndex:(NSUInteger)prviousIndex;

@end


@interface CMTabBar : UIView

@property (nonatomic, assign) id<CMTabBarDelegate>  delegate;
@property (nonatomic, assign) NSUInteger            selectedIndex;

- (void)setItems:(NSArray*)imgNormals imgSelecteds:(NSArray*)imgSelecteds titles:(NSArray*)titles animated:(BOOL)animated;


@end
