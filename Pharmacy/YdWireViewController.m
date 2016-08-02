//
//  YdWireViewController.m
//  Pharmacy
//
//  Created by suokun on 16/4/13.
//  Copyright © 2016年 sk. All rights reserved.
//

#import "YdWireViewController.h"
#import "Color+Hex.h"
#import "YdmingchengViewController.h"
@interface YdWireViewController ()
{
    CGFloat width;
    CGFloat height;
    int index;
    int zhi;
    NSArray *yiji;
    NSArray *erji;
    NSDictionary *dic2;
    int panduan;
    
    UIButton *zhuanshen;
    UIImageView *beijing;
}
@property (strong,nonatomic)UISegmentedControl *segmentedControl;
@property (strong,nonatomic)UITableView *tableview1;
@property (strong,nonatomic)UITableView *tableview2;
@property (nonatomic, strong) UIView *tableFooterView;
@end

@implementation YdWireViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //控制是身体为正面
    panduan = 1;
    //获取屏幕高度
    width = [UIScreen mainScreen].bounds.size.width;
    height = [UIScreen mainScreen].bounds.size.height;
    //创建数组
    yiji = [[NSArray alloc]init];
    yiji = @[@"头部",@"颈部",@"胸部",@"腹部",@"腰部",@"臀部",@"上肢",@"下肢",@"骨",@"男性生殖",@"女性生殖",@"盆腔",@"全身",@"会阴部",@"心理",@"背部",@"其他",@"全部"];
    //设置self.view背景颜色
    self.view.backgroundColor = [UIColor whiteColor];
    //设置导航栏左按钮
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"@3x_xx_06.png"] style:UIBarButtonItemStyleDone target:self action:@selector(fanhui)];
    [self tupian];
    //分段控制器
    [self fenduan];
}

