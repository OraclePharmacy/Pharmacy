//
//  YdDiseaseViewController.m
//  Pharmacy
//
//  Created by suokun on 16/3/22.
//  Copyright © 2016年 sk. All rights reserved.
//

#import "YdDiseaseViewController.h"
#import "Color+Hex.h"
#import "WarningBox.h"
#import "AFNetworking 3.0.4/AFHTTPSessionManager.h"
#import "SBJson.h"
#import "hongdingyi.h"
#import "lianjie.h"
#import "UIImageView+WebCache.h"
#import "YdDrugsViewController.h"

@interface YdDiseaseViewController ()
{
    CGFloat width;
    CGFloat height;
    NSArray *arr;
    UILabel *lable;
    
    NSDictionary*diseaseInfo;
    NSArray *bingyin;
    NSArray *bingzheng;
    NSArray *zhiliao;
    NSArray *zhuyi;
    NSArray *jiankang;
    NSArray *yaopin;
    
    int ling;
    int yi;
    int er;
    int san;
    int si;
    int wu;
}
@end

@implementation YdDiseaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    width = [UIScreen mainScreen].bounds.size.width;
    height = [UIScreen mainScreen].bounds.size.height;
    
    
    
    
    arr = @[@"[发病病因]",@"[发病病症]",@"[中医治疗方案]",@"[注意事项]",@"[健康保健]",@"[推荐药品]"];
    
    bingyin=[[NSArray alloc] init];
    bingzheng=[[NSArray alloc] init];
    zhiliao=[[NSArray alloc] init];
    zhuyi=[[NSArray alloc] init];
    jiankang=[[NSArray alloc] init];
    yaopin=[[NSArray alloc] init];
    
    ling=1;
    yi=1;
    er=1;
    san=1;
    si=1;
    wu=1;
    
    
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    //解决tableview多出的白条
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    //状态栏名称
    self.navigationItem.title = _bingzhengname;
    
    //设置导航栏左按钮
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"@3x_xx_06.png"] style:UIBarButtonItemStyleDone target:self action:@selector(fanhui)];
    
    [self jiekou];
}
#pragma mark ---病症接口
-(void)jiekou
{
    //userID    暂时不用改
    NSString * userID=@"0";
    
    //请求地址   地址不同 必须要改
    NSString * url =@"/basic/bzxxList";
    
    //时间戳
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval a=[dat timeIntervalSince1970];
    NSString *timeSp = [NSString stringWithFormat:@"%.0f",a];
    
    [WarningBox warningBoxModeIndeterminate:@"数据加载中...." andView:self.view];
    //将上传对象转换为json格式字符串
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json",@"text/plain",@"text/html", nil];
    SBJsonWriter *writer = [[SBJsonWriter alloc]init];
    //出入参数：
    NSDictionary*datadic=[NSDictionary dictionaryWithObjectsAndKeys:_bingzhengID,@"id", nil];
    
    NSString*jsonstring=[writer stringWithObject:datadic];
    
    //获取签名
    NSString*sign= [lianjie getSign:url :userID :jsonstring :timeSp ];
    
    NSString *url1=[NSString stringWithFormat:@"%@%@%@%@",service_host,app_name,api_url,url];
    NSLog(@"%@",url1);
    
    //电泳借口需要上传的数据
    NSDictionary*dic=[NSDictionary dictionaryWithObjectsAndKeys:jsonstring,@"params",appkey, @"appkey",userID,@"userid",sign,@"sign",timeSp,@"timestamp", nil];
    
    [manager POST:url1 parameters:dic progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [WarningBox warningBoxHide:YES andView:self.view];
        @try
        {
            //[WarningBox warningBoxModeText:[NSString stringWithFormat:@"%@",[responseObject objectForKey:@"msg"]] andView:self.view];
            
            NSLog(@"－＊－＊－＊－＊＊病症详情接口－＊－＊－＊－＊－＊\n\n\n\n%@",responseObject);
            if ([[responseObject objectForKey:@"code"] intValue]==0000) {
                NSDictionary*dd=[NSDictionary dictionaryWithDictionary:[responseObject objectForKey:@"data"]];
                diseaseInfo=[NSDictionary dictionaryWithDictionary:[dd objectForKey:@"diseaseInfo"]];
                bingyin=[[NSString stringWithFormat:@"%@",[diseaseInfo objectForKey:@"causes"]] componentsSeparatedByString:@"-----------------"];
                bingzheng=[[NSString stringWithFormat:@"%@",[diseaseInfo objectForKey:@"symptoms"]] componentsSeparatedByString:@"\n"];
                jiankang=[[NSString stringWithFormat:@"%@",[diseaseInfo objectForKey:@"healthCare"]] componentsSeparatedByString:@"\n"];
                zhuyi=[[NSString stringWithFormat:@"%@",[diseaseInfo objectForKey:@"precautions"]] componentsSeparatedByString:@"\n"];;
                zhiliao=[[NSString stringWithFormat:@"%@",[diseaseInfo objectForKey:@"cnTreatPlan"]] componentsSeparatedByString:@"\n"];
                //少子段
                yaopin=[diseaseInfo objectForKey:@"lst"] ;
                NSLog(@"-*-*-*-**-*%@",[[[diseaseInfo objectForKey:@"lst"][0] objectForKey:@"addedProduct" ] objectForKey:@"id"]);
                [_tableview reloadData];
                
            }
            
        }
        @catch (NSException * e) {
            
            [WarningBox warningBoxModeText:@"请检查你的网络连接!" andView:self.view];
            
        }
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [WarningBox warningBoxHide:YES andView:self.view];
        [WarningBox warningBoxModeText:@"网络连接失败！" andView:self.view];
        NSLog(@"错误：%@",error);
        [_tableview reloadData];
    }];
}

