//
//  HRHTTPTool.h
//  herolife
//
//  Created by sswukang on 16/9/1.
//  Copyright © 2016年 huarui. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HRHTTPTool : NSObject
+ (void)hr_postHttpWithURL:(NSString *)url parameters:(NSMutableDictionary *)parameters responseDict:(void(^)(id array, NSError *error))responseDict;

+ (void)hr_getHttpWithURL:(NSString *)url parameters:(NSMutableDictionary *)parameters responseDict:(void(^)(id array, NSError *error))responseDict;
+ (void)hr_PutHttpWithURL:(NSString *)url parameters:(NSMutableDictionary *)parameters responseDict:(void(^)(id array, NSError *error))responseDict;
+ (void)hr_DeleteHttpWithURL:(NSString *)url parameters:(NSMutableDictionary *)parameters responseDict:(void(^)(id array, NSError *error))responseDict;
@end
