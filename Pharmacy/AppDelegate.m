//
//  AppDelegate.m
//  Pharmacy
//
//  Created by suokun on 16/3/17.
//  Copyright © 2016年 sk. All rights reserved.
//

#import "AppDelegate.h"
#import "UMSocial.h"
#import "UMSocialWechatHandler.h"
#import "UMSocialSinaSSOHandler.h"
#import "UMSocialQQHandler.h"
#define JMSSAGE_APPKEY @"7f781ffb921114be6cb3d00b"
#define CHANNEL @""
@interface AppDelegate ()<JMessageDelegate>
@end

@implementation AppDelegate


#pragma mark - 应用代理方法
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
     [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(localNotification) name:@"轮回公子" object:nil];
    
    [JMessage addDelegate:self withConversation:nil];
    /// Required - 启动 JMessage SDK
    [JMessage setupJMessage:launchOptions
                     appKey:JMSSAGE_APPKEY
                    channel:CHANNEL
           apsForProduction:NO
                   category:nil];
    
    /// Required - 注册 APNs 通知
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        /// 可以添加自定义categories
        [JPUSHService registerForRemoteNotificationTypes:(UIUserNotificationTypeBadge |
                                                          UIUserNotificationTypeSound |
                                                          UIUserNotificationTypeAlert)
                                              categories:nil];
        if ([[UIApplication sharedApplication]currentUserNotificationSettings].types!=UIUserNotificationTypeNone) {
            
            [self localNotification];
            
        }else{
            [[UIApplication sharedApplication]registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert|UIUserNotificationTypeBadge|UIUserNotificationTypeSound  categories:nil]];
        }

    } else {
        /// categories 必须为nil
        [JPUSHService registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
                                                          UIRemoteNotificationTypeSound |
                                                          UIRemoteNotificationTypeAlert)
                                              categories:nil];
    }
    [JPUSHService setupWithOption:launchOptions appKey:JMSSAGE_APPKEY channel:CHANNEL apsForProduction:NO];
    
    //友盟0.0
    
    
    
    
    [UMSocialData setAppKey:@"573ecc1ee0f55a834f0011fb"];
    
    //设置微信AppId、appSecret，分享url
    [UMSocialWechatHandler setWXAppId:@"wx3f0e5b3522c2f6b1" appSecret:@"d4624c36b6795d1d99dcf0547af5443d" url:@"http://www.baidu.com"];
    //设置手机QQ 的AppId，Appkey，和分享URL，需要#import "UMSocialQQHandler.h"
    [UMSocialQQHandler setQQWithAppId:@"1104922260" appKey:@"rRqcJM43g8GFv6mE" url:@"http://www.umeng.com/social"];
    //打开新浪微博的SSO开关，设置新浪微博回调地址，这里必须要和你在新浪微博后台设置的回调地址一致。需要 #import "UMSocialSinaSSOHandler.h"
    [UMSocialSinaSSOHandler openNewSinaSSOWithAppKey:@"3921700954"
                                              secret:@"04b48b094faeb16683c32669824ebdad"
                                         RedirectURL:@"http://sns.whalecloud.com/sina2/callback"];
    
    

    return YES;
}


#pragma mark ----本地通知
-(void)localNotification
{
    [[UIApplication sharedApplication]cancelAllLocalNotifications];
    NSString * path1 = [NSHomeDirectory() stringByAppendingString:@"/Documents/durgRemindList.plist"];
    
    NSMutableArray * pathArray1 = [[NSMutableArray alloc]init];
//    NSMutableArray *timeArray = [[NSMutableArray alloc]init];
    
    NSMutableArray *array = [[NSMutableArray alloc]initWithContentsOfFile:path1];
    
    //获取用户id
    
    NSString *yhidString = [NSString stringWithFormat:@"%d",[[[NSUserDefaults standardUserDefaults]objectForKey:@"hyid"] intValue]];
    
    //获取某一个id的内容
    for (int i = 0 ; i < array.count; i++) {
        
        if ([[array[i] objectForKey:@"yhid"] isEqualToString:yhidString]) {
            
            [pathArray1 addObject:[array[i] objectForKey:@"neirong"]];
        }
    }
    
    for (NSDictionary *dic in pathArray1) {
        
        if ([[dic objectForKey:@"ison"] isEqualToString:@"1"]) {
            
            NSArray *mnt = [[dic objectForKey:@"riqi"] componentsSeparatedByString:@" "];
            
            //
            
            NSMutableArray *arr=[[NSMutableArray alloc] init];
            
            for (NSString *ser in mnt) {
                
                if (![ser isEqualToString:@"无"])
                    
                    [arr addObject:ser];
            }
      
            for (NSString *str in arr) {
                
                int mm = [self createTimeInterval:str];
                
                [self naozhong:mm ];
                
            }
        }
    }
}
-(void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings{
    
    [application registerForRemoteNotifications];
    
    if (notificationSettings.types!=UIUserNotificationTypeNone) {
        [self localNotification];
    }
}
- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"康速达提示您!"
                          
                                                    message:notification.alertBody
                          
                                                   delegate:nil
                          
                                          cancelButtonTitle:@"确定"
                          
                                          otherButtonTitles:nil];
    
    [alert show];
    
    //这里，你就可以通过notification的userinfo，干一些你想做的事情了
    
    application.applicationIconBadgeNumber -= 1;
}

