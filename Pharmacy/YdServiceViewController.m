//
//  YdServiceViewController.m
//  Pharmacy
//
//  Created by suokun on 16/4/7.
//  Copyright © 2016年 sk. All rights reserved.
//

#import "YdServiceViewController.h"

@interface YdServiceViewController ()
{
    
    CGFloat width;
    CGFloat height;
    
    UICollectionView * CollectionView;
    
    NSString * identifier;
    
}
@end

@implementation YdServiceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    width = [UIScreen mainScreen].bounds.size.width;
    height = [UIScreen mainScreen].bounds.size.height;
    
    
    identifier = @"cell";
    
    // 初始化layout
    
    UICollectionViewFlowLayout * flowLayout =[[UICollectionViewFlowLayout alloc] init];
    
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    
    //水平间隔
    flowLayout.minimumInteritemSpacing = 1.0;
    //垂直行间距
    flowLayout.minimumLineSpacing = 1.0;
    
    CollectionView =[[UICollectionView alloc] initWithFrame:CGRectMake(0, 64, width,height-64-40)collectionViewLayout:flowLayout];
    
    //注册单元格
    
    [CollectionView registerClass:[UICollectionViewCell class]forCellWithReuseIdentifier:identifier];
    
    //设置代理
    
    CollectionView.delegate = self;
    
    CollectionView.dataSource = self;
    
    [self.view addSubview:CollectionView];
    
}

#pragma mark - collectionView delegate

//设置分区



-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView

{
    
    return 2;
    
}

//设置每行显示多少



//设置元素的的大小框

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section

{
    
    UIEdgeInsets top = {0,0,0,0};
    
    return top;
    
}

//每个分区上得元素个数

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section

{
    if (section == 0) {
        return 6;
    }
    else
    return 3;
    
}

//设置元素内容

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath

{
    
    UICollectionViewCell * cell =[collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    
    [cell sizeToFit];
    
    cell.backgroundColor =[UIColor grayColor];
    
    return cell;
    
}

//设置单元格宽度

//设置元素大小

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    return CGSizeMake((collectionView.bounds.size.width-2)/3,((collectionView.bounds.size.height)*0.6-1)/2);
    
}
@end
