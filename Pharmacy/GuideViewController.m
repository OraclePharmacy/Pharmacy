//
//  UZGuideViewController.m
//  WZGuideViewController
//
//  Created by mac on 13-12-19.
//  Copyright (c) 2013年 ZhuoYun. All rights reserved.
//

#import "GuideViewController.h"

@interface GuideViewController ()

@property (nonatomic, assign) BOOL animating;
@property (nonatomic, strong) UIScrollView *pageScroll;

@end


@implementation GuideViewController

@synthesize animating = _animating;
@synthesize pageScroll = _pageScroll;

#pragma mark - Functions
// 获得屏幕的CGRect
- (CGRect)onscreenFrame
{
    return [UIScreen mainScreen].bounds;
}
// 屏幕旋转
- (CGRect)offscreenFrame
{
    CGRect frame = [self onscreenFrame];
    switch ((int)[UIApplication sharedApplication].statusBarOrientation)
    {
        case UIInterfaceOrientationPortrait:
            frame.origin.y = frame.size.height;
            break;
        case UIInterfaceOrientationPortraitUpsideDown:
            frame.origin.y = -frame.size.height;
            break;
        case UIInterfaceOrientationLandscapeLeft:
            frame.origin.x = frame.size.width;
            break;
        case UIInterfaceOrientationLandscapeRight:
            frame.origin.x = -frame.size.width;
            break;
    }
    return frame;
}
// 显示引导界面
- (void)showGuide
{
    if (!_animating && self.view.superview == nil)
    {
        [GuideViewController sharedGuide].view.frame = [self offscreenFrame];
        [[self mainWindow] addSubview:[GuideViewController sharedGuide].view];
        
        _animating = YES;
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.4];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDidStopSelector:@selector(guideShown)];
        [GuideViewController sharedGuide].view.frame = [self onscreenFrame];
        [UIView commitAnimations];
    }
}

// 开始引导界面动作
- (void)guideShown
{
    _animating = NO;
}
// 隐藏引导界面
- (void)hideGuide
{
    if (!_animating && self.view.superview != nil)
    {
        _animating = YES;
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.4];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDidStopSelector:@selector(guideHidden)];
        [GuideViewController sharedGuide].view.frame = [self offscreenFrame];
        [UIView commitAnimations];
    }
}
// 隐藏引导界面动作
- (void)guideHidden
{
    _animating = NO;
    [[[GuideViewController sharedGuide] view] removeFromSuperview];
}
// 返回主窗口
- (UIWindow *)mainWindow
{
    UIApplication *app = [UIApplication sharedApplication];
    if ([app.delegate respondsToSelector:@selector(window)])
    {
        return [app.delegate window];
    }
    else
    {
        return [app keyWindow];
    }
}
// 外接调用，显示引导界面
+ (void)show
{
    [[GuideViewController sharedGuide].pageScroll setContentOffset:CGPointMake(0.f, 0.f)];
    [[GuideViewController sharedGuide] showGuide];
}
// 外接调用，隐藏引导界面
+ (void)hide
{
    [[GuideViewController sharedGuide] hideGuide];
}

#pragma mark -

+ (GuideViewController *)sharedGuide
{
    @synchronized(self)
    {
        static GuideViewController *sharedGuide = nil;
        if (sharedGuide == nil)
        {
            sharedGuide = [[self alloc] init];
        }
        return sharedGuide;
    }
}

- (void)pressCheckButton:(UIButton *)checkButton
{
    [checkButton setSelected:!checkButton.selected];
}

- (void)pressEnterButton:(UIButton *)enterButton
{
    [self hideGuide];
}



#pragma mark - Lifecycle
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        self.view.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSArray *imageNameArray;
    
    imageNameArray= @[
                      WelcomePage1,
                      WelcomePage2,
                      WelcomePage3
                      ];
    
    _pageScroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0,
                                                                 0,
                                                                 SCREEN_WIDTH,
                                                                 SCREEN_HEIGHT)];
    
    self.pageScroll.pagingEnabled = YES;
    self.pageScroll.contentSize = CGSizeMake(self.view.frame.size.width * imageNameArray.count,
                                             self.view.frame.size.height);
    [self.view addSubview:self.pageScroll];
    
    NSString *imgName = nil;
    UIView *view;
    for (int i = 0; i < imageNameArray.count; i++)
    {
        imgName = [imageNameArray objectAtIndex:i];
        view = [[UIView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH * i),
                                                        0.f,
                                                        SCREEN_WIDTH,
                                                        SCREEN_HEIGHT)];
        
        UIImage *image = [UIImage imageNamed:imgName];
        UIImageView *imageview = [[UIImageView alloc] initWithFrame:self.view.frame];
        imageview.contentMode = UIViewContentModeScaleToFill;
        imageview.image = image;
        [view addSubview:imageview];
        [self.pageScroll addSubview:view];
        
        //最后一页-->开始使用按钮
        if (i == imageNameArray.count - 1)
        {
            UIButton *enterButton = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/4,
                                                                               SCREEN_HEIGHT-70,
                                                                               SCREEN_WIDTH/2,
                                                                               40)];
            
            
            enterButton.backgroundColor=[UIColor colorWithRed:140.0/255 green:184.0/255 blue:35.0/255 alpha:1.0f];
            [enterButton setTitle:@"开始体验" forState:UIControlStateNormal];
            enterButton.titleLabel.font=[UIFont systemFontOfSize:15];
            
            [enterButton.layer setCornerRadius:5.0f];
            
            [enterButton addTarget:self action:@selector(pressEnterButton:) forControlEvents:UIControlEventTouchUpInside];
            [view addSubview:enterButton];
        }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
