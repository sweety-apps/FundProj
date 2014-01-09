//
//  Utility.h
//  FundPrj
//
//  Created by leesea on 13-10-22.
//  Copyright (c) 2013年 leesea. All rights reserved.
//

#import <Foundation/Foundation.h>

//版本字符串
#define CURRENT_VERSION  @"1.0"

//渠道字符串
#define CHANNEL_NAME @"AppStore";

//是否已经越狱的字符串
#define IS_JAILBREAK 0

@interface Utility : NSObject

+(NSString*)getFavoritePath;

+(NSString*)getFilePathInFavoriteWithExt:(NSString*)file_ext;

+(NSString*)getFilePathInFavoriteByFileName:(NSString*)fileName;

+(void)saveImage:(UIImage*)image toPath:(NSString*)path;

+(BOOL)deleteFile:(NSString*)file_path;

//计算获取图片居中的rect
+(CGRect)getCenterRect:(UIImage*)image maxWidth:(float)mWidth maxHeight:(float)mHeight containerWidth:(float)cWidth containerHeight:(float)cHeight;

+ (NSString *)convertTimeFromMinuteToHour:(NSString *)time;

@end
