//
//  AlarmClockManager.h
//  AlarmClockDemo
//
//  Created by 石显军 on 16/6/4.
//  Copyright © 2016年 石显军. All rights reserved.
//

#import <Foundation/Foundation.h>


@class ModelClock;

@interface AlarmClockManager : NSObject

+ (AlarmClockManager *)shareManager;


#pragma mark - 操作闹钟

/** 添加一个闹钟 */
- (void)addNewClock:(ModelClock *)clock :(NSString *)ss;

/** 移除一个闹钟 */
- (void)removeClock:(ModelClock *)clock;

@end
