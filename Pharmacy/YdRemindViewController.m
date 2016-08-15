//
//  YdRemindViewController.m
//  Pharmacy
//
//  Created by suokun on 16/4/13.
//  Copyright © 2016年 sk. All rights reserved.
//

#import "YdRemindViewController.h"
#import "Color+Hex.h"
#import "DurgTableViewCell.h"
#import "TianTableViewCell.h"

@interface YdRemindViewController ()<UITableViewDataSource,UITableViewDelegate,UIPickerViewDataSource,UIPickerViewDelegate>
{
    
    UITableView *remindTable;
    
    float width,height;
    
    UIView *back;
    
    NSTimer *ttm;
    
    int shu;
    
    int flagg;
    
    int sectionn;
    
    
    NSMutableArray *pathArray;   //读取plist文件里的内容
    int deleteInt;               //要删除第几个闹钟
    NSString *path;              //保存闹钟plist文件的路径
    int mm;   //判断是否发送通知
    
    UIView *popview;
    
    NSMutableArray *shuju;
    
    UIPickerView *pp;
    
}
@property (nonatomic, strong) UIView *tableFooterView;

@end

@implementation YdRemindViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.view.backgroundColor=[UIColor colorWithRed:245.0/255 green:245.0/255 blue:245.0/255 alpha:1];
    
    flagg=0;
    
    shu=0;
    
    shuju=[[NSMutableArray alloc] init];
    [shuju addObject:@"0:00"];
    [shuju addObject:@"0:30"];
    [shuju addObject:@"1:00"];
    [shuju addObject:@"1:30"];
    [shuju addObject:@"2:00"];
    [shuju addObject:@"2:30"];
    [shuju addObject:@"3:00"];
    [shuju addObject:@"3:30"];
    [shuju addObject:@"4:00"];
    [shuju addObject:@"4:30"];
    [shuju addObject:@"5:00"];
    [shuju addObject:@"5:30"];
    [shuju addObject:@"6:00"];
    [shuju addObject:@"6:30"];
    [shuju addObject:@"7:00"];
    [shuju addObject:@"7:30"];
    [shuju addObject:@"8:00"];
    [shuju addObject:@"8:30"];
    [shuju addObject:@"9:00"];
    [shuju addObject:@"9:30"];
    [shuju addObject:@"10:00"];
    [shuju addObject:@"10:30"];
    [shuju addObject:@"11:00"];
    [shuju addObject:@"11:30"];
    [shuju addObject:@"12:00"];
    [shuju addObject:@"12:30"];
    [shuju addObject:@"13:00"];
    [shuju addObject:@"13:30"];
    [shuju addObject:@"14:00"];
    [shuju addObject:@"14:30"];
    [shuju addObject:@"15:00"];
    [shuju addObject:@"15:30"];
    [shuju addObject:@"16:10"];
    [shuju addObject:@"16:30"];
    [shuju addObject:@"17:00"];
    [shuju addObject:@"17:30"];
    [shuju addObject:@"18:00"];
    [shuju addObject:@"18:30"];
    [shuju addObject:@"19:00"];
    [shuju addObject:@"19:30"];
    [shuju addObject:@"20:00"];
    [shuju addObject:@"20:30"];
    [shuju addObject:@"21:00"];
    [shuju addObject:@"21:30"];
    [shuju addObject:@"22:00"];
    [shuju addObject:@"22:30"];
    [shuju addObject:@"23:00"];
    [shuju addObject:@"23:30"];
    [shuju addObject:@"无"];
    
    
    width=[[UIScreen mainScreen] bounds].size.width;
    
    height=[[UIScreen mainScreen] bounds].size.height;
    
    self.title = @"用药提醒";
    //self.title 的字体大小、颜色
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], NSForegroundColorAttributeName , [UIFont systemFontOfSize:18], NSFontAttributeName,nil]];
    
    
    
    //左按钮；
    //设置导航栏左按钮
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"@3x_xx_06.png"] style:UIBarButtonItemStyleDone target:self action:@selector(fanhui)];
    
    popview=[[UIView alloc] initWithFrame:CGRectMake(0, height, width, 280)];
    popview.backgroundColor=[UIColor whiteColor];
    
    UILabel *text1=[[UILabel alloc] initWithFrame:CGRectMake(0, 4, width/4, 20)];
    
    text1.textColor=[UIColor blackColor];
    text1.textAlignment=NSTextAlignmentCenter;
    
    text1.text=@"第一次";
    
    UILabel *text2=[[UILabel alloc] initWithFrame:CGRectMake(width/4, 4, width/4, 20)];
    text2.textColor=[UIColor blackColor];
    text2.textAlignment=NSTextAlignmentCenter;
    text2.text=@"第二次";
    
    
    UILabel *text3=[[UILabel alloc] initWithFrame:CGRectMake(width/2, 4, width/4, 20)];
    text3.textColor=[UIColor blackColor];
    text3.textAlignment=NSTextAlignmentCenter;
    text3.text=@"第三次";
    
    
    UILabel *text4=[[UILabel alloc] initWithFrame:CGRectMake(width*3/4, 4, width/4, 20)];
    text4.textColor=[UIColor blackColor];
    text4.textAlignment=NSTextAlignmentCenter;
    text4.text=@"第四次";
    
    [popview addSubview:text1];
    [popview addSubview:text2];
    [popview addSubview:text3];
    [popview addSubview:text4];
    
    pp=[[UIPickerView alloc] initWithFrame:CGRectMake(0, 24, width, 160)];
    
    pp.dataSource=self;
    pp.delegate=self;
    
    [pp selectRow:12 inComponent:0 animated:NO];
    [pp selectRow:12 inComponent:1 animated:NO];
    [pp selectRow:12 inComponent:2 animated:NO];
    [pp selectRow:12 inComponent:3 animated:NO];
    
    [popview addSubview:pp];
    
    
    back=[[UIView alloc] initWithFrame:CGRectMake(0, 0, width, height)];
    
    //    UIButton *sd=[[UIButton alloc] initWithFrame:CGRectMake(30, 100, 50, 30)];
    //    [sd setTitle:@"dasd" forState:UIControlStateNormal];
    //
    //    [sd addTarget:self action:@selector(tianjia) forControlEvents:UIControlEventTouchUpInside];
    //
    //    [back addSubview:sd];
    
    back.backgroundColor=[UIColor grayColor];
    back.alpha=0.0f;
    
    [self.view addSubview:back];
    
    
    
    UIButton *queding=[[UIButton alloc] initWithFrame:CGRectMake(0, 180, width, 44)];
    
    [queding setTitle:@"确定" forState:UIControlStateNormal];
    [queding setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    queding.backgroundColor=[UIColor colorWithRed:117.0/255 green:180.0/255 blue:100.0/255 alpha:1];
    
    [queding addTarget:self action:@selector(choossok) forControlEvents:UIControlEventTouchUpInside];
    
    [popview addSubview:queding];
    
    UIButton *queding1=[[UIButton alloc] initWithFrame:CGRectMake(0, 234, width, 44)];
    
    [queding1 setTitle:@"取消" forState:UIControlStateNormal];
    [queding1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [queding1 addTarget:self action:@selector(choossno) forControlEvents:UIControlEventTouchUpInside];
    
    queding1.backgroundColor=[UIColor grayColor];
    
    [popview addSubview:queding1];
    

    remindTable=[[UITableView alloc] initWithFrame:CGRectMake(0, 64, width, height - 64)];
    
    remindTable.backgroundColor = [UIColor clearColor];
    remindTable.delegate = self;
    remindTable.dataSource = self;
    [self.view addSubview:remindTable];
    
    [self.view addSubview:popview];
    
    
    path = [NSHomeDirectory() stringByAppendingString:@"/Documents/durgRemindList.plist"];
    
    pathArray = [[NSMutableArray alloc]init];
    
    
    // Do any additional setup after loading the view.
}

-(void)choossok{
    
    [UIView animateWithDuration:0.7 animations:^{
        
        popview.frame=CGRectMake(0, height, width, 280);
        
        back.alpha=0.0f;
        back.hidden=YES;
        
        // [remindTable reloadData];
        
    }completion:nil];
    
    // [self.view sendSubviewToBack:back];
    NSLog(@"yes");
    
    NSString *str1=shuju[[pp selectedRowInComponent:0]];
    NSString *str2=shuju[[pp selectedRowInComponent:1]];
    NSString *str3=shuju[[pp selectedRowInComponent:2]];
    NSString *str4=shuju[[pp selectedRowInComponent:3]];
    
    
    int aa=0,bb=0,cc=0,dd=0;
    
    NSMutableArray *asd=[[NSMutableArray alloc] init];
    
    if (![str1 isEqualToString:@"无"]){
        aa=1;
        
    }
    if (![str2 isEqualToString:@"无"]){
        bb=1;
        
    }
    if (![str3 isEqualToString:@"无"]){
        cc=1;
        
    }
    if (![str4 isEqualToString:@"无"]){
        dd=1;
        
    }
    
    [asd addObject:str1];
    [asd addObject:str2];
    [asd addObject:str3];
    [asd addObject:str4];
    
    NSString *riqi=[asd componentsJoinedByString:@" "];
    
    int oo=aa+bb+cc+dd;
    
    NSString *tit;
    
    switch (oo) {
        case 1:
            tit=@"一日一次";
            break;
        case 2:
            tit=@"一日二次";
            break;
        case 3:
            tit=@"一日三次";
            break;
        case 4:
            tit=@"一日四次";
            break;
            
            
        default:
            break;
    }
    
    NSDictionary *dic=@{@"title":tit,@"riqi":riqi,@"ison":@"0"};
    
    NSString *yhidString = [NSString stringWithFormat:@"%d",[[[NSUserDefaults standardUserDefaults]objectForKey:@"hyid"] intValue]];
    
    NSDictionary *asdd=@{@"yhid":yhidString,@"neirong":dic};
    
    if (flagg!=8) {
        
        
        NSMutableArray *arrasd=[[NSMutableArray alloc] initWithContentsOfFile:path];
        
        if (arrasd!=nil) {
            
            [arrasd addObject:asdd];
        }
        else
        {
            arrasd=[[NSMutableArray alloc] init];
            [arrasd addObject:asdd];
        }
        
        NSLog(@"asdd-%@-%@",arrasd,path);
        
        [arrasd writeToFile:path atomically:YES];
        
    }
    else{
        
        NSMutableArray *arrasd=[[NSMutableArray alloc] initWithContentsOfFile:path];
        
        [arrasd removeObjectAtIndex:sectionn];
        [arrasd insertObject:asdd atIndex:sectionn];
        
        
        NSLog(@"asdd-gai-%@-%@",arrasd,path);
        
        [arrasd writeToFile:path atomically:YES];
        
        flagg=0;
        
    }
    
    [self readDurgRemindPlist];
    
    NSLog(@"pathasd-----%@",pathArray);
    
    [remindTable reloadData];
    
    
}

-(void)poppp
{
    // flagg=0;
    
    NSLog(@"dsd-weisha");
    
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)choossno{
    
    
    [UIView animateWithDuration:0.7 animations:^{
        
        popview.frame=CGRectMake(0, height, width, 280);
        
        back.alpha=0.0f;
        back.hidden=YES;
        
        
        
    }completion:nil];
    
    flagg=0;
    
    //[self.view sendSubviewToBack:back];
    
    NSLog(@"no");
}


- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    
    return [shuju count];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    
    return 4;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    
    return [shuju objectAtIndex:row];
}


