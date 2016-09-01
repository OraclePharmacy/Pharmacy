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
#import "WarningBox.h"
#import "tiaodaodenglu.h"
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
    
    UILabel *label;
}

@property (weak, nonatomic) IBOutlet UIButton *dianzhangshu;
@end

@implementation YdShoppingCartViewController
-(void)viewWillAppear:(BOOL)animated{
    [self.navigationController setNavigationBarHidden:NO];
    
    self.view.backgroundColor = [UIColor colorWithHexString:@"f4f4f4" alpha:1];
    
    NSUserDefaults * user=[NSUserDefaults standardUserDefaults];
    if ([[user objectForKey:@"wancheng"] intValue]==1) {
        yikaishi=nil;
        _lianxidianzhnag.hidden=YES;
        _tijiao.hidden=YES;
        [user setObject:@"0" forKey:@"wancheng"];
        
        //添加一张没有物品的图片
        
    }else{
        
        NSString *countwenjian=[NSString stringWithFormat:@"%@/Documents/Dingdanxinxi.plist",NSHomeDirectory()];
        
        NSFileManager *file=[NSFileManager defaultManager];
        if([file fileExistsAtPath:countwenjian]){
            yikaishi=[NSMutableArray arrayWithContentsOfFile:countwenjian];
            _lianxidianzhnag.hidden=NO;
            _tijiao.hidden=NO;
            if (yikaishi.count==0) {
                yikaishi=nil;
                _lianxidianzhnag.hidden=YES;
                _tijiao.hidden=YES;
            }
        }else{
            yikaishi=nil;
            _lianxidianzhnag.hidden=YES;
            _tijiao.hidden=YES;
            
            //添加一张没有物品的图片
            
        }
    }
    
    if (yikaishi == nil)
    {
        _tableview.hidden = YES;
        
        label = [[UILabel alloc]init];
        label.frame = CGRectMake(0, 114, width, 30);
        label.font = [UIFont systemFontOfSize:17];
        label.text = @"对不起,你还没有添加药品!";
        label.textColor = [UIColor colorWithHexString:@"323232" alpha:1];
        label.textAlignment = NSTextAlignmentCenter;
        [self.view addSubview:label];
    }
    else
    {
        label.text=@"";
        NSString *countwenjian=[NSString stringWithFormat:@"%@/Documents/Dingdanxinxi.plist",NSHomeDirectory()];
        NSArray* arr=[NSMutableArray arrayWithContentsOfFile:countwenjian];
        for (int i=0; i<arr.count; i++) {
            if ([[arr[i] objectForKey:@"specProdFlag"] intValue]==1) {
                float s=[[arr[i] objectForKey:@"specPrice"] floatValue]*[[arr[i] objectForKey:@"shuliang"] floatValue];
                [arr[i] setValue:[NSString stringWithFormat:@"%.2f",s] forKey:@"zongjia"];
            }else{
                float s=[[arr[i] objectForKey:@"prodPrice"] floatValue]*[[arr[i] objectForKey:@"shuliang"] floatValue];
                [arr[i] setValue:[NSString stringWithFormat:@"%.2f",s] forKey:@"zongjia"];
            }
        }
        float jine;
        
        for (int i=0; i<arr.count; i++) {
            jine+=[[arr[i] objectForKey:@"zongjia"] floatValue];
        }
        [_dianzhangshu setTitle:[NSString stringWithFormat:@"合计金额 : ¥%.2f",jine] forState:UIControlStateNormal];
        
        
        [label removeFromSuperview];
        _tableview.hidden = NO;
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
    self.view.backgroundColor = [UIColor colorWithHexString:@"f4f4f4" alpha:1];
    self.tableview.backgroundColor = [UIColor colorWithHexString:@"f4f4f4" alpha:1];
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
    cell.contentView.backgroundColor = [UIColor colorWithHexString:@"f4f4f4" alpha:1];
    //药品图片
    UIImageView *image = [[UIImageView alloc]init];
    image.frame = CGRectMake(10, 10, 80, 80);
    [image sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",service_host,[[yikaishi[indexPath.row] objectForKey:@"product"] objectForKey:@"picUrl"]]] placeholderImage:[UIImage imageNamed:@"daiti.png"]];
    image.layer.cornerRadius=30;
    
    //药品名称
    UILabel *name = [[UILabel alloc]init];
    name.frame = CGRectMake(100, 10, 200, 20);
    name.text = [NSString stringWithFormat:@"%@",[[yikaishi[indexPath.row] objectForKey:@"product"] objectForKey:@"commonName"]];
    name.textColor = [UIColor colorWithHexString:@"323232" alpha:1];
    name.font =[UIFont systemFontOfSize:15];
    UILabel *yuanjia = [[UILabel alloc]init];
    UILabel *tejia = [[UILabel alloc]init];
    if ([[yikaishi[indexPath.row] objectForKey:@"specProdFlag"] intValue]==1) {
        
        yuanjia.frame = CGRectMake(100, 30, 70, 20);
        yuanjia.text = [NSString stringWithFormat:@"原价:%.2f",[[yikaishi[indexPath.row] objectForKey:@"prodPrice"]floatValue]];
        yuanjia.textColor = [UIColor colorWithHexString:@"646464" alpha:1];
        yuanjia.font =[UIFont systemFontOfSize:13];
        
        tejia.frame = CGRectMake(170, 30, 70, 20);
        tejia.text = [NSString stringWithFormat:@"特价:%.2F",[[yikaishi[indexPath.row] objectForKey:@"specPrice"]floatValue]];
        tejia.textColor = [UIColor colorWithHexString:@"646464" alpha:1];
        tejia.font =[UIFont systemFontOfSize:13];
    }else{
        yuanjia.frame = CGRectMake(100, 30, 70, 20);
        yuanjia.text = [NSString stringWithFormat:@"原价:%@",[yikaishi[indexPath.row] objectForKey:@"prodPrice"]];
        yuanjia.textColor = [UIColor colorWithHexString:@"646464" alpha:1];
        yuanjia.font =[UIFont systemFontOfSize:13];
    }
    
    
    
    //生产厂家
    UILabel *changjia = [[UILabel alloc]init];
    changjia.frame = CGRectMake(100, 50, 60, 20);
    changjia.text = @"生产厂家:";
    changjia.textColor = [UIColor colorWithHexString:@"646464" alpha:1];
    changjia.font =[UIFont systemFontOfSize:13];
    
    UILabel *vender = [[UILabel alloc]init];
    vender.frame = CGRectMake( 160, 50, width - 160 , 20);
    vender.text = [NSString stringWithFormat:@"%@",[[yikaishi[indexPath.row] objectForKey:@"product"] objectForKey:@"manufacturer"]];
    vender.textColor = [UIColor colorWithHexString:@"646464" alpha:1];
    vender.font =[UIFont systemFontOfSize:12];
    
    
    
    //添加数量按钮
    UIButton *add = [[UIButton alloc]init];
    add.frame = CGRectMake(100, 72, 16, 16);
    [add setTitle:@"-" forState:UIControlStateNormal];
    [add setTitleColor:[UIColor colorWithHexString:@"32BE60"] forState:UIControlStateNormal];
    add.backgroundColor = [UIColor colorWithHexString:@"f4f4f4" alpha:1];
    [add addTarget:self action:@selector(jian:) forControlEvents:UIControlEventTouchUpInside];
    
    //数量输入框
    num = [[UITextField alloc]init];
    num.delegate=self;
    num.keyboardType=UIKeyboardTypeNumberPad;
    num.font = [UIFont systemFontOfSize:12];
    num.layer.borderColor = [[UIColor grayColor] CGColor];
    [num addTarget:self action:@selector(NumberLength) forControlEvents:UIControlEventEditingChanged];
    num.tag=(int)indexPath.row+999;
    [num addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    //删减数量按钮
    UIButton *reduce = [[UIButton alloc]init];
    reduce.frame = CGRectMake(200,72, 16, 16);
    [reduce setTitle:@"+" forState:UIControlStateNormal];
    [reduce setTitleColor:[UIColor colorWithHexString:@"32BE60"] forState:UIControlStateNormal];
    reduce.backgroundColor = [UIColor colorWithHexString:@"f4f4f4" alpha:1];
    [reduce addTarget:self action:@selector(jia:) forControlEvents:UIControlEventTouchUpInside];
    
    if (aa == 1 )
    {
        num.frame = CGRectMake(100, 70, 100, 20);
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
        num.frame = CGRectMake(120, 70, 76, 20);
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
    if (aa == 2) {
        if (editingStyle == UITableViewCellEditingStyleDelete) {
            
            //删除字典内容
            
            [yikaishi removeObjectAtIndex:indexPath.row];
            if (yikaishi.count==0) {
                //yikaishi=nil;
            }
            
            [self.tableview deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            
            [self.tableview reloadData];
        }
        else if (editingStyle == UITableViewCellEditingStyleInsert)
        {
            [self.tableview reloadData];
        }
        
    }
    
}

-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    UIView * baseView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, width, 1)];
    baseView.backgroundColor = [UIColor colorWithHexString:@"f4f4f4" alpha:1];
    
    return baseView;
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
    
    //判断是否登录
    if (![[[NSUserDefaults standardUserDefaults] objectForKey:@"isLogin"] isEqualToString:@"YES"]) {
        [tiaodaodenglu jumpToLogin:self.navigationController];
    }else{
        
        
        
        //需要判断各种情况，使下一个界面可有正常显示，如果少东西，则提示框显示是跳跳转到其他界面补全信息;
        NSString *path1 =[NSHomeDirectory() stringByAppendingString:@"/Documents/GRxinxi.plist"];
        NSFileManager *fm =[NSFileManager defaultManager];
        if ([fm fileExistsAtPath:path1]) {
            NSDictionary*gerenxinxi=[NSDictionary dictionaryWithContentsOfFile:path1];
            
            if (aa==2) {
                [WarningBox warningBoxModeText:@"请先保存数据" andView:self.view];
            }else{
                if (((NSString*)[gerenxinxi objectForKey:@"name"]).length==0||((NSString*)[gerenxinxi objectForKey:@"area"]).length==0) {
                    [WarningBox warningBoxModeText:@"请先完善个人信息" andView:self.view];
                    
                }else{
                    //显示订单详情，包括总价钱等等
                    YdshoppingxiangshiViewController *shoppingxiangshi = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"shoppingxiangshi"];
                    [self.navigationController pushViewController:shoppingxiangshi animated:YES];
                }
            }
        }
        
        
    }
    
    
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
    lab.textAlignment = NSTextAlignmentCenter;
    lab.text = @"*  向左侧拉删除";
    
    
}
-(void)textFieldDidChange :(UITextField *)theTextField
{
    UITableViewCell *cell=(UITableViewCell*)[[theTextField superview] superview ];
    
    NSIndexPath *index=[self.tableview indexPathForCell:cell];
    
    UILabel*oo=[cell viewWithTag:index.row+999];
    
    oo.text=[NSString stringWithFormat:@"%d",[oo.text intValue]];
    
    NSString*qw=oo.text;
    [yikaishi[index.row] setObject:qw forKey:@"shuliang"];
    
}

-(void)baocun
{
    NSString *countwenjian=[NSString stringWithFormat:@"%@/Documents/Dingdanxinxi.plist",NSHomeDirectory()];
    [yikaishi writeToFile:countwenjian atomically:YES];
    aa=1;
    
    
    
    NSMutableArray *aaa=[NSMutableArray arrayWithContentsOfFile:countwenjian];
    int lk=0;
    for (int i=0; i<aaa.count+lk; i++) {
        if([[aaa[i-lk] objectForKey:@"shuliang"]isEqualToString:@"0"]){
            [aaa removeObjectAtIndex:i-lk];
            lk++;
        }
    }
    
    [aaa writeToFile:countwenjian atomically:YES];
    self.navigationItem.rightBarButtonItem = right;
    [self viewWillAppear:YES];
}
-(void)xiaoshi
{
    di.hidden = YES;
}
-(void)jia:(UIButton*)tt
{
    [self.view endEditing:YES];
    UITableViewCell *cell=(UITableViewCell*)[[tt superview] superview ];
    
    NSIndexPath *index=[self.tableview indexPathForCell:cell];
    
    UILabel*oo=[cell viewWithTag:index.row+999];
    
    NSString*qw=oo.text;
    
    int wq=[qw intValue];
    
    qw =[NSString stringWithFormat:@"%d", wq+1];
    
    oo.text=qw;
    
    //  存入jieshou数组中
    [yikaishi[index.row] setObject:qw forKey:@"shuliang"];
    
    
    
}

-(void)jian:(UIButton*)tt
{
    [self.view endEditing:YES];
    UITableViewCell *cell=(UITableViewCell*)[[tt superview] superview ];
    
    NSIndexPath *index=[self.tableview indexPathForCell:cell];
    
    UILabel*oo=[cell viewWithTag:index.row+999];
    
    NSString*qw=oo.text;
    
    int wq=[qw intValue];
    
    if ([oo.text intValue]==1||[oo.text intValue]==0) {
        qw=@"1";
    }else
        qw =[NSString stringWithFormat:@"%d", wq-1];
    
    oo.text=qw;
    //  存入jieshou数组中
    [yikaishi[index.row] setObject:qw forKey:@"shuliang"];
    
}


- (IBAction)dianzhanganniu:(id)sender {
    //合计金额
    
    
}
@end
