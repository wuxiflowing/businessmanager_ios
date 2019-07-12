//
//  JKTabBarVC.m
//  BusinessManager
//
//  Created by  on 2018/6/13.
//  Copyright © 2018年 . All rights reserved.
//

#import "JKTabBarVC.h"
#import "JKMessageVC.h"
#import "JKWorkVC.h"
#import "JKFarmersVC.h"
#import "JKMineVC.h"

@interface JKTabBarVC ()

@end

@implementation JKTabBarVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[UITabBar appearance] setBarTintColor:kWhiteColor];
    [self createMainControllersUI];
}

- (void)createMainControllersUI {
    //    设置子控制器
    JKMessageVC *msgVC = [[JKMessageVC alloc] init];
    [self setChildVC:msgVC title:@"消息" image:@"tab_message_n" selectedImage:@"tab_message_h"];

    JKWorkVC *wVC = [[JKWorkVC alloc] init];
    [self setChildVC:wVC title:@"工作" image:@"tab_work_n" selectedImage:@"tab_work_h"];

    JKFarmersVC *fVC = [[JKFarmersVC alloc] init];
    [self setChildVC:fVC title:@"养殖户" image:@"tab_farmers_n" selectedImage:@"tab_farmers_h"];

    JKMineVC *mVC = [[JKMineVC alloc] init];
    [self setChildVC:mVC title:@"我的" image:@"tab_mine_n" selectedImage:@"tab_mine_h"];
}

-(void)setChildVC:(UIViewController *)childVC title:(NSString *)title image:(NSString *)image selectedImage:(NSString *)selectedImage {
    // 设置子控制器的文字和图片
    childVC.title = title;// 同时设置tabbar和navigationBar的文字
    //    childVC.tabBarItem.title = title; //设置tabbar的文字
    //    childVC.navigationItem.title = title; //设置navigationBar的文字
    
    // 设置子控制器的图片
    childVC.tabBarItem.image = [UIImage imageNamed:image];
    // 声明:这张图片按照原始的样子显示出来，不会自动渲染成其他颜色(比如蓝色)
    childVC.tabBarItem.selectedImage = [[UIImage imageNamed:selectedImage]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    // 设置文字的样式
    NSMutableDictionary *textAttrs = [NSMutableDictionary dictionary];
    textAttrs[NSForegroundColorAttributeName] = kGrayColor;
    NSMutableDictionary *selectTextAttrs = [NSMutableDictionary dictionary];
    selectTextAttrs[NSForegroundColorAttributeName] = kThemeColor;
    [childVC.tabBarItem setTitleTextAttributes:textAttrs forState:UIControlStateNormal];
    [childVC.tabBarItem setTitleTextAttributes:selectTextAttrs forState:UIControlStateSelected];
    //    childVC.view.backgroundColor = RandomColor;
    
    // 先给外面传进来的小控制器 包装 一个导航控制器
    self.navi = [[JKNavigationVC alloc] initWithRootViewController:childVC];
    // 添加为子控制器
    [self addChildViewController:self.navi];
}

@end
