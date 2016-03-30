//
//  YdSearchViewController.m
//  Pharmacy
//
//  Created by suokun on 16/3/19.
//  Copyright © 2016年 sk. All rights reserved.
//

#import "YdSearchViewController.h"
#import "YdSearchResultViewController.h"

@interface YdSearchViewController ()
{
    
    CGFloat width;
    CGFloat height;
    
    UITextField *SearchText;
    
}
@end

@implementation YdSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    width = [UIScreen mainScreen].bounds.size.width;
    height = [UIScreen mainScreen].bounds.size.height;
    
    //设置self.view背景颜色
    self.view.backgroundColor = [UIColor whiteColor];
    //设置导航栏左按钮
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"@3x_xx_06.png"] style:UIBarButtonItemStyleDone target:self action:@selector(fanhui)];
    //设置导航栏右按钮
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"@3x_xx_06.png"] style:UIBarButtonItemStyleDone target:self action:@selector(search)];

    [self CreateSearch];
    
}

-(void)CreateSearch
{
    //创建textfield
    //设置基本属性
    SearchText = [[UITextField alloc]init];
    
    SearchText.frame = CGRectMake(0 , 0, width, 20);
    
    SearchText.placeholder = @" 输入药品、病症";
    
    SearchText.delegate=self;
    
    SearchText.font = [UIFont systemFontOfSize:13];
    
    SearchText.layer.borderColor = [[UIColor grayColor] CGColor];
    
    SearchText.layer.borderWidth =1;
    
    SearchText.layer.cornerRadius = 5.0;
    
    self.navigationItem.titleView = SearchText;

}
//点击编辑区以外的地方键盘消失
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    
    [SearchText resignFirstResponder];
    
}


//导航栏右按钮方法
-(void)search
{
    //隐藏键盘
    [self.navigationItem.titleView endEditing:YES];

    //跳转到病症/药品界面
    YdSearchResultViewController *SearchResult = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"searchresult"];
    [self.navigationController pushViewController:SearchResult animated:YES];

}
//导航栏左按钮方法
-(void)fanhui
{
    //隐藏键盘
    [self.navigationItem.titleView endEditing:YES];
    //返回上一页
    [self.navigationController popViewControllerAnimated:YES];
}
@end
