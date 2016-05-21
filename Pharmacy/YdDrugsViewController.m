//
//  YdDrugsViewController.m
//  Pharmacy
//
//  Created by suokun on 16/3/19.
//  Copyright © 2016年 sk. All rights reserved.
//

#import "YdDrugsViewController.h"
#import "Color+Hex.h"
#import "WarningBox.h"
#import "AFNetworking 3.0.4/AFHTTPSessionManager.h"
#import "SBJson.h"
#import "hongdingyi.h"
#import "lianjie.h"
#import "UIImageView+WebCache.h"
#import "YdShoppingCartViewController.h"
#import "YdshoppingxiangshiViewController.h"
@interface YdDrugsViewController ()<UITextFieldDelegate>
{
    CGFloat width;
    CGFloat height;
    int xxx;
    NSString *shuliangCunFang;
    NSArray *arr;
    NSDictionary *xianshiarr;
    
    
    NSMutableDictionary*tianjiaxinxi;
    
}

@end

@implementation YdDrugsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //增加监听，当键盘出现或改变时收出消息
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    arr = @[@"药 品 名 称 :",@"拼   音   码 :",@"通 用 名 称 :",@"药 品 简 介 :",@"药 品 类 别 :",@"药 品 规 格 :",@"生 产 企 业 :",@"商 品 编 号 :",@"上 架 标 识 :",@"说   明   书 :",@"包          装 :",@"批 准 文 号 :",@"是否为处方:"];
    
    width = [UIScreen mainScreen].bounds.size.width;
    height = [UIScreen mainScreen].bounds.size.height;
    
    //解决tableview多出的白条
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    //状态栏名称
    self.navigationItem.title = @"药品详情";
    //self.view.backgroundColor = [UIColor colorWithHexString:@"f4f4f4" alpha:1];
    
    _shuliang.delegate=self;
    self.tableview = [[UITableView alloc]init];
    self.tableview.frame = CGRectMake(0, 64, width, height  - 104);
    self.tableview.backgroundColor= [UIColor colorWithHexString:@"f4f4f4" alpha:1];
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    [self.view addSubview:self.tableview];
    
    
    NSString *countwenjian=[NSString stringWithFormat:@"%@/Documents/Dingdanxinxi.plist",NSHomeDirectory()];
    NSLog(@"文件存放路径  %@",NSHomeDirectory());
    NSFileManager *file=[NSFileManager defaultManager];
    
    if([file fileExistsAtPath:countwenjian]){
        NSArray*ap=[NSArray arrayWithContentsOfFile:countwenjian];
        for (int i=0; i<ap.count; i++) {
            if ([[ap[i] objectForKey:@"id"]isEqual:_yaopinID]) {
                _shuliang.text=[NSString stringWithFormat:@"%@",[ap[i] objectForKey:@"shuliang"]];
            }
        }
    }
    
    
    
    //设置导航栏左按钮
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"@3x_xx_06.png"] style:UIBarButtonItemStyleDone target:self action:@selector(fanhui)];
    
    [self jiekou];
    [self xialan];
}
int popop=0;
//调用接口
-(void)jiekou
{
    [WarningBox warningBoxModeIndeterminate:@"数据加载中..." andView:self.view];
    //userID    暂时不用改
    NSString * userID=@"0";
    
    //请求地址   地址不同 必须要改
    NSString * url =@"/product/productDetailList";
    
    //时间戳
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval a=[dat timeIntervalSince1970];
    NSString *timeSp = [NSString stringWithFormat:@"%.0f",a];
    
    
    //将上传对象转换为json格式字符串
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json",@"text/plain",@"text/html", nil];
    SBJsonWriter *writer = [[SBJsonWriter alloc]init];
    //出入参数：
    NSDictionary*datadic=[NSDictionary dictionaryWithObjectsAndKeys:_yaopinID,@"id", nil];
    
    NSString*jsonstring=[writer stringWithObject:datadic];
    
    //获取签名
    NSString*sign= [lianjie getSign:url :userID :jsonstring :timeSp ];
    
    NSString *url1=[NSString stringWithFormat:@"%@%@%@%@",service_host,app_name,api_url,url];
    
    //电泳借口需要上传的数据
    NSDictionary*dic=[NSDictionary dictionaryWithObjectsAndKeys:jsonstring,@"params",appkey, @"appkey",userID,@"userid",sign,@"sign",timeSp,@"timestamp", nil];
    
    [manager GET:url1 parameters:dic progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [WarningBox warningBoxHide:YES andView:self.view];
        @try
        {
            [WarningBox warningBoxModeText:[NSString stringWithFormat:@"%@",[responseObject objectForKey:@"msg"]] andView:self.view];
            NSLog(@"responseObject%@",responseObject);
            if ([[responseObject objectForKey:@"code"] intValue]==0000) {
                popop=1;
                NSDictionary*datadic=[responseObject valueForKey:@"data"];
                
                xianshiarr = [datadic objectForKey:@"product"];
                tianjiaxinxi=[NSMutableDictionary dictionaryWithDictionary:xianshiarr];
                [self.tableview reloadData];
                
            }
        }
        @catch (NSException * e) {
            
            [WarningBox warningBoxModeText:@"请检查你的网络连接!" andView:self.view];
            
        }
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [WarningBox warningBoxHide:YES andView:self.view];
        [WarningBox warningBoxModeText:@"网络连接失败！" andView:self.view];
        NSLog(@"错误：%@",error);
    }];
    
}
-(void)xialan
{
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}
//行
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0)
    {
        return 1;
    }
    else if (section == 2)
    {
        return arr.count;
    }
    else if (section == 1)
    {
        if ([[[xianshiarr objectForKey:@"addedProduct"] objectForKey:@"specProdFlag"] isEqual:@"1"])
        {
            return 2;
        }
        else{
            return 1;
        }
    }
    return 0;
}

