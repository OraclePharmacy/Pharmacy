//
//  YdRemindViewController.m
//  Pharmacy
//
//  Created by suokun on 16/4/13.
//  Copyright © 2016年 sk. All rights reserved.
//

#import "YdRemindViewController.h"
#import "AppDelegate.h"
#import "Color+Hex.h"
#import "ModelClock.h"
#import "AlarmClockManager.h"

@interface YdRemindViewController ()<UITableViewDataSource,UITableViewDelegate,UIPickerViewDataSource,UIPickerViewDelegate,UIAlertViewDelegate>
{
    CGFloat width;
    CGFloat height;
    
    UITableView *myTable;
        
    UIButton *myButton,*mySender;
    UIPickerView *myPicker;
        
        
    NSMutableArray *arr1, *arr ,*allArr;
        
    UINavigationController *myNavigation;
        
    //选中的时间
    NSMutableArray *chooseTime;
        
        
    int cishu;
        
    int number;
        
    UILocalNotification *notification;
        
    int k;
    
    UIButton *queding;
    UIButton *quxiao;
    UIView *view;
    UIView *xian;
    
    NSArray *jiajia;
}

@end

@implementation YdRemindViewController

- (void)queding {
    
    if (number==1) {
        [chooseTime addObject: arr1[[myPicker selectedRowInComponent:0]]];
        
    }
    else if (number==2){
        [chooseTime addObject:[NSString stringWithFormat:@"%@,%@",arr1[[myPicker selectedRowInComponent:0]],arr1[[myPicker selectedRowInComponent:1]]]];
        
    }
    else if (number==3){
        [chooseTime addObject:[NSString stringWithFormat:@"%@,%@,%@",arr1[[myPicker selectedRowInComponent:0]],arr1[[myPicker selectedRowInComponent:1]],arr1[[myPicker selectedRowInComponent:2]]]];
        
    }
    else if (number==4){
        [chooseTime addObject:[NSString stringWithFormat:@"%@,%@,%@,%@",arr1[[myPicker selectedRowInComponent:0]],arr1[[myPicker selectedRowInComponent:1]],arr1[[myPicker selectedRowInComponent:2]],arr1[[myPicker selectedRowInComponent:3]]]];
        
    }
    for (NSString *strItem in chooseTime) {
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        
        [dateFormatter setDateFormat:@"yyyy年MM月dd日"];
        
        NSString *strNow = [dateFormatter stringFromDate:[NSDate date]];
        
        NSArray *arrTimes = [strItem componentsSeparatedByString:@","];
        
        for (NSString *strAddDate in arrTimes) {
            
            NSString *strTime = [NSString stringWithFormat:@"%@ %@", strNow, strAddDate];
            
            [dateFormatter setDateFormat:@"yyyy年MM月dd日 HH:mm"];
            
            NSDate *date = [dateFormatter dateFromString:strTime];
            
            ModelClock *clock = [[ModelClock alloc] init];
            
            clock.date = date;
            
            [[AlarmClockManager shareManager] addNewClock:clock];
            
        }
    }
    
       if (k==0) {
        
        
        cishu++;
        //刷新tableview
        [myTable reloadData];
        
        myTable.hidden=NO;
        
        [view removeFromSuperview];
        [myPicker removeFromSuperview];
        [queding removeFromSuperview];
        [quxiao removeFromSuperview];
        k=1;
    }
    
    else{
        NSLog(@"NO");
        
    }

}
-(void)quxiao
{
    [view removeFromSuperview];
    [myPicker removeFromSuperview];
    [queding removeFromSuperview];
    [quxiao removeFromSuperview];
}
- (void)tianjia
{
    
    NSLog(@"新建闹钟");
    
    UIAlertView *alertview = [[UIAlertView alloc] initWithTitle:@"闹钟" message:@"提醒几次" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"一次",@"两次",@"三次",@"四次", nil];
    [alertview show];
    
}
-(void)timeNsarry{
    
    [myPicker removeFromSuperview];
    
    arr1=[[NSMutableArray alloc] init];
    
    [arr1 addObject:@"13:03"];
    [arr1 addObject:@"17:45"];
    [arr1 addObject:@"17:46"];
    [arr1 addObject:@"02:00"];
    [arr1 addObject:@"02:30"];
    [arr1 addObject:@"03:00"];
    [arr1 addObject:@"03:30"];
    [arr1 addObject:@"04:00"];
    [arr1 addObject:@"04:30"];
    [arr1 addObject:@"05:00"];
    [arr1 addObject:@"05:30"];
    [arr1 addObject:@"06:00"];
    [arr1 addObject:@"07:30"];
    [arr1 addObject:@"08:55"];
    [arr1 addObject:@"08:30"];
    [arr1 addObject:@"09:00"];
    [arr1 addObject:@"09:30"];
    [arr1 addObject:@"10:00"];
    [arr1 addObject:@"10:30"];
    [arr1 addObject:@"11:00"];
    [arr1 addObject:@"11:30"];
    [arr1 addObject:@"12:00"];
    [arr1 addObject:@"12:30"];
    [arr1 addObject:@"13:00"];
    [arr1 addObject:@"13:30"];
    [arr1 addObject:@"14:00"];
    [arr1 addObject:@"14:30"];
    [arr1 addObject:@"15:00"];
    [arr1 addObject:@"15:30"];
    [arr1 addObject:@"16:00"];
    [arr1 addObject:@"16:30"];
    [arr1 addObject:@"17:06"];
    [arr1 addObject:@"17:12"];
    [arr1 addObject:@"17:30"];
    [arr1 addObject:@"18:00"];
    [arr1 addObject:@"18:30"];
    [arr1 addObject:@"19:00"];
    
    [arr1 addObject:@"19:30"];
    [arr1 addObject:@"20:00"];
    [arr1 addObject:@"20:30"];
    [arr1 addObject:@"21:00"];
    [arr1 addObject:@"21:30"];
    [arr1 addObject:@"22:00"];
    [arr1 addObject:@"22:30"];
    [arr1 addObject:@"23:00"];
    [arr1 addObject:@"23:30"];
    [arr1 addObject:@"00:00"];
    
    
    view = [[UIView alloc]init];
    view.frame = CGRectMake(0, self.view.frame.size.height - self.view.frame.size.height / 3.5 - 25,  self.view.frame.size.width, self.view.frame.size.height / 3.5 + 25);
    view.backgroundColor = [UIColor colorWithHexString:@"f4f4f4" alpha:1];
    [self.view addSubview:view];
    
    myPicker=[[UIPickerView alloc] initWithFrame:CGRectMake(0, 25, self.view.frame.size.width, view.frame.size.height - 25)];
    myPicker.delegate=self;
    myPicker.dataSource=self;
    
    myPicker.backgroundColor=[UIColor clearColor];
    [view addSubview:myPicker];
    
    queding = [[UIButton alloc]init];
    queding.frame = CGRectMake(self.view.frame.size.width - 50, 0, 50, 25);
    [queding setTitle:@"确定" forState:UIControlStateNormal];
    queding.titleLabel.font = [UIFont systemFontOfSize:17];
    [queding setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [queding addTarget:self action:@selector(queding) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:queding];
    
    quxiao = [[UIButton alloc]init];
    quxiao.frame = CGRectMake(0, 0, 50, 25);
    [quxiao setTitle:@"取消" forState:UIControlStateNormal];
    quxiao.titleLabel.font = [UIFont systemFontOfSize:17];
    [quxiao setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [quxiao addTarget:self action:@selector(quxiao) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:quxiao];
    
    xian = [[UIView alloc]init];
    xian.frame = CGRectMake(0, 25, self.view.frame.size.width, 1);
    xian.backgroundColor = [UIColor colorWithHexString:@"e2e2e2" alpha:1];
    [view addSubview:xian];
    
    allArr=[[NSMutableArray alloc] init];
    
    if (number==1) {
        [allArr addObject:arr1[[myPicker selectedRowInComponent:0]]];
        
    }
    
    else if (number==2){
        
        [allArr addObject:arr1[[myPicker selectedRowInComponent:0]]];
        [allArr addObject:arr1[[myPicker selectedRowInComponent:1]]];
        
    }
    
    else if (number==3){
        
        [allArr addObject:arr1[[myPicker selectedRowInComponent:0]]];
        [allArr addObject:arr1[[myPicker selectedRowInComponent:1]]];
        [allArr addObject:arr1[[myPicker selectedRowInComponent:2]]];
        
    }
    else if (number==4){
        
        [allArr addObject:arr1[[myPicker selectedRowInComponent:0]]];
        [allArr addObject:arr1[[myPicker selectedRowInComponent:1]]];
        [allArr addObject:arr1[[myPicker selectedRowInComponent:2]]];
        [allArr addObject:arr1[[myPicker selectedRowInComponent:3]]];
        
    }
    
}



- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    k=0;
    
    if (buttonIndex==1) {
        number=1;
        [self timeNsarry];
    }
    else if (buttonIndex==2){
        
        number=2;
        [self timeNsarry];
    }
    else if (buttonIndex==3){
        
        number=3;
        [self timeNsarry];
    }
    else if (buttonIndex==4){
        
        number=4;
        [self timeNsarry];
    }
    
    
    
}



- (void)viewDidLoad {
    [super viewDidLoad];
    
    //多出空白处
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    //状态栏名称
    self.navigationItem.title = @"用药提醒";
    //设置导航栏左按钮
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"@3x_xx_06.png"] style:UIBarButtonItemStyleDone target:self action:@selector(fanhui)];

    self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc]init] initWithTitle:@"添加闹钟" style:UIBarButtonItemStyleDone target:self action:@selector(tianjia)];
    
    k=0;
    
    chooseTime = [[NSMutableArray alloc]init];
    
    NSString *fileName=[NSString stringWithFormat:@"%@/Documents/%@",NSHomeDirectory(),@"my,plist"];
    arr=[NSMutableArray arrayWithContentsOfFile:fileName];
    
    myTable=[[UITableView alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height - 64)];
    myTable.backgroundColor=[UIColor clearColor];
    
    myTable.delegate=self;
    myTable.dataSource=self;
    
    [self.view addSubview:myTable];
    
    cishu=0;
    
    if (cishu==0) {
        myTable.hidden=YES;
    }
    
}