#pragma  mark ---tableview  建立
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return arr.count;
}
//行
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section==0){
        if (ling==0) {
            return 0;
        }else
            return bingyin.count;
    }else if (section==1){
        if (yi==0) {
            return 0;
        }else
            return bingzheng.count;
    }else if (section==2){
        if (er==0) {
            return 0;
        }else
            return zhiliao.count;
    }else if (section==3){
        if (san==0) {
            return 0;
        }else
            return zhuyi.count;
    }else if (section==4){
        if (si==0) {
            return 0;
        }else
            return jiankang.count;
    }else{
        if (wu==0) {
            return 0;
        }else
            return 1;
    }
}

//cell高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{  NSString* s=[[NSString alloc] init];
    
    
    //给lable 赋值
    if (indexPath.section==0) {
        s =bingyin[indexPath.row];
    }else if(indexPath.section==1){
        s=bingzheng[indexPath.row];
    }else if(indexPath.section==2){
        s=zhiliao[indexPath.row];
    }else if(indexPath.section==3){
        s=zhuyi[indexPath.row];
    }else if(indexPath.section==4){
        s=jiankang[indexPath.row];
    }else{
        return width/3+32;
    }
    
    //根据lable返回行高
    UIFont *font = [UIFont fontWithName:@"Arial" size:15];
    
    NSAttributedString *attributedText =
    [[NSAttributedString alloc]
     initWithString:s
     attributes:@
     {
     NSFontAttributeName: font
     }];
    CGRect rect = [attributedText boundingRectWithSize:(CGSize){width-40, CGFLOAT_MAX}
                                               options:NSStringDrawingUsesLineFragmentOrigin
                                               context:nil];
    
    lable.text=s;
    [lable setFrame:CGRectMake(20, 0, rect.size.width, rect.size.height)];
    
    return lable.frame.size.height+1;
    
}

//header 高度
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    
    return 30;
}

//编辑header内容
-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView * baseView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, width, 30)];
    baseView.backgroundColor = [UIColor colorWithHexString:@"E2E2E2" alpha:1];
    
    UILabel *name = [[UILabel alloc]init];
    name.frame = CGRectMake(10, 5, 150, 20);
    name.font = [UIFont systemFontOfSize:15];
    name.textColor = [UIColor colorWithHexString:@"323232" alpha:1];
    name.text = arr[section];
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, width, 44)];
    button.tag = 10000+section;
    [button addTarget:self action:@selector(btnOpenList:) forControlEvents:UIControlEventTouchUpInside];
    [baseView addSubview:button];
    [baseView addSubview:name];
    
    return baseView;
}