- (void)viewWillAppear:(BOOL)animated
{
    
    [self readDurgRemindPlist];    //调用读文件的方法,判断是否显示提醒视图
    [remindTable reloadData];  //更新tableViee数据
    if (mm == 1) {
        [[NSNotificationCenter defaultCenter]postNotificationName:@"轮回公子" object:nil];
    }
    
}

-(void)readDurgRemindPlist{
    
    
    
    NSMutableArray *array = [[NSMutableArray alloc]initWithContentsOfFile:path];
    
    //获取用户id
    
    NSLog(@"array--%@",array);
    
    NSString *yhidString = [NSString stringWithFormat:@"%d",[[[NSUserDefaults standardUserDefaults]objectForKey:@"hyid"] intValue]];
    
    [pathArray removeAllObjects];
    // NSLog(@"ge--%d",[array count]);
    
    if (array !=nil && [array count]>0) {
        
        NSLog(@"you");
        
        //获取某一个id的内容
        for (int i = 0 ; i < array.count; i++) {
            
            NSString *key1=[array[i] objectForKey:@"yhid"];
            
            BOOL flag=[key1 isEqualToString:yhidString];
            
            if (flag) {
                
                NSLog(@"sssss--%@--%@",key1,yhidString);
                
                [pathArray addObject:[array[i] objectForKey:@"neirong"]];
                
            }
            
        }
    }
    
    else{
        
        NSLog(@"meiyou");
    }
    
    NSLog(@"patha--%@",pathArray);
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return pathArray.count+1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    if (section==0) {
        return 0;
    }
    else
        return 16;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==pathArray.count) {
        return 60;
    }
    return 80;
    
}



