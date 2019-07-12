//
//  JKMyContractVC.m
//  BusinessManager
//
//  Created by  on 2018/6/20.
//  Copyright © 2018年 . All rights reserved.
//

#import "JKMyContractVC.h"
#import "JKServiceContractVC.h"
#import "JKDepositContractVC.h"
#import "JKPrepaymentsVC.h"

@interface JKMyContractVC () <XXPageTabViewDelegate>
@property (nonatomic, strong) XXPageTabView *pageTabView;

@end

@implementation JKMyContractVC

- (XXPageTabView *)pageTabView {
    if (!_pageTabView) {
        _pageTabView = [[XXPageTabView alloc] initWithChildControllers:self.childViewControllers childTitles:@[@"服务合同", @"押金合同",@"预付款"]];
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
    
    self.title = @"合同管理";
    [self addChildVC];
    [self.view addSubview:self.pageTabView];
    [self.pageTabView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.safeAreaTopView.mas_bottom);
        make.left.right.bottom.equalTo(self.view);
    }];
}

#pragma mark -- 加载控制器
- (void)addChildVC {
    //服务合同
    JKServiceContractVC *scVC = [[JKServiceContractVC alloc] init];
    [self addChildViewController:scVC];

    //押金合同
    JKDepositContractVC *dcVC = [[JKDepositContractVC alloc] init];
    [self addChildViewController:dcVC];

    //预付款
    JKPrepaymentsVC *pVC = [[JKPrepaymentsVC alloc] init];
    [self addChildViewController:pVC];
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
