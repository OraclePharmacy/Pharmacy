//
//  YdInformationViewController.m
//  Pharmacy
//
//  Created by suokun on 16/4/6.
//  Copyright © 2016年 sk. All rights reserved.
//

#import "YdInformationViewController.h"
#import "Color+Hex.h"
#import "YdInformationDetailsViewController.h"
#import "YdTextDetailsViewController.h"
@interface YdInformationViewController ()
{
    UICollectionView * CollectionView;
    NSString * identifier;
    
    int index;
    int zhi ;
    
    CGFloat width;
    CGFloat height;
    
    int i;
    
    UITableViewCell *cell;
    
}
@property(strong,nonatomic) UIScrollView *scrollView;
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
    
    self.tableview = [[UITableView alloc]init];
    self.tableview.frame = CGRectMake(0, 64, width, height - 64 - 40);
    [self.view addSubview:self.tableview];
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    
    //设置导航栏左按钮
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"圆角矩形-6@3x.png"] style:UIBarButtonItemStyleDone target:self action:@selector(presentLeftMenuViewController:)];
    
    //进入界面   给zhi赋值
    zhi = 1;
    
}

-(void)tab
{
    //设置scrollView
    self.scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, width, 30)];
    //for循环创建button
    for (i = 0; i < 8; i++) {
        
        UIButton *tabButton = [[UIButton alloc]init];
        tabButton.tag = 300+i;
        tabButton.frame = CGRectMake(width/5*i, 0, width/5, 30);
        tabButton.backgroundColor = [UIColor clearColor];
        [tabButton addTarget:self action:@selector(handleClick:) forControlEvents:UIControlEventTouchUpInside];
        
        //图片
        UIImageView *imageview = [[UIImageView alloc]init];
        imageview.frame = CGRectMake(0, 0, width/5, 30);
        imageview.image = [UIImage imageNamed:@"IMG_0799.jpg"];
        //名称
        UILabel *name = [[UILabel alloc]init];
        name.frame = CGRectMake(0, 0,  width/5, 30);
        name.font = [UIFont systemFontOfSize:15];
        name.textAlignment = NSTextAlignmentCenter;
        name.textColor = [UIColor colorWithHexString:@"323232" alpha:1];
        //通过分段控制器给lable赋值
        if (zhi == 1)
        {
            name.text = @"泻立停";
        }
        else
        {
            name.text = @"泻立停1";
        }
        
        
        self.scrollView.pagingEnabled = YES;
        
        self.scrollView.delegate = self;
        
        
        [self.scrollView addSubview:tabButton];
        [tabButton addSubview:imageview];
        [tabButton addSubview:name];
        
    }
    //设置可滑动大小
    self.scrollView.contentSize = CGSizeMake(width/5*i, 30);
    
    [cell.contentView addSubview:self.scrollView];
    //隐藏滚动条
    self.scrollView.showsHorizontalScrollIndicator = NO;
    
}
//scrollview上面button点击事件
- (void)handleClick:(UIButton *)btn
{
    
    if (btn.tag == 300)
    {
        
    }
    
    NSLog(@"%ld",btn.tag);
    
}

//分段控制器  点击方法
- (IBAction)Segmented:(id)sender {
    index = (int)self.Segmented.selectedSegmentIndex;
    if (index == 0 ) {
        //点击分段控制前半段zhi赋值为1
        zhi = 1;
        //刷新tableview
        [self.tableview reloadData];
    }
    else if(index == 1){
        //点击分段控制前半段zhi赋值为2
        zhi = 2;
        //刷新tableview
        [self.tableview reloadData];
    }

}
#pragma 设置tableview
//组
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (zhi == 1)
    {
        return 2;
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
        if (section == 0)
        {
            return 1;
        }
        else
        {
            return 5;
        }
    }
    else
    {
        return 3;
    }
    }
