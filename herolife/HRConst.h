#import <UIKit/UIKit.h>

#ifndef Constant_h
#define Constant_h

UIKIT_EXTERN NSString *const EocstringConstant;

/** 导航栏高度 */
UIKIT_EXTERN CGFloat const HRNavH;


#define Defalt_BackPic @"1.jpg"



#define NOTIF_APP_WILL_ENTER_FORGROUND @"kNotifAppWillEnterForeground"
#define NOTIF_APP_DID_ENTER_BACKGROUND @"kNotifAppDidEnterBackground"

/* huarui API */
#define TOKEN_HEADER_NAME	@"X-CSRF-Token"

#define HRAPI_LOGIN			@"huaruiapi/user/login"
#define HRAPI_LOGOUT		@"huaruiapi/user/logout"
#define HRAPI_CSRF			@"huaruiapi/user/token"



/// 超时时间
#define HRTimeInterval 10.0

//http协议头
#define SERVER_DOMAIN	@"http://www.gzhuarui.cn/?q="
//#define SERVER_DOMAIN	@"http://183.63.118.58:9885/hrctest/?q="


//TCP IP和端口
#define SERVER_IP		"120.24.183.44"
//#define SERVER_IP		"183.63.118.58"
#define SERVER_PORT		9888

//UDP IP和端口
#define SERVER_APIP		"192.168.5.1"
#define SERVER_APPORT		1200



#define HRAPI_LOGIN_URL		[NSString stringWithFormat:@"%@%@", SERVER_DOMAIN, HRAPI_LOGIN]
#define HRAPI_CSRF_URL		[NSString stringWithFormat:@"%@%@", SERVER_DOMAIN, HRAPI_CSRF]
#define HRAPI_LOGOUT_URL		[NSString stringWithFormat:@"%@%@", SERVER_DOMAIN, HRAPI_LOGOUT]

/** 获取门锁密码编号请求网址*/
#define HRAPI_GetDoorPsw_URL [NSString stringWithFormat:@"%@%@", SERVER_DOMAIN, @"huaruiapi/herolife-dev-hrsc-ul&uuid=%@&user=%@"]
#define HRAPI_DeleteDoorPsw_URL [NSString stringWithFormat:@"%@%@", SERVER_DOMAIN, @"huaruiapi/node/%@"]
#define HRAPI_AddDoorPsw_URL [NSString stringWithFormat:@"%@%@", SERVER_DOMAIN, @"huaruiapi/node"]
#define HRAPI_UpdateDoorNum_URL [NSString stringWithFormat:@"%@%@", SERVER_DOMAIN, @"huaruiapi/node/%@"]
#define HRAPI_UpdateDoorMess_URL [NSString stringWithFormat:@"%@%@", SERVER_DOMAIN, @"huaruiapi/node/%@"]


/// 删除门锁HTTP请求
#define HRAPI_UpdateDoorPsw_URL [NSString stringWithFormat:@"%@%@", SERVER_DOMAIN, @"huaruiapi/node/"]
/// 修改门锁HTTP请求
#define HRAPI_ModifyLock_URL		[NSString stringWithFormat:@"%@%@", SERVER_DOMAIN, @"huaruiapi/node/"]

/// 门锁记录HTTP请求
#define HRAPI_RecordeLock_URL		[NSString stringWithFormat:@"%@%@", SERVER_DOMAIN, @"huaruiapi/herolife-dev-hrsc-ml&uuid="]
/// 校验用户名是否在服务器中存在
#define HRAPI_Checkuser_URL		[NSString stringWithFormat:@"%@%@", SERVER_DOMAIN, @"huaruiapi/checkuser&user="]
//#define HRAPI_Checkuser_URL		 @"http://www.gzhuarui.cn/?q=huaruiapi/checkuser&user="
//#define HRAPI_Checkuser_URL		 @"http://183.63.118.58:9885/hrctest/?q=huaruiapi/checkuser&user="

/// 获取锁信息数据的GET请求URL
#define HRAPI_LockInFo_URL		[NSString stringWithFormat:@"%@%@", SERVER_DOMAIN, @"huaruiapi/herolife-dev"]

/// 获取门锁记录选中状态数据的GET请求URL
#define HRAPI_RecoderSelectState_URL		[NSString stringWithFormat:@"%@%@", SERVER_DOMAIN, @"node/"]

/// 我授权给别人的数据
#define HRAPI_LockAutherUserList_URL		[NSString stringWithFormat:@"%@%@", SERVER_DOMAIN, @"huaruiapi/herolife-dev-hrsc-al&user="]
/// 别人授权给我的数据
#define HRAPI_LockAutherPersonList_URL		[NSString stringWithFormat:@"%@%@", SERVER_DOMAIN, @"huaruiapi/herolife-dev-hrsc-al&person="]

/// 获得授权设备信息 HTTP
#define HRAPI_LockAutherInformation_URL		[NSString stringWithFormat:@"%@%@", SERVER_DOMAIN, @"huaruiapi/herolife-dev&uuid="]