//创建分段控制器
-(void)fenduan
{
    //分段控制器基本属性
    NSArray *segmentedArray = [[NSArray alloc]initWithObjects:@"身体部位",@"列表",nil];
    //初始化UISegmentedControl
    _segmentedControl = [[UISegmentedControl alloc]initWithItems:segmentedArray];
    _segmentedControl.frame = CGRectMake(0,0,width/2,30);
    _segmentedControl.selectedSegmentIndex = 0;//设置默认选择项索引
    _segmentedControl.tintColor = [UIColor colorWithHexString:@"f4f4f4" alpha:1];
    [_segmentedControl addTarget:self action:@selector(change:) forControlEvents:UIControlEventValueChanged];
    //显示在导航栏
    self.navigationItem.titleView = self.segmentedControl;
}
//分段控制器点击方法
-(void)change:(UISegmentedControl *)segmentControl
{
    index = (int)_segmentedControl.selectedSegmentIndex;
    if (index == 0 ) {
        zhi = 1;
        [self.tableview1 removeFromSuperview];
        [self.tableview2 removeFromSuperview];
    }
    else if(index == 1){
        zhi = 2;
        [self tableview];
    }
    
}
#pragma  mark --- 图片
-(void)tupian
{
    //最下面
    beijing = [[UIImageView alloc]init];
    beijing.frame = CGRectMake(0, 64, width, height - 64);
    beijing.image = [UIImage imageNamed:@"bg.png"];
    [self.view addSubview:beijing];
    
    CGFloat viewgao = height - 64;
    CGFloat viewkuan = width;
    
    zhuanshen = [[UIButton alloc]init];
    zhuanshen.frame = CGRectMake(width - 70 ,height - 100 ,50 ,50 );
    [zhuanshen setTitle:@"转身" forState:UIControlStateNormal];
    [zhuanshen setTitleColor:[UIColor colorWithHexString:@"323232" alpha:1] forState:UIControlStateNormal];
    zhuanshen.titleLabel.font = [UIFont systemFontOfSize:17];
    zhuanshen.layer.cornerRadius = 25;
    zhuanshen.layer.masksToBounds = YES;
    zhuanshen.layer.borderWidth = 3;
    zhuanshen.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    [zhuanshen addTarget:self action:@selector(biaoqian:) forControlEvents:UIControlEventTouchUpInside];
    [self.view bringSubviewToFront:zhuanshen];
    [self.view addSubview:zhuanshen];
    
    //第二层
    UIImageView *renti = [[UIImageView alloc]init];
    renti.frame = CGRectMake(65, 0, viewkuan - 130 , viewgao);
    [beijing addSubview:renti];
    if (panduan == 1) {
        
        renti.image = [UIImage imageNamed:@"people2.png"];
        
        //头部
        UIButton *tou = [[UIButton alloc]init];
        tou.frame = CGRectMake((width - width / 8.5)/2 , width / 8.5 / 2, width / 8.5, width / 8.5);
        [tou setTitle:@"头部" forState:UIControlStateNormal];
        [tou setTitleColor:[UIColor colorWithHexString:@"323232" alpha:1] forState:UIControlStateNormal];
        tou.titleLabel.font = [UIFont systemFontOfSize:20];
        [beijing bringSubviewToFront:tou];
        [beijing addSubview:tou];
        //肩部
        UIButton *zuojian = [[UIButton alloc]init];
        zuojian.frame = CGRectMake(width / 8.5 * 2.5,width / 8.5 / 2 + width / 8.5 *1.5 ,width / 8.5,width / 8.5 /2);
        [zuojian setTitle:@"肩部" forState:UIControlStateNormal];
        [zuojian setTitleColor:[UIColor colorWithHexString:@"323232" alpha:1] forState:UIControlStateNormal];
        zuojian.titleLabel.font = [UIFont systemFontOfSize:18];
        [beijing bringSubviewToFront:zuojian];
        [beijing addSubview:zuojian];
        
        UIButton *youjian = [[UIButton alloc]init];
        youjian.frame = CGRectMake(width / 8.5 * 2.5 + width / 8.5 * 2.5  ,width / 8.5 / 2 + width / 8.5 *1.5 ,width / 8.5,width / 8.5 /2);
        [youjian setTitle:@"肩部" forState:UIControlStateNormal];
        [youjian setTitleColor:[UIColor colorWithHexString:@"323232" alpha:1] forState:UIControlStateNormal];
        youjian.titleLabel.font = [UIFont systemFontOfSize:18];
        [beijing bringSubviewToFront:youjian];
        [beijing addSubview:youjian];
        //胸部
        UIButton *xiong = [[UIButton alloc]init];
        xiong.frame = CGRectMake(CGRectGetMaxX(zuojian.frame),CGRectGetMaxY(youjian.frame) + (width / 8.5 ) * 0.2,CGRectGetMinX(youjian.frame) - CGRectGetMaxX(zuojian.frame),width / 8.5 );
        [xiong setTitle:@"胸部" forState:UIControlStateNormal];
        [xiong setTitleColor:[UIColor colorWithHexString:@"323232" alpha:1] forState:UIControlStateNormal];
        xiong.titleLabel.font = [UIFont systemFontOfSize:20];
        [beijing bringSubviewToFront:xiong];
        [beijing addSubview:xiong];
        //上臂
        UIButton *zuoshang = [[UIButton alloc]init];
        zuoshang.frame = CGRectMake(width / 8.5 *2,CGRectGetMaxY(xiong.frame) * 0.9,width / 8.5,width / 8.5 / 2);
        [zuoshang setTitle:@"上臂" forState:UIControlStateNormal];
        [zuoshang setTitleColor:[UIColor colorWithHexString:@"323232" alpha:1] forState:UIControlStateNormal];
        zuoshang.titleLabel.font = [UIFont systemFontOfSize:18];
        [beijing bringSubviewToFront:zuoshang];
        [beijing addSubview:zuoshang];
        
        UIButton *youshang = [[UIButton alloc]init];
        youshang.frame = CGRectMake(CGRectGetMaxX(zuoshang.frame) + width / 8.5 *2.5,CGRectGetMaxY(xiong.frame) * 0.9,width / 8.5,width / 8.5 / 2);
        [youshang setTitle:@"上臂" forState:UIControlStateNormal];
        [youshang setTitleColor:[UIColor colorWithHexString:@"323232" alpha:1] forState:UIControlStateNormal];
        youshang.titleLabel.font = [UIFont systemFontOfSize:18];
        [beijing bringSubviewToFront:youshang];
        [beijing addSubview:youshang];
        //腹部
        UIButton *fu = [[UIButton alloc]init];
        fu.frame = CGRectMake(CGRectGetMinX(xiong.frame),CGRectGetMaxY(youshang.frame),CGRectGetMaxX(xiong.frame) - CGRectGetMinX(xiong.frame),width / 8.5 * 1.3);
        [fu setTitle:@"腹部" forState:UIControlStateNormal];
        [fu setTitleColor:[UIColor colorWithHexString:@"323232" alpha:1] forState:UIControlStateNormal];
        fu.titleLabel.font = [UIFont systemFontOfSize:20];
        [beijing bringSubviewToFront:fu];
        [beijing addSubview:fu];
        //腰部
        UIButton *yao = [[UIButton alloc]init];
        yao.frame = CGRectMake(CGRectGetMinX(xiong.frame),CGRectGetMaxY(fu.frame) + width / 8.5 * 1.3 * 0.2,CGRectGetMaxX(xiong.frame) - CGRectGetMinX(xiong.frame),width / 8.5 * 0.6);
        [yao setTitle:@"腰部" forState:UIControlStateNormal];
        [yao setTitleColor:[UIColor colorWithHexString:@"323232" alpha:1] forState:UIControlStateNormal];
        yao.titleLabel.font = [UIFont systemFontOfSize:20];
        [beijing bringSubviewToFront:yao];
        [beijing addSubview:yao];
        //前臂
        UIButton *zuoqian = [[UIButton alloc]init];
        zuoqian.frame = CGRectMake(width / 8.5 * 1.7,CGRectGetMaxY(fu.frame) + width / 8.5 * 1.3 * 0.2,(CGRectGetMaxX(xiong.frame) - CGRectGetMinX(xiong.frame)) * 0.6,width / 8.5 * 0.6);
        [zuoqian setTitle:@"前臂" forState:UIControlStateNormal];
        [zuoqian setTitleColor:[UIColor colorWithHexString:@"323232" alpha:1] forState:UIControlStateNormal];
        zuoqian.titleLabel.font = [UIFont systemFontOfSize:18];
        [beijing bringSubviewToFront:zuoqian];
        [beijing addSubview:zuoqian];
        
        UIButton *youqian = [[UIButton alloc]init];
        youqian.frame = CGRectMake(CGRectGetMaxX(yao.frame) + (CGRectGetMinX(yao.frame)-CGRectGetMaxX(zuoqian.frame)) ,CGRectGetMaxY(fu.frame) + width / 8.5 * 1.3 * 0.2,(CGRectGetMaxX(xiong.frame) - CGRectGetMinX(xiong.frame)) * 0.6,width / 8.5 * 0.6);
        [youqian setTitle:@"前臂" forState:UIControlStateNormal];
        [youqian setTitleColor:[UIColor colorWithHexString:@"323232" alpha:1] forState:UIControlStateNormal];
        youqian.titleLabel.font = [UIFont systemFontOfSize:18];
        [beijing bringSubviewToFront:youqian];
        [beijing addSubview:youqian];
        //生殖器官
        UIButton *shengzhi = [[UIButton alloc]init];
        shengzhi.frame = CGRectMake(CGRectGetMinX(xiong.frame) ,CGRectGetMaxY(yao.frame) + width / 8.5 * 0.5,CGRectGetMaxX(xiong.frame) - CGRectGetMinX(xiong.frame),width / 8.5 * 0.5);
        [shengzhi setTitle:@"生殖器官" forState:UIControlStateNormal];
        [shengzhi setTitleColor:[UIColor colorWithHexString:@"323232" alpha:1] forState:UIControlStateNormal];
        shengzhi.titleLabel.font = [UIFont systemFontOfSize:18];
        [beijing bringSubviewToFront:shengzhi];
        [beijing addSubview:shengzhi];
        //手
        UIButton *zuoshou = [[UIButton alloc]init];
        zuoshou.frame = CGRectMake(width / 8.5 * 1.6 ,CGRectGetMaxY(shengzhi.frame) ,(CGRectGetMaxX(xiong.frame) - CGRectGetMinX(xiong.frame)) * 0.6,width / 8.5 * 0.5);
        [zuoshou setTitle:@"手" forState:UIControlStateNormal];
        [zuoshou setTitleColor:[UIColor colorWithHexString:@"323232" alpha:1] forState:UIControlStateNormal];
        zuoshou.titleLabel.font = [UIFont systemFontOfSize:18];
        [beijing bringSubviewToFront:zuoshou];
        [beijing addSubview:zuoshou];
        
        UIButton *youshou = [[UIButton alloc]init];
        youshou.frame = CGRectMake(CGRectGetMinX(shengzhi.frame) - CGRectGetMaxX(zuoshou.frame) + CGRectGetMaxX(shengzhi.frame) ,CGRectGetMaxY(shengzhi.frame) ,(CGRectGetMaxX(xiong.frame) - CGRectGetMinX(xiong.frame)) * 0.6,width / 8.5 * 0.5);
        [youshou setTitle:@"手" forState:UIControlStateNormal];
        [youshou setTitleColor:[UIColor colorWithHexString:@"323232" alpha:1] forState:UIControlStateNormal];
        youshou.titleLabel.font = [UIFont systemFontOfSize:18];
        [beijing bringSubviewToFront:youshou];
        [beijing addSubview:youshou];
        //大腿
        UIButton *zuoda = [[UIButton alloc]init];
        zuoda.frame = CGRectMake(width / 8.5 *3,CGRectGetMaxY(shengzhi.frame)+width/8.5*0.5,width / 8.5 ,width / 8.5 * 0.5);
        [zuoda setTitle:@"大腿" forState:UIControlStateNormal];
        [zuoda setTitleColor:[UIColor colorWithHexString:@"323232" alpha:1] forState:UIControlStateNormal];
        zuoda.titleLabel.font = [UIFont systemFontOfSize:18];
        [beijing bringSubviewToFront:zuoda];
        [beijing addSubview:zuoda];
        
        UIButton *youda = [[UIButton alloc]init];
        youda.frame = CGRectMake(CGRectGetMaxX(zuoda.frame) + width / 8.5 / 2,CGRectGetMaxY(shengzhi.frame)+width/8.5*0.5,width / 8.5 ,width / 8.5 * 0.5);
        [youda setTitle:@"大腿" forState:UIControlStateNormal];
        [youda setTitleColor:[UIColor colorWithHexString:@"323232" alpha:1] forState:UIControlStateNormal];
        youda.titleLabel.font = [UIFont systemFontOfSize:18];
        [beijing bringSubviewToFront:youda];
        [beijing addSubview:youda];
        //膝盖
        UIButton *zuoxi = [[UIButton alloc]init];
        zuoxi.frame = CGRectMake(width / 8.5 *3.2,CGRectGetMaxY(zuoda.frame)+width/8.5*1.2,width / 8.5 *0.8 ,width / 8.5 * 0.5);
        [zuoxi setTitle:@"膝盖" forState:UIControlStateNormal];
        [zuoxi setTitleColor:[UIColor colorWithHexString:@"323232" alpha:1] forState:UIControlStateNormal];
        zuoxi.titleLabel.font = [UIFont systemFontOfSize:18];
        [beijing bringSubviewToFront:zuoxi];
        [beijing addSubview:zuoxi];
        
        UIButton *youxi = [[UIButton alloc]init];
        youxi.frame = CGRectMake(CGRectGetMaxX(zuoxi.frame) + width / 8.5 * 0.5,CGRectGetMaxY(zuoda.frame)+width/8.5*1.2,width / 8.5 *0.8 ,width / 8.5 * 0.5);
        [youxi setTitle:@"膝盖" forState:UIControlStateNormal];
        [youxi setTitleColor:[UIColor colorWithHexString:@"323232" alpha:1] forState:UIControlStateNormal];
        youxi.titleLabel.font = [UIFont systemFontOfSize:18];
        [beijing bringSubviewToFront:youxi];
        [beijing addSubview:youxi];
        //小腿
        UIButton *zuoxiao = [[UIButton alloc]init];
        zuoxiao.frame = CGRectMake(width / 8.5 *3.2,CGRectGetMaxY(zuoxi.frame)+width/8.5*1.5,width / 8.5 *0.8 ,width / 8.5 * 0.5);
        [zuoxiao setTitle:@"小腿" forState:UIControlStateNormal];
        [zuoxiao setTitleColor:[UIColor colorWithHexString:@"323232" alpha:1] forState:UIControlStateNormal];
        zuoxiao.titleLabel.font = [UIFont systemFontOfSize:18];
        [beijing bringSubviewToFront:zuoxiao];
        [beijing addSubview:zuoxiao];
        
        UIButton *youxiao = [[UIButton alloc]init];
        youxiao.frame = CGRectMake(CGRectGetMaxX(zuoxiao.frame) + width / 8.5 * 0.5,CGRectGetMaxY(zuoxi.frame)+width/8.5*1.5,width / 8.5 *0.8 ,width / 8.5 * 0.5);
        [youxiao setTitle:@"小腿" forState:UIControlStateNormal];
        [youxiao setTitleColor:[UIColor colorWithHexString:@"323232" alpha:1] forState:UIControlStateNormal];
        youxiao.titleLabel.font = [UIFont systemFontOfSize:18];
        [beijing bringSubviewToFront:youxiao];
        [beijing addSubview:youxiao];
        //脚
        UIButton *zuojiao = [[UIButton alloc]init];
        zuojiao.frame = CGRectMake(width / 8.5 *3.2,viewgao - width / 8.5 *0.5 * 2,width / 8.5 *0.8 ,width / 8.5 * 0.5);
        [zuojiao setTitle:@"脚" forState:UIControlStateNormal];
        [zuojiao setTitleColor:[UIColor colorWithHexString:@"323232" alpha:1] forState:UIControlStateNormal];
        zuojiao.titleLabel.font = [UIFont systemFontOfSize:18];
        [beijing bringSubviewToFront:zuojiao];
        [beijing addSubview:zuojiao];
        
        UIButton *youjiao = [[UIButton alloc]init];
        youjiao.frame = CGRectMake(CGRectGetMaxX(zuojiao.frame) + width / 8.5 * 0.5,viewgao - width / 8.5 *0.5 * 2,width / 8.5 *0.8 ,width / 8.5 * 0.5);
        [youjiao setTitle:@"脚" forState:UIControlStateNormal];
        [youjiao setTitleColor:[UIColor colorWithHexString:@"323232" alpha:1] forState:UIControlStateNormal];
        youjiao.titleLabel.font = [UIFont systemFontOfSize:18];
        [beijing bringSubviewToFront:youjiao];
        [beijing addSubview:youjiao];
        
    }
    else if (panduan == 2){
        
        renti.image = [UIImage imageNamed:@"people1.png"];
        
        //颈部
        UIButton *jing = [[UIButton alloc]init];
        jing.frame = CGRectMake((width - width / 8.5) / 2,width / 8.5 * 1.3,width / 8.5, width / 8.5);
        [jing setTitle:@"颈部" forState:UIControlStateNormal];
        [jing setTitleColor:[UIColor colorWithHexString:@"323232" alpha:1] forState:UIControlStateNormal];
        jing.titleLabel.font = [UIFont systemFontOfSize:20];
        [beijing bringSubviewToFront:jing];
        [beijing addSubview:jing];
        //背部
        UIButton *bei = [[UIButton alloc]init];
        bei.frame = CGRectMake((width - width / 8.5) / 2,CGRectGetMaxY(jing.frame) + width/8.5 * 1,width / 8.5, width / 8.5);
        [bei setTitle:@"背部" forState:UIControlStateNormal];
        [bei setTitleColor:[UIColor colorWithHexString:@"323232" alpha:1] forState:UIControlStateNormal];
        bei.titleLabel.font = [UIFont systemFontOfSize:20];
        [beijing bringSubviewToFront:bei];
        [beijing addSubview:bei];
        //腰部
        UIButton *yao = [[UIButton alloc]init];
        yao.frame = CGRectMake((width - width / 8.5) / 2,CGRectGetMaxY(bei.frame) + width/8.5 * 0.5,width / 8.5, width / 8.5);
        [yao setTitle:@"腰部" forState:UIControlStateNormal];
        [yao setTitleColor:[UIColor colorWithHexString:@"323232" alpha:1] forState:UIControlStateNormal];
        yao.titleLabel.font = [UIFont systemFontOfSize:20];
        [beijing bringSubviewToFront:yao];
        [beijing addSubview:yao];
        //肘部
        UIButton *zuozhou = [[UIButton alloc]init];
        zuozhou.frame = CGRectMake(width / 8.5 * 1.8,CGRectGetMaxY(bei.frame) + width/8.5 * 0.2,width / 8.5, width / 8.5);
        [zuozhou setTitle:@"肘部" forState:UIControlStateNormal];
        [zuozhou setTitleColor:[UIColor colorWithHexString:@"323232" alpha:1] forState:UIControlStateNormal];
        zuozhou.titleLabel.font = [UIFont systemFontOfSize:20];
        [beijing bringSubviewToFront:zuozhou];
        [beijing addSubview:zuozhou];
        
        UIButton *youzhou = [[UIButton alloc]init];
        youzhou.frame = CGRectMake(width - width / 8.5 * 1.8 - width / 8.5,CGRectGetMaxY(bei.frame) + width/8.5 * 0.2,width / 8.5, width / 8.5);
        [youzhou setTitle:@"肘部" forState:UIControlStateNormal];
        [youzhou setTitleColor:[UIColor colorWithHexString:@"323232" alpha:1] forState:UIControlStateNormal];
        youzhou.titleLabel.font = [UIFont systemFontOfSize:20];
        [beijing bringSubviewToFront:youzhou];
        [beijing addSubview:youzhou];
        //臀部
        UIButton *tun = [[UIButton alloc]init];
        tun.frame = CGRectMake((width - width / 8.5) / 2,CGRectGetMaxY(yao.frame) + width/8.5 * 0.5,width / 8.5, width / 8.5);
        [tun setTitle:@"臀部" forState:UIControlStateNormal];
        [tun setTitleColor:[UIColor colorWithHexString:@"323232" alpha:1] forState:UIControlStateNormal];
        tun.titleLabel.font = [UIFont systemFontOfSize:20];
        [beijing bringSubviewToFront:tun];
        [beijing addSubview:tun];
        //大腿
        UIButton *zuoda = [[UIButton alloc]init];
        zuoda.frame = CGRectMake(width / 8.5 *2.9,CGRectGetMaxY(tun.frame)+width/8.5*0.5,width / 8.5 ,width / 8.5 * 0.5);
        [zuoda setTitle:@"大腿" forState:UIControlStateNormal];
        [zuoda setTitleColor:[UIColor colorWithHexString:@"323232" alpha:1] forState:UIControlStateNormal];
        zuoda.titleLabel.font = [UIFont systemFontOfSize:18];
        [beijing bringSubviewToFront:zuoda];
        [beijing addSubview:zuoda];
        
        UIButton *youda = [[UIButton alloc]init];
        youda.frame = CGRectMake(CGRectGetMaxX(zuoda.frame) + width / 8.5 / 2,CGRectGetMaxY(tun.frame)+width/8.5*0.5,width / 8.5 ,width / 8.5 * 0.5);
        [youda setTitle:@"大腿" forState:UIControlStateNormal];
        [youda setTitleColor:[UIColor colorWithHexString:@"323232" alpha:1] forState:UIControlStateNormal];
        youda.titleLabel.font = [UIFont systemFontOfSize:18];
        [beijing bringSubviewToFront:youda];
        [beijing addSubview:youda];
        //小腿
        UIButton *zuoxiao = [[UIButton alloc]init];
        zuoxiao.frame = CGRectMake(width / 8.5 *2.8,CGRectGetMaxY(zuoda.frame)+width/8.5*2.5,width / 8.5 *0.8 ,width / 8.5 * 0.5);
        [zuoxiao setTitle:@"小腿" forState:UIControlStateNormal];
        [zuoxiao setTitleColor:[UIColor colorWithHexString:@"323232" alpha:1] forState:UIControlStateNormal];
        zuoxiao.titleLabel.font = [UIFont systemFontOfSize:18];
        [beijing bringSubviewToFront:zuoxiao];
        [beijing addSubview:zuoxiao];
        
        UIButton *youxiao = [[UIButton alloc]init];
        youxiao.frame = CGRectMake(CGRectGetMaxX(zuoxiao.frame) + width / 8.5 * 1,CGRectGetMaxY(zuoda.frame)+width/8.5*2.5,width / 8.5 *0.8 ,width / 8.5 * 0.5);
        [youxiao setTitle:@"小腿" forState:UIControlStateNormal];
        [youxiao setTitleColor:[UIColor colorWithHexString:@"323232" alpha:1] forState:UIControlStateNormal];
        youxiao.titleLabel.font = [UIFont systemFontOfSize:18];
        [beijing bringSubviewToFront:youxiao];
        [beijing addSubview:youxiao];
    }
    
}
- (void)biaoqian:(UIButton *)btn{
    
    if (btn == zhuanshen) {
        
        if (panduan == 1) {
            [beijing removeFromSuperview];
            panduan = 2;
            [self tupian];
        }
        else
        {
            [beijing removeFromSuperview];
            panduan = 1;
            [self tupian];
        }
        
    }
    
}
#pragma  mark --- tableview
-(void)tableview
{
    erji = [[NSArray alloc]init];
    
    self.tableview1 = [[UITableView alloc]init];
    self.tableview1.frame = CGRectMake(0, 64, width/3, height - 64);
    self.tableview1.backgroundColor = [UIColor colorWithHexString:@"f4f4f4" alpha:1];
    self.tableview1.delegate = self;
    self.tableview1.dataSource = self;
    self.tableview1.tableFooterView = [[UIView alloc] init];
    [self.view addSubview:self.tableview1];
    
    self.tableview2 = [[UITableView alloc]init];
    self.tableview2.frame = CGRectMake(width/3, 64, width/3*2, height - 64);
    self.tableview2.backgroundColor = [UIColor whiteColor];
    self.tableview2.delegate = self;
    self.tableview2.dataSource = self;
    self.tableview2.tableFooterView = [[UIView alloc] init];
    [self.view addSubview:self.tableview2];
    
}
//组
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
//行
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.tableview1) {
        return yiji.count;
    }
    return erji.count;
}
//cell高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
        return 50;
}
//编辑Cell
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *id1 =@"cell1";
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:id1];
    }
    
    if (tableView == self.tableview1) {
        
        cell.contentView.backgroundColor = [UIColor colorWithHexString:@"f4f4f4" alpha:1];
        
        UILabel *bingzheng = [[UILabel alloc]init];
        bingzheng.frame = CGRectMake(0, 0, width/3, 50);
        bingzheng.backgroundColor = [UIColor clearColor];
        bingzheng.text = yiji[indexPath.row];
        bingzheng.textColor = [UIColor colorWithHexString:@"323232" alpha:1];
        bingzheng.textAlignment = NSTextAlignmentCenter;
        bingzheng.font = [UIFont systemFontOfSize:15.0];
        [cell.contentView addSubview:bingzheng];
        
        UIView *view = [[UIView alloc]init];
        view.frame = CGRectMake(0, 49, width/3, 1);
        view.backgroundColor = [UIColor colorWithHexString:@"e2e2e2" alpha:1];
        [cell.contentView addSubview:view];
        
        //自定义cell选中颜色
        UIView *bgColorView = [[UIView alloc] init];
        bgColorView.backgroundColor = [UIColor whiteColor];
        [cell setSelectedBackgroundView:bgColorView];
    }
    else if (tableView == self.tableview2)
    {
        UILabel *bingzheng = [[UILabel alloc]init];
        bingzheng.frame = CGRectMake(0, 0, width/3*2, 50);
        bingzheng.backgroundColor = [UIColor clearColor];
        bingzheng.text = [erji[indexPath.row] objectForKey:@"name"];
        bingzheng.textColor = [UIColor colorWithHexString:@"323232" alpha:1];
        bingzheng.textAlignment = NSTextAlignmentCenter;
        bingzheng.font = [UIFont systemFontOfSize:15.0];
        [cell.contentView addSubview:bingzheng];
        
        //自定义cell选中颜色
        UIView *bgColorView = [[UIView alloc] init];
        bgColorView.backgroundColor = [UIColor colorWithHexString:@"f4f4f4" alpha:1];
        [cell setSelectedBackgroundView:bgColorView];
    }
    //cell点击不变色
    //cell.selectionStyle = UITableViewCellSelectionStyleNone;
    //线消失
    self.tableview1.separatorStyle = UITableViewCellSelectionStyleNone;
    self.tableview2.separatorStyle = UITableViewCellSelectionStyleNone;
    //隐藏滑动条
    self.tableview1.showsVerticalScrollIndicator =NO;
    self.tableview2.showsVerticalScrollIndicator =NO;
    
    return cell;

}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (tableView == self.tableview1) {
        //获取一级名字
        NSString *str = [NSString stringWithFormat:@"%@",yiji[indexPath.row]];
        //获取plist文件
        NSString *path = [[NSBundle mainBundle] pathForResource:@"zizhen.plist" ofType:nil];
        //读文件
        dic2 = [NSDictionary dictionaryWithContentsOfFile:path];
        erji = [dic2 objectForKey:str];
        //刷新 tableview2
        [self.tableview2 reloadData];
    }
    else if (tableView == self.tableview2){
        //  跳页
        YdmingchengViewController *mingcheng = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"mingcheng"];
        mingcheng.sanji = [erji[indexPath.row] objectForKey:@"name"];
        [self.navigationController pushViewController:mingcheng animated:YES];
    }

}

-(void)fanhui
{
    //返回上一页
    [self.navigationController popViewControllerAnimated:YES];
}

@end
