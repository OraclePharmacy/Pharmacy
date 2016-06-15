//
//  YdShoppingCartViewController.m
//  Pharmacy
//
//  Created by suokun on 16/3/19.
//  Copyright © 2016年 sk. All rights reserved.
//

#import "YdShoppingCartViewController.h"
#import "UIImageView+WebCache.h"
#import "hongdingyi.h"
#import "Color+Hex.h"
#import "YdshoppingxiangshiViewController.h"
#import "YdlianxidianzhangViewController.h"

@interface YdShoppingCartViewController ()
{
    
    CGFloat width;
    CGFloat height;
    
    int aa;
    UIBarButtonItem *right;
    UIBarButtonItem *right1;
    UIView * di;
    
    UITextField *num;

    NSMutableArray* yikaishi;
}

@end

@implementation YdShoppingCartViewController
-(void)viewWillAppear:(BOOL)animated{
    
    NSString *countwenjian=[NSString stringWithFormat:@"%@/Documents/Dingdanxinxi.plist",NSHomeDirectory()];
    
    NSLog(@"%@",countwenjian);
    NSFileManager *file=[NSFileManager defaultManager];
    
    if([file fileExistsAtPath:countwenjian]){
        yikaishi=[NSMutableArray arrayWithContentsOfFile:countwenjian];
        _lianxidianzhnag.hidden=NO;
        _tijiao.hidden=NO;
    }else{
        yikaishi=nil;
        _lianxidianzhnag.hidden=YES;
        _tijiao.hidden=YES;
    }
    [_tableview reloadData];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    aa = 1;
    
    width = [UIScreen mainScreen].bounds.size.width;
    height = [UIScreen mainScreen].bounds.size.height;
    
    //状态栏名称
    self.navigationItem.title = @"全部订单";
    //设置self.view背景颜色
    self.view.backgroundColor = [UIColor whiteColor];
    //设置导航栏左按钮
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"圆角矩形-6@3x.png"] style:UIBarButtonItemStyleDone target:self action:@selector(presentLeftMenuViewController:)];
    self.tableview.dataSource = self;
    self.tableview.delegate = self;
    
    right = [[UIBarButtonItem alloc]initWithTitle:@"编辑" style:UIBarButtonItemStylePlain target:self action:@selector(bianij)];
    right1 = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(baocun)];
    self.navigationItem.rightBarButtonItem = right;
    
    //解决tableview多出的白条
    self.automaticallyAdjustsScrollViewInsets = NO;
}
//点击编辑区以外的地方键盘消失
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    
    [num resignFirstResponder];
    
}
//限制输入框长度
-(void)NumberLength
{   
    int MaxLen = 4;
    NSString* szText = [num text];
    if ([num.text length]> MaxLen)
    {
        num.text = [szText substringToIndex:MaxLen];
    }
}