#pragma mark - UIPickerViewDataSource
//返回几列
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    
    return number;
    
}
//每列有几个列表项
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    
    return [arr1 count];
    
    
}


#pragma mark - UIPickerViewDelegate
//返回制定列表项的文本标题
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    
    return arr1 [row];
    
}


#pragma mark - UITableViewDatasouse

//返回多少组
-(NSInteger):(UITableView *)tableView{
    
    return 1;
}
//返回多少行
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return cishu;
}

#pragma mark - UITableViewDelegate


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *str=@"cell";
    
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:str];
    if (cell==nil) {
        
        cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:str];
        
    }
    /**************************消除重叠************************/
    NSArray *arr2=[cell.contentView subviews];
    
    for (UIView *vv in arr2) {
        [vv removeFromSuperview];
    }
    /**********************************************************/
    
    cell.textLabel.frame=CGRectMake(0, 20, CGRectGetWidth(self.view.frame), 50);
    cell.textLabel.font=[UIFont fontWithName:@"Helvetica-Bold" size:17];
    cell.textLabel.textColor=[UIColor colorWithHexString:@"323232" alpha:1];
    cell.textLabel.backgroundColor=[UIColor clearColor];
    cell.textLabel.text=chooseTime[indexPath.row] ;
    
    
    //去掉tableview的杠
    myTable.separatorStyle=UITableViewCellSelectionStyleNone;
    // 添加下划线
    UIView *view1=[[UIView alloc] initWithFrame:CGRectMake(0, 49, self.view.frame.size.width, 1)];
    view1.backgroundColor=[UIColor colorWithHexString:@"e2e2e2" alpha:1];
    
    [cell.contentView addSubview:view1];
    
    UISwitch *kai = [[UISwitch alloc]init];
    kai.frame = CGRectMake(self.view.frame.size.width - 60, 15, 30, 15);
    kai.tag = 600 + indexPath.row;
    [kai setOn:YES animated:YES];
    [kai addTarget: self action:@selector(switchIsChanged:) forControlEvents:UIControlEventValueChanged];
    [cell.contentView addSubview:kai];
    
    return cell;
    
}
//开关
-(void)switchIsChanged:(UISwitch *)paramSender{
    NSLog(@"Sender is=%@",paramSender);
    
    if([paramSender isOn]){//如果开关状态为ON
        
   
        
    }else{
        NSLog(@"The switch is turned off.");
    }
}
//行的高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return section;
    
    
}

