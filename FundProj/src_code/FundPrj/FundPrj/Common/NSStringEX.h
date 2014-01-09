
//
//  NSStringEX.h
//  FundPrj
//
//  Created by leesea on 13-10-22.
//  Copyright (c) 2013年 leesea. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NSString (path)

+ (NSString *)HomePath;
+ (NSString *)TempPath;
+ (NSString *)DocPath;
+ (NSString *)LibPath;
+ (NSString *)AppPath;
+ (BOOL)RemovePath:(NSString *)path;

//将格式为2011-03-33 12:33:32 转化为 2011-03-22
- (NSString *)FPDateString;

//当前时间标准格式2012-03-33 12:33:32 
+ (NSString *)normalDateString;


- (UIColor *)toUIColor;

+ (NSString *) spacesForFont:(UIFont *)f Width:(CGFloat)width;

- (NSString *)md5Value;

- (NSString *)trim;

// 去掉字符串中的html特殊字符，类似	&#39;
-(NSString*)decodeHtmlUnicodeCharacters;

@end

@interface UIColor (HexValue)

+ (id)colorWithHexValue:(NSUInteger)hexValue alpha:(NSUInteger)alpha;
+ (UIColor *)colorWithHexValue:(NSUInteger)hexValue;

@end

@interface NSString (splitString)

+ (NSArray *) splitString:(NSString *)string forWidth:(NSInteger)width useFont:(UIFont *)font;


@end

@interface NSString (html)

-(NSString*)replaceHtmlSymbol;

@end

@interface NSString (encrypto)
- (NSString *) md5;
- (NSString *) sha1;
- (NSString *) sha2;

@end

@interface NSString (URL)
- (NSString *)URLEncodedString;
@end


