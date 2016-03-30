//
//  URLEncode.m
//  网址确定
//
//  Created by 小狼 on 15/12/1.
//  Copyright © 2015年 oracle. All rights reserved.
//

#import "URLEncode.h"

@implementation URLEncode
- (NSString *)encodeToPercentEscapeString: (NSString *) input
{
    NSString*
    outputStr = (__bridge NSString *)CFURLCreateStringByAddingPercentEscapes( NULL, /* allocator */(__bridge CFStringRef)input,NULL, /* charactersToLeaveUnescaped */(CFStringRef)@"!*'();:@&=$,/?%#[]",kCFStringEncodingUTF8);
    
    
    return outputStr;
}
@end