-(void)naozhong:(int)time
{
    UIApplication *app  = [UIApplication sharedApplication];
    
    UILocalNotification *notification = [[UILocalNotification alloc]init];
    if (notification) {
        
        notification.timeZone = [NSTimeZone defaultTimeZone];
        notification.fireDate = [NSDate dateWithTimeIntervalSinceNow:time];
        
        // 设置重复间隔
        
        notification.repeatInterval = kCFCalendarUnitDay;
        
        
        // 设置提醒的文字内容
        
        notification.alertBody   = @"用药时间到！您该用药了！";
        
        notification.alertAction = @"打开";
        
        notification.hasAction = NO; //是否显示额外的按钮，为no时alertAction消失
        
        // 通知提示音 使用默认的
        notification.soundName = UILocalNotificationDefaultSoundName;
        notification.soundName =@"7008.wav";
        // 设置应用程序右上角的提醒个数
        // notification.applicationIconBadgeNumber++;
        
        // 将通知添加到系统中
        [app scheduleLocalNotification:notification];
    }
}


-(int)createTimeInterval:(NSString*)timeDate
{
    NSArray *array = [timeDate componentsSeparatedByString:@":"];
    
    // int weekday1 = [array[0] intValue];
    int hour1 = [array[0] intValue];
    int minute1 = [array [1] intValue];
    
    NSDate *nowTime = [NSDate date];
    NSCalendar *calemdar = [NSCalendar currentCalendar];
    NSUInteger unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth |NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute |NSCalendarUnitSecond | NSCalendarUnitWeekday;
    NSDateComponents *dateComponent = [calemdar components:unitFlags fromDate:nowTime];
    
    //int weekday = (int)[dateComponent weekday];
    int hour = (int)[dateComponent hour];
    int minute = (int)[dateComponent minute];
    
    int sedconds = [self hour:(hour1 - hour)] + [self min:(minute1 - minute)];
    
    
    return sedconds;
}
-(int)hour:(int)hour
{
    hour = [self min:60]*hour;
    return hour;
}

-(int)min:(int)min
{
    min *=60;
    return min;
}




#pragma mark-----   JPUSH
- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
}
- (void)application:(UIApplication *)application
didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    NSLog(@"\n\n\n\n device  token   \n\n\n\n%@\n\n\n\n\n\n",deviceToken);
    /// Required - 注册 DeviceToken
    [JPUSHService registerDeviceToken:deviceToken];
    
    
    NSString*alias=[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"shoujihao"]];
    NSLog(@"%@",alias);
    [JPUSHService setAlias:alias callbackSelector:@selector(tagsAliasCallback:tags:alias:) object:self];
    
}
-(void)tagsAliasCallback:(int)iResCode
                    tags:(NSSet*)tags
                   alias:(NSString*)alias
{
    NSLog(@"\n\n\n\n\n\n\n\n\nrescode: %d, \ntags: %@, \nalias: %@\n", iResCode, tags , alias);

}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    NSLog(@"\n\n\n\n 处理收到的通知\n\n\n\n\n%@\n\n\n\n\n",userInfo);
    // Required - 处理收到的通知
    [JPUSHService handleRemoteNotification:userInfo];
    //进入前台清空角标
    if (application.applicationState == UIApplicationStateActive) {
        [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    }

}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    
    NSLog(@"\n\n\n\n\n\n ios 7 \n\n\n\n\n%@\n\n\n\n\n",userInfo);
    
    // IOS 7 Support Required
    [JPUSHService handleRemoteNotification:userInfo];
    completionHandler(UIBackgroundFetchResultNewData);
    //进入前台清空角标
    if (application.applicationState == UIApplicationStateActive) {
        [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    }

}
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    //Optional
    NSLog(@"did Fail To Register For Remote Notifications With Error: %@", error);
}



@end