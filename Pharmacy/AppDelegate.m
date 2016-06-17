//
//  AppDelegate.m
//  Pharmacy
//
//  Created by suokun on 16/3/17.
//  Copyright © 2016年 sk. All rights reserved.
//

#import "AppDelegate.h"
#define JMSSAGE_APPKEY @"0b4f04ee1fe01108ee17cf70"
#define CHANNEL @""
@interface AppDelegate ()/*<JMessageDelegate>*/
@end

@implementation AppDelegate


#pragma mark - 应用代理方法
//- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
//    
//    [JMessage addDelegate:self withConversation:nil];
//    
//    /// Required - 启动 JMessage SDK
//    [JMessage setupJMessage:launchOptions
//                     appKey:JMSSAGE_APPKEY
//                    channel:CHANNEL
//           apsForProduction:NO
//                   category:nil];
//    
//    /// Required - 注册 APNs 通知
//    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
//        /// 可以添加自定义categories
//        [JPUSHService registerForRemoteNotificationTypes:(UIUserNotificationTypeBadge |
//                                                          UIUserNotificationTypeSound |
//                                                          UIUserNotificationTypeAlert)
//                                              categories:nil];
//    } else {
//        /// categories 必须为nil
//        [JPUSHService registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
//                                                          UIRemoteNotificationTypeSound |
//                                                          UIRemoteNotificationTypeAlert)
//                                              categories:nil];
//    }
//    
//    
////*-*-*-*-*-*--*-*-*-*-*-*-*-*-**-**-*-*-*-**-*-***-*-**-*-*-*-**-*-**-*-*-*-*-*-*-
//    
//    
//    //如果已经获得发送通知的授权则创建本地通知，否则请求授权(注意：如果不请求授权在设置中是没有对应的通知设置项的，也就是说如果从来没有发送过请求，即使通过设置也打不开消息允许设置)
//    if ([[UIApplication sharedApplication]currentUserNotificationSettings].types!=UIUserNotificationTypeNone) {
//        [self addLocalNotification:nil];
//    }else{
//        [[UIApplication sharedApplication]registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert|UIUserNotificationTypeBadge|UIUserNotificationTypeSound  categories:nil]];
//    }
//    
//    return YES;
//}
//
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    return YES;
}


#pragma mark - 通知

//本地通知回调函数，当应用程序收到本地通知时调用（应用在前台时调用，切换到后台则你调用此方法）
- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification{
    //从外部通知点击进入的一个状态
    if (application.applicationState==UIApplicationStateInactive) {
        
        //通知中心👉进入监听👉跳转页面
        [[NSNotificationCenter defaultCenter]postNotificationName:@"presentView" object:nil];
        
        
    }
    
    
    ///获取通知所带的数据
    NSString *details = [notification.userInfo objectForKey:@"key"];
    
    //设置警示框，使用UIAlertController
    UIAlertController *alertControler=[UIAlertController alertControllerWithTitle:@"通知" message:details preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cancelAction=[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    
    UIAlertAction *okAction=[UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:nil];
    
    [alertControler addAction:cancelAction];
    
    [alertControler addAction:okAction];
    
    [self.window.rootViewController presentViewController:alertControler animated:YES completion:nil];
    
    
    //更新显示的角标个数
    NSInteger badge=[UIApplication sharedApplication] .applicationIconBadgeNumber;
    
    
    badge--;
    
    badge=badge>=0?badge:0;
    
    [UIApplication sharedApplication].applicationIconBadgeNumber=badge;
    
}


// 在需要移除某个通知时调用下面方法
// 取消某个本地推送通知
- (void)cancelLocalNotificationWithKey:(NSString *)key{
    
    //获取所有本地推送通知数组
    NSArray *localNotifications=[UIApplication sharedApplication].scheduledLocalNotifications;
    //遍历通知数组
    for (UILocalNotification *notification in localNotifications) {
        NSDictionary *userInfo=notification.userInfo;
        if (userInfo) {
            
            //根据设置通知参数时指定的key来获取通知参数
            NSString *info=[userInfo objectForKey:key];
            
            //如果找到需要取消的通知，则取消通知
            if (info!=nil) {
                [[UIApplication sharedApplication] cancelLocalNotification:notification];
                break;
            }
            
            
        }
    }
}
- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}
@end