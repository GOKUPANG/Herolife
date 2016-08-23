#import <UIKit/UIKit.h>


/** 导航栏最大的Y值 */
CGFloat const XMGNavMaxY = 64;

/** 标题栏的高度 */
CGFloat const XMGTitlesViewH = 35;

/** UITabBar的高度 */
CGFloat const XMGTabBarH = 49;

/** 统一的URL */
NSString * const XMGCommonURL = @"http://api.budejie.com/api/api_open.php";

/** 通知-UITabBarButton被重复点击就会发出这个通知 */
NSString * const XMGTabBarButtonDidRepeatClickNotification = @"XMGTabBarButtonDidRepeatClickNotification";

/** 通知-标题栏按钮被重复点击就会发出这个通知 */
NSString * const XMGTitleButtonDidRepeatClickNotification = @"XMGTitleButtonDidRepeatClickNotification";