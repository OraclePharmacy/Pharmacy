//
//  YCAdView.m
//  TestAdView
//
//  Created by 袁灿 on 15/9/14.
//  Copyright (c) 2015年 yuancan. All rights reserved.
//

#define kADView_Width       _scrollView.bounds.size.width       //广告的宽度
#define kADView_Height      _scrollView.bounds.size.height      //广告的高度

#define kTime   5.0f       //轮播的时间

#import "YCAdView.h"
#import "UIImageView+WebCache.h"

@interface YCAdView ()

@property (retain,nonatomic) UIImageView *leftImageView;
@property (retain,nonatomic) UIImageView *centerImageView;
@property (retain,nonatomic) UIImageView *rightImageView;

@property (retain,nonatomic) UILabel *labTitle;
@property (retain,nonatomic) UIImage *placeHolderImage;
@property (retain,nonatomic) NSTimer *timer;
@property (retain,nonatomic) UIPageControl *pageControl;

@property (nonatomic,assign) NSUInteger centerImageIndex;
@property (nonatomic,assign) NSUInteger leftImageIndex;
@property (nonatomic,assign) NSUInteger rightImageIndex;
@property (nonatomic,assign) NSUInteger currentPage;

@property (nonatomic,strong) NSArray *arrAdTitle;
@property (nonatomic,strong) NSMutableArray *arrImgUrl;

@end

@implementation YCAdView

+ (id)initAdViewWithFrame:(CGRect)frame
                   images:(NSArray *)arrImage
                   titles:(NSArray*)arrTitle
         placeholderImage:(UIImage *)placeholderImage
{
    if (arrImage.count == 0) {
        return nil;
    }
    
    YCAdView *ycAdview = [[YCAdView alloc] initWithFrame:frame];
    [ycAdview setAdViewImage:arrImage];
    [ycAdview setAdViewTitle:arrTitle withShowStyle:AdViewTitleShowStyleLeft];
    [ycAdview setPageControlShowStyle:UIPageControlShowStyleRight];
    ycAdview.placeHolderImage = placeholderImage;
    
    return ycAdview;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        _scrollView = [[UIScrollView alloc] initWithFrame:frame];
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.delegate = self;
        _scrollView.contentOffset = CGPointMake(kADView_Width, 0);
        _scrollView.contentSize = CGSizeMake(kADView_Width*3, kADView_Height);
        _scrollView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
        _scrollView.pagingEnabled = YES;
        _scrollView.bounces = NO;
        [self addSubview:_scrollView];
        
        _leftImageView = [[UIImageView alloc] initWithFrame:CGRectMake(kADView_Width*0, 0, kADView_Width, kADView_Height)];
        _centerImageView = [[UIImageView alloc] initWithFrame:CGRectMake(kADView_Width*1, 0, kADView_Width, kADView_Height)];
        _rightImageView = [[UIImageView alloc] initWithFrame:CGRectMake(kADView_Width*2, 0, kADView_Width, kADView_Height)];
        
        //添加图片点击事件
        _centerImageView.userInteractionEnabled = YES;
        [_centerImageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAdImage)]];
        
        [_scrollView addSubview:_leftImageView];
        [_scrollView addSubview:_centerImageView];
        [_scrollView addSubview:_rightImageView];

    }
        return self;
}


//设置广告轮播的图片
- (void)setAdViewImage:(NSArray *)arrImage
{
    _leftImageIndex = arrImage.count - 1;
    _centerImageIndex = 0;
    _rightImageIndex = 1;
    
    if (arrImage.count == 1) {
        _scrollView.scrollEnabled = NO;
        _rightImageIndex = 0;
    }
    
    _arrImgUrl = [[NSMutableArray alloc] init];
    
    for (int i=0; i<arrImage.count; i++) {
        NSString *strImg = [arrImage objectAtIndex:i];
        NSURL *urlImg = [NSURL URLWithString:strImg];
        [_arrImgUrl addObject:urlImg];
    }
    
    [_leftImageView sd_setImageWithURL:_arrImgUrl[_leftImageIndex] placeholderImage:_placeHolderImage];
    [_centerImageView sd_setImageWithURL:_arrImgUrl[_centerImageIndex] placeholderImage:_placeHolderImage];
    [_rightImageView sd_setImageWithURL:_arrImgUrl[_rightImageIndex] placeholderImage:_placeHolderImage];
    
    //添加定时器
    _timer = [NSTimer scheduledTimerWithTimeInterval:kTime target:self selector:@selector(moveAdImage) userInfo:nil repeats:YES];
}

