//
//  JKNavigationVC.m
//  BusinessManager
//
//  Created by  on 2018/6/13.
//  Copyright © 2018年 . All rights reserved.
//

#import "JKNavigationVC.h"
#import "JKSuccessVC.h"
#import "JKInstallingVC.h"

@interface JKNavigationVC () <UIGestureRecognizerDelegate>

@end

@implementation JKNavigationVC

- (void)viewDidLoad {
    [super viewDidLoad];

    //设置手势代理
    self.interactivePopGestureRecognizer.delegate = self;
    //设置NavigationBar
    [self setupNavigationBar];
}

#pragma mark -- 设置NavigationBar
- (void)setupNavigationBar {
    UINavigationBar *bar = [UINavigationBar appearance];
    //统一设置导航栏颜色，如果单个界面需要设置，可以在viewWillAppear里面设置，在viewWillDisappear设置回统一格式。
    [bar setBarTintColor:kThemeColor];
    
    //导航栏title格式
    NSMutableDictionary *textAttribute = [NSMutableDictionary dictionary];
    textAttribute[NSForegroundColorAttributeName] = kWhiteColor;
    textAttribute[NSFontAttributeName] = JKFont(18);
    [bar setTitleTextAttributes:textAttribute];
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if (self.viewControllers.count > 0) {
        viewController.hidesBottomBarWhenPushed = YES;
        //返回按钮
        UIButton *backBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 80, 22)];
        backBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [backBtn setTitle:@"返回" forState:UIControlStateNormal];
        [backBtn setTitleColor:kWhiteColor forState:UIControlStateNormal];
        [backBtn setImage:[UIImage imageNamed:@"ic_back"] forState:UIControlStateNormal];
        if (@available(iOS 11.0, *)) {
            [backBtn setImageEdgeInsets:UIEdgeInsetsMake(0, -30, 0, 0)];
            [backBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, -30, 0, 0)];
        } else {
            [backBtn setImageEdgeInsets:UIEdgeInsetsMake(0, -10, 0, 0)];
            [backBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, -10, 0, 0)];
        }
        [backBtn addTarget:self action:@selector(popView) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *btnItem=[[UIBarButtonItem alloc]initWithCustomView:backBtn];
        
        UIBarButtonItem *navigationSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
        if (@available(iOS 11.0, *)) {
            
        } else {
            navigationSpace.width = -15;
        }
        
        viewController.navigationItem.leftBarButtonItems = @[navigationSpace, btnItem];
    }
    [super pushViewController:viewController animated:animated];
}

#pragma mark -- 返回
- (void)popView {
    UIViewController * vc = [self currentViewController];
    if ([vc isKindOfClass:[JKSuccessVC class]]) {   //如果是页面XXX，则执行下面语句
        [self popToRootViewControllerAnimated:YES];
    } else {
        [self popViewControllerAnimated:YES];
    }
}

- (UIViewController*) findBestViewController:(UIViewController*)vc {
    if (vc.presentedViewController) {
        return [self findBestViewController:vc.presentedViewController];
    } else if ([vc isKindOfClass:[UISplitViewController class]]) {
        UISplitViewController* svc = (UISplitViewController*) vc;
        if (svc.viewControllers.count > 0)
            return [self findBestViewController:svc.viewControllers.lastObject];
        else
            return vc;
    } else if ([vc isKindOfClass:[UINavigationController class]]) {
        UINavigationController* svc = (UINavigationController*) vc;
        if (svc.viewControllers.count > 0)
            return [self findBestViewController:svc.topViewController];
        else
            return vc;
    } else if ([vc isKindOfClass:[UITabBarController class]]) {
        UITabBarController* svc = (UITabBarController*) vc;
        if (svc.viewControllers.count > 0)
            return [self findBestViewController:svc.selectedViewController];
        else
            return vc;
    } else {
        return vc;
    }
}

-(UIViewController*) currentViewController {
    UIViewController* viewController = [UIApplication sharedApplication].keyWindow.rootViewController;
    return [self findBestViewController:viewController];
}

#pragma mark -- 手势
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    return self.childViewControllers.count > 1;
}

#pragma mark -- 状态栏颜色
- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

@end
