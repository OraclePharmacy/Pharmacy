//
//  denglu123.m
//  Pharmacy
//
//  Created by suokun on 16/8/22.
//  Copyright © 2016年 sk. All rights reserved.
//

#import "denglu123.h"
#import "WarningBox.h"
#import "AFHTTPSessionManager.h"
#import "SBJson.h"
#import "hongdingyi.h"
#import "lianjie.h"
@interface denglu123 ()
{
    NSString *yongjingxi,*wenyaoshi,*daigouyao,*youhuiquan,*bingyoujiaoliu,*zizhen,*yongyaotixing,*xueyaxuetang,*dianzibingli,*zhihuiyaoxiang;
}
@end

@implementation denglu123


-(void)sssddaaa
{

    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString *path2=[paths objectAtIndex:0];
    //NSLog(@"path = %@",path);
    NSString *filename=[path2 stringByAppendingPathComponent:@"baocun.plist"];
    //NSLog(@"path = %@",filename);
    //判断是否已经创建文件
    if ([[NSFileManager defaultManager] fileExistsAtPath:filename]) {
        
        NSDictionary* dic = [NSDictionary dictionaryWithContentsOfFile:filename];
        yongjingxi = [dic objectForKey:@"yongjingxi"];
        wenyaoshi = [dic objectForKey:@"wenyaoshi"];
        daigouyao = [dic objectForKey:@"daigouyao"];
        youhuiquan = [dic objectForKey:@"youhuiquan"];
        bingyoujiaoliu = [dic objectForKey:@"bingyoujiaoliu"];
        zizhen = [dic objectForKey:@"zizhen"];
        yongyaotixing = [dic objectForKey:@"yongyaotixing"];
        xueyaxuetang = [dic objectForKey:@"xueyaxuetang"];
        dianzibingli = [dic objectForKey:@"dianzibingli"];
        zhihuiyaoxiang = [dic objectForKey:@"zhihuiyaoxiang"];
        
        [self diaojiekou];
        
    }else {
        
        NSDictionary* dic = [NSDictionary dictionaryWithObjectsAndKeys:/*1*/@"0",@"yongjingxi",/*2*/@"0",@"wenyaoshi",/*3*/@"0",@"daigouyao",/*4*/@"0",@"youhuiquan",/*5*/@"0",@"bingyoujiaoliu",/*6*/@"0",@"zizhen",/*7*/@"0",@"yongyaotixing",/*8*/@"0",@"xueyaxuetang",/*9*/@"0",@"dianzibingli",/*10*/@"0",@"zhihuiyaoxiang",nil]; //写入数据
        //NSLog(@"%@",dic);
        [dic writeToFile:filename atomically:YES];
        
    }
}
-(void)diaojiekou
{
    //userID    暂时不用改
    NSString * userID=@"0";
    
    //请求地址   地址不同 必须要改
    NSString * url =@"/basic/saveStatistics";
    
    //时间戳
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval a=[dat timeIntervalSince1970];
    NSString *timeSp = [NSString stringWithFormat:@"%.0f",a];
    
    
    //将上传对象转换为json格式字符串
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json",@"text/plain",@"text/html", nil];
    SBJsonWriter *writer = [[SBJsonWriter alloc]init];
    //出入参数：
    NSDictionary*datadic=[NSDictionary dictionaryWithObjectsAndKeys:yongjingxi,@"a",wenyaoshi,@"b",daigouyao,@"c",youhuiquan,@"d",bingyoujiaoliu,@"e",zizhen,@"f",yongyaotixing,@"g",xueyaxuetang,@"h",dianzibingli,@"i",zhihuiyaoxiang,@"j", nil];
    
    NSLog(@"%@",datadic);
    
    NSString*jsonstring=[writer stringWithObject:datadic];
    
    //获取签名
    NSString*sign= [lianjie getSign:url :userID :jsonstring :timeSp ];
    
    NSString *url1=[NSString stringWithFormat:@"%@%@%@%@",service_host,app_name,api_url,url];
    
    //电泳借口需要上传的数据
    NSDictionary*dic=[NSDictionary dictionaryWithObjectsAndKeys:jsonstring,@"params",appkey, @"appkey",userID,@"userid",sign,@"sign",timeSp,@"timestamp", nil];
    
    [manager POST:url1 parameters:dic progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [WarningBox warningBoxHide:YES andView:self.view];
        @try
        {
            [WarningBox warningBoxModeText:[NSString stringWithFormat:@"%@",[responseObject objectForKey:@"msg"]] andView:self.view];
            NSLog(@"responseObject%@",responseObject);
            if ([[responseObject objectForKey:@"code"] intValue]==0000) {
                
                NSLog(@"121313132132132131321123123132123123123");
                //NSDictionary*datadic=[responseObject valueForKey:@"data"];
                
                NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
                NSString *path2=[paths objectAtIndex:0];
                //NSLog(@"path = %@",path);
                NSString *filename=[path2 stringByAppendingPathComponent:@"baocun.plist"];
                NSDictionary* dictionaryic = [NSDictionary dictionaryWithObjectsAndKeys:/*1*/@"0",@"yongjingxi",/*2*/@"0",@"wenyaoshi",/*3*/@"0",@"daigouyao",/*4*/@"0",@"youhuiquan",/*5*/@"0",@"bingyoujiaoliu",/*6*/@"0",@"zizhen",/*7*/@"0",@"yongyaotixing",/*8*/@"0",@"xueyaxuetang",/*9*/@"0",@"dianzibingli",/*10*/@"0",@"zhihuiyaoxiang",nil];
                
                [dictionaryic writeToFile:filename atomically:YES];
            }
        }
        @catch (NSException * e) {
            
            [WarningBox warningBoxModeText:@"请检查你的网络连接!" andView:self.view];
            
        }
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [WarningBox warningBoxHide:YES andView:self.view];
        [WarningBox warningBoxModeText:@"网络连接失败！" andView:self.view];
        NSLog(@"错误：%@",error);
    }];
    
    
}

@end
