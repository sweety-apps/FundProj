//
//  FPNonClearBgColorView.h
//  FundPrj
//
//  Created by leesea on 13-10-22.
//  Copyright (c) 2013年 leesea. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 * 此View主要用于UITableViewCell
 * 由于UITableViewCell在设置了selectionStyle并且select的时候，会将所有subView的backgroundColor设置为clearColor
 * 但有时候我们希望保留backgroundColor，则相应subView可以继承这个类，默认的setBackgroundColor会过滤alpha为0的color
 */
@interface FPNonClearBgColorView : UIView

@end