//cell高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    if (indexPath.section ==0) {
        return 150;
    }
    else if (indexPath.section == 1){
        return 25;
    }
    else if (indexPath.section == 2){
        return 25;
    }
    return 0;
}

//header 高度
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 0;
    }
    return 30;
}
//编辑header内容
-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc]init];
    view.backgroundColor = [UIColor colorWithHexString:@"e2e2e2" alpha:1];
    
    UILabel *tishi = [[UILabel alloc]init];
    tishi.frame = CGRectMake(5, 5, 100 , 20);
    tishi.font = [UIFont systemFontOfSize:15];
    tishi.textColor = [UIColor colorWithHexString:@"323232" alpha:1];
    
    [view addSubview:tishi];
    
    if (section == 1) {
        if ([[[xianshiarr objectForKey:@"addedProduct"] objectForKey:@"specProdFlag"] isEqual:@"1"])
        {
            tishi.text = @"特价药品";
        }
        else
        {
            tishi.text = @"非特价药品";
        }
        
    }
    else if (section == 2){
        
        tishi.text = @"药品信息";
        
    }
    
    return view;
}

//编辑Cell
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *id1 =@"cell1";
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:id1];
    }
    if (indexPath.section == 0) {
        UIImageView *image = [[UIImageView alloc] init];
        image.frame = CGRectMake(0, 0, width, 150);
        NSString*path=[NSString stringWithFormat:@"%@%@",service_host,[xianshiarr objectForKey:@"picUrl"]];
        [image sd_setImageWithURL:[NSURL URLWithString:path] placeholderImage:[UIImage imageNamed:@"IMG_0800.jpg" ]];
        
        [cell.contentView addSubview:image];
        self.tableview.separatorStyle = UITableViewCellSelectionStyleNone;
    }
    
    cell.contentView.backgroundColor = [UIColor colorWithHexString:@"f4f4f4" alpha:1];
    cell.textLabel.font = [UIFont systemFontOfSize:13];
    cell.textLabel.textColor = [UIColor colorWithHexString:@"323232" alpha:1];
    
    UILabel *shuju = [[UILabel alloc]init];
    shuju.frame = CGRectMake(100, 2, width - 110 , 20);
    shuju.font = [UIFont systemFontOfSize:13];
    shuju.textColor = [UIColor colorWithHexString:@"646464" alpha:1];
    if (indexPath.section == 1){
        
        if ([[[xianshiarr objectForKey:@"addedProduct"] objectForKey:@"specProdFlag"] isEqual:@"1"]) {
            
             if (indexPath.row == 0) {
                cell.textLabel.text = @"特          价 :";
                shuju.textColor = [UIColor redColor];
                 if (xianshiarr.count==0) {
                     shuju.text=@"";
                 }else
                shuju.text = [NSString stringWithFormat:@"%@",[[xianshiarr objectForKey:@"addedProduct"] objectForKey:@"specPrice"]];
            }
            else if (indexPath.row == 1) {
                cell.textLabel.text = @"原          价 :";
                if (xianshiarr.count==0) {
                    shuju.text=@"";
                }else
                shuju.text = [NSString stringWithFormat:@"%@",[[xianshiarr objectForKey:@"addedProduct"] objectForKey:@"prodPrice"]];
            }
        }
        else
        {
             if (indexPath.row == 0) {
                cell.textLabel.text = @"价          格 :";
                 if (xianshiarr.count==0||[[xianshiarr objectForKey:@"addedProduct"] isEqual:[NSNull null]]) {
                     shuju.text=@"";
                 }else
                shuju.text = [NSString stringWithFormat:@"%@",[[xianshiarr objectForKey:@"addedProduct"] objectForKey:@"prodPrice"]];
            }

        }
    }
    if (indexPath.section == 2){
        
        cell.textLabel.text = arr[indexPath.row];
        
        if (indexPath.row == 0) {
            if (xianshiarr.count==0) {
                shuju.text=@"";
            }else
            shuju.text = [NSString stringWithFormat:@"%@",[xianshiarr objectForKey:@"name"]];
        }
        else if (indexPath.row == 1) {
            if (xianshiarr.count==0) {
                shuju.text=@"";
            }else
            shuju.text = [NSString stringWithFormat:@"%@",[xianshiarr objectForKey:@"pinyinCode"]];
        }
        else if (indexPath.row == 2) {
            if (xianshiarr.count==0) {
                shuju.text=@"";
            }else
            shuju.text = [NSString stringWithFormat:@"%@",[xianshiarr objectForKey:@"commonName"]];
        }
        else if (indexPath.row == 3) {
            if (xianshiarr.count==0) {
                shuju.text=@"";
            }else
            shuju.text = [NSString stringWithFormat:@"%@",[xianshiarr objectForKey:@"summary"]];
        }
        else if (indexPath.row == 4) {
            if (xianshiarr.count==0) {
                shuju.text=@"";
            }else
            shuju.text = [NSString stringWithFormat:@"%@",[xianshiarr objectForKey:@"level3Name"]];
        }
        else if (indexPath.row == 5) {
            if (xianshiarr.count==0) {
                shuju.text=@"";
            }else
            shuju.text = [NSString stringWithFormat:@"%@",[xianshiarr objectForKey:@"specification"]];
        }
        else if (indexPath.row == 6) {
            if (xianshiarr.count==0) {
                shuju.text=@"";
            }else
            shuju.text = [NSString stringWithFormat:@"%@",[xianshiarr objectForKey:@"manufacturer"]];
        }
        else if (indexPath.row == 7) {
            if (xianshiarr.count==0) {
                shuju.text=@"";
            }else
            shuju.text = [NSString stringWithFormat:@"%@",[xianshiarr objectForKey:@"prodCode"]];
        }
        else if (indexPath.row == 8) {
            
            shuju.text = @"";//[NSString stringWithFormat:@"%@",[xianshiarr objectForKey:@""]];
        }
        else if (indexPath.row == 9) {
            if (xianshiarr.count==0) {
                shuju.text=@"";
            }else
            shuju.text = [NSString stringWithFormat:@"%@",[xianshiarr objectForKey:@"instructions"]];
        }
        else if (indexPath.row == 10) {
            if (xianshiarr.count==0) {
                shuju.text=@"";
            }else
            shuju.text = [NSString stringWithFormat:@"%@",[xianshiarr objectForKey:@"package"]];
        }
        else if (indexPath.row == 11) {
            if (xianshiarr.count==0) {
                shuju.text=@"";
            }else
            shuju.text = [NSString stringWithFormat:@"%@",[xianshiarr objectForKey:@"approvalNumber"]];
        }
        else if (indexPath.row == 12) {
            if (xianshiarr.count==0) {
                shuju.text=@"";
            }else
            shuju.text = [NSString stringWithFormat:@"%@",[xianshiarr objectForKey:@"prescription"]];
        }

    }
    
    [cell.contentView addSubview:shuju];
    
    //cell点击不变色
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    //线消失
    //self.tableview.separatorStyle = UITableViewCellSelectionStyleNone;
    //隐藏滑动条
    self.tableview.showsVerticalScrollIndicator =NO;
    
    return cell;
}

