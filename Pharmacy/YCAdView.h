//
//  YCAdView.h
//  TestAdView
//
//  Created by 袁灿 on 15/9/14.
//  Copyright (c) 2015年 yuancan. All rights reserved.
//

#import <UIKit/UIKit.h>

//标题文字显示的方式
typedef NS_ENUM(NSInteger, AdViewTitleShowStyle)
{
    AdViewTitleShowStyleNone,
    AdViewTitleShowStyleLeft,
    AdViewTitleShowStyleCenter,
    AdViewTitleShowStyleRight,
};

//pageControl显示方式
typedef NS_ENUM(NSInteger, UIPageControlShowStyle)
{
    UIPageControlShowStyleNone,
    UIPageControlShowStyleLeft,
    UIPageControlShowStyleCenter,
    UIPageControlShowStyleRight,
};

@interface YCAdView : UIView <UIScrollViewDelegate>

@property (strong, nonatomic) UIScrollView *scrollView;

//点击图片的回调方法
@property (strong, nonatomic) void (^clickAdImage)(NSInteger index);

/**
 *  自定义广告轮播视图
 *
 *  @param frame            广告轮播视图位置及大小
 *  @param arrImage         轮播的图片
 *  @param arrTitle         轮播的标题（如不需要展示标题，传nil）
 *  @param placeholderImage 无网络图片时的默认图片
 *
 *  @return 广告轮播视图
 */
+ (id)initAdViewWithFrame:(CGRect)frame
                   images:(NSArray *)arrImage
                   titles:(NSArray*)arrTitle
         placeholderImage:(UIImage *)placeholderImage;

@end
