//
//  mmm5.m
//  NSString+MD5HexDigest
//
//  Created by 小狼 on 15/11/26.
//  Copyright © 2015年 oracle. All rights reserved.
//

#import "mmm5.h"

@implementation mmm5

+ (NSString *)md5HexDigest:(NSString *)url
{
    
    
    
    const char *original_str = [url UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(original_str, strlen(original_str), result);
    NSMutableString *hash = [NSMutableString string];
    for (int i = 0; i < 16; i++)
        [hash appendFormat:@"%02X", result[i] ];
    
    
    return [hash lowercaseString];
    
}
@end