- (void)registerLocalNotification:(NSInteger)interval{
    
    
    
    
    //初始化本地通知
    notification=[[UILocalNotification alloc] init];
    
    //设置触发通知的时间（方法参数传入的时间）
    /****************这该咋写**************************/
    
    NSDate *fireDate=[NSDate dateWithTimeIntervalSinceNow:interval];
    notification.fireDate=fireDate;
    
    //时区
    notification.timeZone=[NSTimeZone defaultTimeZone];
    //通知主体内容
    notification.alertBody=@"aaaa内容";
    //通知的动作（解锁时下面一小行小字，滑动来。。。后面的字）
    notification.alertAction=@"偷偷";
    //应用程序角标，默认为0（不显示角标）
    notification.applicationIconBadgeNumber=1;
    //通知的参数，通过key值来标识这个通知
    NSDictionary *userDict=[NSDictionary dictionaryWithObject:@"CJT" forKey:@"key"];
    notification.userInfo=userDict;
    
    
    // ios8后，需要能响应registerUserNotificationSettings:方法，才能得到授权
    if ([[UIApplication sharedApplication] respondsToSelector:@selector(registerUserNotificationSettings:)]) {
        //设置通知类型
        UIUserNotificationType type=UIUserNotificationTypeAlert |UIUserNotificationTypeBadge |UIUserNotificationTypeSound;
        UIUserNotificationSettings *settings=[UIUserNotificationSettings settingsForTypes:type categories:nil];
        
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
        
        //通知重复的时间间隔，可以是天，周，月（实际最小单位是分钟）
        notification.repeatInterval=kCFCalendarUnitDay;
    }
    
    else{
        
        //通知重复的时间间隔，可以是天，周，月（实际最小单位是分钟）
        notification.repeatInterval=NSCalendarUnitDay;
        
    }
    
    // 执行通知注册
    [[UIApplication sharedApplication] scheduleLocalNotification:notification];
    
}
- (void)remove{
    
    
    [[UIApplication sharedApplication] cancelLocalNotification:notification];
    
    
}

//导航左按钮
-(void)fanhui
{
    //返回上一页
    [self.navigationController popViewControllerAnimated:YES];
}


@end
