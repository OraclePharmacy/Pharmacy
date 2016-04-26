//
//  YdTurntableViewController.m
//  Pharmacy
//
//  Created by suokun on 16/4/7.
//  Copyright © 2016年 sk. All rights reserved.
//

#import "YdTurntableViewController.h"
#import "WarningBox.h"
@interface YdTurntableViewController ()<UIWebViewDelegate>{
    int i;
}
@property (weak, nonatomic) IBOutlet UIWebView *webview;
@end

@implementation YdTurntableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    i=0;
    [WarningBox warningBoxModeIndeterminate:@"页面加载中....." andView:self.view];
    _webview.hidden=YES;
    //状态栏名称
    self.navigationItem.title = @"大转盘";
    //设置self.view背景颜色
    self.view.backgroundColor = [UIColor whiteColor];
    //设置导航栏左按钮
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"@3x_xx_06.png"] style:UIBarButtonItemStyleDone target:self action:@selector(fanhui)];
     _webview.delegate=self;
    NSString * path=@"http://www.baidu.com";
    NSURL *url=[NSURL URLWithString:path];
    [_webview loadRequest:[NSURLRequest requestWithURL:url]];
    
   
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)fanhui
{
    //返回上一页
    [self.navigationController popViewControllerAnimated:YES];
}


-(void)webViewDidFinishLoad:(UIWebView *)webView{
    i++;
    [WarningBox warningBoxHide:YES andView:self.view];
    _webview.hidden=NO;
    NSLog(@"%d",i);
    if (i==2) {
//        xixiix*xixi=[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"xixi"];
//        NSLog(@"url====  %@",_webview.request.URL.absoluteURL);
//        [self presentViewController:xixi animated:YES completion:nil];
    }
    
}

@end
