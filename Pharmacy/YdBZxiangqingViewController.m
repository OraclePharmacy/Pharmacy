//
//  YdBZxiangqingViewController.m
//  Pharmacy
//
//  Created by suokun on 16/8/1.
//  Copyright © 2016年 sk. All rights reserved.
//

#import "YdBZxiangqingViewController.h"
#import "WarningBox.h"
#import "AFNetworking 3.0.4/AFHTTPSessionManager.h"
#import "SBJson.h"
#import "hongdingyi.h"
#import "lianjie.h"
@interface YdBZxiangqingViewController ()
{
    CGFloat width;
    CGFloat height;
}
@end

@implementation YdBZxiangqingViewController

-(void)request: (NSString*)httpUrl withHttpArg: (NSString*)HttpArg  {
    NSString *urlStr = [[NSString alloc]initWithFormat: @"%@?%@", httpUrl, HttpArg];
    NSURL *url = [NSURL URLWithString: urlStr];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL: url cachePolicy: NSURLRequestUseProtocolCachePolicy timeoutInterval: 10];
    [request setHTTPMethod: @"GET"];
    [request addValue: @"8cbada9d05fbb4a8966a0060adb0c1c8" forHTTPHeaderField: @"apikey"];
    [NSURLConnection sendAsynchronousRequest: request
                                       queue: [NSOperationQueue mainQueue]
                           completionHandler: ^(NSURLResponse *response, NSData *data, NSError *error){
                               if (error) {
                                   NSLog(@"Httperror: %@%ld", error.localizedDescription, error.code);
                               } else {
                                   NSInteger responseCode = [(NSHTTPURLResponse *)response statusCode];
                                   NSString *responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                   NSLog(@"HttpResponseCode:%ld", responseCode);
                                   NSLog(@"HttpResponseBody %@",responseString);
                                   
                                   UIWebView *web = [[UIWebView alloc]init];
                                   web.frame = CGRectMake(0, 64, width, height - 64);
                                   [self.view addSubview:web];
                                   
                                   NSDictionary *content = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];//转换数据格式
                                   NSLog(@"%@",content);
                                   NSMutableString *str=[[NSMutableString alloc]init];
                                   [str appendString:[content objectForKey:@"name"]];
                                   [str appendString:[content objectForKey:@"causetext"]];
                                   [str appendString:[content objectForKey:@"description"]];
                                   [str appendString:[content objectForKey:@"detailtext"]];
                                   [str appendString:[content objectForKey:@"disease"]];
                                   [str appendString:[content objectForKey:@"drug"]];
                                   [str appendString:[content objectForKey:@"place"]];
                                   [str appendString:[content objectForKey:@"message"]];
                                   
                                   [web loadHTMLString:str baseURL:nil];

                               }
                           }];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    width = [UIScreen mainScreen].bounds.size.width;
    height = [UIScreen mainScreen].bounds.size.height;
    
    //状态栏名称
    self.navigationItem.title = @"病症详情";
    
    //设置导航栏左按钮
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"@3x_xx_06.png"] style:UIBarButtonItemStyleDone target:self action:@selector(fanhui)];
    
    NSString *strB = [self.mingcheng stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *httpUrl = @"http://apis.baidu.com/tngou/symptom/name";
    NSString *httpArg = [NSString stringWithFormat:@"name=%@",strB];
    [self request: httpUrl withHttpArg: httpArg];
    
    
}

-(void)fanhui
{
    //返回上一页
    [self.navigationController popViewControllerAnimated:YES];
}

@end
