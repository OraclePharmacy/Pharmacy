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
     self.automaticallyAdjustsScrollViewInsets = NO;
    NSURL *url = [NSURL URLWithString:_uu];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    self.webview.delegate = self;
    
    [self.webview loadRequest:request];
}
-(void)webViewDidFinishLoad:(UIWebView *)webView{
    NSString *vip=[[NSUserDefaults standardUserDefaults] objectForKey:@"vipId"];
    NSString*offceId=[[NSUserDefaults standardUserDefaults] objectForKey:@"officeid"];
    NSString*s=[NSString stringWithFormat:@"%@,%@",vip,offceId];
    [self.webview stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"javascript:javacalljswithargs(' + %@ + ')",s]];

    //webView.loadUrl("javascript:javacalljswithargs('" + s + "')");
    
    
}
-(void)webViewDidStartLoad:(UIWebView *)webView{
    NSString *vip=[[NSUserDefaults standardUserDefaults] objectForKey:@"vipId"];
    NSString*offceId=[[NSUserDefaults standardUserDefaults] objectForKey:@"officeid"];
    NSString*s=[NSString stringWithFormat:@"%@,%@",vip,offceId];
    [self.webview stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"javascript:javacalljswithargs(' + %@ + ')",s]];
}
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    NSString *url = request.URL.absoluteString;
    NSLog(@"打印请求的URL-->%@", url);
   
    [self getValue];
    return YES;
}

- (void)getValue {
    NSString *vip=[[NSUserDefaults standardUserDefaults] objectForKey:@"vipId"];
    NSString*offceId=[[NSUserDefaults standardUserDefaults] objectForKey:@"officeid"];
    
    
    
    NSMutableString *js = [NSMutableString string];
    [js appendString:[NSString stringWithFormat:@"%@,%@",vip,offceId]];
    [self.webview stringByEvaluatingJavaScriptFromString:js];
}


@end
