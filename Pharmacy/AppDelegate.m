//
//  AppDelegate.m
//  Pharmacy
//
//  Created by suokun on 16/3/17.
//  Copyright © 2016年 sk. All rights reserved.
//

#import "AppDelegate.h"

#define JMSSAGE_APPKEY @"7f781ffb921114be6cb3d00b"
#define CHANNEL @""
#import <JMessage/JMessage.h>
#import <UserNotifications/UserNotifications.h>

#import <UMSocialCore/UMSocialCore.h>

@interface AppDelegate () <JMessageDelegate,JPUSHRegisterDelegate>
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
    
    // 注册apns通知
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 10.0) // iOS10
    {
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
        JPUSHRegisterEntity * entity = [[JPUSHRegisterEntity alloc] init];
        entity.types = UNAuthorizationOptionAlert|UNAuthorizationOptionBadge | UNAuthorizationOptionSound;
        [JPUSHService registerForRemoteNotificationConfig:entity delegate:self];
#endif
    }
    else if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) // iOS8, iOS9
    {
        //可以添加自定义categories
        [JPUSHService registerForRemoteNotificationTypes:(UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert) categories:nil];
    }
    else // iOS7
    {
        //categories 必须为nil
        [JPUSHService registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert) categories:nil];
    }
    
    
    //2.1.9版本新增获取registration id block接口。
    [JPUSHService registrationIDCompletionHandler:^(int resCode, NSString *registrationID) {
        if(resCode == 0)
        {
            // iOS10获取registrationID放到这里了, 可以存到缓存里, 用来标识用户单独发送推送
            NSLog(@"registrationID获取成功：%@",registrationID);
            [[NSUserDefaults standardUserDefaults] setObject:registrationID forKey:@"registrationID"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            NSString*alias=[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"shoujihao"]];
            NSLog(@"%@",alias);
            [JPUSHService setAlias:alias callbackSelector:@selector(tagsAliasCallback:tags:alias:) object:self];
        }
        else
        {
            NSLog(@"registrationID获取失败，code：%d",resCode);
        }
    }];
    
    
    
//    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
//        /// 可以添加自定义categories
//        [JPUSHService registerForRemoteNotificationTypes:(UIUserNotificationTypeBadge |
//                                                          UIUserNotificationTypeSound |
//                                                          UIUserNotificationTypeAlert)
//                                              categories:nil];
//        if ([[UIApplication sharedApplication]currentUserNotificationSettings].types!=UIUserNotificationTypeNone) {
//            
//            [self localNotification];
//            
//        }else{
//            [[UIApplication sharedApplication]registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert|UIUserNotificationTypeBadge|UIUserNotificationTypeSound  categories:nil]];
//        }
//
//    } else {
//        /// categories 必须为nil
//        [JPUSHService registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
//                                                          UIRemoteNotificationTypeSound |
//                                                          UIRemoteNotificationTypeAlert)
//                                              categories:nil];
//    }
    [JPUSHService setupWithOption:launchOptions appKey:JMSSAGE_APPKEY channel:CHANNEL apsForProduction:NO];
    
    //友盟0.0
    
    
    /* 打开调试日志 */
    [[UMSocialManager defaultManager] openLog:YES];
    
    /* 设置友盟appkey */
    [[UMSocialManager defaultManager] setUmSocialAppkey:@"58f5c91804e2055cce000c37"];
    
    [self configUSharePlatforms];
    
    [self confitUShareSettings];
 
    

    return YES;
}
- (void)confitUShareSettings
{
    /*
     * 打开图片水印
     */
    //[UMSocialGlobal shareInstance].isUsingWaterMark = YES;
    
    /*
     * 关闭强制验证https，可允许http图片分享，但需要在info.plist设置安全域名
     <key>NSAppTransportSecurity</key>
     <dict>
     <key>NSAllowsArbitraryLoads</key>
     <true/>
     </dict>
     */
    //[UMSocialGlobal shareInstance].isUsingHttpsWhenShareContent = NO;
    
}
- (void)configUSharePlatforms
{
    /* 设置微信的appKey和appSecret */
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_WechatSession appKey:@"wx1c53e8647ce24417" appSecret:@"e5486a6a118b5343334c1683f87ebde1" redirectURL:@"http://www.kanglins.com"];//审核未完成
    //e5486a6a118b5343334c1683f87ebde1微信appsecret 
    /*
     * 移除相应平台的分享，如微信收藏
     */
    //[[UMSocialManager defaultManager] removePlatformProviderWithPlatformTypes:@[@(UMSocialPlatformType_WechatFavorite)]];
    
    /* 设置分享到QQ互联的appID
     * U-Share SDK为了兼容大部分平台命名，统一用appKey和appSecret进行参数设置，而QQ平台仅需将appID作为U-Share的appKey参数传进即可。
     */
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_QQ appKey:@"1106111034"/*设置QQ平台的appID*/  appSecret:nil redirectURL:@"http://www.kanglins.com"];
    
    /* 设置新浪的appKey和appSecret */
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_Sina appKey:@"4226703456"  appSecret:@"fa390074566d8d9aaaefa272fe2f18f3" redirectURL:@"http://www.kanglins.com"];
    
    /* 钉钉的appKey */
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_DingDing appKey:@"dingoalmlnohc0wggfedpk" appSecret:nil redirectURL:@"http://www.kanglins.com"];//还没有
    
   
    
}



