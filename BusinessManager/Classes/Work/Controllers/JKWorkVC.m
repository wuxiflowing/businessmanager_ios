//
//  JKWorkVC.m
//  BusinessManager
//
//  Created by  on 2018/6/13.
//  Copyright © 2018年 . All rights reserved.
//

#import "JKWorkVC.h"
#import "SDCycleScrollView.h"
#import "JKCommonTaskCell.h"
#import "JKInternetOfThingsModuleCell.h"
#import "JKInstallationVC.h"
#import "JKMaintainVC.h"
#import "JKRepairVC.h"
#import "JKRecyceVC.h"
#import "JKOpenAccountVC.h"
#import "JKInstallationTaskVC.h"
#import "JKRepairTaskVC.h"
#import "JKRecyceTaskVC.h"
#import "JKContractFarmersVC.h"
#import "JKFeedModuleCell.h"

@interface JKWorkVC () <UITableViewDelegate, UITableViewDataSource, JKCommonTaskCellDelegate, JKInternetOfThingsModuleCellDelegate>
@property (nonatomic, strong) SDCycleScrollView *bannerView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataSource;
@end

@implementation JKWorkVC
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] init];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.backgroundColor = kClearColor;
        _tableView.separatorColor = kClearColor;
        _tableView.tableFooterView = [[UIView alloc] init];
        if (@available(iOS 11.0, *)) {
            _tableView.estimatedRowHeight = 0;
            _tableView.estimatedSectionHeaderHeight = 0;
            _tableView.estimatedSectionFooterHeight = 0;
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
    }
    return _tableView;
}

- (SDCycleScrollView *)bannerView {
    if (!_bannerView) {
        _bannerView = [[SDCycleScrollView alloc] init];
        _bannerView.autoScrollTimeInterval = 3;
        _bannerView.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;
    }
    return _bannerView;
}

- (NSMutableArray *)dataSource {
    if (!_dataSource) {
        _dataSource = [[NSMutableArray alloc] init];
    }
    return _dataSource;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = kWhiteColor;
    
    [self.view addSubview:self.bannerView];
    [self.bannerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.safeAreaTopView.mas_bottom);
        make.left.right.equalTo(self.view);
        make.height.mas_equalTo(SCREEN_HEIGHT / 4);
    }];
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bannerView.mas_bottom);
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(self.view).offset(-SafeAreaBottomHeight);
    }];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self getBanner];
    [self dropDownRefresh];
}

#pragma mark -- 获取Banner图
- (void)getBanner {
    NSString *urlStr = [NSString stringWithFormat:@"%@",kUrl_Banner];
    UIWindow *window = [[[UIApplication sharedApplication] delegate] window];
    [YJProgressHUD showProgressCircleNoValue:@"加载中..." inView:self.view];
    [[JKHttpTool shareInstance] GetReceiveInfo:nil url:urlStr successBlock:^(id responseObject) {
        [YJProgressHUD hide];
        if (responseObject[@"success"]) {
            self.bannerView.localizationImageNamesGroup = responseObject[@"data"];
        }
    } withFailureBlock:^(NSError *error) {
        [YJProgressHUD hide];
    }];
}

#pragma mark -- 下拉刷新
- (void)dropDownRefresh {
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshNewData)];
    header.automaticallyChangeAlpha = YES;
    header.lastUpdatedTimeLabel.hidden = YES;
    [header beginRefreshing];
    self.tableView.mj_header = header;
}

#pragma mark -- 刷新新数据
- (void)refreshNewData {
    [self.tableView.mj_header endRefreshing];
    [self getTaskList];
}

#pragma mark -- 获取任务数量
- (void)getTaskList {
    NSString *loginId = [JKUserDefaults objectForKey:@"loginid"];
    NSString *urlStr = [NSString stringWithFormat:@"%@/RESTAdapter/app/mytask/%@/taskList",kUrl_Base,loginId];
    
    NSArray *arr = @[@"", @"", @"", @"", @"", @"", @"", @""];
    [self.dataSource removeAllObjects];
    [self.dataSource addObjectsFromArray:arr];
    
    [[JKHttpTool shareInstance] GetReceiveInfo:nil url:urlStr successBlock:^(id responseObject) {
        if (responseObject[@"success"]) {
            for (NSDictionary *dict in responseObject[@"data"]) {
                if ([dict[@"queryType"] isEqualToString:@"install"]) {
                    [self.dataSource removeObjectAtIndex:0];
                    [self.dataSource insertObject:dict[@"total"] atIndex:0];
                } else if ([dict[@"queryType"] isEqualToString:@"maintain"]) {
                    [self.dataSource removeObjectAtIndex:1];
                    [self.dataSource insertObject:dict[@"total"] atIndex:1];
                } else if ([dict[@"queryType"] isEqualToString:@"repair"]) {
                    [self.dataSource removeObjectAtIndex:2];
                    [self.dataSource insertObject:dict[@"total"] atIndex:2];
                } else if ([dict[@"queryType"] isEqualToString:@"recycling"]) {
                    [self.dataSource removeObjectAtIndex:3];
                    [self.dataSource insertObject:dict[@"total"] atIndex:3];
                }
            }
        }
        [self.tableView reloadData];
    } withFailureBlock:^(NSError *error) {
        
    }];
}

