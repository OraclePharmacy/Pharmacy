//
//  lianjie.m
//  网址确定
//
//  Created by 小狼 on 15/12/1.
//  Copyright © 2015年 oracle. All rights reserved.
//

#import "lianjie.h"
#import "hongdingyi.h"
#import "mmm5.h"
#import "URLEncode.h"
@implementation lianjie
/**
 *  POST方法 获取sign
 *
 *  @param url
 *  @param userID
 *  @param jsonstring
 *  @param timeSP
 *
 *  @return sign
 */
+(NSString*)postSign:(NSString*)url :(NSString*)userID :(NSString*)jsonstring :(NSString*)timeSP{
    
   
    NSArray*pl=[NSArray arrayWithObjects:[NSString stringWithFormat:@"appkey=%@",appkey],[NSString stringWithFormat:@"params=%@",jsonstring],[NSString stringWithFormat:@"timestamp=%@",timeSP],[NSString stringWithFormat:@"userid=%@",userID], nil];
    NSString*plstr=[pl componentsJoinedByString:@","];
NSString*host=[NSString stringWithFormat:@"%@%@%@",sign_host,app_name,api_url];
    NSMutableString*basestr=[NSMutableString stringWithFormat:@"%@%@%@%@",host,url,plstr,appsecret];
    
    //把字符串basestr中的＋用％20代替
     NSString * beibei = [basestr stringByReplacingOccurrencesOfString:@"+" withString:@"%20"];
    //加盐
   // NSString*jiayan=[beibei stringByAppendingString:@"48"];

    URLEncode*haha=[[URLEncode alloc] init];
   
    NSString * memeda=[haha encodeToPercentEscapeString:beibei];
    
   
    NSString*sign=[mmm5 md5HexDigest:memeda];

    return sign;
}
+(NSString*)getSign:(NSString*)url :(NSString*)userID :(NSString*)jsonstring :(NSString*)timeSP{
    
    
    NSArray*pl=[NSArray arrayWithObjects:[NSString stringWithFormat:@"appkey=%@",appkey],[NSString stringWithFormat:@"params=%@",jsonstring],[NSString stringWithFormat:@"timestamp=%@",timeSP],[NSString stringWithFormat:@"userid=%@",userID], nil];
    NSString*plstr=[pl componentsJoinedByString:@","];
NSString*host=[NSString stringWithFormat:@"%@%@%@",sign_host,app_name,api_url];
    NSMutableString*basestr=[NSMutableString stringWithFormat:@"%@%@%@%@",host,url,plstr,appsecret];
    //把字符串basestr中的＋用％20代替
    NSString * beibei = [basestr stringByReplacingOccurrencesOfString:@"+" withString:@"%20"];
    //加盐
    // NSString*jiayan=[beibei stringByAppendingString:@"48"];
    
    URLEncode*haha=[[URLEncode alloc] init];
    
    NSString * memeda=[haha encodeToPercentEscapeString:beibei];
    
    
    NSString*sign=[mmm5 md5HexDigest:memeda];
    
    return sign;
}
@end
