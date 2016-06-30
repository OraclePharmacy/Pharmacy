//
//  AlarmClockManager.m
//  AlarmClockDemo
//
//  Created by 石显军 on 16/6/4.
//  Copyright © 2016年 石显军. All rights reserved.
//

#import "AlarmClockManager.h"
#import "ModelClock.h"
#import <UIKit/UIKit.h>

@implementation AlarmClockManager

+ (AlarmClockManager *)shareManager
{
    static AlarmClockManager *sharedAccountManagerInstance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        sharedAccountManagerInstance = [[AlarmClockManager alloc] init];
    });
    
    return sharedAccountManagerInstance;
}


#pragma mark - 操作闹钟

/** 添加一个闹钟 */
- (void)addNewClock:(ModelClock *)clock :(NSString *)ss
{
    UILocalNotification *notification=[[UILocalNotification alloc] init];
    notification.fireDate = clock.date;
    notification.alertBody = @"闹钟";
    notification.alertAction = clock.remark;
    notification.applicationIconBadgeNumber=1;
//    NSDictionary *userDict=[NSDictionary dictionaryWithObject:clock.remark forKey:@"key"];
//    notification.userInfo=userDict;
    // ios8后，需要能响应registerUserNotificationSettings:方法，才能得到授权
    if ([[UIApplication sharedApplication] respondsToSelector:@selector(registerUserNotificationSettings:)]) {
        //设置通知类型
        UIUserNotificationType type=UIUserNotificationTypeAlert |UIUserNotificationTypeBadge |UIUserNotificationTypeSound;
        UIUserNotificationSettings *settings=[UIUserNotificationSettings settingsForTypes:type categories:nil];
        
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
        
        notification.repeatInterval=kCFCalendarUnitDay;
    }
    
    else{
        
        notification.repeatInterval=NSCalendarUnitDay;
        
    }
    NSDictionary *userDict=[NSDictionary dictionaryWithObject:ss forKey:@"key"];
    notification.userInfo=userDict; 
    clock.notification = notification;
     [[UIApplication sharedApplication] scheduleLocalNotification:notification];
}

/** 移除一个闹钟 */
- (void)removeClock:(ModelClock *)clock
{
    [[UIApplication sharedApplication] cancelLocalNotification:clock.notification];
}

@end
