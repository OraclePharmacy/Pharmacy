//
//  YdfabiaopinglunViewController.m
//  Pharmacy
//
//  Created by suokun on 16/5/13.
//  Copyright © 2016年 sk. All rights reserved.
//

#import "YdfabiaopinglunViewController.h"
#import "Color+Hex.h"
#import "WarningBox.h"
#import "AFNetworking 3.0.4/AFHTTPSessionManager.h"
#import "SBJson.h"
#import "hongdingyi.h"
#import "lianjie.h"


@interface YdfabiaopinglunViewController ()
{
    UILabel *tishi;
    
    CGFloat width;
    CGFloat height;
}
@end

@implementation YdfabiaopinglunViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSDictionary* s=[NSDictionary dictionaryWithObjectsAndKeys:@"哈哈哈",@"ij", nil];
    width = [UIScreen mainScreen].bounds.size.width;
    height = [UIScreen mainScreen].bounds.size.height;
    
    //状态栏名称
    self.navigationItem.title = @"发表评论";
    //设置self.view背景颜色
    self.view.backgroundColor = [UIColor colorWithHexString:@"f4f4f4" alpha:1];
    //设置导航栏左按钮
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"@3x_xx_06.png"] style:UIBarButtonItemStyleDone target:self action:@selector(fanhui)];
    
    [self kongjian];
    
}
-(void)textViewDidBeginEditing:(UITextView *)textView{
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"完成" style:UIBarButtonItemStyleDone target:self action:@selector(wancheng)];
}
-(void)wancheng{
    [self.view endEditing:YES];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"" style:UIBarButtonItemStyleDone target:self action:nil];
}
-(void)kongjian
{
    
    self.pinglunText = [[UITextView alloc]init];
    self.pinglunText.frame = CGRectMake(10, 74, width - 20, height / 3);
    self.pinglunText.delegate = self;
    self.pinglunText.layer.cornerRadius = 8;
    self.pinglunText.layer.borderColor = [[UIColor colorWithHexString:@"e2e2e2" alpha:1] CGColor];
    self.pinglunText.layer.borderWidth =1;
    [self.view addSubview:self.pinglunText];
    
    tishi = [[UILabel alloc]init];
    tishi.frame = CGRectMake(5, 5, 150, 21);
    tishi.textColor = [UIColor colorWithHexString:@"c8c8c8" alpha:1];
    tishi.font = [UIFont systemFontOfSize:13];
    tishi.text = @"请添加内容...";
    [self.pinglunText addSubview:tishi];
    
    self.pinglunNutton.layer.cornerRadius = 5;
    self.pinglunNutton.layer.masksToBounds = YES;
    
}
-(void)textViewDidChange:(UITextView *)textView
{
    
    if (textView.text.length == 0) {
        tishi.text = @"请添加内容...";
    }else{
        tishi.text = @"";
    }
}

//点击编辑区以外的地方键盘消失
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    
     self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"" style:UIBarButtonItemStyleDone target:self action:nil];
    [self.pinglunText resignFirstResponder];
    
}

-(void)fanhui
{
    //返回上一页
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)pinglunButton:(id)sender {
    
    [self.view endEditing:YES];
    NSString *path1 =[NSHomeDirectory() stringByAppendingString:@"/Documents/GRxinxi.plist"];
    
    NSFileManager * fm=[NSFileManager defaultManager];
    if (self.pinglunText.text.length > 0)
    {
        if (![fm fileExistsAtPath:path1]) {
            [WarningBox warningBoxModeText:@"请先完善个人资料!" andView:self.view];
        }else{
            NSDictionary* du=[NSDictionary dictionaryWithContentsOfFile:path1];
            if (NULL == [du objectForKey:@"age"]) {
                [WarningBox warningBoxModeText:@"请先完善个人资料!" andView:self.view];
            }else{
                
                [WarningBox warningBoxModeIndeterminate:@"评论中..." andView:self.view];
                //userID    暂时不用改
                NSString * userID=@"0";
                
                //请求地址   地址不同 必须要改
                NSString * url =@"/share/saveReply";
                
                //时间戳
                NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
                NSTimeInterval a=[dat timeIntervalSince1970];
                NSString *timeSp = [NSString stringWithFormat:@"%.0f",a];
                
                
                //将上传对象转换为json格式字符串
                AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
                manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json",@"text/plain",@"text/html", nil];
                SBJsonWriter *writer = [[SBJsonWriter alloc]init];
                NSString*vip=[[NSUserDefaults standardUserDefaults] objectForKey:@"vipId"];        //出入参数：
                if ([_pinglunID isEqualToString:@""]||_pinglunID==nil||[_pinglunID isEqual:[NSNull null]])
                {
                    _pinglunID = @"";
                }
                
                
                
                NSDictionary*datadic=[NSDictionary dictionaryWithObjectsAndKeys:_pinglunID,@"parentId",_pinglunText.text, @"reply",vip,@"vipId",_tieziID,@"id",nil];
                
                NSString*jsonstring=[writer stringWithObject:datadic];
                
                //获取签名
                NSString*sign= [lianjie getSign:url :userID :jsonstring :timeSp];
                
                NSString *url1=[NSString stringWithFormat:@"%@%@%@%@",service_host,app_name,api_url,url];
                
                //电泳借口需要上传的数据
                NSDictionary*dic=[NSDictionary dictionaryWithObjectsAndKeys:jsonstring,@"params",appkey, @"appkey",userID,@"userid",sign,@"sign",timeSp,@"timestamp", nil];
                
                [manager POST:url1 parameters:dic progress:^(NSProgress * _Nonnull downloadProgress) {
                    
                } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                    [WarningBox warningBoxHide:YES andView:self.view];
                    @try
                    {
                        if ([[responseObject objectForKey:@"code"] intValue]==0000) {
                            [WarningBox warningBoxModeText:@"评论成功" andView:self.view];
                
                            self.pinglunText.text = @"";
                            //返回上一页
                            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                [self.navigationController popViewControllerAnimated:YES];
                            });
                            
                            
                        }else{
                            [WarningBox warningBoxModeText:@"评论失败" andView:self.view];
                    
                        
                        }
                    }
                    @catch (NSException * e) {
                        
                        [WarningBox warningBoxModeText:@"请检查你的网络连接!" andView:self.view];
                        
                    }
                    
                    
                } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                    [WarningBox warningBoxHide:YES andView:self.view];
                    [WarningBox warningBoxModeText:@"网络连接失败！" andView:self.view];
                }];
            }
        }
    }
    else
    {
        [WarningBox warningBoxModeText:@"评论不能为空!!!" andView:self.view];
    }
    
}
@end
