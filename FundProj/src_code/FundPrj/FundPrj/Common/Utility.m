//
//  Utility.m
//  FundPrj
//
//  Created by leesea on 13-10-22.
//  Copyright (c) 2013年 leesea. All rights reserved.
//

#import "Utility.h"

#define FAVORITE_DIRECTORY @"Favorite"

@implementation Utility

+(NSString*)getCurrentTimeStr
{
	NSDate *date=[NSDate date];
	NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
	//[formatter setDateStyle:kCFDateFormatterNoStyle];
	[formatter setDateFormat:@"yyyy-MM-dd-HH-mm-ss"];
	NSString *time=[formatter stringFromDate:date];
	return time;
}

//返回收藏夹路径（存放收藏夹图片),若不存在，则创建
+(NSString*)getFavoritePath
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *favPath = [[paths objectAtIndex:0] stringByAppendingPathComponent:FAVORITE_DIRECTORY];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:favPath])
    {
        [[NSFileManager defaultManager] createDirectoryAtPath:favPath
                                  withIntermediateDirectories:YES
                                                   attributes:nil
                                                        error:NULL];
    }
    
    return favPath;
}

//根据当前时间和扩展名生成文件路径
+(NSString*)getFilePathInFavoriteWithExt:(NSString*)file_ext
{
    NSString *filePath = [NSString stringWithFormat:@"%@.%@",[Utility getCurrentTimeStr],file_ext];
    return [[Utility getFavoritePath] stringByAppendingPathComponent:filePath];
}

//返回Favorite目录下指定文件名的路径
+(NSString*)getFilePathInFavoriteByFileName:(NSString*)fileName
{
    return [[Utility getFavoritePath] stringByAppendingPathComponent:fileName];
}

//删除指定位置文件
+(BOOL)deleteFile:(NSString*)file_path
{
    if([[NSFileManager defaultManager] fileExistsAtPath:file_path])
	{
        return [[NSFileManager defaultManager] removeItemAtPath:file_path error:nil];
    }
    
    return FALSE;
}


+(BOOL)writeFile:(NSData*)data toPath:(NSString*)path
{
    return [data writeToFile:path atomically:YES];
}

+(void)saveImage:(UIImage*)image toPath:(NSString*)path
{
    NSData *imageData = UIImageJPEGRepresentation(image, 1.f);
    [imageData writeToFile:path atomically:YES];
}

//计算获取图片居中的rect
+(CGRect)getCenterRect:(UIImage*)image maxWidth:(float)mWidth maxHeight:(float)mHeight containerWidth:(float)cWidth containerHeight:(float)cHeight
{
	float height = 0.f;
	float width = 0.f;
	float x,y;
	
	if (image.size.height >0 && image.size.width>0) {
		
		if (image.size.height > image.size.width) {  //竖直图
			height = mHeight; //限定高度
			width = (image.size.width/image.size.height)*height;
		}
		else {  //水平图
			width = mWidth; //限定宽度
			height = (image.size.height/image.size.width)*width;
		}
	}
	
	x = (cWidth-width)/2;
	y = (cHeight-height)/2;
	
	CGRect ivImageRect = CGRectZero;
	ivImageRect.size.width = width;
	ivImageRect.size.height = height;
	ivImageRect.origin.x = x;
	ivImageRect.origin.y = y;
	
	return ivImageRect;
}

//把分钟字符串转换为小时分字符串，如果是0，则不显示。比如96:12 -> 1小时36分；120:00 -> 2小时
+ (NSString *)convertTimeFromMinuteToHour:(NSString *)time
{
    if ([time isEqualToString:@"0"] || time.length == 0)
        return @"";
    
    NSArray *array = [time componentsSeparatedByString:@":"];
    
    NSString *strMinute = @"";
    if (array)
    {
        if (array.count > 0)
        {
            strMinute = [array objectAtIndex:0];
        }
    }
    
    int minutes = [strMinute intValue];
    int iHour = 0;
    int iMinutes = 0;
    iHour = minutes / 60;
    iMinutes = minutes % 60;
    
    NSString *retVal = @"";
    if (minutes == 0)
    {
        // 不到1分钟的情况不显示。比如15秒，00:15
        retVal = @"";
    }
    else if (iHour == 0)
    {
        // 不到1小时显示分
        retVal = [NSString stringWithFormat:@"%d分钟", iMinutes];
    }
    else if (iMinutes == 0)
    {
        // 整小时
        retVal = [NSString stringWithFormat:@"%d小时", iHour];
    }
    else
    {
        // 小时+分
        retVal = [NSString stringWithFormat:@"%d小时%d分钟", iHour, iMinutes];
    }
    
    return retVal;
    
}

@end