//编辑Cell
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *id1 =@"cell1";
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:id1];
    }
    for (id subView in cell.contentView.subviews) {//获取当前cell的全部子视图
        
        [subView removeFromSuperview];//移除全部子视图
        
    }
    if (indexPath.section==5) {
        //图片
        UIImageView*b1=[[UIImageView alloc] initWithFrame:CGRectMake(5, 5, width/3-10, width/3-10)];
        UIImageView*b2=[[UIImageView alloc] initWithFrame:CGRectMake(width/3+5, 5, width/3-10, width/3-10)];
        UIImageView*b3=[[UIImageView alloc] initWithFrame:CGRectMake(2*width/3+5, 5, width/3-10, width/3-10)];
        [b1 setUserInteractionEnabled:YES];
        [b2 setUserInteractionEnabled:YES];
        [b3 setUserInteractionEnabled:YES];

        if (yaopin.count==0) {
            
        }else if(yaopin.count==1){
            //一张图片
            [b1 sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",service_host,[yaopin[0] objectForKey:@"picUrl"]]] placeholderImage:[UIImage imageNamed: @"IMG_0800.jpg"]];
            UILabel*ming1=[[UILabel alloc] initWithFrame:CGRectMake(5, width/3, width/3-10, 23)];
            ming1.text=[NSString stringWithFormat:@"%@",[yaopin[0] objectForKey:@"commonName"]];
            ming1.font=[UIFont systemFontOfSize:12];
            ming1.textAlignment=NSTextAlignmentCenter;
            UITapGestureRecognizer* singleRecognizer1;
            singleRecognizer1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTapFrom1)];
            singleRecognizer1.numberOfTapsRequired = 1; // 单击
            [b1 addGestureRecognizer:singleRecognizer1];
            [cell addSubview:ming1];
            [cell addSubview:b1];
        }else if(yaopin.count==2){
            //两张图片
            [b1 sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",service_host,[yaopin[0] objectForKey:@"picUrl"]]] placeholderImage:[UIImage imageNamed: @"IMG_0800.jpg"]];
            UILabel*ming1=[[UILabel alloc] initWithFrame:CGRectMake(5, width/3, width/3-10, 23)];
            ming1.text=[NSString stringWithFormat:@"%@",[yaopin[0] objectForKey:@"commonName"]];
            ming1.font=[UIFont systemFontOfSize:12];
            ming1.textAlignment=NSTextAlignmentCenter;
            UITapGestureRecognizer* singleRecognizer1;
            singleRecognizer1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTapFrom1)];
            
            singleRecognizer1.numberOfTapsRequired = 1; // 单击
            [b1 addGestureRecognizer:singleRecognizer1];
            [b2 sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",service_host,[yaopin[1] objectForKey:@"picUrl"]]] placeholderImage:[UIImage imageNamed: @"IMG_0800.jpg"]];
            UILabel*ming2=[[UILabel alloc] initWithFrame:CGRectMake(width/3+5, width/3, width/3-10, 23)];
            ming2.text=[NSString stringWithFormat:@"%@",[yaopin[1] objectForKey:@"commonName"]];
            ming2.font=[UIFont systemFontOfSize:12];
            ming2.textAlignment=NSTextAlignmentCenter;
            UITapGestureRecognizer* singleRecognizer2;
            singleRecognizer2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTapFrom2)];
            singleRecognizer2.numberOfTapsRequired = 1; // 单击
            [b2 addGestureRecognizer:singleRecognizer2];
            [cell addSubview:ming1];
            [cell addSubview:b1];
            [cell addSubview:b2];
            
            [cell addSubview:ming2];
        }else{
            //三张图片
            [b1 sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",service_host,[yaopin[0] objectForKey:@"picUrl"]]] placeholderImage:[UIImage imageNamed: @"IMG_0800.jpg"]];
            UILabel*ming1=[[UILabel alloc] initWithFrame:CGRectMake(5, width/3, width/3-10, 23)];
            ming1.text=[NSString stringWithFormat:@"%@",[yaopin[0] objectForKey:@"commonName"]];
            ming1.font=[UIFont systemFontOfSize:12];
            ming1.textAlignment=NSTextAlignmentCenter;
            UITapGestureRecognizer* singleRecognizer1;
            singleRecognizer1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTapFrom1)];
            
            singleRecognizer1.numberOfTapsRequired = 1; // 单击
            [b1 addGestureRecognizer:singleRecognizer1];
            [b2 sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",service_host,[yaopin[1] objectForKey:@"picUrl"]]] placeholderImage:[UIImage imageNamed: @"IMG_0800.jpg"]];
            UILabel*ming2=[[UILabel alloc] initWithFrame:CGRectMake(width/3+5, width/3, width/3-10, 23)];
            ming2.text=[NSString stringWithFormat:@"%@",[yaopin[1] objectForKey:@"commonName"]];
            ming2.font=[UIFont systemFontOfSize:12];
            ming2.textAlignment=NSTextAlignmentCenter;
            UITapGestureRecognizer* singleRecognizer2;
            singleRecognizer2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTapFrom2)];
            singleRecognizer2.numberOfTapsRequired = 1; // 单击
            [b2 addGestureRecognizer:singleRecognizer2];
            [b3 sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",service_host,[yaopin[2] objectForKey:@"picUrl"]]] placeholderImage:[UIImage imageNamed: @"IMG_0800.jpg"]];
            UILabel*ming3=[[UILabel alloc] initWithFrame:CGRectMake(2*width/3+5, width/3, width/3-10, 23)];
            ming3.text=[NSString stringWithFormat:@"%@",[yaopin[2] objectForKey:@"commonName"]];
            ming3.font=[UIFont systemFontOfSize:12];
            ming3.textAlignment=NSTextAlignmentCenter;
            UITapGestureRecognizer* singleRecognizer3;
            singleRecognizer3 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTapFrom3)];
            singleRecognizer3.numberOfTapsRequired = 1; // 单击
            [b3 addGestureRecognizer:singleRecognizer3];
            [cell addSubview:ming1];
            [cell addSubview:b1];
            [cell addSubview:b2];
            [cell addSubview:ming2];
            [cell addSubview:b3];
            [cell addSubview:ming3];
        }
    }else{
        lable=[[UILabel alloc] init];
        lable.numberOfLines=0;
        lable.font=[UIFont systemFontOfSize:14];
        lable.textColor=[UIColor colorWithHexString:@"323232"];
        
        [cell addSubview:lable];
    }
    
    
    //cell点击不变色
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    //线消失
    self.tableview.separatorStyle = UITableViewCellSelectionStyleNone;
    //隐藏滑动条
    self.tableview.showsVerticalScrollIndicator =NO;
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 1;
}
#pragma mark ---跳转药品详情
-(void)handleSingleTapFrom3{
    NSLog(@"3");
    YdDrugsViewController*dd=[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"drugs"];
    dd.yaopinID=[NSString stringWithFormat:@"%@",[[[diseaseInfo objectForKey:@"lst"][2] objectForKey:@"addedProduct" ] objectForKey:@"id"]];
    [self.navigationController pushViewController:dd animated:YES];

}
-(void)handleSingleTapFrom2{
    NSLog(@"2");
    YdDrugsViewController*dd=[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"drugs"];
    dd.yaopinID=[NSString stringWithFormat:@"%@",[[[diseaseInfo objectForKey:@"lst"][1] objectForKey:@"addedProduct" ] objectForKey:@"id"]];
    [self.navigationController pushViewController:dd animated:YES];
}
-(void)handleSingleTapFrom1{
    NSLog(@"1");
    YdDrugsViewController*dd=[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"drugs"];
    dd.yaopinID=[NSString stringWithFormat:@"%@",[[[diseaseInfo objectForKey:@"lst"][0] objectForKey:@"addedProduct" ] objectForKey:@"id"]];
    [self.navigationController pushViewController:dd animated:YES];
}
#pragma  mark ---点击 展开---合并
-(void)btnOpenList:(UIButton*)sender{
    
    switch (sender.tag-10000) {
        case 0:
            if (ling==0) {
                ling=1;
            }else{
                ling=0;
            }
            [_tableview reloadData];
            break;
            
        case 1:
            if (yi==0) {
                yi=1;
            }else{
                yi=0;
            }
            [_tableview reloadData];
            break;
        case 2:
            if (er==0) {
                er=1;
            }else{
                er=0;
            }
            [_tableview reloadData];
            break;
        case 3:
            if (san==0) {
                san=1;
            }else{
                san=0;
            }
            [_tableview reloadData];
            break;
        case 4:
            if (si==0) {
                si=1;
            }else{
                si=0;
            }
            [_tableview reloadData];
            break;
        case 5:
            if (wu==0) {
                wu=1;
            }else{
                wu=0;
            }
            [_tableview reloadData];
            break;
            
        default:
            break;
    }
}
-(void)fanhui
{
    //返回上一页
    [self.navigationController popViewControllerAnimated:YES];
}
@end
