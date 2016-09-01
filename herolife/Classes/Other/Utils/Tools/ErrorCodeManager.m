//
//  ErrorCodeManager.m
//  xiaorui
//
//  Created by sswukang on 16/5/30.
//  Copyright © 2016年 huarui. All rights reserved.
//

#import "ErrorCodeManager.h"
#import <SVProgressHUD.h>
@implementation ErrorCodeManager

static NSTimeInterval const dimissTimer = 2;
+ (void)showError:(NSError *)error
{
	if (error == nil) {
		return;
	}
	NSDictionary *dict = error.userInfo;
	NSString  *str = [dict valueForKeyPath:@"body"];
	NSString * code = [dict valueForKeyPath:@"statusCode"];
	
	if (str) {
		
		str = [str replaceUnicode:str];
		str = [str substringFromIndex:2];
		NSRange range = [str rangeOfString:@"\"]" options:NSBackwardsSearch];
		str = [str substringToIndex:range.location];
		NSString *description = [NSString stringWithFormat:@"%@  %@", code,str];

		[SVProgressTool hr_showErrorWithStatus:description];

		
	}else
	{
		[SVProgressTool hr_showErrorWithStatus:@"未连接到服务器!"];
	}
	
	code = [NSString stringWithFormat:@"%@", code];
	
	if ([code isEqualToString:@"403"] || [code isEqualToString:@"406"]) {
		
//		[PushToLoginController pushToLoginController];
	}
}

+ (void)showPostError:(NSError *)error
{
	if (error == nil) {
		return;
	}
	
	NSDictionary *dict = error.userInfo;
	NSString * code = [dict valueForKeyPath:@"statusCode"];
	NSString *str = [dict valueForKeyPath:@"body"];
	if (str) {
		DDLogInfo(@"str|%@|", str);
		NSScanner *theScanner;
		NSString *text = nil;
		theScanner = [NSScanner scannerWithString:str];
		
		while ([theScanner isAtEnd] == NO) {
			// find start of tag
			[theScanner scanUpToString:@"<" intoString:NULL] ;
			// find end of tag
			[theScanner scanUpToString:@">" intoString:&text] ;
			
			str = [str stringByReplacingOccurrencesOfString:
				   [NSString stringWithFormat:@"%@>", text]
												 withString:@""];
		}
		DDLogInfo(@"str2|%@|", str);
		
		str = [str replaceUnicode:str];
		if ([str containsString:@"[\""]) {
			
			NSRange range1 = [str rangeOfString:@"[\""];
			str = [str substringFromIndex:range1.location + 2];
			NSRange range2 = [str rangeOfString:@"\"]"];
			str = [str substringToIndex:range2.location - 1];
			NSString *description = [NSString stringWithFormat:@"%@  %@", code,str];
			DDLogInfo(@"description|%@|", description);
			[SVProgressTool hr_showErrorWithStatus:description];
			
			return;
		}
		NSRange range1 = [str rangeOfString:@":{"];
		str = [str substringFromIndex:range1.location + 2];
		NSRange range2 = [str rangeOfString:@"}"];
		str = [str substringToIndex:range2.location - 1];
		NSString *description = [NSString stringWithFormat:@"%@  %@", code,str];
		DDLogInfo(@"description|%@|", description);
		[SVProgressTool hr_showErrorWithStatus:description];

	}else
	{
		[SVProgressTool hr_showErrorWithStatus:@"请求超时!"];
		
	}
	
	code = [NSString stringWithFormat:@"%@", code];
	
	if ([code isEqualToString:@"403"] || [code isEqualToString:@"406"]) {
		
//		[PushToLoginController pushToLoginController];
	}
	
}

@end