//设置广告轮播的标题
- (void)setAdViewTitle:(NSArray *)arrTitle withShowStyle:(AdViewTitleShowStyle)adViewTitleShowStyle
{
    if (arrTitle.count == 0 || adViewTitleShowStyle == AdViewTitleShowStyleNone) {
        return;
    }
    
    _arrAdTitle = [NSArray arrayWithArray:arrTitle];
    
    //灰色遮罩层
    UIView *grayView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_scrollView.frame)-30, kADView_Width, 30)];
    grayView.backgroundColor = [UIColor blackColor];
    grayView.alpha = 0.3;
    [self addSubview:grayView];
    
    _labTitle = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, grayView.frame.size.width-10, 30)];
    [grayView addSubview:_labTitle];
    _labTitle.textColor = [UIColor whiteColor];
    _labTitle.text = arrTitle[_centerImageIndex];
    
    if (adViewTitleShowStyle == AdViewTitleShowStyleLeft) {
        _labTitle.textAlignment = NSTextAlignmentLeft;
    } else if (adViewTitleShowStyle == AdViewTitleShowStyleCenter) {
        _labTitle.textAlignment = NSTextAlignmentCenter;
    } else if (adViewTitleShowStyle == AdViewTitleShowStyleRight) {
        _labTitle.textAlignment = AdViewTitleShowStyleRight;
    }
}

//创建pageControl,设置其样式
- (void)setPageControlShowStyle:(UIPageControlShowStyle)pageControlShowStyle
{
    if (pageControlShowStyle == UIPageControlShowStyleNone || _arrImgUrl.count == 1) {
        return;
    }
    
    _pageControl = [[UIPageControl alloc] init];
    _pageControl.currentPage = 0;
    _pageControl.numberOfPages = _arrImgUrl.count;
    [self addSubview:_pageControl];
    
    if (pageControlShowStyle == UIPageControlShowStyleLeft) {
        _pageControl.frame = CGRectMake(0, kADView_Height-30, 20*_pageControl.numberOfPages, 30);
    } else if (pageControlShowStyle == UIPageControlShowStyleCenter) {
        _pageControl.frame = CGRectMake((kADView_Width-20*_pageControl.numberOfPages)/2, CGRectGetMaxY(_scrollView.frame)-30, 20*_pageControl.numberOfPages, 30);
    } else if (pageControlShowStyle == UIPageControlShowStyleRight) {
        _pageControl.frame = CGRectMake(kADView_Width-20*_pageControl.numberOfPages, CGRectGetMaxY(_scrollView.frame)-30, 20*_pageControl.numberOfPages, 30);
    }
}

//定时器自动滚动视图
- (void)moveAdImage
{
    _leftImageIndex = _leftImageIndex + 1;
    _centerImageIndex = _centerImageIndex + 1;
    _rightImageIndex = _rightImageIndex + 1;
    if (_leftImageIndex == _arrImgUrl.count) {
        _leftImageIndex = 0;
    }
    if (_centerImageIndex == _arrImgUrl.count) {
        _centerImageIndex = 0;
    }
    if (_rightImageIndex == _arrImgUrl.count) {
        _rightImageIndex = 0;
    }
    
    [_leftImageView sd_setImageWithURL:_arrImgUrl[_leftImageIndex] placeholderImage:_placeHolderImage];
    [_centerImageView sd_setImageWithURL:_arrImgUrl[_centerImageIndex] placeholderImage:_placeHolderImage];
    [_rightImageView sd_setImageWithURL:_arrImgUrl[_rightImageIndex] placeholderImage:_placeHolderImage];
    
    _pageControl.currentPage = _centerImageIndex;

    _labTitle.text = _arrAdTitle[_centerImageIndex];
    
    _scrollView.contentOffset = CGPointMake(kADView_Width, 0);
}

//点击广告轮播的图片
- (void)tapAdImage
{
    _clickAdImage(_centerImageIndex);
}

#pragma mark - UIScrollView Delegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (_scrollView.contentOffset.x == 0) {
        _leftImageIndex = _leftImageIndex - 1;
        _centerImageIndex = _centerImageIndex - 1;
        _rightImageIndex = _rightImageIndex - 1;
        if (_leftImageIndex == -1) {
            _leftImageIndex = _arrImgUrl.count - 1;
        }
        if (_centerImageIndex == -1) {
            _centerImageIndex = _arrImgUrl.count - 1;
        }
        if (_rightImageIndex == - 1) {
            _rightImageIndex = _arrImgUrl.count - 1;
        }
    }else if (_scrollView.contentOffset.x == kADView_Width * 2) {
        _leftImageIndex = _leftImageIndex + 1;
        _centerImageIndex = _centerImageIndex + 1;
        _rightImageIndex = _rightImageIndex + 1;
        if (_leftImageIndex == _arrImgUrl.count) {
            _leftImageIndex = 0;
        }
        if (_centerImageIndex == _arrImgUrl.count) {
            _centerImageIndex = 0;
        }
        if (_rightImageIndex == _arrImgUrl.count) {
            _rightImageIndex = 0;
        }
    }else {
        return;
    }
    
    _pageControl.currentPage = _centerImageIndex;
    
    if (_arrAdTitle.count > 0) {
        _labTitle.text = _arrAdTitle[_centerImageIndex];
    }
    
    [_leftImageView sd_setImageWithURL:_arrImgUrl[_leftImageIndex] placeholderImage:_placeHolderImage];
    [_centerImageView sd_setImageWithURL:_arrImgUrl[_centerImageIndex] placeholderImage:_placeHolderImage];
    [_rightImageView sd_setImageWithURL:_arrImgUrl[_rightImageIndex] placeholderImage:_placeHolderImage];

    _scrollView.contentOffset = CGPointMake(kADView_Width, 0);
        
}

@end
