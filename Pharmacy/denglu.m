//
//  denglu.m
//  Pharmacy
//
//  Created by 小狼 on 16/8/1.
//  Copyright © 2016年 sk. All rights reserved.
//

#import "denglu.h"
#import "WarningBox.h"
#import "AFHTTPSessionManager.h"
#import "SBJson.h"
#import "hongdingyi.h"
#import "lianjie.h"
#import "denglu123.h"
#import <JMessage/JMessage.h>

@implementation denglu
+(void)zidongdenglu:(UIView*)view{

    NSString*Rempath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/RememberPass.plist"];
    
    NSFileManager *fm = [NSFileManager defaultManager];
    
    
    if ([fm fileExistsAtPath:Rempath]){
        NSMutableDictionary *edic = [[NSMutableDictionary alloc]initWithContentsOfFile:Rempath];
        if ([[edic objectForKey:@"phonetext"] isEqualToString:@""]||[[edic objectForKey:@"password"] isEqualToString:@""]) {
            
        }else{
//    [WarningBox warningBoxModeIndeterminate:@"登录中..." andView:view];
    
    //userID    暂时不用改
    NSString * userID=@"0";
    
    //请求地址   地址不同 必须要改
    NSString * url =@"/viplogin";
    
    //时间戳
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval a=[dat timeIntervalSince1970];
    NSString *timeSp = [NSString stringWithFormat:@"%.0f",a];
    
    
    //将上传对象转换为json格式字符串
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json",@"text/plain",@"text/html", nil];
    SBJsonWriter *writer = [[SBJsonWriter alloc]init];
    //出入参数：
    NSDictionary*datadic=[NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%@",[edic objectForKey:@"phonetext"] ],@"loginName",[NSString stringWithFormat:@"%@",[edic objectForKey:@"password"] ],@"password", nil];
    
    NSString*jsonstring=[writer stringWithObject:datadic];
    
    //获取签名
    NSString*sign= [lianjie getSign:url :userID :jsonstring :timeSp ];
    
    NSString *url1=[NSString stringWithFormat:@"%@%@%@%@",service_host,app_name,api_url,url];
    
    
    //电泳借口需要上传的数据
    NSDictionary*dic=[NSDictionary dictionaryWithObjectsAndKeys:jsonstring,@"params",appkey, @"appkey",userID,@"userid",sign,@"sign",timeSp,@"timestamp", nil];
    
    [manager POST:url1 parameters:dic progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [WarningBox warningBoxHide:YES andView:view];
        @try
        {
            
            NSLog(@"登陆返回－－－＊＊＊－－－\n\n\n%@",responseObject);
            if ([[responseObject objectForKey:@"code"]isEqual:@"0000"]) {
                
                NSDictionary*datadic=[responseObject valueForKey:@"data"];
                NSDictionary*vipInfoReturnList=[NSDictionary dictionaryWithDictionary:[datadic objectForKey:@"vipInfoReturnList"]];
                NSString *path = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/GRtouxiang"];
                NSFileManager*fm=[NSFileManager defaultManager];
                if ([fm fileExistsAtPath:path]) {
                    
                    [fm removeItemAtPath:path error:NULL];
                    
                }
                
                NSString *path1 =[NSHomeDirectory() stringByAppendingString:@"/Documents/GRxinxi.plist"];
                [vipInfoReturnList writeToFile:path1 atomically:YES];
                NSLog(@"个人信息内容：%@",vipInfoReturnList);
                NSUserDefaults*s= [NSUserDefaults standardUserDefaults];
                [s setObject:[vipInfoReturnList objectForKey:@"loginName"] forKey:@"shoujihao"];
                [s setObject:[vipInfoReturnList objectForKey:@"id"] forKey:@"vipId"];
                [[NSUserDefaults standardUserDefaults] setObject:@"YES" forKey:@"isLogin"];
                
                
                denglu123 *deng123 = [[denglu123 alloc]init ];
                [deng123 sssddaaa];
                
            }
            else{
                [WarningBox warningBoxModeText:@"自动登录失败!" andView:view];
            }
        }
        @catch (NSException * e) {
            
            [WarningBox warningBoxModeText:@"请检查你的网络连接!" andView:view];
            
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [WarningBox warningBoxHide:YES andView:view];
        [WarningBox warningBoxModeText:@"网络连接失败！" andView:view];
        NSLog(@"错误：%@",error);
        
    }];
        }
    }
    
}


@end
