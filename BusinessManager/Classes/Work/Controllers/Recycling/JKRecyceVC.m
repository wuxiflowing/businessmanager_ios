//
//  JKRecyceVC.m
//  BusinessManager
//
//  Created by  on 2018/6/21.
//  Copyright © 2018年 . All rights reserved.
//

#import "JKRecyceVC.h"
#import "JKRecycePendVC.h"
#import "JKRecyceWaitVC.h"
#import "JKRecycingVC.h"
#import "JKRecycedVC.h"
#import "JKRecyceTaskVC.h"
#import "JKSearchTaskVC.h"
#import "JKRecyceCheckVC.h"

@interface JKRecyceVC () <XXPageTabViewDelegate>
{
    NSInteger _recyceType;
}
@property (nonatomic, strong) XXPageTabView *pageTabView;

@end

@implementation JKRecyceVC

- (XXPageTabView *)pageTabView {
    if (!_pageTabView) {
        _pageTabView = [[XXPageTabView alloc] initWithChildControllers:self.childViewControllers childTitles:@[@"管家审核", @"大区审核", @"待接单", @"进行中",@"已完成"]];
        _pageTabView.delegate = self;
        _pageTabView.titleStyle = XXPageTabTitleStyleDefault;
        _pageTabView.indicatorStyle = XXPageTabIndicatorStyleFollowText;
        _pageTabView.selectedColor = kThemeColor;
        _pageTabView.unSelectedColor = RGBHex(0x999999);
        _pageTabView.selectedTabIndex = 0;
        _pageTabView.bodyBounces = NO;
    }
    return _pageTabView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"回收任务";
    
    _recyceType = 0;
    
    [self createNavigationUI];
    
    [self addChildVC];
    [self.view addSubview:self.pageTabView];
    [self.pageTabView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.safeAreaTopView.mas_bottom);
        make.left.right.bottom.equalTo(self.view);
    }];
}

#pragma mark -- 导航栏
- (void)createNavigationUI {
    UIBarButtonItem *searchItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"ic_search"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStyleDone target:self action:@selector(searchBtnClick:)];
    UIBarButtonItem *addItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"ic_add_work"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStyleDone target:self action:@selector(addBtnClick:)];
    self.navigationItem.rightBarButtonItems = @[addItem,searchItem];
}

- (void)searchBtnClick:(UIButton *)btn {
    JKSearchTaskVC *stVC = [[JKSearchTaskVC alloc] init];
    if (_recyceType == 0) {
        stVC.queryType = @"recycling";
        stVC.type = @"sign";
    } else if (_recyceType == 1) {
        stVC.queryType = @"recycling";
        stVC.type = @"check";
    } else if (_recyceType == 2) {
        stVC.queryType = @"subRecycling";
        stVC.type = @"prepare";
    } else if (_recyceType == 3) {
        stVC.queryType = @"subRecycling";
        stVC.type = @"ing";
    } else {
        stVC.queryType = @"subRecycling";
        stVC.type = @"finish";
    }
    stVC.title = @"回收任务";
    [self.navigationController pushViewController:stVC animated:YES];
}

- (void)addBtnClick:(UIButton *)btn {
    JKRecyceTaskVC *rtVC = [[JKRecyceTaskVC alloc] init];
    [self.navigationController pushViewController:rtVC animated:YES];
}

#pragma mark -- 加载控制器
- (void)addChildVC {
    //待我审核
    JKRecyceCheckVC *rcVC = [[JKRecyceCheckVC alloc] init];
    [self addChildViewController:rcVC];
    
    //待审核
    JKRecycePendVC *rpVC = [[JKRecycePendVC alloc] init];
    [self addChildViewController:rpVC];
    
    //待接单
    JKRecyceWaitVC *rwVC = [[JKRecyceWaitVC alloc] init];
    [self addChildViewController:rwVC];
    
    //进行中
    JKRecycingVC *riVC = [[JKRecycingVC alloc] init];
    [self addChildViewController:riVC];
    
    //已完成
    JKRecycedVC *rdVC = [[JKRecycedVC alloc] init];
    [self addChildViewController:rdVC];
}

#pragma mark -- XXPageTabViewDelegate
- (void)pageTabViewDidEndChange {
    _recyceType = self.pageTabView.selectedTabIndex;
}

- (void)scrollToLast:(id)sender {
    [self.pageTabView setSelectedTabIndexWithAnimation:self.pageTabView.selectedTabIndex-1];
}

- (void)scrollToNext:(id)sender {
    [self.pageTabView setSelectedTabIndexWithAnimation:self.pageTabView.selectedTabIndex+1];
}


@end
