//
//  YdInformationViewController.m
//  Pharmacy
//
//  Created by suokun on 16/4/6.
//  Copyright © 2016年 sk. All rights reserved.
//

#import "YdInformationViewController.h"

@interface YdInformationViewController ()
{
    int index;
    int zhi ;
    
    CGFloat width;
    CGFloat height;
    
}
@end

@implementation YdInformationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    width = [UIScreen mainScreen].bounds.size.width;
    height = [UIScreen mainScreen].bounds.size.height;
    
    //设置分段控制器的默认选项
    self.Segmented.selectedSegmentIndex = 0;
    //解决tableview多出的白条
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    //设置导航栏左按钮
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"圆角矩形-6@3x.png"] style:UIBarButtonItemStyleDone target:self action:@selector(presentLeftMenuViewController:)];
    
}

//组
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (zhi == 1) {
        return 0;
    }
    else
    {
    return 1;

    }
}
//行
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (zhi == 1) {
        return 0;
    }
    else
    {
        return 0;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    if (zhi == 1) {
        return 0;
    }
    else
    {
        return 1;
    }
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *id1 =@"cell1";
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:id1];
    }
    
    
    if (zhi == 1) {
        
    }
    else
    {
       
        
    }

    
    //cell点击不变色
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    //线消失
    self.tableview.separatorStyle = UITableViewCellSelectionStyleNone;
    //隐藏滑动条
    self.tableview.showsVerticalScrollIndicator =NO;
    
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
   
}

//分段控制器  点击方法
- (IBAction)Segmented:(id)sender {
    index = (int)self.Segmented.selectedSegmentIndex;
    if (index == 0 ) {
        zhi = 1;
        [self.tableview reloadData];
    }
    else if(index == 1){
        zhi = 2;
        self.tableview.frame = CGRectMake(0, 64,width, height-64-40);
       
        [self.tableview reloadData];
    }

}
@end
