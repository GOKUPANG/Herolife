//
//  HRHTTPTool.m
//  herolife
//
//  Created by sswukang on 16/9/1.
//  Copyright © 2016年 huarui. All rights reserved.
//

#import "HRHTTPTool.h"

@implementation HRHTTPTool
+ (void)hr_postHttpWithURL:(NSString *)url parameters:(NSMutableDictionary *)parameters responseDict:(void(^)(id array, NSError *error))responseDict
{
	AFHTTPSessionManager *manager = [AFHTTPSessionManager hrManager];
	[manager POST:url parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
		
	} success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
		
		responseDict(responseObject,nil);
		
	} failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
		
		responseDict(nil,error);
	}];
	
}

+ (void)hr_getHttpWithURL:(NSString *)url parameters:(NSMutableDictionary *)parameters responseDict:(void(^)(id array, NSError *error))responseDict
{
	AFHTTPSessionManager *manager = [AFHTTPSessionManager hrManager];
	[manager GET:url parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
		
	} success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
		responseDict(responseObject,nil);
	} failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
		responseDict(nil,error);
	}];
}
+ (void)hr_PutHttpWithURL:(NSString *)url parameters:(NSMutableDictionary *)parameters responseDict:(void(^)(id array, NSError *error))responseDict
{
	AFHTTPSessionManager *manager = [AFHTTPSessionManager hrManager];
	[manager PUT:url parameters:parameters success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
		responseDict(responseObject,nil);
		
	} failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
		responseDict(nil,error);
		
	}];
}

+ (void)hr_DeleteHttpWithURL:(NSString *)url parameters:(NSMutableDictionary *)parameters responseDict:(void(^)(id array, NSError *error))responseDict
{
	AFHTTPSessionManager *manager = [AFHTTPSessionManager hrManager];
	[manager DELETE:url parameters:parameters success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
		responseDict(responseObject,nil);
		
	} failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
		responseDict(nil,error);
		
	}];
}
@end
