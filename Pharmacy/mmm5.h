//
//  mmm5.h
//  NSString+MD5HexDigest
//
//  Created by 小狼 on 15/11/26.
//  Copyright © 2015年 oracle. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonDigest.h>
@interface mmm5 : NSObject
+ (NSString *)md5HexDigest:(NSString *)url ;
@end
