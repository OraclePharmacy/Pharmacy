// 设备判断
#define IS_IPHONE ( [[[UIDevice currentDevice] model] isEqualToString:@"iPhone"] )
#define IS_IPOD   ( [[[UIDevice currentDevice ] model] isEqualToString:@"iPod touch"] )
#define IS_HEIGHT_GTE_568 [[UIScreen mainScreen ] bounds].size.height >= 568.0f
#define IS_IPHONE_5 ( IS_IPHONE && IS_HEIGHT_GTE_568 )

#define IPHONE4 															\
([UIScreen instancesRespondToSelector:@selector(currentMode)] ?             \
CGSizeEqualToSize(CGSizeMake(640, 960),                                     \
[[UIScreen mainScreen] currentMode].size) : NO)                             \

#define IPHONE5 															\
([UIScreen instancesRespondToSelector:@selector(currentMode)] ?             \
CGSizeEqualToSize(CGSizeMake(640, 1136),                                    \
[[UIScreen mainScreen] currentMode].size) : NO)                             \

#define IPHONE6 															\
([UIScreen instancesRespondToSelector:@selector(currentMode)] ?             \
CGSizeEqualToSize(CGSizeMake(750, 1334),                                    \
[[UIScreen mainScreen] currentMode].size) : NO)                             \

#define IPHONE6PLUS															\
([UIScreen instancesRespondToSelector:@selector(currentMode)] ?             \
CGSizeEqualToSize(CGSizeMake(1080, 1920),                                   \
[[UIScreen mainScreen] currentMode].size) : NO)                             \


#define IOS7  [[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0f
#define IOS8  [[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0f

#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height

// 工具宏
#define IOS7EdgeNone                            \
if (IOS7) {                                     \
self.edgesForExtendedLayout = UIRectEdgeNone;   \
}

/*
 *  获得工程的appdelegate单例
 */
#define ApplicationDelegate ((AppDelegate *)[[UIApplication sharedApplication] delegate])

/*
 *  从NSBundle获取图片，适用于大图(非重复调用)
 */
#define LoadBigImage(file,type) [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] \
pathForResource:file ofType:type]]

/*
 *  使用图片名获得图片，适用于中小图（tableview等）
 *  这个方法会将图片内存放在cache里，如果调用大图过多会导致内存占用过多
 */
#define LoadNormalImage(file) [UIImage imageNamed:file]

#define LoadWebImage(imageview,url,defaultImage) []

/*
 *  从RGB获得颜色 0xffffff
 */
#define UIColorFromRGB(rgbValue)                            \
[UIColor                                                    \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0   \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0             \
blue:((float)(rgbValue & 0xFF))/255.0                       \
alpha:1.0]
/*
 *  从RGB获得颜色 R G B A
 */
#define Color(R, G, B, A) [UIColor colorWithRed:R/255.0 green:G/255.0 blue:B/255.0 alpha:A]

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

/**
 * 简单打印调试信息
 */
#define DEBUG_SWITCH        1
#ifdef    DEBUG_SWITCH
#define DebugLog(fmt,args...) NSLog(fmt,##args)
#else
#define DebugLog(fmt,args...)
#endif

/**
 * 错误信息打印
 * 自动打印发生错误时代码所在的位置
 */
#define     ERR_DEBUG_SWITCH        1
#ifdef    ERR_DEBUG_SWITCH
#define ErrLog(fmt,args...) NSLog(@"\n--File:<%s> \n--Fun:[%s] \n--Line:%d"fmt, __FILE__, __FUNCTION__, __LINE__, ##args)
#else
#define ErrLog(fmt,args...)
#endif