#pragma mark -- JKCommonTaskCellDelegate
- (void)commonTaskBtnsClick:(UIButton *)btn {
    if (btn.tag == 0) {
        JKInstallationVC *iVC = [[JKInstallationVC alloc] init];
        [self.navigationController pushViewController:iVC animated:YES];
    } else if (btn.tag == 1) {
        JKMaintainVC *mVC = [[JKMaintainVC alloc] init];
        [self.navigationController pushViewController:mVC animated:YES];
    } else if (btn.tag == 2) {
        JKRepairVC *rVC = [[JKRepairVC alloc] init];
        [self.navigationController pushViewController:rVC animated:YES];
    } else if (btn.tag == 3) {
        JKRecyceVC *reVC = [[JKRecyceVC alloc] init];
        [self.navigationController pushViewController:reVC animated:YES];
    }
}

#pragma mark -- JKInternetOfThingsModuleCellDelegate
- (void)moduleBtnsClick:(UIButton *)btn {
    if (btn.tag == 0) {
        JKOpenAccountVC *opVC = [[JKOpenAccountVC alloc] init];
        opVC.isGeneral = NO;
        [self.navigationController pushViewController:opVC animated:YES];
    } else if (btn.tag == 1) {
        JKContractFarmersVC *cfVC = [[JKContractFarmersVC alloc] init];
        cfVC.contractType = JKContractTypeSign;
        [self.navigationController pushViewController:cfVC animated:YES];
    } else if (btn.tag == 2) {
        JKInstallationTaskVC *itVC = [[JKInstallationTaskVC alloc] init];
        [self.navigationController pushViewController:itVC animated:YES];
    } else if (btn.tag == 3) {
        JKRepairTaskVC *rtVC = [[JKRepairTaskVC alloc] init];
        [self.navigationController pushViewController:rtVC animated:YES];
    } else if (btn.tag == 4) {
        JKRecyceTaskVC *rtVC = [[JKRecyceTaskVC alloc] init];
        [self.navigationController pushViewController:rtVC animated:YES];
    }
}

#pragma mark -- UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    return 3;
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    if (indexPath.row == 0) {
//        return SCALE_SIZE(30 + SCREEN_WIDTH / 4 * 2) + 30;
//    } else if (indexPath.row == 1) {
//        return SCALE_SIZE(30 + SCREEN_WIDTH / 4 * 2) + 30;
//    } else {
//        return SCALE_SIZE(30 + SCREEN_WIDTH / 4) +30;
//    }
    
    if (indexPath.row == 0) {
        return SCALE_SIZE(30 + SCREEN_WIDTH / 4 * 1) + 30;
    } else {
        return SCALE_SIZE(30 + SCREEN_WIDTH / 4 * 2) + 30;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    if (indexPath.row == 0) {
//        static NSString *identifier = @"JKCommonTaskCell";
//        JKCommonTaskCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
//        if(!cell){
//            cell = [[JKCommonTaskCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
//            cell.selectionStyle = UITableViewCellSelectionStyleNone;
//        } else {
//            while ([cell.contentView.subviews lastObject] != nil) {
//                [(UIView *)[cell.contentView.subviews lastObject] removeFromSuperview];
//            }
//        }
//
//        cell.delegate = self;
//        [cell createUI:self.dataSource];
//        return cell;
//    } else if (indexPath.row == 1) {
//        static NSString *identifier = @"JKInternetOfThingsModuleCell";
//        JKInternetOfThingsModuleCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
//        if(!cell){
//            cell = [[JKInternetOfThingsModuleCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
//            cell.selectionStyle = UITableViewCellSelectionStyleNone;
//        }
//
//        cell.delegate = self;
//        return cell;
//    } else {
//        static NSString *identifier = @"JKFeedModuleCell";
//        JKFeedModuleCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
//        if(!cell){
//            cell = [[JKFeedModuleCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
//            cell.selectionStyle = UITableViewCellSelectionStyleNone;
//        }
//
//        return cell;
//    }
    
    if (indexPath.row == 0) {
        static NSString *identifier = @"JKCommonTaskCell";
        JKCommonTaskCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if(!cell){
            cell = [[JKCommonTaskCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        } else {
            while ([cell.contentView.subviews lastObject] != nil) {
                [(UIView *)[cell.contentView.subviews lastObject] removeFromSuperview];
            }
        }

        cell.delegate = self;
        [cell createUI:self.dataSource];
        return cell;
    } else {
        static NSString *identifier = @"JKInternetOfThingsModuleCell";
        JKInternetOfThingsModuleCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if(!cell){
            cell = [[JKInternetOfThingsModuleCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }

        cell.delegate = self;
        return cell;
    }
}

@end
