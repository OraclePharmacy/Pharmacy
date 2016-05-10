//
//  TableViewCell.m
//  UUChartView
//
//  Created by shake on 15/1/4.
//  Copyright (c) 2015年 uyiuyao. All rights reserved.
//

#import "TableViewCell.h"
#import "YdBloodViewController.h"
#import "UUChart.h"

@interface TableViewCell ()<UUChartDataSource>
{
    NSIndexPath *path;
    UUChart *chartView;
    
}
@end

@implementation TableViewCell
- (void)configUI:(NSIndexPath *)indexPath
{
    if (chartView) {
        [chartView removeFromSuperview];
        chartView = nil;
    }
    
    path = indexPath;
    
    chartView = [[UUChart alloc]initWithFrame:CGRectMake(5, 10, [UIScreen mainScreen].bounds.size.width-20, 160)
                                   dataSource:self
                                        style:indexPath.section==1?UUChartStyleBar:UUChartStyleLine];
    [chartView showInView:self.contentView];
}

- (NSArray *)getXTitles:(int)num
{
    NSMutableArray *xTitles = [NSMutableArray array];
    for (int i=0; i<num; i++) {
        NSString * str = [NSString stringWithFormat:@"R-%d",i];
        [xTitles addObject:str];
    }
    return xTitles;
}

#pragma mark - @required
//横坐标标题数组
- (NSArray *)chartConfigAxisXLabel:(UUChart *)chart
{

    if (path.section==0) {
        switch (path.row) {
            case 0:
                return [self getXTitles:5];
            case 1:
                return [self getXTitles:5];
            default:
                break;
        }
    }else{
       
    }
    return nil;
}
int op=0;
//数值多重数组
- (NSArray *)chartConfigAxisYValue:(UUChart *)chart
{
    
     NSArray *ary;
     NSArray *ary2;
     NSArray *ary3;
     NSArray *ary4;

     NSUserDefaults*oo=[NSUserDefaults standardUserDefaults];
        
     ary =[NSArray arrayWithArray:[oo objectForKey:@"gaoya"]];
     ary2 =[NSArray arrayWithArray:[oo objectForKey:@"diya"]];
     ary3 =[NSArray arrayWithArray:[oo objectForKey:@"fanqian"]];
     ary4 =[NSArray arrayWithArray:[oo objectForKey:@"fanhou"]];

    if (path.section==0) {
        switch (path.row) {
            case 0:
                return @[ary,ary2];
            default:
                return @[ary3,ary4];
        }
    }
    else{
        
        return nil;
    }
}

#pragma mark - @optional
//颜色数组
- (NSArray *)chartConfigColors:(UUChart *)chart
{
    return @[[UUColor green],[UUColor red],[UUColor brown]];
}
//显示数值范围
- (CGRange)chartRange:(UUChart *)chart
{
    if (path.section==0 ) {
        if(path.row == 0)
        {
            return CGRangeMake(300, 0);
        }
        else
        {
             return CGRangeMake(20, 0);
        }
        
    }
    
 
    return CGRangeZero;
}

#pragma mark 折线图专享功能

//标记数值区域
- (CGRange)chartHighlightRangeInLine:(UUChart *)chart
{
    if (path.row == 2) {
        return CGRangeMake(20, 75);
    }
    return CGRangeZero;
}

//判断显示横线条
- (BOOL)chart:(UUChart *)chart showHorizonLineAtIndex:(NSInteger)index
{
    return YES;
}

//判断显示最大最小值
- (BOOL)chart:(UUChart *)chart showMaxMinAtIndex:(NSInteger)index
{
    return path.row == 2;
}
@end
