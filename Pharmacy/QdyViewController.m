//
//  QdyViewController.m
//  Pharmacy
//
//  Created by suokun on 16/8/24.
//  Copyright © 2016年 sk. All rights reserved.
//

#import "QdyViewController.h"

@interface QdyViewController ()
{
    CGFloat width,heigh;
    UIImageView *scrollimg;
}
@end

@implementation QdyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    width = [UIScreen mainScreen].bounds.size.width;
    heigh = [UIScreen mainScreen].bounds.size.height;
    
    _scrollview.delegate =self;
    _scrollview.contentSize = CGSizeMake(width*5, 0);
    // _scrollview.frame = CGRectMake(0, 0, width, heigh);
    _scrollview.pagingEnabled = YES;
    _scrollview.showsVerticalScrollIndicator = NO;
    
    
    _page.numberOfPages = 5;
    _page.currentPageIndicatorTintColor = [UIColor blueColor];
    _page.pageIndicatorTintColor = [UIColor grayColor];
    _page.currentPage = 0;
    
    
    
    UIButton  *backbtn = [[UIButton alloc]initWithFrame:CGRectMake(width*4, 0, width, heigh)];
    [backbtn addTarget:self action:@selector(backbutton) forControlEvents:UIControlEventTouchUpInside];
    //按钮位置不对 按钮文本
    
    [_scrollview addSubview:backbtn];
    
    [backbtn bringSubviewToFront:_scrollview];
    
    
    for (int i=0; i<5; i++) {
        scrollimg = [[UIImageView alloc]initWithFrame:CGRectMake(i*width, 0, width, heigh)];
        NSString *imgname = [NSString stringWithFormat:@"IMG_0797.jpg"];
        scrollimg.image =[UIImage imageNamed:imgname];
        [_scrollview addSubview: scrollimg];
    }
    
    
    // Do any additional setup after loading the view.
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    int  dex = (int)(scrollView.contentOffset.x/width);
    _page.currentPage = dex;
    
}
-(void)backbutton{
    
    NSLog(@"1");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
