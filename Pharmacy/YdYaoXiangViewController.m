//
//  YdYaoXiangViewController.m
//  Pharmacy
//
//  Created by suokun on 16/5/3.
//  Copyright © 2016年 sk. All rights reserved.
//

#import "YdYaoXiangViewController.h"
#import "Color+Hex.h"
#import "YdjiluViewController.h"
#import "YdRemindViewController.h"
@interface YdYaoXiangViewController ()
{
    CGFloat width;
    CGFloat height;
    
    NSMutableArray *cishu1;
    NSDictionary* dic2;
    
    NSMutableArray *changshang1 ;
    NSMutableArray *name1;
    NSMutableArray *time1;
    NSMutableArray *cishu2;
    NSMutableArray *tupian1;
    
    int ccc;
}
@end

@implementation YdYaoXiangViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    changshang1 = [[NSMutableArray alloc]init];
    name1 = [[NSMutableArray alloc]init];
    time1 = [[NSMutableArray alloc]init];
    cishu2 = [[NSMutableArray alloc]init];
    tupian1 = [[NSMutableArray alloc]init];
    
    width = [UIScreen mainScreen].bounds.size.width;
    height = [UIScreen mainScreen].bounds.size.height;
    
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString *path=[paths objectAtIndex:0];
    NSLog(@"path = %@",path);
    NSString *filename=[path stringByAppendingPathComponent:@"zhihui.plist"];
    
    //判断是否已经创建文件
    if ([[NSFileManager defaultManager] fileExistsAtPath:filename]) {
        
        ccc = 1;
        //读文件
        dic2 = [NSDictionary dictionaryWithContentsOfFile:filename];
        
        changshang1 = [dic2 objectForKey:@"changshang"];
        name1 = [dic2 objectForKey:@"name"];
        cishu2 = [dic2 objectForKey:@"cishu"];
        time1 = [dic2 objectForKey:@"time"];
        tupian1 = [dic2 objectForKey:@"tupian"];
        
    }else {
        
        ccc = 2;
        
    }
    
    //状态栏名称
    self.navigationItem.title = @"智慧药箱";
    //设置self.view背景颜色
    self.view.backgroundColor = [UIColor colorWithHexString:@"f4f4f4" alpha:1];
    //设置导航栏左按钮
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"@3x_xx_06.png"] style:UIBarButtonItemStyleDone target:self action:@selector(fanhui)];
    
    self.tableview.backgroundColor = [UIColor colorWithHexString:@"f4f4f4" alpha:1];
    
    self.tianjia.layer.cornerRadius = 5;
    self.tianjia.layer.masksToBounds = YES;
    
}

//section
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
//cell
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (ccc == 1)
    {
        return changshang1.count;
    }
    else if (ccc == 2)
    {
         return 0;
    }
    return 0;
}
//cell高
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    return 90;
}
//header高
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0;
}
//自定义header
-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return self.view;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *id1 =@"cell1";
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:id1];
    }

    UIImageView *image = [[UIImageView alloc]init];
    image.frame = CGRectMake(5, 5, 80, 80);
    image.image=[UIImage imageWithData:tupian1[indexPath.row]];
    [cell.contentView addSubview:image];
    
    UILabel *name = [[UILabel alloc]init];
    name.frame = CGRectMake(90, 5, width - 95, 20);
    name.text = [NSString stringWithFormat:@"名    称:   %@",name1[indexPath.row]];
    name.textColor = [UIColor colorWithHexString:@"323232" alpha:1];
    name.font = [UIFont systemFontOfSize:13];
    [cell.contentView addSubview:name ];
    
    UILabel *changshang = [[UILabel alloc]init];
    changshang.frame = CGRectMake(90, 25, width - 95, 20);
    changshang.text = [NSString stringWithFormat:@"厂    商:   %@",changshang1[indexPath.row]];
    changshang.textColor = [UIColor colorWithHexString:@"323232" alpha:1];
    changshang.font = [UIFont systemFontOfSize:13];
    [cell.contentView addSubview:changshang];
    
    UILabel *time = [[UILabel alloc]init];
    time.frame = CGRectMake(90, 45, width - 95, 20);
    time.text = [NSString stringWithFormat:@"有限期:   %@",time1[indexPath.row]];
    time.textColor = [UIColor colorWithHexString:@"323232" alpha:1];
    time.font = [UIFont systemFontOfSize:13];
    [cell.contentView addSubview:time];
    
    UILabel *num = [[UILabel alloc]init];
    num.frame = CGRectMake(90, 65, width - 95, 20);
    num.text = [NSString stringWithFormat:@"次    数:   %@",cishu2[indexPath.row]];
    num.textColor = [UIColor colorWithHexString:@"323232" alpha:1];
    num.font = [UIFont systemFontOfSize:13];
    [cell.contentView addSubview:num];
    
    //cell点击不变色
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    YdRemindViewController *Remind = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"remind"];
    [self.navigationController pushViewController:Remind animated:YES];
    
}
- (void) tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath //对选中的Cell根据editingStyle进行操作
{

    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        //删除字典内容
        
        [changshang1 removeObjectAtIndex:indexPath.row];
        [name1 removeObjectAtIndex:indexPath.row];
        [time1 removeObjectAtIndex:indexPath.row];
        [cishu2 removeObjectAtIndex:indexPath.row];
        [tupian1 removeObjectAtIndex:indexPath.row];
        NSLog(@"0.0%@,%@,%@,%@",name1,changshang1,time1,cishu2);
        
        if (changshang1.count==0) {
            //yikaishi=nil;
        }
        
        [self.tableview deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        
        NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
        NSString *path=[paths    objectAtIndex:0];
        NSString *filename=[path stringByAppendingPathComponent:@"zhihui.plist"];
        NSDictionary* dic = [NSDictionary dictionaryWithObjectsAndKeys:name1,@"name",changshang1,@"changshang",time1,@"time",cishu2,@"cishu",tupian1,@"tupian",nil]; //写入数据
        [dic writeToFile:filename atomically:YES];
        
        [self.tableview reloadData];
    }
    else if (editingStyle == UITableViewCellEditingStyleInsert)
    {
        [self.tableview reloadData];
    }
    
    
    
}

-(void)fanhui
{
    //返回上一页
    [self.navigationController popViewControllerAnimated:YES];
}


- (IBAction)tianjia:(id)sender {
    
    YdjiluViewController *jilu = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"jilu"];
    
    [self.navigationController pushViewController:jilu animated:YES];

    
}
@end
