//
//  YdRootViewController.m
//  侧滑
//
//  Created by suokun on 16/2/29.
//  Copyright © 2016年 sk. All rights reserved.
//

#import "YdRootViewController.h"
#import "YdLeftViewController.h"
@interface YdRootViewController ()

@end

@implementation YdRootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)awakeFromNib
{
    self.menuPreferredStatusBarStyle = UIStatusBarStyleLightContent;
    self.contentViewShadowColor = [UIColor blackColor];
    self.contentViewShadowOffset = CGSizeMake(0, 0);
    self.contentViewShadowOpacity = 0.6;
    self.contentViewShadowRadius = 12;
    self.contentViewShadowEnabled = YES;
    //是否缩小
    self.scaleContentView = NO;
    
    self.contentViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"contentViewController"];
    self.leftMenuViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"left"];
    //self.rightMenuViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"rightMenuViewController"];
    self.backgroundImage = [UIImage imageNamed:@"Stars"];
    self.delegate = self;
}
#pragma mark -
#pragma mark RESideMenu Delegate

- (void)sideMenu:(RESideMenu *)sideMenu willShowMenuViewController:(UIViewController *)menuViewController
{
    //NSLog(@"willShowMenuViewController: %@", NSStringFromClass([menuViewController class]));
}

- (void)sideMenu:(RESideMenu *)sideMenu didShowMenuViewController:(UIViewController *)menuViewController
{
    //NSLog(@"didShowMenuViewController: %@", NSStringFromClass([menuViewController class]));
}

- (void)sideMenu:(RESideMenu *)sideMenu willHideMenuViewController:(UIViewController *)menuViewController
{
    //NSLog(@"willHideMenuViewController: %@", NSStringFromClass([menuViewController class]));
}

- (void)sideMenu:(RESideMenu *)sideMenu didHideMenuViewController:(UIViewController *)menuViewController
{
    //NSLog(@"didHideMenuViewController: %@", NSStringFromClass([menuViewController class]));
}


@end
