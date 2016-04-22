//
//  YdElectronicsViewController.m
//  Pharmacy
//
//  Created by suokun on 16/4/13.
//  Copyright © 2016年 sk. All rights reserved.
//

#import "YdElectronicsViewController.h"
#import "YdRecordListViewController.h"
#import "Color+Hex.h"
@interface YdElectronicsViewController ()
{
    UILabel *tishi;
}
@end

@implementation YdElectronicsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //状态栏名称
    self.navigationItem.title = @"电子病历";
    //设置导航栏左按钮
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"@3x_xx_06.png"] style:UIBarButtonItemStyleDone target:self action:@selector(fanhui)];
    //设置导航栏右按钮
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"列表" style:UIBarButtonItemStyleDone target:self action:@selector(liebiao)];
    
    self.tijiao.layer.cornerRadius = 8;
    self.tijiao.layer.masksToBounds = YES;
    
    self.writeText.delegate = self;
    self.writeText.layer.cornerRadius = 8;
    self.writeText.layer.borderColor = [[UIColor colorWithHexString:@"e2e2e2" alpha:1] CGColor];
    self.writeText.layer.borderWidth =1;

    self.titleText.layer.cornerRadius = 8;
    self.titleText.layer.borderColor = [[UIColor colorWithHexString:@"e2e2e2" alpha:1] CGColor];
    self.titleText.layer.borderWidth =1;

    
    
    tishi = [[UILabel alloc]init];
    tishi.frame = CGRectMake(5, 5, 150, 21);
    tishi.textColor = [UIColor colorWithHexString:@"c8c8c8" alpha:1];
    tishi.font = [UIFont systemFontOfSize:13];
    tishi.text = @"请对病历进行备注...";
    
    [_writeText addSubview:tishi];

}

-(void)textViewDidChange:(UITextView *)textView
{
    
    if (textView.text.length == 0) {
        tishi.text = @"请对病历进行备注...";
    }else{
        tishi.text = @"";
    }
}





//电子病历列表跳转
-(void)liebiao
{
    YdRecordListViewController *RecordList = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"recordlist"];
    [self.navigationController pushViewController:RecordList animated:YES];
}

-(void)fanhui
{
    //返回上一页
    [self.navigationController popViewControllerAnimated:YES];
}



- (IBAction)first:(id)sender {
}
- (IBAction)second:(id)sender {
}
- (IBAction)third:(id)sender {
}
- (IBAction)tijiao:(id)sender {
}
@end
