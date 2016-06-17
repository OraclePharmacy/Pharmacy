//
//  ModelClock.h
//  AlarmClockDemo
//
//  Created by 石显军 on 16/5/31.
//  Copyright © 2016年 石显军. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ModelClock : NSObject

/** 时钟ID */
@property (nonatomic, strong) NSString *clockID;

/** 时间 */
@property (nonatomic, strong) NSDate *date;

/** 备注 */
@property (nonatomic, strong) NSString *remark;

/** 时钟是否开启 */
@property (nonatomic, assign) BOOL clockOn;

/** 通知 */
@property (nonatomic, strong) UILocalNotification *notification;

@end
