//
//  lianjie.h
//  网址确定
//
//  Created by 小狼 on 15/12/1.
//  Copyright © 2015年 oracle. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface lianjie : NSObject
+(NSString*)postSign:(NSString*)url :(NSString*)userID :(NSString*)jsonstring :(NSString*)timeSP;
+(NSString*)getSign:(NSString*)url :(NSString*)userID :(NSString*)jsonstring :(NSString*)timeSP;
@end
