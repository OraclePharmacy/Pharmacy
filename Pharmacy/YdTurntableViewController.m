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
    self.navigationController.interactivePopGestureRecognizer.enabled = NO; 
     self.automaticallyAdjustsScrollViewInsets = NO;
    NSURL *url = [NSURL URLWithString:_uu];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    self.webview.delegate = self;
    _webview.userInteractionEnabled=NO;
    [self.webview loadRequest:request];
}

-(void)webViewDidFinishLoad:(UIWebView *)webView{
    NSString *vip=[[NSUserDefaults standardUserDefaults] objectForKey:@"vipId"];
    NSString*offceId=[[NSUserDefaults standardUserDefaults] objectForKey:@"officeid"];
    NSString*s=[NSString stringWithFormat:@"%@,%@",vip,offceId];
    [self.webview stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"javascript:javacalljswithargs('%@')",s]];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
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
