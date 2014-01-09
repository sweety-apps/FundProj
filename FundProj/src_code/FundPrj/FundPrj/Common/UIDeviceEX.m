//
//  UIDeviceEX.m
//  FundPrj
//
//  Created by leesea on 13-10-22.
//  Copyright (c) 2013年 leesea. All rights reserved.
//

#import "UIDeviceEX.h"
#include <sys/sysctl.h>  
#include <mach/mach.h>


@implementation UIDevice (EX)

- (double)availableMemory 
{
	vm_statistics_data_t vmStats;
	mach_msg_type_number_t infoCount = HOST_VM_INFO_COUNT;
	kern_return_t kernReturn = host_statistics(mach_host_self(), HOST_VM_INFO, (host_info_t)&vmStats, &infoCount);
	
	if(kernReturn != KERN_SUCCESS) {
		return 0.0;
	}
	
	return ((vm_page_size * vmStats.free_count) / 1024.0) / 1024.0;
}

- (BOOL)isRetinaScreen
{
    CGSize screenSize = [[UIScreen mainScreen] bounds].size;
    
    float scale = 1.0;
    if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)]) {
        scale = [[UIScreen mainScreen] scale];
    }
    
    if(screenSize.width * scale == 320*2){
        return YES;
    }
    
    return NO;
}

@end
