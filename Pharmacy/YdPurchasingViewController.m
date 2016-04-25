//
//  YdPurchasingViewController.m
//  Pharmacy
//
//  Created by suokun on 16/4/22.
//  Copyright © 2016年 sk. All rights reserved.
//

#import "YdPurchasingViewController.h"
#import "Color+Hex.h"

@interface YdPurchasingViewController ()
{
    UILabel *tishi;
}
@end

@implementation YdPurchasingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //状态栏名称
    self.navigationItem.title = @"代购药";
    //设置导航栏左按钮
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"@3x_xx_06.png"] style:UIBarButtonItemStyleDone target:self action:@selector(fanhui)];
    self.yuding.layer.cornerRadius = 8;
    self.yuding.layer.masksToBounds = YES;
    
    self.beizhu.delegate = self;
    self.beizhu.layer.cornerRadius = 8;
    self.beizhu.layer.borderColor = [[UIColor colorWithHexString:@"e2e2e2" alpha:1] CGColor];
    self.beizhu.layer.borderWidth =1;
    
    self.nametext.layer.cornerRadius = 8;
    self.nametext.layer.borderColor = [[UIColor colorWithHexString:@"e2e2e2" alpha:1] CGColor];
    self.nametext.layer.borderWidth =1;

    self.guigetext.layer.cornerRadius = 8;
    self.guigetext.layer.borderColor = [[UIColor colorWithHexString:@"e2e2e2" alpha:1] CGColor];
    self.guigetext.layer.borderWidth =1;
    
    self.changjiatext.layer.cornerRadius = 8;
    self.changjiatext.layer.borderColor = [[UIColor colorWithHexString:@"e2e2e2" alpha:1] CGColor];
    self.changjiatext.layer.borderWidth =1;
    
    self.shuliangtext.layer.cornerRadius = 8;
    self.shuliangtext.layer.borderColor = [[UIColor colorWithHexString:@"e2e2e2" alpha:1] CGColor];
    self.shuliangtext.layer.borderWidth =1;
    
    self.pizhuntext.layer.cornerRadius = 8;
    self.pizhuntext.layer.borderColor = [[UIColor colorWithHexString:@"e2e2e2" alpha:1] CGColor];
    self.pizhuntext.layer.borderWidth =1;
    

    tishi = [[UILabel alloc]init];
    tishi.frame = CGRectMake(5, 5, 150, 21);
    tishi.textColor = [UIColor colorWithHexString:@"c8c8c8" alpha:1];
    tishi.font = [UIFont systemFontOfSize:13];
    tishi.text = @"请对药品进行备注...";
    
    [_beizhu addSubview:tishi];

}

//点击编辑区以外的地方键盘消失
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    
    [self.beizhu resignFirstResponder];
    [self.nametext resignFirstResponder];
    [self.guigetext resignFirstResponder];
    [self.changjiatext resignFirstResponder];
    [self.shuliangtext resignFirstResponder];
    [self.pizhuntext resignFirstResponder];
    
}

-(void)textViewDidChange:(UITextView *)textView
{
    
    if (textView.text.length == 0) {
        tishi.text = @"请对药品进行备注...";
    }else{
        tishi.text = @"";
    }
}

-(void)fanhui
{
    //返回上一页
    [self.navigationController popViewControllerAnimated:YES];
}
//照片1
- (IBAction)one:(id)sender {
    [self.view endEditing:YES];
}
//照片2
- (IBAction)two:(id)sender {
    [self.view endEditing:YES];
}
//照片3
- (IBAction)three:(id)sender {
    [self.view endEditing:YES];
}
//预定按钮
- (IBAction)yuding:(id)sender {
    [self.view endEditing:YES];
}
@end