// 支持所有iOS系统
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    //6.3的新的API调用，是为了兼容国外平台(例如:新版facebookSDK,VK等)的调用[如果用6.2的api调用会没有回调],对国内平台没有影响
    BOOL result = [[UMSocialManager defaultManager] handleOpenURL:url sourceApplication:sourceApplication annotation:annotation];
    if (!result) {
        // 其他如支付等SDK的回调
    }
    return result;
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
// 通知事件监听
- (void)onReceiveNotificationEvent:(JMSGNotificationEvent *)event{
    switch (event.eventType) {
        case kJMSGEventNotificationReceiveFriendInvitation:
            NSLog(@"1111Receive Friend Invitation Event ");
            break;
        case kJMSGEventNotificationAcceptedFriendInvitation:
            NSLog(@"1111Accepted Friend Invitation Event ");
            break;
        case kJMSGEventNotificationDeclinedFriendInvitation:
            NSLog(@"1111Declined Friend Invitation Event ");
            break;
        case kJMSGEventNotificationDeletedFriend:
            NSLog(@"1111Deleted Friend Event ");
            break;
        case kJMSGEventNotificationReceiveServerFriendUpdate:
            NSLog(@"1111Receive Server Friend Update Event ");
            break;
        case kJMSGEventNotificationLoginKicked:
            NSLog(@"1111Login Kicked Event ");
            break;
        case kJMSGEventNotificationServerAlterPassword:
            NSLog(@"1111Server Alter Password Event ");
            break;
        case kJMSGEventNotificationUserLoginStatusUnexpected:
            NSLog(@"1111User login status unexpected Event ");
            break;
        default:
            NSLog(@"1111Other Notification Event ");
            break;
    }
}





#pragma mark-----   JPUSH
// iOS 10 Support
/*
 * @brief handle UserNotifications.framework [willPresentNotification:withCompletionHandler:]
 * @param center [UNUserNotificationCenter currentNotificationCenter] 新特性用户通知中心
 * @param notification 前台得到的的通知对象
 * @param completionHandler 该callback中的options 请使用UNNotificationPresentationOptions
 */

- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(NSInteger))completionHandler {
    // Required
    
    NSDictionary * userInfo = notification.request.content.userInfo;
    
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]])
    {
        [JPUSHService handleRemoteNotification:userInfo];
        
        NSString *message = [NSString stringWithFormat:@"%@", [userInfo[@"aps"] objectForKey:@"alert"]];
        if ([message rangeOfString:@"订单已"].location !=NSNotFound) {
            [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"youjian"];
            [[NSNotificationCenter defaultCenter]postNotificationName:@"111" object:nil];
        }else{
            [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"tiezixinxi"];
            [[NSNotificationCenter defaultCenter]postNotificationName:@"222" object:nil];
        }
        
//        NSLog(@"iOS10程序在前台时收到的推送: %@", message);
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:message delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil, nil];
//        [alert show];
    }
    
    completionHandler(UNNotificationPresentationOptionBadge|UNNotificationPresentationOptionSound|UNNotificationPresentationOptionAlert); // 需要执行这个方法，选择是否提醒用户，有Badge、Sound、Alert三种类型可以设置
}

// iOS 10 Support
/*
* @brief handle UserNotifications.framework [didReceiveNotificationResponse:withCompletionHandler:]
* @param center [UNUserNotificationCenter currentNotificationCenter] 新特性用户通知中心
* @param response 通知响应对象
* @param completionHandler
*/

- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler {
    // Required
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]])
    {
        [JPUSHService handleRemoteNotification:userInfo];
        
        NSString *message = [NSString stringWithFormat:@"%@", [userInfo[@"aps"] objectForKey:@"alert"]];
        if ([message rangeOfString:@"订单已"].location !=NSNotFound) {
            [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"youjian"];
        }else{
            [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"tiezixinxi"];
        }
//         [[NSNotificationCenter defaultCenter] postNotificationName:@"111" object:nil];
//        NSString *message = [NSString stringWithFormat:@"%@", [userInfo[@"aps"] objectForKey:@"alert"]];
//        NSLog(@"iOS10程序关闭后通过点击推送进入程序弹出的通知: %@", message);
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:message delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil ,nil];
//        [alert show];
    }
    
    completionHandler();  // 系统要求执行这个方法
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
}
- (void)application:(UIApplication *)application
didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    NSLog(@"\n\n\n\n 注册：device  token   \n\n\n\n%@\n\n\n\n\n\n",deviceToken);
    /// Required - 注册 DeviceToken
    [JPUSHService registerDeviceToken:deviceToken];
    
}
-(void)tagsAliasCallback:(int)iResCode
                    tags:(NSSet*)tags
                   alias:(NSString*)alias
{
    NSLog(@"\n\n\n\n\n\n\n\n\nrescode: %d, \ntags: %@, \nalias: %@\n", iResCode, tags , alias);

}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    NSLog(@"\n\n\n\n接收： 处理收到的通知\n\n\n\n\n%@\n\n\n\n\n",userInfo);
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
-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"111" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"222" object:nil];
}
@end
