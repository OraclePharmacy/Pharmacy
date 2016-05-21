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

@interface YdShoppingCartViewController ()
{
    
    CGFloat width;
    CGFloat height;
    
    
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
        
    }else{
        yikaishi=nil;
    }
    [_tableview reloadData];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
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
    return width/3+1;
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
    image.frame = CGRectMake(10, 5, width/3-10, width/3-10);
    [image sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/hyb/%@",service_host,[yikaishi[indexPath.row]objectForKey:@"picUrl"]]] placeholderImage:[UIImage imageNamed:@"IMG_0800.jpg"]];
    image.layer.cornerRadius=30;
    [cell.contentView addSubview:image];
    //药品名称
    UILabel *name = [[UILabel alloc]init];
    name.frame = CGRectMake(width/3+10, 0, width/3*2-10, width/3/3-10);
    name.text = [NSString stringWithFormat:@"%@",[yikaishi[indexPath.row]objectForKey:@"commonName"]];
    name.textColor = [UIColor blackColor];
    name.font =[UIFont systemFontOfSize:15];
    //name.backgroundColor = [UIColor redColor];
    [cell.contentView addSubview:name];
    //药品数量
    UILabel *number = [[UILabel alloc]init];
    number.frame = CGRectMake( width/3+10, width/3/3-10, width/3*2-10, width/3/6);
    number.text = @"预订数量:";
    number.textColor = [UIColor blackColor];
    number.font =[UIFont systemFontOfSize:12];
    //number.backgroundColor = [UIColor yellowColor];
    [cell.contentView addSubview:number];
    //添加数量按钮
    UIButton *add = [[UIButton alloc]init];
    add.frame = CGRectMake(width/3+5+5, width/3/3+width/3/6, width/3/6, width/3/6);
    [add setImage:[UIImage imageNamed:@"IMG_0799.jpg"] forState:UIControlStateNormal];
    [cell.contentView addSubview:add];
    //数量输入框
    num = [[UITextField alloc]init];
    num.frame = CGRectMake(width/3+5+width/3/6+5, width/3/3+width/3/6, width/3/3, width/3/6);
    num.delegate=self;
    num.font = [UIFont systemFontOfSize:13];
    num.layer.borderColor = [[UIColor grayColor] CGColor];
    num.layer.borderWidth =1;
    num.layer.cornerRadius = 5.0;
    [num addTarget:self action:@selector(NumberLength) forControlEvents:UIControlEventEditingChanged];
    num.text=[NSString stringWithFormat:@"%@",[yikaishi[indexPath.row]objectForKey:@"shuliang"]];
              [cell.contentView addSubview:num];
              //删减数量按钮
              UIButton *reduce = [[UIButton alloc]init];
              reduce.frame = CGRectMake(width/3+5+width/3/6+width/3/3+5, width/3/3+width/3/6, width/3/6, width/3/6);
              [reduce setImage:[UIImage imageNamed:@"IMG_0799.jpg"] forState:UIControlStateNormal];
              [cell.contentView addSubview:reduce];
              //生产厂家
              UILabel *vender = [[UILabel alloc]init];
              vender.frame = CGRectMake( width/3+10, width/3/3+width/3/6+width/3/6+10, width/3*2-10, width/3/6);
              vender.text = @"哈尔滨市甲骨文实训基地";
              vender.textColor = [UIColor blackColor];
              vender.font =[UIFont systemFontOfSize:12];
              //number.backgroundColor = [UIColor yellowColor];
              [cell.contentView addSubview:vender];

    
    
    
    
    
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
    
    return  UITableViewCellEditingStyleDelete;   //返回此值时,Cell上不会出现Delete按键,即Cell不做任何响应
        
    
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

@end