//cell高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    
    if (zhi == 1) {
        if (indexPath.section == 0)
        {
            return 180;
        }
        else
        {
            return 160;
        }
    }
    else
        return 160;
}
//header 高度
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *id1 =@"cell1";
    
    cell = [tableView cellForRowAtIndexPath:indexPath];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:id1];
    }
    if (zhi == 1)
    {
        if (indexPath.section == 0) {
            //创建scrollview
            [self tab];
            //创建图片
            UIImageView *img = [[UIImageView alloc]init];
            img.frame = CGRectMake(0, 30, width, 150);
            img.backgroundColor = [UIColor colorWithHexString:@"943545" alpha:1];
            
            [cell.contentView addSubview:img];
        }
        else
        {
            UIImageView *image = [[UIImageView alloc]init];
            image.frame = CGRectMake(10, 10, 100 , 100);
            image.image = [UIImage imageNamed:@"IMG_0800.jpg"];
            
            UILabel *title = [[UILabel alloc]init];
            title.frame = CGRectMake(CGRectGetMaxX(image.frame) + 10, 10, width - CGRectGetMaxY(image.frame) - 20, 30);
            title.font = [UIFont systemFontOfSize:15];
            title.text = @"纵容他人的欺骗，害人害己速度速度";
            title.textColor = [UIColor colorWithHexString:@"323232" alpha:1];
            //title.backgroundColor = [UIColor grayColor];
            
            UILabel *content = [[UILabel alloc]init];
            content.frame = CGRectMake(CGRectGetMaxX(image.frame) + 10, 60, width - CGRectGetMaxY(image.frame) - 20, 40);
            content.font = [UIFont systemFontOfSize:12];
            content.text = @"纵容他人的欺骗，害人害己 纵容他人的欺骗，害人害己 纵容他人的欺骗，害人害己";
            content.textColor = [UIColor colorWithHexString:@"646464" alpha:1];
            content.numberOfLines = 2;
            //content.backgroundColor = [UIColor grayColor];
            
            UILabel *time = [[UILabel alloc]init];
            time.frame = CGRectMake(width - 120, 100, 110, 20);
            time.font = [UIFont systemFontOfSize:10];
            time.text = @"2016-04-27 14:05:25";
            time.textColor = [UIColor colorWithHexString:@"646464" alpha:1];
            time.numberOfLines = 2;
            //time.backgroundColor = [UIColor grayColor];

            
            UIView *xian = [[UIView alloc] init];
            xian.frame = CGRectMake(0, 120, width, 1);
            xian.backgroundColor = [UIColor colorWithHexString:@"e2e2e2" alpha:1];
            
            UILabel *laiyuan = [[UILabel alloc]init];
            laiyuan.frame = CGRectMake(10,130, 100, 20);
            laiyuan.font = [UIFont systemFontOfSize:13];
            laiyuan.text = @"情感.今天";
            laiyuan.textColor = [UIColor colorWithHexString:@"646464" alpha:1];
            
            
            UIButton *fenxiang = [[UIButton alloc] init];
            fenxiang.frame = CGRectMake(width - 70 ,130 ,20 ,20);
            fenxiang.backgroundColor = [UIColor clearColor];
            [fenxiang addTarget:self action:@selector(fenxiang) forControlEvents:UIControlEventTouchUpInside];
            
            
            UILabel *fenxianglabel = [[UILabel alloc]init];
            fenxianglabel.frame = CGRectMake(0,0,70,20);
            fenxianglabel.text = @"阅读量: 20";
            fenxianglabel.textColor = [UIColor colorWithHexString:@"646464" alpha:1];
            fenxianglabel.font = [UIFont systemFontOfSize:11];
            [fenxiang addSubview:fenxianglabel];
            
            
            UIButton *shoucang = [[UIButton alloc] init];
            shoucang.frame = CGRectMake(width - 140 ,130 ,20 ,20);
            shoucang.backgroundColor = [UIColor clearColor];
            [shoucang addTarget:self action:@selector(shoucang) forControlEvents:UIControlEventTouchUpInside];
            
            
            UILabel *shoucanglabel = [[UILabel alloc]init];
            shoucanglabel.frame = CGRectMake(0,0,70,20);
            shoucanglabel.text = @"点赞量: 2000";
            shoucanglabel.textColor = [UIColor colorWithHexString:@"646464" alpha:1];
            shoucanglabel.font = [UIFont systemFontOfSize:11];
            [shoucang addSubview:shoucanglabel];
            
            UIView *xian1 = [[UIView alloc] init];
            xian1.frame = CGRectMake(0, 159, width, 1);
            xian1.backgroundColor = [UIColor colorWithHexString:@"e2e2e2" alpha:1];
            
            [cell.contentView addSubview:image];
            [cell.contentView addSubview:title];
            [cell.contentView addSubview:content];
            [cell.contentView addSubview:xian];
            [cell.contentView addSubview:time];
            [cell.contentView addSubview:shoucang];
            [cell.contentView addSubview:fenxiang];
            [cell.contentView addSubview:laiyuan];
            [cell.contentView addSubview:xian1];
        }
        

    }
    else
    {
        UIImageView *image = [[UIImageView alloc]init];
        image.frame = CGRectMake(10, 10, 100 , 100);
        image.image = [UIImage imageNamed:@"IMG_0800.jpg"];
        
        UILabel *title = [[UILabel alloc]init];
        title.frame = CGRectMake(CGRectGetMaxX(image.frame) + 10, 10, width - CGRectGetMaxY(image.frame) - 20, 30);
        title.font = [UIFont systemFontOfSize:15];
        title.text = @"纵容他人的欺骗，害人害己速度速度";
        title.textColor = [UIColor colorWithHexString:@"323232" alpha:1];
        //title.backgroundColor = [UIColor grayColor];
        
        UILabel *content = [[UILabel alloc]init];
        content.frame = CGRectMake(CGRectGetMaxX(image.frame) + 10, 60, width - CGRectGetMaxY(image.frame) - 20, 40);
        content.font = [UIFont systemFontOfSize:12];
        content.text = @"纵容他人的欺骗，害人害己 纵容他人的欺骗，害人害己 纵容他人的欺骗，害人害己";
        content.textColor = [UIColor colorWithHexString:@"646464" alpha:1];
        content.numberOfLines = 2;
        //content.backgroundColor = [UIColor grayColor];
        
        UILabel *time = [[UILabel alloc]init];
        time.frame = CGRectMake(width - 120, 100, 110, 20);
        time.font = [UIFont systemFontOfSize:10];
        time.text = @"2016-04-27 14:05:25";
        time.textColor = [UIColor colorWithHexString:@"646464" alpha:1];
        time.numberOfLines = 2;
        //time.backgroundColor = [UIColor grayColor];
        
        
        UIView *xian = [[UIView alloc] init];
        xian.frame = CGRectMake(0, 120, width, 1);
        xian.backgroundColor = [UIColor colorWithHexString:@"e2e2e2" alpha:1];
        
        UILabel *laiyuan = [[UILabel alloc]init];
        laiyuan.frame = CGRectMake(10,130, 100, 20);
        laiyuan.font = [UIFont systemFontOfSize:13];
        laiyuan.text = @"情感.今天";
        laiyuan.textColor = [UIColor colorWithHexString:@"646464" alpha:1];
        
        
        UIButton *fenxiang = [[UIButton alloc] init];
        fenxiang.frame = CGRectMake(width - 70 ,130 ,20 ,20);
        fenxiang.backgroundColor = [UIColor clearColor];
        [fenxiang addTarget:self action:@selector(fenxiang) forControlEvents:UIControlEventTouchUpInside];
        
        
        UILabel *fenxianglabel = [[UILabel alloc]init];
        fenxianglabel.frame = CGRectMake(0,0,70,20);
        fenxianglabel.text = @"阅读量: 20";
        fenxianglabel.textColor = [UIColor colorWithHexString:@"646464" alpha:1];
        fenxianglabel.font = [UIFont systemFontOfSize:11];
        [fenxiang addSubview:fenxianglabel];
        
        
        UIButton *shoucang = [[UIButton alloc] init];
        shoucang.frame = CGRectMake(width - 140 ,130 ,20 ,20);
        shoucang.backgroundColor = [UIColor clearColor];
        [shoucang addTarget:self action:@selector(shoucang) forControlEvents:UIControlEventTouchUpInside];
        
        
        UILabel *shoucanglabel = [[UILabel alloc]init];
        shoucanglabel.frame = CGRectMake(0,0,70,20);
        shoucanglabel.text = @"点赞量: 2000";
        shoucanglabel.textColor = [UIColor colorWithHexString:@"646464" alpha:1];
        shoucanglabel.font = [UIFont systemFontOfSize:11];
        [shoucang addSubview:shoucanglabel];
        
        UIView *xian1 = [[UIView alloc] init];
        xian1.frame = CGRectMake(0, 159, width, 1);
        xian1.backgroundColor = [UIColor colorWithHexString:@"e2e2e2" alpha:1];
        
        [cell.contentView addSubview:image];
        [cell.contentView addSubview:title];
        [cell.contentView addSubview:content];
        [cell.contentView addSubview:xian];
        [cell.contentView addSubview:time];
        [cell.contentView addSubview:shoucang];
        [cell.contentView addSubview:fenxiang];
        [cell.contentView addSubview:laiyuan];
        [cell.contentView addSubview:xian1];
        
    }
    
    //cell点击不变色
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    //线消失
    self.tableview.separatorStyle = UITableViewCellSelectionStyleNone;
    //隐藏滑动条
    self.tableview.showsVerticalScrollIndicator =NO;
    
    return cell;
}

-(void)fenxiang
{
    NSLog(@"分享");
}
-(void)shoucang
{
    NSLog(@"收藏");
}
//tableview点击事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(zhi == 1)
    {
        //跳转文字资讯详情
        YdTextDetailsViewController *TextDetails = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"textdetails"];
        [self.navigationController pushViewController:TextDetails animated:YES];

    }
    else
    {
        //跳转健康电台详情
        YdInformationDetailsViewController *InformationDetails = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"informationdetails"];
        [self.navigationController pushViewController:InformationDetails animated:YES];
    }
    
}

@end
