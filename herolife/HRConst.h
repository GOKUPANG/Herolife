#import <UIKit/UIKit.h>

#ifndef Constant_h
#define Constant_h

/** 导航栏高度 */
UIKIT_EXTERN CGFloat const HRNavH;



#define NOTIF_APP_WILL_ENTER_FORGROUND @"kNotifAppWillEnterForeground"
#define NOTIF_APP_DID_ENTER_BACKGROUND @"kNotifAppDidEnterBackground"

/* huarui API */
#define TOKEN_HEADER_NAME	@"X-CSRF-Token"

#define HRAPI_HTTP_PREFIX	@"http://www.gzhuarui.cn/?q="
#define HRAPI_LOGIN			@"huaruiapi/user/login"
#define HRAPI_LOGOUT		@"huaruiapi/user/logout"
#define HRAPI_CSRF			@"huaruiapi/user/token"

#define HRAPI_LOGIN_URL		[NSString stringWithFormat:@"%@%@", HRAPI_HTTP_PREFIX, HRAPI_LOGIN]
#define HRAPI_CSRF_URL		[NSString stringWithFormat:@"%@%@", HRAPI_HTTP_PREFIX, HRAPI_CSRF]
#define HRAPI_LOGOUT_URL		[NSString stringWithFormat:@"%@%@", HRAPI_HTTP_PREFIX, HRAPI_LOGOUT]
/// 获取温湿度数据的GET请求URL
#define HRAPI_TempHumid_URL @"http://www.gzhuarui.cn/?q=huaruiapi/xiaorui-humiture"

/// 获取锁信息数据的GET请求URL
#define HRAPI_LockInFo_URL @"http://www.gzhuarui.cn/?q=huaruiapi/herolife-dev"
/// 我授权给别人的数据
#define HRAPI_LockAutherUserList_URL @"http://www.gzhuarui.cn/?q=huaruiapi/herolife-dev-hrsc-al&user="
/// 别人授权给我的数据
#define HRAPI_LockAutherPersonList_URL @"http://www.gzhuarui.cn/?q=huaruiapi/herolife-dev-hrsc-al&person="

/// 获得授权设备信息 HTTP
#define HRAPI_LockAutherInformation_URL @"http://www.gzhuarui.cn/?q=huaruiapi/herolife-dev&uuid="

/// 创建小睿GET请求URL
#define HRAPI_XiaoRuiNode_URL @"http://www.gzhuarui.cn/?q=huaruiapi/node"
/// 获取小睿PM2.5值数据的GET请求URL
#define HRAPI_XiaoRuiPm2_5_URL @"http://www.gzhuarui.cn/?q=huaruiapi/xiaorui-pm2_5"
/// 获取小睿VOC值数据的GET请求URL
#define HRAPI_XiaoRuiVOC_URL @"http://www.gzhuarui.cn/?q=huaruiapi/xiaorui-voc"
/// 注册小睿POST请求URL
#define HRAPI_XiaoRuiRegister_URL @"http://www.gzhuarui.cn/?q=huaruiapi/user"
/// 修改密码PUT请求URL
#define HRAPI_XiaoRuiModifyPassword_URL @"http://www.gzhuarui.cn/?q=huaruiapi/user/"

/// 获取小睿红外空调信息GET请求URL
#define HRAPI_XiaoRuiIRAC_URL @"http://www.gzhuarui.cn/?q=huaruiapi/xiaorui-irac"
/// 获取小睿通用设备信息GET请求URL
#define HRAPI_XiaoRuiIRGM_URL @"http://www.gzhuarui.cn/?q=huaruiapi/xiaorui-irgm"
/// 获取小睿开关设备信息GET请求URL
#define HRAPI_XiaoRuiIHRDO_URL @"http://www.gzhuarui.cn/?q=huaruiapi/xiaorui-hrdo"
/// 获取小睿情景设备信息GET请求URL
#define HRAPI_XiaoRuiIHRScene_URL @"http://www.gzhuarui.cn/?q=huaruiapi/xiaorui-scene"


/// 忘记密码POST请求URL
#define HRAPI_ForgetPasswd_URL @"http://www.gzhuarui.cn/?q=huaruiapi/user/request_new_password"
/// 添加门锁POST请求URL
#define HRAPI_QueryLock_URL @"http://www.gzhuarui.cn/?q=huaruiapi/herolife-dev"
/// 添加门锁POST请求URL
#define HRAPI_AddLock_URL @"http://www.gzhuarui.cn/?q=huaruiapi/node"
/// 修改门锁名称PUT请求URL
//#define HRAPI_ModifyLock_URL @"http://www.gzhuarui.cn/?q=huaruiapi/node/did"



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
