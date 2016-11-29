//
//  HRUDPSocketTool.m
//  herolife
//
//  Created by sswukang on 16/9/6.
//  Copyright © 2016年 huarui. All rights reserved.
//

#import "HRUDPSocketTool.h"
#import "WIFIListModel.h"

@interface HRUDPSocketTool ()<AsyncUdpSocketDelegate>

@property(nonatomic, strong) AsyncUdpSocket  *udpSocket;
@end


@implementation HRUDPSocketTool

+ (instancetype)shareHRUDPSocketTool
{
	return [[self alloc] init];
}
static id _instance;
+ (instancetype)allocWithZone:(struct _NSZone *)zone
{
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		_instance = [super allocWithZone:zone];
	});
	return _instance;
}

#pragma mark - haibo 建立UDP连接
- (void)connectWithUDPSocket
{
	//初始化udp
	self.udpSocket=[[AsyncUdpSocket alloc] initWithDelegate:self];
}

/// 发送UDPSocke数据
- (void)sendUDPSockeWithString:(NSString *)string
{
	//启动接收线程
	[self.udpSocket receiveWithTimeout:-1 tag:0];
	
	NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
	
	[self.udpSocket sendData:data
					  toHost:@SERVER_APIP
						port:SERVER_APPORT
				 withTimeout:-1
						 tag:0];
}
#pragma mark AsyncUdpSocketDelegate
-(void)onUdpSocket:(AsyncUdpSocket *)sock didSendDataWithTag:(long)tag{
	
	NSLog(@"Message send success!");
}

- (void)onUdpSocket:(AsyncUdpSocket *)sock didNotSendDataWithTag:(long)tag dueToError:(NSError *)error
{
	NSLog(@"Message not send for error: %@",error);
}

- (BOOL)onUdpSocket:(AsyncUdpSocket *)sock didReceiveData:(NSData *)data withTag:(long)tag fromHost:(NSString *)host port:(UInt16)port
{
	DDLogWarn(@"didReceiveData没截取  收到的数据%@", data);
	
	//启动监听下一条消息
	[self.udpSocket receiveWithTimeout:-1 tag:0];
	
	static NSUInteger lengthInteger = 0;
	
	NSString *strData = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
	//这里可以加入你想要的代码
 
	DDLogWarn(@"AsyncUdpSocket没截取  收到的数据%@", strData);
	//下次 就可能没有length的情况
	
	//截取  length字符串
	if ([strData containsString:@"length\r\n"]) {
		
		lengthInteger = [strData rangeOfString:@"{" options:NSCaseInsensitiveSearch].location ;
		
		
		NSString *lengthStr = [strData substringFromIndex:lengthInteger];
		
		NSUInteger nowLength = [lengthStr rangeOfString:@"}\r\n\0" options:NSCaseInsensitiveSearch].location;
		lengthStr = [lengthStr substringToIndex:nowLength + 1];
		
		/// 把截取好的字符串转换成UTF-8二进制数据
		NSData *jsonData = [lengthStr dataUsingEncoding:NSUTF8StringEncoding];
		/// 把二进制数据 转成JSON字典
		NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableLeaves error:nil];
		DDLogWarn(@"AsyncUdpSocket  收到截取之后的数据%@", jsonDict);
		//如果有错误信息
		if ([jsonDict[@"hrpush"][@"type"] isEqualToString:@"error"])
		{
			
		}
		
		
		//接收到返回的wifi数据
		if ([jsonDict[@"hrpush"][@"type"] isEqualToString:@"set"])
		{
            if ([jsonDict[@"msg"][@"set"] isEqualToString:@"1"]) {
                
                
                [kNotification postNotificationName:kNotificationReceiveSet1 object:nil];
                return YES;
            }
            
			if ([jsonDict[@"msg"][@"set"] isEqualToString:@"3"]) {
				
				WIFIListModel *wifiModel = [WIFIListModel mj_objectWithKeyValues:jsonDict[@"msg"]];
				AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
				app.wifiNameArray = wifiModel.ssidlist;
				app.authlistArray = wifiModel.authlist;
				app.rssilistArray = wifiModel.rssilist;
				
				[kNotification postNotificationName:kNotificationReceiveWiFiList object:nil];
                
                return YES;
			}
		}
		
		//接收到连接wifi返回的连接成功数据
		if ([jsonDict[@"hrpush"][@"type"] isEqualToString:@"set"])
		{
			if ([jsonDict[@"msg"][@"set"] isEqualToString:@"5"] || [jsonDict[@"msg"][@"set"] isEqualToString:@"6"]) {
				
				AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
				app.msgDictionary = jsonDict[@"msg"];
				
				[kNotification postNotificationName:kNotificationReceiveStratAddWiFiLink object:nil];
				
			}
		}
		
	}
	return YES;
}

- (void)onUdpSocket:(AsyncUdpSocket *)sock didNotReceiveDataWithTag:(long)tag dueToError:(NSError *)error
{
	NSLog(@"Message not received for error: %@", error);
}

- (void)onUdpSocketDidClose:(AsyncUdpSocket *)sock
{
	NSLog(@"socket closed!");
}


@end