- (void)tianjia{
    
    
    if (ttm!=nil)
        [ttm invalidate];
    
    ttm=nil;
    
    shu=0;
    
    [self.view bringSubviewToFront:back];
    [self.view bringSubviewToFront:popview];
    
    back.hidden=NO;
    
    ttm= [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(bian) userInfo:nil repeats:YES];
    
    [UIView animateWithDuration:1 animations:^{
        
        popview.frame=CGRectMake(0, height-280, width, 280);
        
    }completion:nil];
    
    
}

- (void)bian{
    
    shu++;
    
    back.alpha=shu*0.1;
    
    if (shu==8) {
        
        [ttm invalidate];
        
        ttm=nil;
        
        shu=0;
    }
    
    NSLog(@"---%d",shu);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    //cell.width1=width;
    
    if (indexPath.section==[pathArray count]) {
        
        
        NSLog(@"meizhixing");
        
        TianTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"mmod"];
        
        if (!cell) {
            cell = [[TianTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"mmod"];
        }
        
        
        cell.botline.frame= CGRectMake(0, 59, width, 1);
        cell.botline.backgroundColor=[UIColor lightGrayColor];
        
        cell.add.frame=CGRectMake(0, 0, width, 60);
        
//        [cell.add setImage:[UIImage imageNamed:@"icon_add.png"] forState:UIControlStateNormal];
        
        [cell.add setTitle:@"添加提醒" forState:UIControlStateNormal];
        
        [cell.add setTitleColor:[UIColor colorWithRed:117.0/255 green:180.0/255 blue:100.0/255 alpha:1] forState:UIControlStateNormal];
        
//        [cell.add setImageEdgeInsets:UIEdgeInsetsMake(-15, -20, 0, 0)];
//        [cell.add setTitleEdgeInsets:UIEdgeInsetsMake(-17, -10, 0, 0)];
        
        cell.add.titleLabel.font=[UIFont systemFontOfSize:15.0f];
        
        [cell.add addTarget:self action:@selector(tianjia) forControlEvents:UIControlEventTouchUpInside];
        
        
        return cell;
        
        
    }
    
    else{
        
        DurgTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
        
        if (!cell) {
            cell = [[DurgTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        }
        
        NSLog(@"zhixingmei");
        
        cell.topline.frame=CGRectMake(0, 0, width, 1);
        cell.botline.frame=CGRectMake(0, 79, width, 1);
        cell.sw.frame=CGRectMake(width-66, 30, 30, 20);
        
        cell.ll1.text=[[pathArray objectAtIndex:indexPath.section] objectForKey:@"title"];
        
        NSString *asd= [[pathArray objectAtIndex:indexPath.section] objectForKey:@"riqi"];
        
        NSArray *mnb=[asd componentsSeparatedByString:@" "];
        NSMutableArray *rt=[[NSMutableArray alloc] init];
        
        for (NSString *ser in mnb) {
            
            if (![ser isEqualToString:@"无"])
                
                [rt addObject:ser];
        }
        
        
        
        cell.ll2.text=[rt componentsJoinedByString:@" "];
        
        BOOL kk=[[[pathArray objectAtIndex:indexPath.section] objectForKey:@"ison"] isEqualToString:@"0"];
        
        NSLog(@"kk---%d",kk);
        
        [cell.sw setOn:((kk)? NO :YES)];
        
        cell.sw.tag=100+indexPath.section;
        
        [cell.sw addTarget:self action:@selector(qiehuan:) forControlEvents:UIControlEventValueChanged];
        
        
        return cell;
        
    }
    
}


-(void)qiehuan:(UISwitch *)ss{
    
    int mmm=(int)ss.tag-100;
    
    NSString *status;
    
    if (ss.isOn) {
        status=@"1";
    }
    else
        status=@"0";
    
    NSMutableArray *wqe=[[NSMutableArray alloc] initWithContentsOfFile:path];
    
    NSDictionary *dic=[wqe[mmm] objectForKey:@"neirong"];
    
    NSLog(@"status--%@",dic);
    
    [dic setValue:status forKey:@"ison"];
    
    [wqe writeToFile:path atomically:YES];
    
    NSLog(@"mm---%d",mmm);
    
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"轮回公子" object:nil];
    
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if ([pathArray count]>(int)indexPath.section) {
        
        NSLog(@"ssdds");
        
        flagg=8;
        
        DurgTableViewCell *cc=(DurgTableViewCell*)[tableView cellForRowAtIndexPath:indexPath];
        
        cc.selectionStyle=UITableViewCellSelectionStyleNone;
        
        NSLog(@"---%d",(int)indexPath.section);
        
        sectionn=(int)indexPath.section;
        
        NSMutableArray *fdata=[[NSMutableArray alloc] initWithContentsOfFile:path];
        NSDictionary *dfg=[fdata objectAtIndex:indexPath.section];
        
        NSArray *riri=[[[dfg objectForKey:@"neirong"] objectForKey:@"riqi"] componentsSeparatedByString:@" "];
        
        int mm1=(int)[shuju indexOfObject:riri[0]];
        int mm2=(int)[shuju indexOfObject:riri[1]];
        int mm3=(int)[shuju indexOfObject:riri[2]];
        int mm4=(int)[shuju indexOfObject:riri[3]];
        
        [pp selectRow:mm1 inComponent:0 animated:YES];
        [pp selectRow:mm2 inComponent:1 animated:YES];
        
        [pp selectRow:mm3 inComponent:2 animated:YES];
        
        [pp selectRow:mm4 inComponent:3 animated:YES];
        
        [self tianjia];
        
    }
    
    else{
        
        NSLog(@"ssdds---000");
        
        TianTableViewCell *ce=(TianTableViewCell*)[tableView cellForRowAtIndexPath:indexPath];
        
        ce.selectionStyle=UITableViewCellSelectionStyleNone;
        
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section!=[pathArray count])
        return YES;
    else
        return NO;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"前%lu",(unsigned long)pathArray.count);
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        [remindTable setEditing:NO];
        
        [pathArray removeObjectAtIndex:indexPath.section];
        
        NSMutableArray *wew=[[NSMutableArray alloc] initWithContentsOfFile:path];
        
        NSLog(@"wew--%@",wew);
        
        [wew removeObjectAtIndex:indexPath.section];
        
        [wew writeToFile:path atomically:YES];
        //
        //        NSMutableArray *wew1=[[NSMutableArray alloc] initWithContentsOfFile:path];
        //
        //        NSLog(@"wew--%@",wew1);
        //
        
        [[UIApplication sharedApplication] cancelAllLocalNotifications];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"轮回公子" object:nil];
        
        [remindTable reloadData];
        
        
    }
    NSLog(@"后%lu",(unsigned long)pathArray.count);
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSLog(@"dsss");
    
    return UITableViewCellEditingStyleDelete;
}

-(void)fanhui
{
    //返回上一页
    [self.navigationController popViewControllerAnimated:YES];
}
@end
