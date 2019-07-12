//
//  JKMyOrderVC.m
//  BusinessManager
//
//  Created by  on 2018/6/19.
//  Copyright © 2018年 . All rights reserved.
//

#import "JKMyOrderVC.h"
#import "JKServiceOrderVC.h"
#import "JKDepositOrderVC.h"
#import "JKPrepaymentOrderVC.h"
#import "JKFeedOrderVC.h"

@interface JKMyOrderVC () <XXPageTabViewDelegate>
@property (nonatomic, strong) XXPageTabView *pageTabView;

@end

@implementation JKMyOrderVC

- (XXPageTabView *)pageTabView {
    if (!_pageTabView) {
        _pageTabView = [[XXPageTabView alloc] initWithChildControllers:self.childViewControllers childTitles:@[@"服务订单", @"押金订单",@"预付款订单",@"饲料订单"]];
        _pageTabView.delegate = self;
        _pageTabView.titleStyle = XXPageTabTitleStyleGradient;
        _pageTabView.indicatorStyle = XXPageTabIndicatorStyleFollowText;
        _pageTabView.selectedColor = kThemeColor;
        _pageTabView.selectedTabIndex = 0;
    }
    return _pageTabView;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"我的订单";
    [self addChildVC];
    [self.view addSubview:self.pageTabView];
    [self.pageTabView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.safeAreaTopView.mas_bottom);
        make.left.right.bottom.equalTo(self.view);
    }];
}

#pragma mark -- 加载控制器
- (void)addChildVC {
    //服务订单
    JKServiceOrderVC *soVC = [[JKServiceOrderVC alloc] init];
    [self addChildViewController:soVC];

    //押金订单
    JKDepositOrderVC *doVC = [[JKDepositOrderVC alloc] init];
    [self addChildViewController:doVC];

    //预付款订单
    JKPrepaymentOrderVC *poVC = [[JKPrepaymentOrderVC alloc] init];
    [self addChildViewController:poVC];

    //饲料订单
    JKFeedOrderVC *foVC = [[JKFeedOrderVC alloc] init];
    [self addChildViewController:foVC];

}

#pragma mark -- XXPageTabViewDelegate
- (void)pageTabViewDidEndChange {

}

- (void)scrollToLast:(id)sender {
    [self.pageTabView setSelectedTabIndexWithAnimation:self.pageTabView.selectedTabIndex-1];
}

- (void)scrollToNext:(id)sender {
    [self.pageTabView setSelectedTabIndexWithAnimation:self.pageTabView.selectedTabIndex+1];
}


@end