//联系店长
- (IBAction)lianxidianzhang:(id)sender {
    //聊天   固定  id
}
//减号
- (IBAction)jian:(id)sender {
    int shu= [_shuliang.text intValue];
    if(shu==1)
    {
        
        
    }else
    {
        
        _shuliang.text=[NSString stringWithFormat:@"%d",shu-1];
        shuliangCunFang=_shuliang.text;
    }
    
    [_shuliang resignFirstResponder];
    
    
}
//加号
- (IBAction)jia:(id)sender {
    int shu= [_shuliang.text intValue];
    if(shu<1000)
    {
        _shuliang.text=[NSString stringWithFormat:@"%d",shu+1];
        shuliangCunFang=_shuliang.text;
    }
    [_shuliang resignFirstResponder];

}
//加入购物车
- (IBAction)jiaru:(id)sender {
   
    if ([_shuliang.text intValue]<1) {
        
    }else{
        NSMutableArray * arrr=[NSMutableArray array];
        NSString *countwenjian=[NSString stringWithFormat:@"%@/Documents/Dingdanxinxi.plist",NSHomeDirectory()];
        NSLog(@"文件存放路径  %@",NSHomeDirectory());
         NSFileManager *file=[NSFileManager defaultManager];
        [tianjiaxinxi setObject:[NSString stringWithFormat:@"%@", _shuliang.text ] forKey:@"shuliang"];
        if([file fileExistsAtPath:countwenjian])
        {
            
            //   获取文件里的数据
            arrr=[NSMutableArray arrayWithContentsOfFile:countwenjian];
            int ioi=0;
            for (int i=0; i<arrr.count; i++) {
                if ([[arrr[i] objectForKey:@"id"]isEqual:[tianjiaxinxi objectForKey:@"id"]]) {
                    ioi=1;
                    [arrr[i] setObject:shuliangCunFang forKey:@"shuliang"];
                    [arrr writeToFile:countwenjian atomically:YES];
                    [WarningBox warningBoxModeText:@"更改数量成功" andView:self.navigationController.view];
//                    [self.navigationController popViewControllerAnimated:YES];
                    
                }
            }
            if (ioi==0) {
                
                [arrr addObject:tianjiaxinxi];
                [arrr writeToFile:countwenjian atomically:YES];
                [WarningBox warningBoxModeText:@"添加成功～" andView:self. navigationController.view];
                [self.navigationController popViewControllerAnimated:YES];
                
                
            }
            
            
        }
        else{
            
            
            [arrr addObject:tianjiaxinxi];
            [arrr writeToFile:countwenjian atomically:YES];
            [WarningBox warningBoxModeText:@"添加成功～" andView:self. navigationController.view];
//            [self.navigationController popViewControllerAnimated:YES];
            
            
        }
        

    }
}
#pragma  mark ----textField
int ll=0;
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    float op;
    if ([string isEqual:@"0"]&& ll==0) {
        NSLog(@"没事");
    }else if ([string isEqual:@""]) {
        NSLog(@"%lu",[textField.text length]-1);
        op=[textField.text length]-1;
    }else{
        NSLog(@"%lu",[textField.text length]+1);
        op=[textField.text length]+1;
    }
    
    if (op>4) {
        [WarningBox warningBoxModeText:@"请出入1——10000之间的数" andView:self.view];
        return NO;
    }
    
    if (ll==0) {
        if ([string isEqual:@"0"]) {return NO;}else ll=1;return YES;}if ([textField.text isEqual:@""]) {ll=0;if (ll==0) {if ([string isEqual:@"0"]) {return NO;}else ll=1;return YES;}}return YES;
    
}
//在UITextField 编辑之前调用方法
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    
}
//在UITextField 编辑完成调用方法
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [self animateTextField: textField up: NO];
}
- (void) animateTextField: (UITextField *) xx up: (BOOL) up
{
    
    //设置视图上移的距离，单位像素
    const int movementDistance = xxx; // tweak as needed
    //三目运算，判定是否需要上移视图或者不变
    int movement = (up ? -movementDistance : movementDistance);
    //设置动画的名字
    [UIView beginAnimations: @"Animation" context: nil];
    //设置动画的开始移动位置
    [UIView setAnimationBeginsFromCurrentState: YES];
    //设置动画的间隔时间
    [UIView setAnimationDuration: 0.20];
    //设置视图移动的位移
    self.view.frame = CGRectOffset(self.view.frame, 0, movement);
    //设置动画结束
    [UIView commitAnimations];
    
    
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self.view endEditing:YES];
    return YES;
}

//导航左按钮
-(void)fanhui
{
    //返回上一页
    [self.navigationController popViewControllerAnimated:YES];
}
//当键盘出现或改变时调用
- (void)keyboardWillShow:(NSNotification *)aNotification
{
    //获取键盘的高度
    NSDictionary *userInfo = [aNotification userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    xxx = keyboardRect.size.height;
    [self animateTextField: nil up: YES];
}

@end