/// 忘记密码POST请求URL
#define HRAPI_ForgetPasswd_URL		[NSString stringWithFormat:@"%@%@", SERVER_DOMAIN, @"huaruiapi/user/request_new_password"]

/// 添加门锁POST请求URL
#define HRAPI_QueryLock_URL		[NSString stringWithFormat:@"%@%@", SERVER_DOMAIN, @"huaruiapi/herolife-dev"]

/// 添加门锁POST请求URL
#define HRAPI_AddLock_URL		[NSString stringWithFormat:@"%@%@", SERVER_DOMAIN, @"huaruiapi/node"]

/******************************* HTTP URL key ************************/
///用户注册POST请求URL

#define HRHTTP_UserRegister_URL		[NSString stringWithFormat:@"%@%@", SERVER_DOMAIN, @"huaruiapi/user"]

/// 修改门锁名称PUT请求URL
#define HRAPI_ModifyLock_URL		[NSString stringWithFormat:@"%@%@", SERVER_DOMAIN, @"huaruiapi/node/"]



/// 获取小睿信息数据的GET请求URL
#define HRAPI_XiaoRuiInFo_URL [NSString stringWithFormat:@"%@%@", SERVER_DOMAIN, @"huaruiapi/xiaorui-info"]

/// 获取温湿度数据的GET请求URL
#define HRAPI_TempHumid_URL [NSString stringWithFormat:@"%@%@", SERVER_DOMAIN, @"huaruiapi/xiaorui-humiture"]

/// 创建小睿GET请求URL
#define HRAPI_XiaoRuiNode_URL [NSString stringWithFormat:@"%@%@", SERVER_DOMAIN, @"huaruiapi/node"]
/// 获取小睿PM2.5值数据的GET请求URL
#define HRAPI_XiaoRuiPm2_5_URL [NSString stringWithFormat:@"%@%@", SERVER_DOMAIN, @"huaruiapi/xiaorui-pm2_5"]
/// 获取小睿VOC值数据的GET请求URL
#define HRAPI_XiaoRuiVOC_URL [NSString stringWithFormat:@"%@%@", SERVER_DOMAIN, @"huaruiapi/xiaorui-voc"]
/// 注册小睿POST请求URL
#define HRAPI_XiaoRuiRegister_URL [NSString stringWithFormat:@"%@%@", SERVER_DOMAIN, @"huaruiapi/user"]
/// 修改密码PUT请求URL
//#define HRAPI_XiaoRuiModifyPassword_URL @"http://www.gzhuarui.cn/?q=huaruiapi/user/"


//斌修改 正式发布时要把接口换回去
#define HRAPI_XiaoRuiModifyPassword_URL		[NSString stringWithFormat:@"%@%@", SERVER_DOMAIN, @"huaruiapi/user/"]

/// 获取小睿红外空调信息GET请求URL
#define HRAPI_XiaoRuiIRAC_URL [NSString stringWithFormat:@"%@%@", SERVER_DOMAIN, @"huaruiapi/xiaorui-irac"]
/// 获取小睿通用设备信息GET请求URL
#define HRAPI_XiaoRuiIRGM_URL [NSString stringWithFormat:@"%@%@", SERVER_DOMAIN, @"huaruiapi/xiaorui-irgm"]
/// 获取小睿开关设备信息GET请求URL
#define HRAPI_XiaoRuiIHRDO_URL [NSString stringWithFormat:@"%@%@", SERVER_DOMAIN, @"huaruiapi/xiaorui-hrdo"]
/// 获取小睿情景设备信息GET请求URL
#define HRAPI_XiaoRuiIHRScene_URL [NSString stringWithFormat:@"%@%@", SERVER_DOMAIN, @"huaruiapi/xiaorui-scene"]





/* Error domains and codes*/
#define HRERR_DOMAIN		@"com.huarui"
#define HRERR_HTTP			@".http"
#define HRERR_LOGIN			@".login"

#define HRERR_DOMAIN_LOGIN	[NSString stringWithFormat:@"%@%@%@", HRERR_DOMAIN, HRERR_HTTP, HRERR_LOGIN]



#pragma mark - User Preferences
///用户是否已经登陆登陆
#define USRPREF_IS_USER_LOGINED		@"isUserLogined"
///当前登陆的用户名
#define USRPREF_CURR_LOGINED_USER	@"currentLoginedUser"



/* MISC */
///导航栏高度
#define NAV_BAR_HEIGHT		64
///3.5寸屏幕
#define IS_3_5_INCH_SCREEN	(([UIScreen mainScreen].bounds.size.height == 480) && ([UIScreen mainScreen].bounds.size.width == 320))
///空调最高温度
#define AIRCTRL_TEMP_MAX		30
///空调最低温度
#define AIRCTRL_TEMP_MIN		16

#endif /* Constant_h */


/*** Error Code说明：
 -------
 Domain = com.alamofire.error.serialization.response
 Code   = -1011
 Description： "Request failed: unauthorized (401)"
 --------
 
 **/

#pragma mark - notifications

#define NOTIF_USER_DID_LOGINED		@"notif_user_did_login"
#define NOTIF_USER_DID_LOGOUTED		@"notif_user_did_logouted"
