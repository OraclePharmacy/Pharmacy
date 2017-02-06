//
//  zizhiViewController.m
//  Pharmacy
//
//  Created by 小狼 on 2017/1/18.
//  Copyright © 2017年 sk. All rights reserved.
//

#import "zizizhiViewController.h"
#import "hongdingyi.h"

@interface zizizhiViewController ()<UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *webview;

@end

@implementation zizizhiViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor whiteColor];
    self.navigationController.title=@"资质";
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@%@",service_host,app_name,_url]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    self.webview.delegate = self;
    [self.webview loadRequest:request];
}

@end
