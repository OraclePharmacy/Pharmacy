//
//  YdSheZhiTableViewController.m
//  Pharmacy
//
//  Created by suokun on 16/6/6.
//  Copyright © 2016年 sk. All rights reserved.
//

#import "YdSheZhiTableViewController.h"
#import "Color+Hex.h"
#import "YdModifyViewController.h"
#import "guanyuViewController.h"
#import "WarningBox.h"
#import "tiaodaodenglu.h"
@interface YdSheZhiTableViewController ()
@property (nonatomic, strong) UIView *tableFooterView;
@end

@implementation YdSheZhiTableViewController

-(void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.tableFooterView = [[UIView alloc] init];
    
    //状态栏名称
    self.navigationItem.title = @"设置";
    
    //设置导航栏左按钮
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"@3x_xx_06.png"] style:UIBarButtonItemStyleDone target:self action:@selector(fanhui)];
    
    self.tableView.scrollEnabled =NO; //设置tableview 不能滚动
    
    self.view.backgroundColor = [UIColor colorWithHexString:@"f4f4f4" alpha:1];
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        if (indexPath.row == 0)
        {
            if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"isLogin"] isEqualToString:@"NO"]) {
                [tiaodaodenglu jumpToLogin:self.navigationController];
            }else{
                YdModifyViewController *ModifyViewController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"modify"];
                
                [self.navigationController pushViewController:ModifyViewController animated:YES];
            }
        }
        else if (indexPath.row == 1)
        {
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"是否退出登录?" delegate:self cancelButtonTitle:@"否" otherButtonTitles:@"是", nil];
            
            [alert show];
            
            
        }
        
    }
    else if (indexPath.section == 1)
    {
        if (indexPath.row == 0)
        {
            
            guanyuViewController * guanyu = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"guanyu"];
            
            [self.navigationController pushViewController: guanyu animated:YES];
            
        }
        
    }
    
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==0) {
        
    }else{
        if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"isLogin"] isEqualToString:@"YES"]) {
            [[NSUserDefaults standardUserDefaults] setObject:@"NO" forKey:@"isLogin"];
            [self.navigationController popViewControllerAnimated:YES];
            [self.navigationController setNavigationBarHidden:YES animated:NO];
            
            //清除plist文件，可以根据我上面讲的方式进去本地查看plist文件是否被清除
            NSFileManager *fileMger = [NSFileManager defaultManager];
            
            NSString *xiaoXiPath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)objectAtIndex:0]stringByAppendingPathComponent:@"RememberPass.plist"];
            
            //如果文件路径存在的话
            BOOL bRet = [fileMger fileExistsAtPath:xiaoXiPath];
            
            if (bRet) {
                
                NSError *err;
                
                [fileMger removeItemAtPath:xiaoXiPath error:&err];
            }
            
        }else{
            [WarningBox warningBoxModeText:@"还未登录..." andView:self.view];
        }
    }
}

//返回
-(void)fanhui
{
    //返回上一页
    [self.navigationController popToRootViewControllerAnimated:YES];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}

@end