//组
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
//行
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return yikaishi.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    return 100;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *id1 =@"cell1";
    UITableViewCell *cell;
    cell = [tableView cellForRowAtIndexPath:indexPath];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:id1];
    }
    //药品图片
    UIImageView *image = [[UIImageView alloc]init];
    image.frame = CGRectMake(10, 10, 80, 80);
    [image sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/hyb/%@",service_host,[yikaishi[indexPath.row]objectForKey:@"picUrl"]]] placeholderImage:[UIImage imageNamed:@"IMG_0800.jpg"]];
    image.layer.cornerRadius=30;
  
    //药品名称
    UILabel *name = [[UILabel alloc]init];
    name.frame = CGRectMake(100, 10, 200, 20);
    name.text = [NSString stringWithFormat:@"%@",[[yikaishi[indexPath.row] objectForKey:@"product"] objectForKey:@"commonName"]];
    name.textColor = [UIColor colorWithHexString:@"323232" alpha:1];
    name.font =[UIFont systemFontOfSize:15];
    //name.backgroundColor = [UIColor redColor];
   
    
    UILabel *yuanjia = [[UILabel alloc]init];
    yuanjia.frame = CGRectMake(100, 30, 70, 20);
    yuanjia.text = @"原价:99.8";
    yuanjia.textColor = [UIColor colorWithHexString:@"646464" alpha:1];
    yuanjia.font =[UIFont systemFontOfSize:13];
    
    
    UILabel *tejia = [[UILabel alloc]init];
    tejia.frame = CGRectMake(170, 30, 70, 20);
    tejia.text = @"特价:99.8";
    tejia.textColor = [UIColor colorWithHexString:@"646464" alpha:1];
    tejia.font =[UIFont systemFontOfSize:13];
    
    
    //生产厂家
    UILabel *changjia = [[UILabel alloc]init];
    changjia.frame = CGRectMake(100, 50, 60, 20);
    changjia.text = @"生产厂家:";
    changjia.textColor = [UIColor colorWithHexString:@"646464" alpha:1];
    changjia.font =[UIFont systemFontOfSize:13];
    //changjia.backgroundColor = [UIColor colorWithHexString:@"646464" alpha:1];
   
    
    UILabel *vender = [[UILabel alloc]init];
    vender.frame = CGRectMake( 160, 50, width - 160 , 20);
    vender.text = [NSString stringWithFormat:@"%@",[[yikaishi[indexPath.row] objectForKey:@"product"] objectForKey:@"manufacturer"]];
    vender.textColor = [UIColor colorWithHexString:@"646464" alpha:1];
    vender.font =[UIFont systemFontOfSize:12];
   
    
    
    //添加数量按钮
    UIButton *add = [[UIButton alloc]init];
    add.frame = CGRectMake(100, 72, 16, 16);
    [add setImage:[UIImage imageNamed:@"IMG_0799.jpg"] forState:UIControlStateNormal];
    
    //数量输入框
    num = [[UITextField alloc]init];
    num.delegate=self;
    num.font = [UIFont systemFontOfSize:12];
    num.layer.borderColor = [[UIColor grayColor] CGColor];
    [num addTarget:self action:@selector(NumberLength) forControlEvents:UIControlEventEditingChanged];
    //删减数量按钮
    UIButton *reduce = [[UIButton alloc]init];
    reduce.frame = CGRectMake(174,72, 16, 16);
    [reduce setImage:[UIImage imageNamed:@"IMG_0799.jpg"] forState:UIControlStateNormal];
   
    
    if (aa == 1 )
    {
        num.frame = CGRectMake(100, 70, 50, 20);
        num.text=[NSString stringWithFormat:@"数量:%@",[yikaishi[indexPath.row]objectForKey:@"shuliang"]];
        num.textColor = [UIColor colorWithHexString:@"646464" alpha:1];
        [cell.contentView addSubview:image];
        [cell.contentView addSubview:name];
        [cell.contentView addSubview:yuanjia];
        [cell.contentView addSubview:tejia];
        [cell.contentView addSubview:changjia];
        [cell.contentView addSubview:vender];
        [cell.contentView addSubview:num];
    }
    else
    {
        num.text=[NSString stringWithFormat:@"%@",[yikaishi[indexPath.row]objectForKey:@"shuliang"]];
        num.frame = CGRectMake(120, 70, 50, 20);
        num.layer.borderWidth =1;
        num.layer.cornerRadius = 5.0;
        num.textAlignment = NSTextAlignmentCenter;
        [cell.contentView addSubview:image];
        [cell.contentView addSubview:name];
        [cell.contentView addSubview:yuanjia];
        [cell.contentView addSubview:tejia];
        [cell.contentView addSubview:changjia];
        [cell.contentView addSubview:vender];
        [cell.contentView addSubview:add];
        [cell.contentView addSubview:num];
        [cell.contentView addSubview:reduce];
    }
    
    
    //cell点击不变色
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    //线消失
    //self.tableview.separatorStyle = UITableViewCellSelectionStyleNone;
    //隐藏滑动条
    self.tableview.showsVerticalScrollIndicator =NO;
   
   
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //隐藏键盘
    [self.view endEditing:YES];
    
}
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath      //当在Cell上滑动时会调用此函数
{
    if (aa == 2) {
        
         return  UITableViewCellEditingStyleDelete;   //返回此值时,Cell上不会出现Delete按键,即Cell不做任何响应
    }
   
    return 0;
}
- (void) tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath //对选中的Cell根据editingStyle进行操作
{
    
        if (editingStyle == UITableViewCellEditingStyleDelete) {
            
            //删除字典内容
            
            [yikaishi removeObjectAtIndex:indexPath.row];
            if (yikaishi.count==0) {
                yikaishi=nil;
            }
            [self.tableview deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            
            [self.tableview reloadData];
        }
        else if (editingStyle == UITableViewCellEditingStyleInsert)
        {
            [self.tableview reloadData];
        }
    
}
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (aa == 2) {
        
        return YES;
    }
    return NO;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.view endEditing:YES];
    
    
    return YES;
}

- (IBAction)tijiaoanniu:(id)sender {
    
    //显示订单详情，包括总价钱等等
    YdshoppingxiangshiViewController *shoppingxiangshi = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"shoppingxiangshi"];
    [self.navigationController pushViewController:shoppingxiangshi animated:YES];

}
-(void)bianij
{
    aa=2;

    self.navigationItem.rightBarButtonItem = right1;
    [self.tableview reloadData];
    
    di = [[UIView alloc]initWithFrame:CGRectMake(0, 0, width, height)];
    di.backgroundColor = [UIColor colorWithHexString:@"000000" alpha:0.3];
    UIButton *quan = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, width, height)];
    [quan addTarget:self action:@selector(xiaoshi) forControlEvents:UIControlEventTouchUpInside];
    
    UIImageView *iam = [[UIImageView alloc]initWithFrame:CGRectMake(width/2-50, height/3, 100 , 100)];
    iam.image = [UIImage imageNamed:@"huadong.png"];
    
    UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(0, height/2, width, 25)];
    lab.font = [UIFont systemFontOfSize:17];
    lab.textColor = [UIColor whiteColor];
    //    lab.textAlignment = NSTextAlignmentLeft;
    lab.textAlignment = NSTextAlignmentCenter;
    lab.text = @"*  向左侧拉删除";

    
}
-(void)baocun
{

    aa=1;
            
    self.navigationItem.rightBarButtonItem = right;
    
    [self.tableview reloadData];

}
-(void)xiaoshi
{
    
    di.hidden = YES;
    
}
- (IBAction)dianzhanganniu:(id)sender {
    
    //聊天界面，聊天的对象是店长。。。。
    YdlianxidianzhangViewController *lianxidianzhang = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"lianxidianzhang"];
    [self.navigationController pushViewController:lianxidianzhang animated:YES];
    
}
@end
